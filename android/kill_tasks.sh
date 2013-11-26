#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Rationale : Kill all tasks of the given package."
    echo "Usage     : $(basename $0) <package>"
    exit -1
fi

ps=$(adb shell ps | grep $1)
if [ -z "$ps" ]; then
    echo "No tasks found matching package \"$1\"."
    exit 0
fi

for line in "$ps"; do
    pid=$(echo "$line" | awk '{print $2}')
    package=$(echo "$line" | awk '{print $9}')
    echo "Stopping package $package (process $pid)."
    adb shell am force-stop $package
done
