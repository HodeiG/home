#!/bin/bash
# https://faq.i3wm.org/question/5312/how-to-toggle-onoff-external-and-internal-monitors.1.html
# https://wiki.archlinux.org/index.php/xrandr
connectedOutputs=$(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
activeOutput=$(xrandr | grep -E " connected (primary )?[1-9]+" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")

if [ "$connectedOutputs" == "$activeOutput" ] ; then
    # Disable multiple monitors
    xrandr -o normal
else
    # Disable multiple monitors
    xrandr -o normal
    # Enable multiple monitors
    previous=""
    execute="xrandr "
    for display in $connectedOutputs ; do
        execute="$execute --output $display --auto"
        if [ "$previous" != "" ] ; then
            execute="$execute --right-of $previous"
        fi
        previous="$display"
    done
    eval "$execute"
fi