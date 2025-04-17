#!/usr/bin/env python3

import sys
import os
import json
from pathlib import Path

STORAGE_DIR = Path("/tmp/lfs_storage")  # Simulated blob store
STORAGE_DIR.mkdir(exist_ok=True)

LOG_FILE = STORAGE_DIR / "smudge.log"

LFS_META_DIR = Path(".lfs-meta")  # Replace with your own metadata dir

def extract_oid_from_pointer(data):
    for line in data.splitlines():
        if line.startswith("oid sha256:"):
            return line.strip().split("sha256:")[1]
    return None


def log_debug(msg):
    with open(LOG_FILE, 'a') as f:
        print(f"DEBUG: {msg}", file=f)

def main():
    input_data = sys.stdin.read()
    log_debug(f"read {input_data}")
    skip_smudge = os.getenv("GIT_LFS_SKIP_SMUDGE", "0")
    if skip_smudge == "1":
        sys.stdout.write(input_data)
        log_debug(f"skipping smudge: {input_data}")
        return

    oid = extract_oid_from_pointer(input_data)

    if not oid:
        sys.stderr.write("No OID found in pointer file.\n")
        sys.stdout.write(input_data)  # fallback: emit input unchanged
        log_debug(f"No OID found in pointer file.")
        return

    blob_path = STORAGE_DIR / oid
    if blob_path.exists():
        with open(blob_path, "rb") as f:
            sys.stdout.buffer.write(f.read())
            log_debug(f"wrote {oid} from {blob_path} to stdout")
    else:
        sys.stderr.write(f"Missing object: {oid}\n")
        log_debug(f"Missing object: {oid}")
        sys.stdout.write(input_data)  # emit pointer if blob not found


if __name__ == "__main__":
    log_debug("Starting smudge script...")
    main()
