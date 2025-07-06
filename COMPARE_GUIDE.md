# AtomicArch Version Comparison Guide

This guide shows you how to compare different versions of your AtomicArch configurations from daily builds.

## Quick Commands

### Basic Comparison (Latest Two Versions)
```bash
./compare-versions.sh
```

### Detailed Comparison with All Changes
```bash
./compare-versions.sh -v
```

### Compare Specific Versions
```bash
./compare-versions.sh atomicarch-minimal-20250705120000 atomicarch-minimal-20250706120000
```

### Show Detailed Diff for Specific File
```bash
./compare-versions.sh -d package.list
./compare-versions.sh -d pacman.conf
./compare-versions.sh -d bootstrap.list
```

## Example Output

### Summary Output (Default)
```
=== Summary: atomicarch-minimal-20250705120000 → atomicarch-minimal-20250706120000 ===
Build dates:
  Build Date: 20250705120000
  Build Date: 20250706120000
Changes detected:
  Package changes: 3
  Total configuration changes: (run with -v for details)
```

### Verbose Output (-v flag)
```
=== Package Changes ===
+ Package: firefox
+ Package: htop
- Package: nano

=== Configuration File Changes ===
~ File: pacman.conf
  Lines: 45 → 47 (+2)
+ File: new-config.conf

=== Overlay Changes ===
+ Overlay: post_bootstrap/etc/systemd/system/my-service.service
~ Overlay: post_bootstrap/etc/profile.d/custom.sh
```

## Color Coding

- 🟢 **Green (+)**: Added items (packages, files)
- 🔴 **Red (-)**: Removed items
- 🟡 **Yellow (~)**: Changed/Modified items
- 🔵 **Blue (===)**: Section headers

## Common Use Cases

### Track Package Changes
```bash
# See what packages were added/removed
./compare-versions.sh -v | grep "Package:"
```

### Monitor Configuration Drift
```bash
# Check for configuration file changes
./compare-versions.sh -v | grep "File:"
```

### Review Overlay Updates
```bash
# See overlay file changes
./compare-versions.sh -v | grep "Overlay:"
```

### Compare Specific Dates
```bash
# Compare last week vs today
./compare-versions.sh atomicarch-minimal-$(date -d '7 days ago' +%Y%m%d)120000 atomicarch-minimal-$(date +%Y%m%d)120000
```

## Advanced Usage

### Get List of Available Versions
```bash
curl -s "https://api.github.com/repos/whelanh/arkdep/releases" | grep '"tag_name"' | grep 'atomicarch-minimal'
```

### Download Specific Version for Manual Inspection
```bash
VERSION="atomicarch-minimal-20250706120000"
curl -L "https://github.com/whelanh/arkdep/releases/download/${VERSION}/${VERSION}.tar.gz" -o ${VERSION}.tar.gz
tar -xzf ${VERSION}.tar.gz
```

### Compare Local Changes vs Latest Release
```bash
# First download latest release
curl -L "https://github.com/whelanh/arkdep/releases/latest/download/atomicarch-minimal-*.tar.gz" -o latest.tar.gz
tar -xzf latest.tar.gz

# Then compare
diff -r arkdep-build.d/atomicarch/ extracted-release/arkdep-build.d/atomicarch/
```

## Automation Ideas

### Daily Change Report
```bash
#!/bin/bash
# Save as daily-changes.sh
echo "=== Daily AtomicArch Changes $(date) ===" >> changes.log
./compare-versions.sh -v >> changes.log
echo "====================================" >> changes.log
```

### Email Notifications on Changes
```bash
#!/bin/bash
CHANGES=$(./compare-versions.sh -v)
if [[ $(echo "$CHANGES" | grep -E "^\+|^-|^~" | wc -l) -gt 0 ]]; then
    echo "$CHANGES" | mail -s "AtomicArch Changes Detected" user@example.com
fi
```

### Integration with CI/CD
```bash
# In your build pipeline
if ./compare-versions.sh -v | grep -q "Package:"; then
    echo "Package changes detected, running additional tests..."
    # Run your test suite
fi
```

## Troubleshooting

### Script Won't Download
- Check internet connection
- Verify GitHub repository is accessible
- Ensure curl is installed

### No Versions Found
- Verify you have releases with "atomicarch-minimal" in the tag name
- Check if GitHub API rate limiting is affecting requests
- Ensure releases are public

### Permission Errors
```bash
chmod +x compare-versions.sh
```

### Missing Dependencies
```bash
# Ensure required tools are installed
which curl diff comm sort grep
```
