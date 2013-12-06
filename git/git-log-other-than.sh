#!/bin/sh

if [ $# -ne 2 ]; then
    echo "Rationale : Lists all commits that touch any files other than those matching a regex pattern."
    echo "Usage     : $(basename $0) <branch> <pattern>"
    exit 1
fi

for commit in $(git rev-list $1); do
    names=$(git show --pretty="format:" --name-only $commit | tail -n +2)
    if echo "$names" | grep -qv $2; then
        echo "$commit touches other files"
    fi
done
