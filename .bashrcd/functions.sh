#! /bin/bash
#
# ALIASES
alias cd='_cl' # Change directory and ls
alias pwd='_pwd' # Change directory and ls
alias ..='_go_back' # Change directory and ls
alias z='_start_zellij' # Change directory and ls


DGREEN='\e[0;1;32m'
NC='\e[0m' #No color

function _choose_option {
    MAIN_MESSAGE="Choose option"
    CMD="whiptail --menu \"$MAIN_MESSAGE\" 0 0 6"
    INDEX=1
    for var in "$@" ; do
        CMD="${CMD} \"$var\" \"\""
        ((INDEX++))
    done
    eval "$CMD 3>&1 1>&2 2>&3"
}

# Change directory and ls
function _cl {
    EXIT=0
    if [[ "$1" == "" ]]
    then
        eval "\cd"
        EXIT=$?
    else
        # $1 is-a:
        #   - directory, or
        #   - "-" (go back to previous folder)
        if [ -d "$1" ] || [ "$1" == "-" ]; then
            eval "\cd '$1'"
            EXIT=$?
        # $1 is-a:
        #   - file
        elif [ -f "$1" ]; then
            DIRNAME=$(dirname "$1")
            echo "$1 >>> ${DIRNAME}/"
            eval "\cd '$DIRNAME'"
            EXIT=$?
        # $1 not a valid value
        else
            echo "_cl: $1: No such file or directory"
            EXIT=1
        fi
    fi
    if [ -f .env.sh ] ; then
        # shellcheck disable=SC1091
        source .env.sh
    fi
    ls
    return $EXIT
}

# Go back a number of folders
function _go_back {
    if [[ "$1" == "" ]];then
        eval "cd .."
    else
        re='^[0-9]+$'
        if ! [[ $1 =~ $re ]] ; then
            echo "error: Not a valid number" >&2; return 1
        fi
        if [[ "$1" -gt "0" ]] ; then
            CD=$(eval "printf '../%.0s' {1..$1}")
            echo "$CD"
            OLDPWD=pwd
            eval "cd $CD"
            echo "$OLDPWD >>> $PWD"
        fi
    fi
}

# pwd and show how many directories back numbers
function _pwd {
    # shellcheck disable=SC1001
    _PWD=$(\pwd "$@")
    EXIT=$?
    # If token PS1 exists the command is run in the command line.
    # Otherwise it is run interactively in an script.
    if [ -n "$PS1" ]  && [ $EXIT == 0 ] ; then
        echo -e "${DGREEN}${_PWD}${NC}"
        _PWD=$(echo "$_PWD" | sed 's/[^\/]/\ /g')
        SC=$(echo "$_PWD" | fgrep -o / | wc -l) # Slash Count
        while [[ "$SC" -gt "0" ]]; do
            if [[ "$SC" -gt "9" ]]; then
                _PWD=$(echo "$_PWD" | sed "s/[\/]\ /$SC/")
            else
                _PWD=$(echo "$_PWD" | sed "s/[\/]/$SC/")
            fi
            ((SC--))
        done
    fi
    if [ $EXIT == 0 ] ; then
        echo "$_PWD"
    fi
    return $EXIT
}

function try {
    if [ -z "$TIMEOUT" ] ; then
        TIMEOUT=2
    fi
    ATTEMPT=0
    until eval "$@"
    do
        ((ATTEMPT++))
        echo "[Attempt $ATTEMPT] Trying again in $TIMEOUT seconds..."
        sleep $TIMEOUT
    done
}

function _start_zellij {
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
}
