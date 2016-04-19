#!/bin/sh

(stat --printf="blob %s\0" "$1"; cat "$1") | sha1sum -b | cut -d" " -f1
