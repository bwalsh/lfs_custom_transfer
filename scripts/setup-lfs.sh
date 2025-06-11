#!/bin/bash

# Check if Git LFS is installed
if ! git lfs &> /dev/null; then
  echo "Git LFS is not installed. Installing..."
  # Will not download files automatically see https://sabicalija.github.io/git-lfs-intro/
  git lfs install --skip-smudge
else
  echo "Git LFS is already installed."
fi

# configure Git LFS to use our custom transfer agent
git config lfs.standalonetransferagent local
git config lfs.customtransfer.local.path "transfer.py"
git config lfs.customtransfer.local.args ""

# enable for add url testing
# use our custom smudge and clean filters
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

git config filter.drs.clean $SCRIPT_DIR/git-drs clean
git config filter.drs.smudge $SCRIPT_DIR/git-drs smudge
git config drs.standalonetransferagent local
git config drs.customtransfer.local.path $SCRIPT_DIR/git-drs
git config drs.customtransfer.local.args "transfer"

git config filter.customlfs.process $SCRIPT_DIR/git-drs-filter
git config filter.customlfs.required true


# view config
git config --list | grep lfs

