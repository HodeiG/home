#!/bin/bash

ACESTREAMID=$1

if [ -z "$ACESTREAMID" ] ; then
    echo "No acestream id provided."
    echo "Use: https://search-ace.stream/"
    exit 1
fi

if ! docker container ls | grep -q acestreamengine ; then
    echo "Start acestream egine"
    if docker container ls -a | grep -q acestreamengine ; then
        # If engine was stopped start it again
        docker start acestreamengine
    else
        # If first time, then start by the first time
        docker run --detach --publish 6878:6878 --name acestreamengine vstavrinov/acestream-engine
    fi
else
    echo "Acestream engine already started"
fi

while ! docker logs acestreamengine 2>1 | grep -q Success ; do
    echo "Wait until acestreamegine starts..."
    sleep 1
done


OUTPUT=$(curl "http://127.0.0.1:6878/ace/getstream?id=$ACESTREAMID")
if echo "$OUTPUT" | grep -q "failed to load content" ; then
    echo "Provided stream cannot be loaded. Try another one..."
else
    URL=$(echo "$OUTPUT" | awk '{print $3}')
    echo "URL for stream is $URL"
    mpv --no-ytdl "$URL"
fi
