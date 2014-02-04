#!/bin/sh

spawn=
case $(uname -s) in
CYGWIN* | MSYS* | MINGW*)
    spawn="cmd //c"
    ;;
esac

apks=$(find . -maxdepth 3 -path "*/bin/*" -and -name "*.apk")
build_tools_version=$(find $ANDROID_HOME/build-tools -mindepth 1 -maxdepth 1 | tail -1)

for file in $apks; do
echo $file
    $spawn "$build_tools_version/dexdump" -f $file | grep method_ids_size
done
