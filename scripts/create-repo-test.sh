#!/bin/bash
# Check if the script is in the PATH
if ! command -v setup-lfs.sh &> /dev/null; then
  echo "Warning: setup-lfs.sh is not in your PATH. Please add it to your PATH to use it globally."
fi

# Create a new directory for the repository and navigate into it
if [ -d "ttt" ]; then
  echo "Directory 'ttt' already exists. Removing it."
  rm -rf ttt
fi
mkdir ttt
cd ttt

# Initialize a new Git repository
git init

# Run the setup script to configure Git LFS
setup-lfs.sh
setup-git-hooks.sh

# Add a remote origin pointing to the GitHub repository
# Set it to some repository you have write access to
git remote add origin https://github.com/bwalsh/ttt.git

# Configure Git LFS to track files with the .bin extension

git lfs track "*.bin"
git lfs track "*.vcf.gz"
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

# enable for add url testing
#git add-url s3://1000genomes/phase1/analysis_results/integrated_call_sets/ALL.chr22.integrated_phase1_v3.20101123.snps_indels_svs.genotypes.vcf.gz
## TODO - this add is extraneous. Should happen automatically
#git add phase1/analysis_results/integrated_call_sets/ALL.chr22.integrated_phase1_v3.20101123.snps_indels_svs.genotypes.vcf.gz
#git commit -m "Add genotypes.vcf.gz"

git push -f origin main

# Check if myfile.bin is a Git LFS pointer file
if git lfs ls-files | grep -q "myfile.bin"; then
  echo "myfile.bin is listed as a LFS pointer file."
else
  echo "myfile.bin is NOT listed as a Git LFS pointer file."
fi

# Check if myfile.bin is a Git LFS pointer file
if git lfs ls-files | grep -q "genotypes.vcf.gz"; then
  echo "genotypes.vcf.gz is listed as a LFS pointer file."
else
  echo "genotypes.vcf.gz is NOT a Git LFS pointer file."
fi