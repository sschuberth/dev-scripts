#!/bin/sh

if [ $# -lt 1 -o $# -gt 2 ]; then
    echo "Rationale : Show the merge commit resolution in the configured merge tool."
    echo "Usage     : $(basename $0) [-c] <merge commit>"
    echo "Options   : -c (Show conflicts only.)"
    exit 1
fi

die() {
    echo >&2 "$@"
    exit 255
}

if [ "$1" = "-c" ]; then
    conflicts_only=true
    shift
else
    conflicts_only=false
fi

ours=$1^1
theirs=$1^2
base=$(git merge-base $ours $theirs)

if $conflicts_only; then
    files=$(git show $1 | grep "diff --cc" | cut -d " " -f 3-)
else
    files=$(git merge-tree $base $ours $theirs | grep -A 3 "changed in both" | grep "base" | cut -d " " -f 8-)
fi

if [ -n "$files" ]; then
    count=$(echo "$files" | wc -l)
    count=$(echo $count)
else
    count=0
fi

if $conflicts_only; then
    if [ $count = "0" ]; then
        echo "There were no conflicting files in that merge commit."
    elif [ $count = "1" ]; then
        echo "There was one conflicting file in that merge commit:"
    else
        echo "There were $count conflicting files in that merge commit:"
    fi
else
    if [ $count = "0" ]; then
        echo "There were no files concurrently changed in both parents."
    elif [ $count = "1" ]; then
        echo "There was one file concurrently changed in both parents:"
    else
        echo "There were $count files concurrently changed in both parents:"
    fi
fi

for f in "$files"; do
    echo "$f"
done

TOOL_MODE=merge
: ${MERGE_TOOL_LIB=$(git --exec-path)/git-mergetool--lib}
. "$MERGE_TOOL_LIB"

merge_tool=$(get_merge_tool "$merge_tool") || die "Error: No merge tool configured."

check_unchanged () {
    status=0
}

for f in $files; do
    LOCAL="/tmp/$f.LOCAL"
    BASE="/tmp/$f.BASE"
    REMOTE="/tmp/$f.REMOTE"
    MERGED="/tmp/$1.MERGED"

    # Silence the call to "touch" in "merge_cmd ()".
    BACKUP="/tmp/$1.BACKUP"

    mkdir -p $(dirname $LOCAL) && git show $ours:"$f" > $LOCAL
    mkdir -p $(dirname $BASE) && git show $base:"$f" > $BASE
    mkdir -p $(dirname $REMOTE) && git show $theirs:"$f" > $REMOTE
    mkdir -p $(dirname $MERGED) && git show $1:"$f" > $MERGED

    run_merge_tool "$merge_tool" "true"
done
