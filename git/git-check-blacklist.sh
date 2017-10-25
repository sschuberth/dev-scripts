#!/bin/bash

# Space-separated list of blacklisted word.
BLACKLIST=${1:-secret password}

echo -e "Searching commit messages for blacklisted words...\n"
BLACKLIST_ARGS="${BLACKLIST/ / --grep=}"
git log --all --format=full --grep=$BLACKLIST_ARGS -i

echo -e "\n--\n"

echo -e "Searching commits for blacklisted words...\n"
BLACKLIST_PATTERN="(${BLACKLIST/ /|})"
git rev-list --all | (
    while read REVISION; do
        git grep -i -E $BLACKLIST_PATTERN $REVISION
    done
)
