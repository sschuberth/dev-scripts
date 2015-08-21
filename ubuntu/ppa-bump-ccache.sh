#!/bin/bash

if [ $# -ne 6 ]; then
    echo "Usage   : $(basename $0) <from user> <from name> <from version> <to user> <to name> <to version>"
    echo "Example : $(basename $0) ubuntu ccache 3.1.10-1 sschuberth ccache 3.2.3-1~vivid1"
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

wget http://samba.org/ftp/ccache/ccache-$to_ver.tar.xz
tar -xf ccache-$to_ver.tar.xz
mv ccache-$to_ver.tar.xz ccache_$to_ver.orig.tar.xz

[ ${from_user:0:1} = "~" ] && space="ubuntu" || space="primary"
wget https://launchpad.net/$from_user/+archive/$space/+files/ccache_$from.debian.tar.xz
tar -C ccache-$to_ver -xf ccache_$from.debian.tar.xz

cd ccache-$to_ver &&
dch -v $to -D $to_dist &&
dpkg-buildpackage -S &&

cd .. &&
dput ppa:$to_user/$to_name ccache_${to}_source.changes

result=$?

popd > /dev/null

[ $result -eq 0 ] && rm -fr $temp_dir || echo "Not removing $temp_dir due to errors."
