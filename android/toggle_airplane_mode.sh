#!/bin/bash

if [ $# -gt 1 ]; then
    echo "Rationale : Toogle Airplane mode on the attached Android device. If neither"
    echo "            \"on\" nor \"off\" is specified the current state is toggled."
    echo "Usage     : $(basename $0) [on|off]"
    exit 1
fi

if [ $# -eq 1 -a "$1" != "on" -a "$1" != "off" ]; then
    echo "Error: Invalid argument, must be \"on\" nor \"off\"."
    exit 1
fi

before="$(adb shell settings get global airplane_mode_on | tr -d '\r\n')"
if [ "$before" = "0" ]; then
    before="off"
elif [ "$before" = "1" ]; then
    before="on"
else
    echo "Error: Unable to determine Airplane mode."
    echo $before
    exit 1
fi
echo "Before: Airplane mode is $before."

if [ "$before" = "$1" ]; then
    echo "Nothing to do, exiting."
    exit 0
fi

# Default values.
channel=0
steps=1

host=$(adb shell cat //system/build.prop | sed -n "s/ro\.build\.host=\(.*\)/\1/p")
if [ "$host" = "cyanogenmod" ]; then
    echo "This is a Cyanogenmod device."
    steps=3
else
    brand=$(adb shell cat //system/build.prop | sed -n "s/ro\.product\.brand=\(.*\)/\1/p" | head -1)
    case "$brand" in
    lge*)
        echo "This is an LG device."
        channel=1
        steps=2
        if [ "$before" = "off" ]; then
            confirm=true
        fi
        ;;
    htc*)
        echo "This is an HTC device."
        channel=2
        ;;
    samsung*)
        echo "This is a Samsung device."
        if [ "$before" = "off" ]; then
            steps=2
        else
            steps=1
        fi
        confirm=true
        ;;
    esac
fi

# Long-press the Power key. The double-slashes are requited for MSYS compatibility.
adb shell sendevent //dev/input/event$channel 1 116 1
adb shell sendevent //dev/input/event$channel 0 0 0

sleep 3

adb shell sendevent //dev/input/event$channel 1 116 0
adb shell sendevent //dev/input/event$channel 0 0 0

# Focus the first menu entry and then go the number of steps down.
adb shell input keyevent 122
for ((i=0; i<steps; ++i)); do
    adb shell input keyevent 20
done

# Toggle Airplane mode.
adb shell input keyevent 23

if [ -n "$confirm" ]; then
    adb shell input keyevent 122
    adb shell input keyevent 22
    adb shell input keyevent 23
fi

after="$(adb shell settings get global airplane_mode_on | tr -d '\r\n')"
after=$([ "$after" = "0" ] && echo "off" || echo "on")
echo "After: Airplane mode is $after."

if [ "$after" != "$before" ]; then
    echo "Success."
    exit 0
else
    echo "Failure."
    exit 1
fi
