#!/bin/sh

path=$(type -p adb)
[ -f "$path" ] && path=$(dirname "$(dirname "$path")") || path=$ANDROID_HOME

if [ ! -d "$path" ]; then
    echo "Error: Unable to find the Android SDK installation directory."
    exit 1
fi

grep "Pkg.Revision" "$path/tools/source.properties"
