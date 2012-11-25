#!/bin/bash

# This script requires bash for array functionality.

# Get the list of branches and convert it to an array.
branches=$(git for-each-ref --format='%(refname:short)' refs/heads/)
branches=( $branches )
N=${#branches[*]}

cc_merges=0

# Loop over all combinations of two branches.
for ((i=0; i<N-1; ++i)); do
    for ((k=i+1; k<N; ++k)); do
        a=${branches[$i]}
        b=${branches[$k]}
        bases=$(git merge-base --all $a $b | wc -l)
        if [ $bases -gt 1 ]; then
            let "cc_merges += 1"
        fi
    done
done

echo "Number of criss-cross merges in repository: $cc_merges"
