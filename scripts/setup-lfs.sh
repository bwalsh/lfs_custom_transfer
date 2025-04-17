#!/bin/bash

# Check if Git LFS is installed
if ! git lfs &> /dev/null; then
  echo "Git LFS is not installed. Installing..."
  git lfs install
else
  echo "Git LFS is already installed."
fi
# configure Git LFS to use our custom transfer agent
git config lfs.standalonetransferagent local
git config lfs.customtransfer.local.path "transfer.py"
git config lfs.customtransfer.local.args ""

# view config
git config -l | grep lfs

