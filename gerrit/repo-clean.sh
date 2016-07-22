#!/bin/sh

die() {
    echo "$@" >&2
    exit 1
}

[ -d ".repo" ] || die "Error: Please change to the root of the repo working tree."

rm -rf build/
repo forall -p -c git clean -fdx
