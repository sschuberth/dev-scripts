#!/bin/sh

if [ $# -gt 1 ]; then
    echo "Rationale : Download the APK for an installed package from the device."
    echo "Usage     : $(basename $0) [package]"
    exit 1
fi

packages=$(adb shell pm list packages | cut -d : -f 2 | sort)

if [ $# -eq 0 ]; then
    echo "$packages"
else
    case $(uname -s) in
    MINGW*)
        # Use a double-slash in the beginning to prevent MSYS path mangling.
        prefix="/"
        ;;
    esac

    for package in $(echo "$packages" | grep $1); do
        path=$(adb shell pm path $package | cut -d : -f 2)

        # Strip trailing whitespace.
        path=$(echo $path)

        adb pull $prefix$path $package.apk
    done
fi
