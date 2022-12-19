#!/bin/bash

UPSTREAM_BRANCH=${2:-origin/main}
REMOTE_BRANCHES=$(git branch -r -l origin/* | grep -vE "(HEAD|$UPSTREAM_BRANCH)")
CHECK_BRANCHES=${1:-$REMOTE_BRANCHES}

NUM_BRANCHES=$(echo "$CHECK_BRANCHES" | wc -l)
BRANCH_COUNTER=0

for BRANCH in $CHECK_BRANCHES; do
    BRANCH_COUNTER=$((BRANCH_COUNTER + 1))
    echo -n "[$BRANCH_COUNTER/$NUM_BRANCHES] Commits of branch $BRANCH "

    UNEQUAL_LINES=$(git range-diff $UPSTREAM_BRANCH...$BRANCH | grep -v " = " | wc -l)

    if [ $UNEQUAL_LINES -eq 0 ]; then
        echo "ARE contained in $UPSTREAM_BRANCH."
    else
        echo "are NOT contained in $UPSTREAM_BRANCH."
    fi
done
