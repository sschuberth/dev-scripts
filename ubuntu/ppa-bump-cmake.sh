#!/bin/bash

if [ $# -ne 6 ]; then
    echo "Usage   : $(basename $0) <from user> <from name> <from version> <to user> <to name> <to version>"
    echo "Example : $(basename $0) ~george-edison55 cmake-3.x 3.2.2-2ubuntu2~ubuntu15.04.1~ppa1 sschuberth cmake 3.2.3-1ppa1~vivid1"
    exit 1
fi

from_user=$1
from_name=$2
from=$3
from_ver=${from%%-*}

to_user=$4
to_name=$5
to=$6
to_ver=${to%%-*}
to_ver_short=${to_ver%.*}
to_dist=${to##*~}
to_dist=${to_dist::-1}

temp_dir=$(mktemp -d)
pushd $temp_dir > /dev/null

echo "Bumping version from $from_ver to $to_ver in $to_ver_short series ..."

wget http://www.cmake.org/files/v$to_ver_short/cmake-$to_ver.tar.gz
tar -xf cmake-$to_ver.tar.gz
mv cmake-$to_ver.tar.gz cmake_$to_ver.orig.tar.gz

[ "$from_user" = "ubuntu" ] && from_name=primary || from_name=ubuntu/$from_name
wget https://launchpad.net/$from_user/+archive/$from_name/+files/cmake_$from.debian.tar.xz
tar -C cmake-$to_ver -xf cmake_$from.debian.tar.xz

cd cmake-$to_ver &&
dch -v $to -D $to_dist &&
dpkg-buildpackage -S &&

cd .. &&
dput ppa:$to_user/$to_name cmake_${to}_source.changes

result=$?

popd > /dev/null

[ $result -eq 0 ] && rm -fr $temp_dir || echo "Not removing $temp_dir due to errors."
