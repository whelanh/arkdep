#!/bin/bash
# One-liner version: Copy newest .tar.zst and remove files older than 4 days
# Usage: copy_cleanup_oneliner.sh <destination_directory>
set -euo pipefail

DEST_DIR="/arkdep/cache"
NEWEST=$(find ./target -name "*.tar.zst" -type f -printf "%T@ %p\n" | sort -nr | head -1 | cut -d' ' -f2-)
# Calculate threshold time as 4 days ago (4 * 24 * 60 * 60 = 345600 seconds)
THRESHOLD_TIME=$(($(date +%s) - 345600))
cd ./target
# Extract just the filename from the full path
NEWEST_FILE=$(basename "$NEWEST")
echo "Copying $NEWEST_FILE to $DEST_DIR"
sudo cp "$NEWEST_FILE" "$DEST_DIR"
echo "Removing files older than $(date -d "@$THRESHOLD_TIME" '+%Y-%m-%d %H:%M:%S')"
find . -maxdepth 1 -type f -not -newermt "@$THRESHOLD_TIME" -exec sudo rm -r -v {} \;
echo "Done!"
