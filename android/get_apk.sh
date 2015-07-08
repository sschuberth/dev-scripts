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
        # Strip whitespace.
        package=$(echo "$package" | tr -d "[[:space:]]")

        path=$(adb shell pm path $package | cut -d : -f 2)
        path=$(echo "$path" | tr -d "[[:space:]]")

        echo "Pulling package $package from $path..."
        adb pull $prefix$path $package.apk
    done
fi
