#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Rationale : Push the current branch to Gerrit for integration into a target branch."
    echo "Usage     : $(basename $0) <target>"
    echo "Example   : $(basename $0) SI/master"
    exit 1
fi

target=$1

remotes=$(git remote show)
if echo "$remotes" | grep -q ^gerrit$; then
    remote=gerrit
elif echo "$remotes" | grep -q ^origin$; then
    remote=origin
else
    remote=$(echo "$remotes" | head -1)
fi

topic=$(git rev-parse --abbrev-ref HEAD)
if [ $topic != $target ]; then
    echo "Pushing topic \"$topic\" to remote \"$remote\"..."
    git push $remote HEAD:refs/for/$target%topic=$topic
else
    echo "Pushing to remote \"$remote\"..."
    git push $remote HEAD:refs/for/$target
fi
