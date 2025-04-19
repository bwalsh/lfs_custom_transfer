#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# copy from this folder to the hooks
cp $SCRIPT_DIR/pre-commit.py .git/hooks/pre-commit
cp $SCRIPT_DIR/pre-add.py .git/hooks/pre-add