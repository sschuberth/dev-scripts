#!/bin/bash

if [ -z "$ANDROID_HOME" ]; then
    echo "Please make ANDROID_HOME point to your Android SDK directory."
    exit 1
fi

spawn=
case $(uname -s) in
CYGWIN* | MSYS* | MINGW*)
    spawn="cmd //c"
    ;;
esac

apks=$(find . \( -path "*/bin/*" -or -path "*/build/*" \) -and -name "*.apk" | sort)
build_tools_version=$(find "$ANDROID_HOME/build-tools" -mindepth 1 -maxdepth 1 | tail -1)

if [ "$1" = "-csv" ]; then
    for file in $apks; do
        basename_no_sha1=$(basename $file .apk | cut -d "-" -f -3)

        # Strip any trailing build number for consistent file names across builds.
        echo -n ${basename_no_sha1%-[0-9]*},
    done | sed "s/,\+$/\n/"

    for file in $apks; do
        count=$($spawn "$build_tools_version/dexdump" -f $file | grep method_ids_size | cut -d ":" -f 2)
        echo -n $count,
    done | sed "s/,\+$/\n/"
else
    for file in $apks; do
        echo $file
        $spawn "$build_tools_version/dexdump" -f $file | grep method_ids_size
    done
fi
