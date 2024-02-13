#!/bin/bash
# Start a new zellij session or attach to an existing one

if [ "$#" -gt 0 ]; then
    zellij "$@"
else
    SESSIONS=$(zellij ls | grep -v EXITED | awk '{print $1}')
    NUM_SESSIONS=$(echo "$SESSIONS" | wc -l)
    if [ -n "$SESSIONS" ]; then
        if [ "$NUM_SESSIONS" -eq 1 ]; then
            zellij attach
        else
            SELECTED_SESSION=$(echo "$SESSIONS" | fzf --ansi)
            if [ -n "$SELECTED_SESSION" ]; then
                zellij attach "$SELECTED_SESSION"
            fi
        fi
    else
        zellij setup
    fi
fi
