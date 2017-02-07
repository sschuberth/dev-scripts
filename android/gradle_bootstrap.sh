#!/bin/sh

if ! which jq > /dev/null 2>&1; then
    echo "This script depends on https://stedolan.github.io/jq/."
    echo "Please put the 'jq' executable into your PATH."
    exit 1
fi

current=$(curl -s https://services.gradle.org/versions/current)

version=$(echo $current | jq -r '.version')
echo "The most recent Gradle version is $version."

if [ -n "$2" ]; then
    version=$2
    echo "Using provided Gradle version $version."
fi

dist_type_min_version=3.1
if [ $(echo -e "$version\n$dist_type_min_version" | sort -V | head -1) = $dist_type_min_version ]; then
    [ -z $1 ] && dist_type="bin" || dist_type="all"
    echo "Will use the '$dist_type' distribution type."
    dist_type="--distribution-type $dist_type"
fi

dist=$(ls -d ~/.gradle/wrapper/dists/gradle-$version-*/*/gradle-$version 2> /dev/null)
if [ $? -eq 0 ]; then
    dist=$(echo "$dist" | head -1)
    echo "Found version in cache at $dist."
    gradle=$dist/bin/gradle
else
    url=$(echo $current | jq -r '.downloadUrl')
    echo "Downloading version from $url."
    zip=$(mktemp --suffix .zip)
    curl -o $zip -L -s $url
    unzip -o -q $zip -d /tmp
    gradle=/tmp/gradle-$version/bin/gradle
fi

$gradle --no-daemon wrapper --gradle-version $version $dist_type

# Ensure the Gradle wrapper is executable, e.g. if a previously existing one was overwritten.
chmod a+x gradlew

if [ -f "$zip" ]; then
    rm -r $zip /tmp/gradle-$version
fi
