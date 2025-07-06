#!/bin/bash

# Script to compare the two most recent *.pkgs files and report differences
# Shows what packages were updated, removed, or added

set -euo pipefail

# Check if a directory argument is provided, otherwise use current directory
TARGET_DIR="${1:-.}"

# Find the two most recent .pkgs files
echo "Finding the two most recent .pkgs files in $TARGET_DIR..."
PKGS_FILES=($(find "$TARGET_DIR" -name "*.pkgs" -type f -printf "%T@ %p\n" | sort -nr | head -2 | cut -d' ' -f2))

if [ ${#PKGS_FILES[@]} -lt 2 ]; then
    echo "Error: Need at least 2 .pkgs files to compare"
    exit 1
fi

NEWER_FILE="${PKGS_FILES[0]}"
OLDER_FILE="${PKGS_FILES[1]}"

echo "Comparing:"
echo "  Newer: $(basename "$NEWER_FILE")"
echo "  Older: $(basename "$OLDER_FILE")"
echo

# Extract package names and versions from files
# Format: number|package_name version
extract_packages() {
    local file="$1"
    cut -d'|' -f2 "$file" | sort
}

# Create temporary files for comparison
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

NEWER_PACKAGES="$TEMP_DIR/newer_packages.txt"
OLDER_PACKAGES="$TEMP_DIR/older_packages.txt"

extract_packages "$NEWER_FILE" > "$NEWER_PACKAGES"
extract_packages "$OLDER_FILE" > "$OLDER_PACKAGES"

# Extract just package names (without versions) for comparison
NEWER_NAMES="$TEMP_DIR/newer_names.txt"
OLDER_NAMES="$TEMP_DIR/older_names.txt"

cut -d' ' -f1 "$NEWER_PACKAGES" > "$NEWER_NAMES"
cut -d' ' -f1 "$OLDER_PACKAGES" > "$OLDER_NAMES"

# Find added packages (in newer but not in older)
ADDED_PACKAGES="$TEMP_DIR/added.txt"
comm -23 "$NEWER_NAMES" "$OLDER_NAMES" > "$ADDED_PACKAGES"

# Find removed packages (in older but not in newer)
REMOVED_PACKAGES="$TEMP_DIR/removed.txt"
comm -13 "$NEWER_NAMES" "$OLDER_NAMES" > "$REMOVED_PACKAGES"

# Find updated packages (same name but different version)
UPDATED_PACKAGES="$TEMP_DIR/updated.txt"
comm -12 "$NEWER_NAMES" "$OLDER_NAMES" > "$TEMP_DIR/common_names.txt"

# For each common package, check if version differs
> "$UPDATED_PACKAGES"
while read -r package_name; do
    newer_version=$(grep "^$package_name " "$NEWER_PACKAGES" | cut -d' ' -f2-)
    older_version=$(grep "^$package_name " "$OLDER_PACKAGES" | cut -d' ' -f2-)
    
    if [ "$newer_version" != "$older_version" ]; then
        echo "$package_name: $older_version -> $newer_version" >> "$UPDATED_PACKAGES"
    fi
done < "$TEMP_DIR/common_names.txt"

# Display results
echo "═══════════════════════════════════════════════════════════════════════════════"
echo "PACKAGE COMPARISON RESULTS"
echo "═══════════════════════════════════════════════════════════════════════════════"
echo

# Count totals
ADDED_COUNT=$(wc -l < "$ADDED_PACKAGES")
REMOVED_COUNT=$(wc -l < "$REMOVED_PACKAGES")
UPDATED_COUNT=$(wc -l < "$UPDATED_PACKAGES")

echo "SUMMARY:"
echo "  Added packages:   $ADDED_COUNT"
echo "  Removed packages: $REMOVED_COUNT"
echo "  Updated packages: $UPDATED_COUNT"
echo

# Show added packages
if [ $ADDED_COUNT -gt 0 ]; then
    echo "┌─ ADDED PACKAGES ($ADDED_COUNT)"
    echo "│"
    while read -r package_name; do
        version=$(grep "^$package_name " "$NEWER_PACKAGES" | cut -d' ' -f2-)
        echo "│  + $package_name $version"
    done < "$ADDED_PACKAGES"
    echo "└─"
    echo
fi

# Show removed packages
if [ $REMOVED_COUNT -gt 0 ]; then
    echo "┌─ REMOVED PACKAGES ($REMOVED_COUNT)"
    echo "│"
    while read -r package_name; do
        version=$(grep "^$package_name " "$OLDER_PACKAGES" | cut -d' ' -f2-)
        echo "│  - $package_name $version"
    done < "$REMOVED_PACKAGES"
    echo "└─"
    echo
fi

# Show updated packages
if [ $UPDATED_COUNT -gt 0 ]; then
    echo "┌─ UPDATED PACKAGES ($UPDATED_COUNT)"
    echo "│"
    while read -r line; do
        echo "│  ↗ $line"
    done < "$UPDATED_PACKAGES"
    echo "└─"
    echo
fi

if [ $ADDED_COUNT -eq 0 ] && [ $REMOVED_COUNT -eq 0 ] && [ $UPDATED_COUNT -eq 0 ]; then
    echo "No differences found between the two package files."
fi

echo "Comparison complete."
