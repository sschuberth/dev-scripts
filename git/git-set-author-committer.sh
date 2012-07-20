#!/bin/sh

if [ $# -ne 3 ]; then
    echo "Rationale : Set the author name an email address for a number of recent commits."
    echo "Usage     : $(basename $0) <number of commits> <name> <email address>"
    exit -1
fi

git filter-branch -f --env-filter "GIT_AUTHOR_NAME='$2'; GIT_AUTHOR_EMAIL='$3'; GIT_COMMITTER_NAME='$2'; GIT_COMMITTER_EMAIL='$3';" HEAD~$1..HEAD
