#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage   : $(basename $0) <package> <release> <ppa>"
    echo "Example : $(basename $0) cmake trusty we-are-here/testing"
    exit 1
fi

if [[ "$1" != *.dsc ]]; then
    # Get the name of the latest available package (in case of multiple matching package names).
    package=$(apt-cache search "^$1(-[0-9\.]+)?$" | tail -1 | cut -d" " -f1)
    echo "Using package name '$package'"

    # Find out the source package it belogs to.
    message=$(apt-get source -s $package)
    echo "$message" | grep "^Picking.*as source package"
    source=$(echo "$message" | tail -1 | cut -d" " -f3)
    echo "Using source package name '$source'"
else
    source=$1
fi

# Backport the package. For details see
# https://opensourcehacker.com/2013/03/20/how-to-backport-packages-on-ubuntu-linux/
backportpackage -d $2 -u ppa:$3 -y $source
