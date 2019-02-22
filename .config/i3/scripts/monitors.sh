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
secondary_monitor_output=

if [ "$connected_outputs" == "$active_output" ] ; then
    # Disable multiple monitors
    secondary_monitor_output="--off"
else
    # Enable multiple monitors
    secondary_monitor_output="--auto"
fi
# Disable multiple monitors
# xrandr -o normal
# Enable multiple monitors
previous=""
execute="xrandr "
default_output="--auto"
for display in $connected_outputs ; do
    execute="$execute --output $display $default_output"
    if [ "$previous" != "" ] ; then
        if [ "$secondary_monitor_output" != "--off" ] ; then
            execute="$execute --right-of $previous"
        fi
    fi
    default_output=$secondary_monitor_output
    previous="$display"
done
echo $execute
eval "$execute"