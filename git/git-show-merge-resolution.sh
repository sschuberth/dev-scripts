#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Rationale : Show the conflict resolution of a given merge commit in the configured merge tool."
    echo "Usage     : $(basename $0) <merge commit>"
    exit -1
fi

# Test e.g. with https://github.com/git/git/commit/8cde60210dd01f23d89d9eb8b6f08fb9ef3a11b8
our=$1^1
their=$1^2
base=$(git merge-base $our $their)

conflicting_files=$(git merge-tree $base $our $their | grep -A 3 "changed in both" | grep "base" | cut -d " " -f 8)
for f in $conflicting_files; do
    diffuse -r $our -r $base -r $their $f
done
