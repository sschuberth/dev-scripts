#!/bin/sh

WATCH_DIR=$1
COPY_DIR=$2

inotifywait -m "$WATCH_DIR" -e create | while read DIRECTORY EVENT FILE; do
    cp "$DIRECTORY/$FILE" "$COPY_DIR"
    echo "Copied $FILE to $COPY_DIR".
done
