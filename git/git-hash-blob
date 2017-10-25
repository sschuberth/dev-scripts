#!/bin/sh

# This script calculates the same as "git hash-object $1".

infile=$1
outfile=$(mktemp)

if !(dos2unix -n "$infile" "$outfile" 2>&1 | grep -q "Skipping binary file"); then
    infile=$outfile
fi

(stat --printf="blob %s\0" "$infile"; cat "$infile") | sha1sum -b | cut -d" " -f1

rm -f "$outfile"
