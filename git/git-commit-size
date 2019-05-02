#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Rationale : Get the total size of all files added by the specified commit."
    echo "Usage     : $(basename $0) <commit>"
    exit 1
fi

blob_sizes=$(git diff-tree -r -c -M -C --no-commit-id $1 | grep " A	" | cut -d " " -f 4 | git cat-file --batch-check | cut -d " " -f 3)
total_size=0

for size in $blob_sizes; do
    let total_size+=size
done

if [ $total_size -gt 0 ]; then
    total_size_kib=$(echo $total_size | awk '{printf "%.2f",$1/1024}')
    total_size_mib=$(echo $total_size_kib | awk '{printf "%.2f",$1/1024}')
    echo "The commit adds files totalling in $total_size bytes ($total_size_kib KiB, $total_size_mib MiB)."
else
    echo "The commit does not add any files."
fi
