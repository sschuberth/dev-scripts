#!/bin/sh

if [ "$#" -ne 3 ]; then
    echo "Usage: $(basename $0) <groupId> <artifactId> <version>"
    exit 1
fi

POM_DIR="$(echo "$1" | tr . /)/$2/$3"
POM_PATH="$POM_DIR/$2-$3.pom"

mkdir -p "$HOME/.m2/repository/$POM_DIR"

if type -p wget > /dev/null; then
    wget -q -O "$HOME/.m2/repository/$POM_PATH" "http://repo.maven.apache.org/maven2/$POM_PATH"
elif type -p curl > /dev/null; then
    curl -s -o "$HOME/.m2/repository/$POM_PATH" "http://repo.maven.apache.org/maven2/$POM_PATH"
fi

mvn -f "$HOME/.m2/repository/$POM_PATH" dependency:tree
