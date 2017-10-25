#!/bin/sh

if [ $# -ne 2 ]; then
    echo "Rationale : Cherry-pick only those changes in a commit that affect a certain path."
    echo "Usage     : $(basename $0) <commit> <path>"
    exit 1
fi

# If getting the diff to the previous commit fails (e.g. when picking the root commit), checkout instead.
(git diff $1^ $1 -- $2 | git apply --index) 2> /dev/null || git checkout $1 -- $2 && git commit -C $1 -n -q
