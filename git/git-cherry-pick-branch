#!/bin/bash

# This script requires bash for some advanced string matching.

if [ $# -lt 2 ]; then
    echo "Rationale : Cherry-pick only those changes in a branch that affect a certain path"
    echo "Usage     : $(basename $0) <branch> <path> [resume]"
    exit 1
fi

die() {
    echo >&2 "$@"
    exit 255
}

commits=$(git rev-list --reverse --topo-order --no-merges $1 -- $2)
words=$(echo $commits | wc -w)

# Trim whitespaces.
count=$(echo $words)

if [[ $# -ge 3 && $commits == *$3* ]]; then
    skip=true
    resume=$3
    echo "Resuming picking after $resume ..."
else
    skip=false
fi

i=0
for sha1 in $commits; do
    let i++

    if [[ $skip != true ]]; then
        echo $(printf "(%03d of %03d)" $i $count) $sha1

        # Save a huge amount of time for vastly different trees by using the
        # "resolve" merge strategy to avoid rename detection. However, this may
        # may lead to unnecessary conflicts sometimes, and it segfaults with
        # Git 1.7.5.1 (a fix is underway).
        #git cherry-pick --strategy=resolve $sha1 > /dev/null 2>&1 || (git commit -C $sha1 -o $2 && git reset --hard HEAD) > /dev/null || die "Error cherry-picking $sha1."

        # This is an alternate method without using git cherry-pick at all.
        $(dirname $0)/git-cherry-pick-path.sh $sha1 $2 > /dev/null || die "Error cherry-picking $sha1."
    fi

    if [[ $sha1 == $resume* ]]; then
        skip=false
    fi
done
