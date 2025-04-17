#!/usr/bin/env python3

import sys
import json
import os
from pathlib import Path

STORAGE_DIR = Path("/tmp/lfs_storage")  # Change to your actual remote store path
STORAGE_DIR.mkdir(exist_ok=True)

GIT_LFS_DIR = Path(".git/lfs/objects")  # LFS storage directory

LOG_FILE = STORAGE_DIR / "transfer.log"

def log_debug(msg):
    with open(LOG_FILE, 'a') as f:
        print(f"DEBUG: {msg}", file=f)

def send(message):
    sys.stdout.write(json.dumps(message) + "\n")
    sys.stdout.flush()

def handle_init(request):
    send({"event": "init", "operation": request["operation"], "transfers": ["basic"]})

def handle_upload(request):
    oid = request["oid"]
    size = request["size"]
    path = Path(request["path"])
    target_path = STORAGE_DIR / oid[:2] / oid[2:4] / oid

    log_debug(f"Uploading {oid} ({size} bytes) to {target_path}")
    try:
        target_path.parent.mkdir(parents=True, exist_ok=True)
        with open(path, "rb") as src, open(target_path, "wb") as dst:
            dst.write(src.read())
        send({"event": "complete", "oid": oid})
    except Exception as e:
        send({"event": "error", "oid": oid, "code": 500, "message": str(e)})

def handle_download(request):
    log_debug(f"Download request: {request}")
    oid = request["oid"]

    if 'path' not in request:
        # import tempfile
        # # Get the path to the temporary directory
        # temp_dir = tempfile.gettempdir()
        # path = Path(temp_dir) / oid
        path = Path(GIT_LFS_DIR / oid[:2] / oid[2:4] / oid)
        path.parent.mkdir(parents=True, exist_ok=True)
    else:
        path = Path(request["path"])

    source_path = STORAGE_DIR / oid[:2] / oid[2:4] / oid
    if not source_path.exists():
        source_path = STORAGE_DIR / oid
        if not source_path.exists():
            send({"event": "error", "oid": oid, "code": 404, "message": "Object not found"})
            return
    log_debug(f"Downloading {oid} to {path}")
    try:
        with open(source_path, "rb") as src, open(path, "wb") as dst:
            dst.write(src.read())
        send({"event": "complete", "oid": oid, "path": str(path)})
    except Exception as e:
        log_debug({"event": "error", "oid": oid, "code": 404, "message": str(e)})
        send({"event": "error", "oid": oid, "code": 404, "message": str(e)})

def main():
    while True:
        line = sys.stdin.readline()
        log_debug(f"read {line}")

        if not line:
            break
        try:
            request = json.loads(line)
            event = request["event"]

            if event == "init":
                handle_init(request)
            elif event == "upload":
                handle_upload(request)
            elif event == "download":
                handle_download(request)
            else:
                log_debug(f"Unhandled event: {event}")
        except Exception as e:
            log_debug(f"Exception: {str(e)}")

if __name__ == "__main__":
    log_debug("Starting transfer script...")
    main()
