#!/bin/sh

dir=${1:-.}/.git

if git --git-dir=$dir ls-tree -r HEAD | grep -q ^12; then
    path=$(dirname $(readlink -f $dir))
    echo "Repository at '$path' contains symbolic links."
fi
