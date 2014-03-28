#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Rationale : Push the current branch to Gerrit for integration into a target branch."
    echo "Usage     : $(basename $0) <target>"
    echo "Example   : $(basename $0) master"
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

# Create changes from the command line with topic and reviewers optionally set, see:
# http://gerrit-documentation.googlecode.com/svn/Documentation/2.6/user-upload.html#push_create

# Specify a topic if we are on a branch different from the target.
topic=$(git rev-parse --abbrev-ref HEAD)
if [ $topic != $target ]; then
    echo -n "Going to push topic \"$topic\" to remote \"$remote\""
    options="%topic=$topic"
else
    echo -n "Going to push to remote \"$remote\""
fi

# Determine email addresses of potential reviewers (except oneself).
if git help -a | grep -q " contacts "; then
    user=$(git config user.name)
    reviewers=$(git contacts $remote/$target..HEAD | grep -iv "$user" | cut -d "<" -f 2 | cut -d ">" -f 1)

    # Determine the reviewer count, stripping leading whitespace.
    count=$(echo "$reviewers" | wc -l)
    count=$(echo $count)

    if [ $count -gt 0 ]; then
        echo " with $count reviewer(s) set:"

        for email in $reviewers; do
            echo "    $email"
            if [ -z "$r" ]; then
                r="r=$email"
            else
                r="$r,$email"
            fi
        done
    else
        echo " with no reviewers set."
    fi
else
    echo " with no reviewers set."
fi

if [ -n "$r" ]; then
    if [ -z "$options" ]; then
        options="%$r"
    else
        options="$options,$r"
    fi
fi

read -p "Do you want to push this review? [Y/n] " -n 1 -r
echo
if [ "$REPLY" != "n" -a "$REPLY" != "N" ]; then
    git push $remote HEAD:refs/for/$target$options
fi
