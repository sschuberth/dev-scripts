#!/bin/bash

while [ -n "$1" ]; do
    case "$1" in
    --help)
        help=true
        ;;
    -*)
        echo "Error: Invalid option \"$1\"."
        exit 2
        ;;
    *)
        # Stop parsing options on the first non-option argument.
        break
        ;;
    esac

    shift
done

if [ -n "$help" -o $# -ne 2 ]; then
    echo "Rationale"
    echo "    Clone all projects matching the given pattern from Gerrit."
    echo
    echo "Usage"
    echo "    $(basename $0) <host> <pattern>"
    echo
    echo "Example"
    echo "    $(basename $0) review.openstack.org openstack-attic/akanda"
    echo
    echo "Options"
    echo "    --help"
    echo "        Show this help."
    exit 1
fi

host=$(echo $1 | cut -d":" -f1)
port=$(echo $1 | cut -d":" -f2 -s)
[ -z "$port" ] && port=29418

pattern=$2
matches=$(ssh -p $port $host gerrit ls-projects --type code | grep -E $pattern)

if [ -z "$matches" ]; then
    echo "No matching projects found."
    exit 2
fi

echo "$matches"
echo
read -p "Do you want to clone these projects? [(Y)es/(n)o] " -n 1 -r

if [ "$REPLY" != "n" -a "$REPLY" != "N" ]; then
    echo "$matches" | xargs -I % -n 1 -P 8 git clone -q ssh://$host:$port/% %
fi
