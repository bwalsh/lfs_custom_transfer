#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Check if the script is in the PATH
if ! command -v setup-lfs.sh &> /dev/null; then
  echo "Warning: setup-lfs.sh is not in your PATH. Please add it to your PATH to use it globally."
fi

if [ -d "ttt" ]; then
  echo "Directory 'ttt' already exists. Removing it."
  rm -rf ttt
fi

# GIT_LFS_SKIP_SMUDGE=1 git clone --verbose  https://github.com/bwalsh/ttt
git clone --verbose  https://github.com/bwalsh/ttt
cd ttt

setup-lfs.sh
setup-git-hooks.sh

# Check if myfile.bin is a Git LFS pointer file
cat myfile.bin  | grep -q git-lfs && echo "OK: is lfs pointer" || echo "FAIL: expected a lfs pointer"
cat myfile2.bin  | grep -q git-lfs && echo "OK: is lfs pointer" || echo "FAIL: expected a lfs pointer"

# enable for add url testing
cat phase1/analysis_results/integrated_call_sets/ALL.chr22.integrated_phase1_v3.20101123.snps_indels_svs.genotypes.vcf.gz | grep -q git-lfs && echo "OK: is lfs pointer" || echo "FAIL: expected a lfs pointer"


echo lfs pulling files individually
git lfs pull -I myfile.bin
git lfs pull -I myfile2.bin

cat myfile.bin  | grep -q Hello && echo "OK: is content" || echo "FAIL: expected a content file"
cat myfile2.bin  | grep -q Hello && echo "OK: is content" || echo "FAIL: expected a content file"
