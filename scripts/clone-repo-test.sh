#!/bin/bash


# Check if the script is in the PATH
if ! command -v setup-lfs.sh &> /dev/null; then
  echo "Warning: setup-lfs.sh is not in your PATH. Please add it to your PATH to use it globally."
fi

GIT_LFS_SKIP_SMUDGE=1 git clone --verbose  https://github.com/bwalsh/ttt
cd ttt

setup-lfs.sh
setup-precommit-meta-check.sh

# Check if myfile.bin is a Git LFS pointer file
cat myfile.bin  | grep -q git-lfs && echo "OK: is lfs pointer" || echo "FAIL: expected a lfs pointer"
cat myfile2.bin  | grep -q git-lfs && echo "OK: is lfs pointer" || echo "FAIL: expected a lfs pointer"

echo lfs pulling files individually
git lfs pull -I myfile.bin
git lfs pull -I myfile2.bin

cat myfile.bin  | grep -q Hello && echo "OK: is content" || echo "FAIL: expected a content file"
cat myfile2.bin  | grep -q Hello && echo "OK: is content" || echo "FAIL: expected a content file"
