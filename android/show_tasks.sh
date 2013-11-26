#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Rationale : List the activity stack for all tasks of the given package."
    echo "Usage     : $(basename $0) <package>"
    exit -1
fi

dump=$(adb shell dumpsys activity)

# Get the line number of the first match.
line_begin=$(echo "$dump" | grep -P -m 1 -n "^\s*TaskRecord.*$1" | grep -P -o "^\d+")

i=1
while [ "$line_begin" -eq "$line_begin" ] 2> /dev/null; do
    # Remove all lines before the first match.
    dump_tail=$(echo "$dump" | tail -n +$line_begin)

    # Remove the line containing the match.
    dump_tail1=$(echo "$dump_tail" | tail -n +2)

    # Get the line number of the match after the first match.
    line_end=$(echo "$dump_tail1" | grep -P -m 1 -n "^\s*(TaskRecord|$)" | grep -P -o "^\d+")

    if [ "$line_end" -eq "$line_end" ] 2> /dev/null; then
        # Remove all lines after and including the second match.
        dump_head=$(echo "$dump_tail" | head -n $line_end)
    else
        dump_head=$dump_tail
    fi

    echo
    echo "$i. matching task"
    echo "----------------"
    echo "$dump_head"
    let i=i+1

    # Get the line number of the next match.
    dump=$dump_tail1
    line_begin=$(echo "$dump" | grep -P -m 1 -n "^\s*TaskRecord.*$1" | grep -P -o "^\d+")
done
