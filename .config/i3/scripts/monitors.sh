#!/bin/bash
#
# Script to enable/disable multiple monitors.
# If multiple monitors are enabled, it will enable just the main monitor.
# If only the main monitor is enabled enable all of them.
# See also:
# https://faq.i3wm.org/question/5312/how-to-toggle-onoff-external-and-internal-monitors.1.html 
# https://wiki.archlinux.org/index.php/xrandr 


connected_outputs=$(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
active_output=$(xrandr | grep -E " connected (primary )?[1-9]+" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")

monitor_mode=$1
secondary_monitor_output=
secondary_monitor_position=

if [ -z "$monitor_mode" ] ; then
    # If monitor mode not provided, switch between MAIN and RIGHT
    if [ "$connected_outputs" == "$active_output" ] ; then
        # Disable multiple monitors
        secondary_monitor_output="--off"
        secondary_monitor_position=""
    else
        # Enable multiple monitors
        secondary_monitor_output="--auto"
        secondary_monitor_position="--right-of"
    fi
else
    if [ "$monitor_mode" == "MAIN" ] ; then
        # Enable only main monitor
        secondary_monitor_output="--off"
        secondary_monitor_position=""
    elif [ "$monitor_mode" == "RIGHT" ] ; then
        # Enable multiple monitors set up on the right
        secondary_monitor_output="--auto"
        secondary_monitor_position="--right-of"
    elif [ "$monitor_mode" == "LEFT" ] ; then
        # Enable multiple monitors set up on the left
        secondary_monitor_output="--auto"
        secondary_monitor_position="--left-of"
    elif [ "$monitor_mode" == "CLONE" ] ; then
        # Enable multiple monitors cloned
        secondary_monitor_output="--auto"
        secondary_monitor_position="--same-as"
    fi
fi
# Execute xrandr commands to configure displays
# https://unix.stackexchange.com/questions/485026/
#   xrandr-fails-randomly-with-configure-crtc-x-failed-on-dock-with-multiple-
#   monit/485147#485147

previous_display=""
current_display_output="--auto"
for display in $connected_outputs ; do
    cmd="xrandr --output $display $current_display_output"
    if [ "$previous_display" != "" ] ; then
        if [ "$secondary_monitor_output" != "--off" ] ; then
            cmd="$cmd $secondary_monitor_position $previous_display"
        fi
    fi
    current_display_output=$secondary_monitor_output
    previous_display="$display"
    echo "$cmd"
    eval "$cmd"
done