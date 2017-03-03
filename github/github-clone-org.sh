#!/bin/sh

if ! which jq > /dev/null 2>&1; then
    echo "This script depends on https://stedolan.github.io/jq/."
    echo "Please put the 'jq' executable into your PATH."
    exit 1
fi

if [ $# -ne 1 ]; then
    echo "Rationale : Clone all public repositories of a GitHub organization."
    echo "Usage     : $(basename $0) <github org name>"
    exit 1
fi

ORG=$1

URLS=$(curl -s https://api.github.com/orgs/$1/repos | jq -r '.[].clone_url' | tr -d '\r')

for URL in $URLS; do
    DIRNAME=$(basename "$URL" .git)
    if [ -d $DIRNAME -o -f $DIRNAME.lnk ]; then
        echo "Skipping '$DIRNAME' as the target already exists."
        continue
    fi

    echo "Cloning to '$DIRNAME'..."
    git clone -q $URL
done
