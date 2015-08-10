#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Rationale"
    echo "    Set the parent of projects matching a pattern."
    echo
    echo "Usage"
    echo "    $(basename $0) <host> <pattern> <parent>"
    echo
    echo "Example"
    echo "    $(basename $0) android-review.googlesource.com device Platform-Unrestricted-Projects"
    exit 1
fi

port=29418
host=$1
pattern=$2
parent=$3

projects=$(ssh -p $port $host gerrit ls-projects | grep "$pattern")

echo
echo "$projects"
echo
read -p "Do you want to change the parent for these projects? [(Y)es/(n)o] " -n 1 -r
echo

if [ "$REPLY" != "n" -a "$REPLY" != "N" ]; then
    echo "$projects" | xargs ssh -p $port $host gerrit set-project-parent --parent $parent
fi
