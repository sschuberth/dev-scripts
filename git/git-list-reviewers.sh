#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Rationale : Lists potential reviewers for given commits (wraps git-contacts)."
    echo "Usage     : $(basename $0) (<patch>|<range>|<rev>)..."
    exit 1
fi

for arg in "$@"; do
    if [ ! -f "$arg" ]; then
       if [[ "$arg" != *..* ]]; then
           # Use different semantics than git-contacts if this is a single commit.
           git contacts $arg^..$arg
           continue
       fi
    fi

    # Fall back to just calling git-contacts as-is.
    git contacts $arg
done
