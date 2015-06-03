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
    prefix="/data/app/"

    case $(uname -s) in
    MINGW*)
        # Use a double-slash in the beginning to prevent MSYS path mangling.
        prefix="/$prefix"
        ;;
    esac

    version=$(adb shell getprop ro.build.version.sdk)
    if [ $version -ge 20 ]; then
        suffix="-1/base.apk"
    else
        suffix="-1.apk"
    fi

    for package in $(echo "$packages" | grep $1); do
        adb pull $prefix$package$suffix $package.apk
    done
fi
