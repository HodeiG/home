#! /bin/bash

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
            eval "\cd $1"
            EXIT=$?
        # $1 is-a:
        #   - file
        elif [ -f "$1" ]; then
            DIRNAME=$(dirname "$1")
            echo "$1 >>> ${DIRNAME}/"
            eval "\cd $DIRNAME"
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
    _PWD=$(\pwd "$@")
    EXIT=$?
    # If token PS1 exists the command is run in the command line.
    # Otherwise it is run interactively in an script.
    if [ -n "$PS1" -a $EXIT == 0 ] ; then
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

function _cdf {
    if [ -z "$1" ] ; then
        FIND=$(find . -type d | grep -v "/\.")
    else
        FIND=$(find . -type d -name "$1" | grep -v "/\.")
    fi
    FIND_AMOUNT=$(echo "${FIND}" | wc -l)
    if [ -z "$FIND" ] ; then
        echo "Cannot find directory any directory."
        return 1
    elif [ "${FIND_AMOUNT}" -gt "1" ] ; then
        XPATH=$(_choose_option $FIND)
    else
        XPATH=$FIND
    fi
    if [ ! -z "$XPATH" ] ; then
        OLD_PWD=$PWD
        _cl $XPATH
        echo $OLD_PWD " >>> " $PWD
    fi
}
