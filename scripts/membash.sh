#!/bin/bash

# Gist: 11375877
# Url: https://gist.github.com/goodevilgenius/11375877
#
# All memcache functions are supported.
# 
# Can also be sourced from other scripts, e.g.
#    source membash.sh
#    MCSERVER="localhost"
#    MCPORT=11211
#    foobar=$(mc_get foobar)
#    [ -z "$foobar" ] && foobar="default value"
#    mc_set foobar 0 "$foobar"

# original author: wumin, https://gist.github.com/ri0day/1538831
# updated by goodevilgenius to support debian-based systems, support more
# functions, and be more user-friendly 

mc_usage() {
    format_usage="membash: a memcache library for BASH \n\
https://gist.github.com/goodevilgenius/11375877\n\n\
Usage:\n
    \t $(basename "$0") [-hp] command [arguments] \n \
    \t [-h]\t memcached hostname or ip. \n \
    \t [-p]\t memcached port. \n\n\
Commands: \n \
    \t usage (print this help) \n \
    \t set/add/replace/append/prepend key exptime value \n \
    \t touch key exptime \n \
    \t incr/decr key value \n \
    \t get key \n \
    \t delete key [time] \n \
    \t stats \n \
    \t list \n \
    \t purge"
    echo -e "$format_usage"
}
mc_help() { mc_usage;}

mc_sendmsg() { echo -e "$*\r" | nc "$MCSERVER" "$MCPORT" -q 1;}

mc_stats() { mc_sendmsg "stats";}

mc_list() {
    slabs=$(mc_sendmsg "stats items" | awk -F':' '/number/{print $2}')
    for slab in $slabs ; do
        mc_sendmsg "stats cachedump $slab 0" | awk '{print $2}'
    done
}

mc_get() { mc_sendmsg "get $1" | awk "/^VALUE $1/{a=1;next}/^END/{a=0}a" ;}

mc_touch() {
    key="$1"
    shift
    let exptime="$1"
    shift
    mc_sendmsg "touch $key $exptime"
}

mc_doset() {
    command="$1"
    shift
    key="$1"
    shift
    let exptime="$1"
    shift
    val="$*"
    let bytes=$(echo -n "$val"|wc -c)
    mc_sendmsg "$command $key 0 $exptime $bytes\r\n$val"
}

mc_set() { mc_doset set "$@";}
mc_add() { mc_doset add "$@";}
mc_replace() { mc_doset replace "$@";}
mc_append() { mc_doset append "$@";}
mc_prepend() { mc_doset prepend "$@";}

mc_delete() { mc_sendmsg delete "$*";}
mc_incr() { mc_sendmsg incr "$*";}
mc_decr() { mc_sendmsg decr "$*";}

mc_purge() {
    for key in $(mc_list | grep "$1") ; do
        mc_sendmsg "delete ${key}"
    done
}

MCSERVER="localhost"
MCPORT=11211
while getopts "h:p:" flag
do
    case $flag in
        h)
            MCSERVER=${OPTARG:="localhost"}
            ;;
        p)
            MCPORT=${OPTARG:="11211"}
            ;;
        \?)
            echo "Invalid option: $OPTARG" >&2
            ;;
    esac
done
command="$1"
# Check if the given command exists
if ! type "mc_$command" &> /dev/null ; then
    command="usage"
fi
mc_$command "${@:2}"
exit $?
