#!/usr/bin/env bash

# AtomicArch Configuration Version Comparison Tool
# Usage: ./compare-versions.sh [version1] [version2]
# If no versions specified, compares latest two releases

set -e

REPO="whelanh/arkdep"
TEMP_DIR="/tmp/atomicarch-compare"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_added() {
    echo -e "${GREEN}+ $1${NC}"
}

print_removed() {
    echo -e "${RED}- $1${NC}"
}

print_changed() {
    echo -e "${YELLOW}~ $1${NC}"
}

# Function to get latest releases
get_releases() {
    curl -s "https://api.github.com/repos/${REPO}/releases" | \
    grep '"tag_name"' | \
    grep 'atomicarch-minimal' | \
    head -10 | \
    sed 's/.*"tag_name": "\(.*\)".*/\1/'
}

# Function to download and extract a version
download_version() {
    local version=$1
    local target_dir=$2
    
    echo "Downloading $version..."
    curl -L -s "https://github.com/${REPO}/releases/download/${version}/${version}.tar.gz" \
         -o "${TEMP_DIR}/${version}.tar.gz"
    
    mkdir -p "$target_dir"
    tar -xzf "${TEMP_DIR}/${version}.tar.gz" -C "$target_dir" --strip-components=1 2>/dev/null || \
    tar -xzf "${TEMP_DIR}/${version}.tar.gz" -C "$target_dir" 2>/dev/null
}

# Function to compare package lists
compare_packages() {
    local dir1="$1/arkdep-build.d/atomicarch"
    local dir2="$2/arkdep-build.d/atomicarch"
    
    if [[ -f "$dir1/package.list" && -f "$dir2/package.list" ]]; then
        print_header "Package Changes"
        
        # Find added packages
        comm -13 <(sort "$dir1/package.list") <(sort "$dir2/package.list") | while read pkg; do
            [[ -n "$pkg" ]] && print_added "Package: $pkg"
        done
        
        # Find removed packages
        comm -23 <(sort "$dir1/package.list") <(sort "$dir2/package.list") | while read pkg; do
            [[ -n "$pkg" ]] && print_removed "Package: $pkg"
        done
    fi
    
    if [[ -f "$dir1/bootstrap.list" && -f "$dir2/bootstrap.list" ]]; then
        print_header "Bootstrap Package Changes"
        
        # Find added bootstrap packages
        comm -13 <(sort "$dir1/bootstrap.list") <(sort "$dir2/bootstrap.list") | while read pkg; do
            [[ -n "$pkg" ]] && print_added "Bootstrap: $pkg"
        done
        
        # Find removed bootstrap packages
        comm -23 <(sort "$dir1/bootstrap.list") <(sort "$dir2/bootstrap.list") | while read pkg; do
            [[ -n "$pkg" ]] && print_removed "Bootstrap: $pkg"
        done
    fi
}

# Function to compare configuration files
compare_configs() {
    local dir1="$1/arkdep-build.d/atomicarch"
    local dir2="$2/arkdep-build.d/atomicarch"
    
    print_header "Configuration File Changes"
    
    # Find all config files
    find "$dir1" -type f \( -name "*.conf" -o -name "*.list" -o -name "*.sh" \) 2>/dev/null | \
    sed "s|$dir1/||" | sort > "${TEMP_DIR}/files1.txt"
    
    find "$dir2" -type f \( -name "*.conf" -o -name "*.list" -o -name "*.sh" \) 2>/dev/null | \
    sed "s|$dir2/||" | sort > "${TEMP_DIR}/files2.txt"
    
    # Added files
    comm -13 "${TEMP_DIR}/files1.txt" "${TEMP_DIR}/files2.txt" | while read file; do
        [[ -n "$file" ]] && print_added "File: $file"
    done
    
    # Removed files
    comm -23 "${TEMP_DIR}/files1.txt" "${TEMP_DIR}/files2.txt" | while read file; do
        [[ -n "$file" ]] && print_removed "File: $file"
    done
    
    # Changed files
    comm -12 "${TEMP_DIR}/files1.txt" "${TEMP_DIR}/files2.txt" | while read file; do
        if [[ -n "$file" ]] && ! diff -q "$dir1/$file" "$dir2/$file" >/dev/null 2>&1; then
            print_changed "File: $file"
            
            # Show line count difference
            lines1=$(wc -l < "$dir1/$file" 2>/dev/null || echo "0")
            lines2=$(wc -l < "$dir2/$file" 2>/dev/null || echo "0")
            if [[ $lines1 -ne $lines2 ]]; then
                echo "  Lines: $lines1 → $lines2 ($(($lines2 - $lines1)))"
            fi
        fi
    done
}

# Function to compare overlay files
compare_overlays() {
    local dir1="$1/arkdep-build.d/atomicarch/overlay"
    local dir2="$2/arkdep-build.d/atomicarch/overlay"
    
    if [[ -d "$dir1" && -d "$dir2" ]]; then
        print_header "Overlay Changes"
        
        # Find all overlay files
        find "$dir1" -type f 2>/dev/null | sed "s|$dir1/||" | sort > "${TEMP_DIR}/overlay1.txt"
        find "$dir2" -type f 2>/dev/null | sed "s|$dir2/||" | sort > "${TEMP_DIR}/overlay2.txt"
        
        # Added overlay files
        comm -13 "${TEMP_DIR}/overlay1.txt" "${TEMP_DIR}/overlay2.txt" | while read file; do
            [[ -n "$file" ]] && print_added "Overlay: $file"
        done
        
        # Removed overlay files
        comm -23 "${TEMP_DIR}/overlay1.txt" "${TEMP_DIR}/overlay2.txt" | while read file; do
            [[ -n "$file" ]] && print_removed "Overlay: $file"
        done
        
        # Changed overlay files
        comm -12 "${TEMP_DIR}/overlay1.txt" "${TEMP_DIR}/overlay2.txt" | while read file; do
            if [[ -n "$file" ]] && ! diff -q "$dir1/$file" "$dir2/$file" >/dev/null 2>&1; then
                print_changed "Overlay: $file"
            fi
        done
    fi
}

# Function to show detailed diff for a specific file
show_file_diff() {
    local file="$1"
    local dir1="$2/arkdep-build.d/atomicarch"
    local dir2="$3/arkdep-build.d/atomicarch"
    
    if [[ -f "$dir1/$file" && -f "$dir2/$file" ]]; then
        print_header "Detailed diff for $file"
        diff -u "$dir1/$file" "$dir2/$file" | head -50
    fi
}

# Function to generate summary
generate_summary() {
    local version1="$1"
    local version2="$2"
    local dir1="$3"
    local dir2="$4"
    
    print_header "Summary: $version1 → $version2"
    
    # Count changes
    local pkg_changes=0
    local file_changes=0
    local overlay_changes=0
    
    if [[ -f "$dir1/arkdep-build.d/atomicarch/package.list" && -f "$dir2/arkdep-build.d/atomicarch/package.list" ]]; then
        pkg_changes=$(comm -3 <(sort "$dir1/arkdep-build.d/atomicarch/package.list") <(sort "$dir2/arkdep-build.d/atomicarch/package.list") | wc -l)
    fi
    
    # Build info comparison
    if [[ -f "$dir1/build-info.txt" && -f "$dir2/build-info.txt" ]]; then
        echo "Build dates:"
        grep "Build Date" "$dir1/build-info.txt" 2>/dev/null || echo "  Version 1: Unknown"
        grep "Build Date" "$dir2/build-info.txt" 2>/dev/null || echo "  Version 2: Unknown"
    fi
    
    echo "Changes detected:"
    echo "  Package changes: $pkg_changes"
    echo "  Total configuration changes: (run with -v for details)"
}

# Main function
main() {
    local version1="$1"
    local version2="$2"
    local verbose=false
    local detail_file=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--verbose)
                verbose=true
                shift
                ;;
            -d|--detail)
                detail_file="$2"
                shift 2
                ;;
            -h|--help)
                echo "Usage: $0 [version1] [version2] [options]"
                echo "Options:"
                echo "  -v, --verbose     Show detailed changes"
                echo "  -d, --detail FILE Show detailed diff for specific file"
                echo "  -h, --help        Show this help"
                echo ""
                echo "Examples:"
                echo "  $0                              # Compare latest two versions"
                echo "  $0 -v                           # Compare with verbose output"
                echo "  $0 version1 version2            # Compare specific versions"
                echo "  $0 -d package.list version1 version2  # Show detailed diff for package.list"
                exit 0
                ;;
            *)
                if [[ -z "$version1" ]]; then
                    version1="$1"
                elif [[ -z "$version2" ]]; then
                    version2="$1"
                fi
                shift
                ;;
        esac
    done
    
    # Setup temp directory
    rm -rf "$TEMP_DIR"
    mkdir -p "$TEMP_DIR"
    
    # Get versions if not specified
    if [[ -z "$version1" || -z "$version2" ]]; then
        echo "Getting latest releases..."
        releases=($(get_releases))
        
        if [[ ${#releases[@]} -lt 2 ]]; then
            echo "Error: Need at least 2 releases to compare"
            exit 1
        fi
        
        version1="${version1:-${releases[1]}}"  # Older version
        version2="${version2:-${releases[0]}}"  # Newer version
    fi
    
    echo "Comparing $version1 → $version2"
    
    # Download and extract both versions
    download_version "$version1" "${TEMP_DIR}/v1"
    download_version "$version2" "${TEMP_DIR}/v2"
    
    if [[ -n "$detail_file" ]]; then
        show_file_diff "$detail_file" "${TEMP_DIR}/v1" "${TEMP_DIR}/v2"
    elif [[ "$verbose" == true ]]; then
        compare_packages "${TEMP_DIR}/v1" "${TEMP_DIR}/v2"
        echo ""
        compare_configs "${TEMP_DIR}/v1" "${TEMP_DIR}/v2"
        echo ""
        compare_overlays "${TEMP_DIR}/v1" "${TEMP_DIR}/v2"
    else
        generate_summary "$version1" "$version2" "${TEMP_DIR}/v1" "${TEMP_DIR}/v2"
    fi
    
    # Cleanup
    rm -rf "$TEMP_DIR"
}

# Run main function with all arguments
main "$@"
