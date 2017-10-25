#!/bin/sh

# Git Compare Differences
function git_cmp_diffs() {
    if [ $(git show $1 | git patch-id | cut -c 40) != $(git show $2 | git patch-id | cut -c 40) ]; then
        echo "Diffs are NOT equal."
    else
        echo "Diffs ARE equal."
    fi
}

alias gcd='git_cmp_diffs'

# Git Is Merged
function git_is_merged() {
    revlist=$(git rev-list -1 $1 --not $2)
    if [ $? -eq 0 ]; then
        if [ "$revlist" = "" ]; then
            echo "$(basename $1) IS merged into $(basename $2)."
        else
            echo "$(basename $1) is NOT merged into $(basename $2)."
        fi
    fi
}

alias gim='git_is_merged'
