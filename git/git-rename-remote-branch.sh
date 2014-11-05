#!/bin/sh

if [ $# -ne 3 ]; then
    echo "Rationale : Rename a branch on the server without checking it out."
    echo "Usage     : $(basename $0) <remote> <old name> <new name>"
    echo "Example   : $(basename $0) origin master release"
    exit 1
fi

git push $1 $1/$2:refs/heads/$3 :$2
