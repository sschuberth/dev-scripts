#!/bin/bash

if [ $# -ne 4 ]; then
    echo "Usage   : $(basename $0) <ppa user> <ppa name> <old version> <new version>"
    echo "Example : $(basename $0) sschuberth cmake 3.2.1-1ppa3~vivid1 3.2.3-1ppa1~vivid1"
    exit 1
fi

ppa_user=$1
ppa_name=$2

old=$3
oldver=${old%%-*}
olddist=${old##*~}
olddist=${olddist::-1}

new=$4
newver=${new%%-*}
newvershort=${newver%.*}
newdist=${new##*~}
newdist=${newdist::-1}

if [ "$olddist" != "$newdist" ]; then
    echo "Error: Old and new distributions have to match."
    exit 2
fi

tmpdir=$(mktemp -d)
pushd $tmpdir > /dev/null

echo "Bumping version from $oldver to $newver from $newvershort servies ..."

wget http://www.cmake.org/files/v$newvershort/cmake-$newver.tar.gz
tar -xf cmake-$newver.tar.gz
mv cmake-$newver.tar.gz cmake_$newver.orig.tar.gz

wget https://launchpad.net/~$ppa_user/+archive/ubuntu/$ppa_name/+files/cmake_$old.debian.tar.xz
tar -C cmake-$newver -xf cmake_$old.debian.tar.xz

cd cmake-$newver
dch -v $new -D $newdist
dpkg-buildpackage -S

cd ..
dput ppa:$ppa_user/$ppa_name cmake_${new}_source.changes

popd > /dev/null
rm -fr $tempdir
