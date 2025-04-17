#!/bin/bash
# Check if the script is in the PATH
if ! command -v setup-lfs.sh &> /dev/null; then
  echo "Warning: setup-lfs.sh is not in your PATH. Please add it to your PATH to use it globally."
fi

# Create a new directory for the repository and navigate into it
mkdir ttt
cd ttt

# Initialize a new Git repository
git init

# Run the setup script to configure Git LFS
setup-lfs.sh

# Add a remote origin pointing to the GitHub repository
git remote add origin https://github.com/bwalsh/ttt.git

# Configure Git LFS to track files with the .bin extension

git lfs track "*.bin"
git add .gitattributes
git commit -m "Add .gitattributes"

# Add the README file to the repository
echo "# ttt" >> README.md
echo "This is a test repo" >> README.md
git add README.md
git commit -m "Add README.md"

echo "Hello LFS" > myfile.bin
git add myfile.bin
git commit -m "Add myfile.bin"

echo "Hello LFS 2" > myfile2.bin
git add myfile2.bin
git commit -m "Add myfile2.bin"

git push -f origin main

# Check if myfile.bin is a Git LFS pointer file
if git lfs ls-files | grep -q "myfile.bin"; then
  echo "myfile.bin is a Git LFS pointer file."
else
  echo "myfile.bin is NOT a Git LFS pointer file."
fi