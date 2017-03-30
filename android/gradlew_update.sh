#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname $0)" && pwd)"

for i in $(find . -type d -exec [ -f {}/gradlew ] \; -print -prune); do
    echo "Entering directory $i..."
    pushd $i > /dev/null
    $SCRIPT_DIR/gradlew_bootstrap.sh all
    popd > /dev/null
done
