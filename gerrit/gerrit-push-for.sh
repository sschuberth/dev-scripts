#!/bin/bash

if [ $# -gt 2 ]; then
    echo "Rationale : Push the current branch to Gerrit for integration into a target branch."
    echo "Usage     : $(basename $0) [target] [ref]"
    echo "Example   : $(basename $0) master HEAD"
    exit 1
fi

[ $# -ge 1 ] && target=$1 || target=master
[ $# -ge 2 ] && ref=$2 || ref=HEAD

remotes=$(git remote show)
if echo "$remotes" | grep -q ^gerrit$; then
    remote=gerrit
elif echo "$remotes" | grep -q ^origin$; then
    remote=origin
else
    remote=$(echo "$remotes" | head -1)
fi

revlist=$(git rev-list -1 $ref --not $remote/$target)
if [[ $? -eq 0 && "$revlist" = "" ]]; then
    echo "Nothing to do, $ref is already merged into $remote/$target."
    exit 2
fi

# Create changes from the command line with topic and reviewers optionally set, see:
# http://gerrit-documentation.googlecode.com/svn/Documentation/2.6/user-upload.html#push_create

# Specify a topic if we are on a branch different from the target.
topic=$(git rev-parse --abbrev-ref $ref)
topic=${topic#gerrit/}
if [[ "$topic" != "" && "$topic" != "HEAD" && "$topic" != "$target" ]]; then
    echo -n "Going to push topic \"$topic\" for \"$remote/$target\""
    options="%topic=$topic"
else
    echo -n "Going to push for \"$remote/$target\""
fi

# Determine email addresses of potential reviewers (except oneself).
if git help -a | grep -q " contacts "; then
    user=$(git config user.name)
    reviewers=$(git contacts $remote/$target..$ref | grep -iv "$user" | cut -d "<" -f 2 | cut -d ">" -f 1)

    if [ "$reviewers" != "" ]; then
        # Determine the reviewer count, stripping (leading) whitespace.
        count=$(echo "$reviewers" | wc -l)
        count=$(echo $count)
        echo " with $count reviewer(s) set:"

        for email in $reviewers; do
            echo "    $email"
            if [ -n "$r" ]; then
                r="$r,"
            fi
            r="${r}r=$email"
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
    git push $remote $ref:refs/for/$target$options
fi
