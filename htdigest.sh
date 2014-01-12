#!/bin/sh

if [ $# -ne 3 ]; then
    echo "Usage: $0 <user> <realm> <pass>"
    exit 1
fi

hash=`echo -n "$1:$2:$3" | md5sum | cut -b -32`
echo "$1:$2:$hash"
