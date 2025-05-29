#!/usr/bin/env python3

import subprocess
import sys

def get_staged_files():
    """Get a list of files staged for commit."""
    try:
        result = subprocess.run(
            ["git", "diff", "--cached", "--name-only"],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout.strip().split("\n")
    except subprocess.CalledProcessError as e:
        print(f"Error getting staged files: {e}")
        sys.exit(1)

def check_lfs_files(files):
    """Check if any staged files are tracked by Git LFS."""
    lfs_files = []
    for file in files:
        if not file.strip():
            continue
        try:
            result = subprocess.run(
                ["git", "check-attr", "filter", "--", file],
                capture_output=True,
                text=True,
                check=True
            )
            if "lfs" in result.stdout:
                lfs_files.append(file)
        except subprocess.CalledProcessError as e:
            print(f"Error checking file attributes: {e}")
            sys.exit(1)
    return lfs_files

def main():
    staged_files = get_staged_files()
    if not staged_files:
        print("No files staged for commit.")
        sys.exit(0)

    lfs_files = check_lfs_files(staged_files)
    if lfs_files:
        print("The following files are new Git LFS objects being added in this commit:")
        for file in lfs_files:
            print(f"  - {file}")
        print("Ensure these files are associated with META files.")
        sys.exit(0)
    else:
        print("No new Git LFS objects detected in this commit.")
        sys.exit(0)  # Allow the commit

if __name__ == "__main__":
    main()