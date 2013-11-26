#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Rationale : Pull files from the device by wildcard."
    echo "Usage     : $(basename $0) <path>"
    exit -1
fi

adb shell ls $1 | tr -s "\r\n" "\0" | xargs -0 -n1 adb pull
