#!/bin/sh

git diff --name-only "$@" | while read name; do
    git difftool "$@" --no-prompt "$name" &
done
