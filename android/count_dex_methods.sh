#!/bin/bash

# See http://www.betaful.com/2013/10/android-too-many-methods-dex-fails/.

if [ -z "$ANDROID_HOME" ]; then
    echo "Please make ANDROID_HOME point to your Android SDK directory."
    exit 1
fi

spawn=
case $(uname -s) in
CYGWIN* | MSYS* | MINGW*)
    spawn="cmd //c"
    ;;
esac

jars=$(find . -maxdepth 3 \( -path "*/bin/*" -or -path "*/libs/*" \) -and -name "*.jar")
build_tools_version=$(find $ANDROID_HOME/build-tools -mindepth 1 -maxdepth 1 | tail -1)

tmp_file=$(dirname $0)/tmp.dex

total=0
for file in $jars; do
    $spawn "$build_tools_version/dx" --dex --output="$tmp_file" "$file"

    # We have no hexdump on MSYS, so use a Perl script instead.
    count=$(head -c 92 $tmp_file | tail -c 4 | perl -e 'read STDIN, $long, 4; $value = unpack "V", $long; print "$value"')

    echo "$file: $count"
    let total=$total+$count
done
echo "Total: $total"

rm $tmp_file
