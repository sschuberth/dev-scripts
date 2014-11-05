#!/bin/sh

dirs=$(find . -maxdepth 1 -type d)
for dir in $dirs; do
    if [ -f $dir/AndroidManifest.xml ]; then
        name=$(sed -n "s/android:versionName=\"\(.*\)\">/\1/p" $dir/AndroidManifest.xml)
        name=$(echo $name)
        [ -n "$name" ] && echo "$dir: $name"
    fi
done
