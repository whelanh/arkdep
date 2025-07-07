#!/bin/bash

# One-liner version: Copy newest .tar.zst and remove files older than 2nd newest .tar.zst
# Usage: copy_cleanup_oneliner.sh <destination_directory>

set -euo pipefail

#DEST_DIR="$1"
DEST_DIR="/arkdep/cache"
NEWEST=$(find . -name "*.tar.zst" -type f -printf "%T@ %p\n" | sort -nr | head -1 | cut -d' ' -f2-)
THRESHOLD_TIME=$(find . -name "*.tar.zst" -type f -printf "%T@ %p\n" | sort -nr | head -2 | tail -1 | cut -d' ' -f1)

cd /home/$(whoami)/Downloads/arkdep/target
echo "Copying $(basename "$NEWEST") to $DEST_DIR"
sudo cp "$NEWEST" "$DEST_DIR"

echo "Removing files older than $(date -d "@$THRESHOLD_TIME" '+%Y-%m-%d %H:%M:%S')"
find . -maxdepth 1 -type f -not -newermt "@$THRESHOLD_TIME" -exec sudo rm -r  -v {} \;

echo "Done!"
