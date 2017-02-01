#!/bin/sh

for COMMIT in $(git rev-list $1); do
    MOD_FILES=$(git diff --diff-filter=M --name-only $COMMIT | wc -l)
    if [ -z "$MIN" -o ]; then
        MIN=$MOD_FILES
        BEST=$COMMIT
    elif [ $MOD_FILES -lt $MIN ]; then
        MIN=$MOD_FILES
        BEST=$COMMIT
    fi
done

echo "Best matching commit is $BEST with $MIN modified files."
