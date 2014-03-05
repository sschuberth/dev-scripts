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

# Determine email addresses of potential reviewers (except oneself).
git contacts 2> /dev/null
if [ $? -eq 9 ]; then
    user=$(git config user.name)
    reviewers=$(git contacts $remote/$target..HEAD | grep -iv "$user" | cut -d "<" -f 2 | cut -d ">" -f 1)
    for email in $reviewers; do
        if [ -z "$r" ]; then
            r="r=$email"
        else
            r="$r,$email"
        fi
    done
fi

# Determine the reviewer count, stripping leading whitespace.
count=$(echo "$reviewers" | wc -l)
count=$(echo $count)

# Specify a topic if we are on a branch different from the target.
topic=$(git rev-parse --abbrev-ref HEAD)
if [ $topic != $target ]; then
    echo "Pushing topic \"$topic\" to remote \"$remote\" with $count reviewer(s) set."
    options="%topic=$topic"
else
    echo "Pushing to remote \"$remote\" with $count reviewer(s) set."
fi

if [ -n "$r" ]; then
    if [ -z "$options" ]; then
        options="%$r"
    else
        options="$options,$r"
    fi
fi

git push $remote HEAD:refs/for/$target$options
