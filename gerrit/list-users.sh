#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Rationale"
    echo "    List all registered Gerrit users."
    echo
    echo "Usage"
    echo "    $(basename $0) <host>"
    exit 1
fi

port=29418
host=$1

ssh -p $port $host 'gerrit gsql --format PRETTY -c "select full_name,preferred_email from accounts"'
