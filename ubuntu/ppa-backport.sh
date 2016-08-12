#!/bin/sh

if [ $# -ne 3 ]; then
    echo "Usage   : $(basename $0) <package> <release> <ppa>"
    echo "Example : $(basename $0) cmake trusty we-are-here/testing"
    exit 1
fi

# Get the latest available version of the package.
package=$(apt-cache search $1 | tail -1 | cut -d" " -f1)

# Find out the source package it belogs to.
message=$(apt-get source -s $package | grep "as source package")
echo $message

source=$(echo $message | cut -d"'" -f2)

# Backport the package. For details see
# https://opensourcehacker.com/2013/03/20/how-to-backport-packages-on-ubuntu-linux/
backportpackage -d $2 -u ppa:$3 -y $source
