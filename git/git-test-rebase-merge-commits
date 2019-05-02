#!/bin/sh

if [ -d test ]; then
    echo "The test directory already exists, please delete it manually."
    exit 1
fi

mkdir test
cd test

# Create a repo with an initial commit.
git init
echo "line 1" > readme.txt
git add .
git commit -m "Initial commit"

# Create branches A and B with additional non-conflicting commits each.
git co -b A master
echo "A" > A.txt
git add .
git commit -m "Add A.txt"

# Create branches A and B with additional non-conflicting commits each.
git co -b B master
echo "B" > B.txt
git add .
git commit -m "Add B.txt"

# Merge B into A and create yet another commit on A.
git checkout A
git merge B
echo "A2" > A2.txt
git add .
git commit -m "Add A2.txt"

# Create another commit on master.
git checkout master
echo "line 2" >> readme.txt
git commit -a -m "Second commit"

echo -e "\nHistory looks like this:"
git log --graph --all --oneline
read -n1 -p "Press any key to continue ..." -s

# Rebase A onto the current master.
echo -e "\nRebasing A onto the current master without preserving merges ..."
git checkout A
git rebase master

echo -e "\nNow history looks like this:"
git log --graph --oneline
read -n1 -p "Press any key to continue ..." -s

echo -e "\nRebasing A onto the current master with preserving merges ..."
git reset --hard ORIG_HEAD
git rebase -p master

echo -e "\nNow history looks like this:"
git log --graph --oneline
