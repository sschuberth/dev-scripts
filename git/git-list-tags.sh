#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Rationale : Lists all (lightweight) tags matching a pattern in reverse chronological order."
    echo "Usage     : $(basename $0) <pattern>"
    exit -1
fi

git log --tags=$1 --no-walk --pretty="format:%d" | grep -o $1
