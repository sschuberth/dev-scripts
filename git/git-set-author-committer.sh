#!/bin/sh

if [ $# -ne 3 -a $# -ne 5 ]; then
    echo "Rationale : Set the author and committer name and email for a number of recent commits."
    echo "Usage     : $(basename $0) <number of commits> <name> <email> [<name> <email>]"
    exit -1
fi

an=$2
ae=$3
if [ $# -eq 3 ]; then
    cn=$2
    ce=$3
else
    cn=$4
    ce=$5
fi

git filter-branch -f --env-filter "GIT_AUTHOR_NAME='$an'; GIT_AUTHOR_EMAIL='$ae'; GIT_COMMITTER_NAME='$cn'; GIT_COMMITTER_EMAIL='$ce';" HEAD~$1..HEAD
