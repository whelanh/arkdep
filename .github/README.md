# Automated AtomicArch Builds

This repository provides automated daily builds of AtomicArch ***configurations*** (not images) using GitHub Actions. AtomicArch is a
customized Arkane Linux image and is only useful if you already have installed Arkane.  You should refer 
to https://arkanelinux.org/ for full details on Arkane Linux.

This customization was designed to emulate Bluefin-dx. In addition to the image, there is an init script to install 
AtomicArch.  There is a second init script after you've installed and rebooted into this customized image to add useful Flatpaks,
chezmoi, Brew etc.  These init scripts only have to be run once.

The arkdep-build.d/atomicarch/extensions/post_install.sh does also add two AUR packages: rstudio-desktop-bin and r-rjava.

### `The automated build function is not too useful as it doesn't build a full image (due to Google's 14 Gb space constraint).`
Currently it's only tracking changes in my configuration.


## Workflow

### `build-atomicarch.yml` (Main Workflow)
- **Runs daily at 2:00 AM UTC** automatically
- **Can be triggered manually** via GitHub Actions interface  
- **Creates configuration-only builds** optimized for GitHub Actions storage constraints
- **Validates configurations** without requiring 50GB+ storage
- **Generates releases** with downloadable configuration archives

## What You Get

**Configuration-Only Builds** containing:
- ✅ All AtomicArch configuration files
- ✅ Package lists and dependencies
- ✅ Overlay files and customizations  
- ✅ Build scripts and metadata
- ✅ Validation that configurations work

**NOT included** (due to storage constraints):
- ❌ Complete system images (requires 50GB+ storage)
- ❌ Bootable filesystems
- ❌ Full package installations

## Features

- **Daily automated builds** - Stay up-to-date with configuration changes
- **Manual triggering** - Build on-demand via GitHub Actions
- **Automatic releases** - Downloadable archives with each build
- **Smart cleanup** - Keeps only the latest 3 builds
- **Change detection** - Triggers on atomicarch configuration updates
- **Version comparison** - Track changes between builds

## Build Artifacts

Each successful build creates:
1. **GitHub Release** with timestamp tag (e.g., `atomicarch-minimal-20250706021500`)
2. **Compressed configuration archive** (a few MB)
3. **Build artifacts** available for 30 days in Actions tab
4. **Build validation** - ensures your configuration works

## Manual Triggering

1. Go to your repository on GitHub
2. Click **"Actions"** tab
3. Select **"Build AtomicArch Daily"**
4. Click **"Run workflow"**
5. Select branch and click **"Run workflow"**

## Using Build Products

### Download Configuration Archives
```bash
# Get latest release
curl -L "https://github.com/whelanh/arkdep/releases/latest/download/atomicarch-minimal-*.tar.gz" -o latest-config.tar.gz

# Extract configuration
tar -xzf latest-config.tar.gz
```

### Create Full System Build
```bash
# On a system with 50GB+ storage
tar -xzf atomicarch-minimal-*.tar.gz
cd arkdep  # or extracted directory
sudo arkdep-build atomicarch
```

### Compare Versions
```bash
# Use the provided comparison tool
./compare-versions.sh              # Compare latest two
./compare-versions.sh -v           # Detailed comparison
./compare-versions.sh -d package.list  # Specific file diff
```

## Customization

### Change Build Schedule
Edit `.github/workflows/build-atomicarch.yml`:
```yaml
schedule:
  - cron: '0 2 * * *'  # Daily at 2:00 AM UTC
```

### Keep More/Fewer Builds
Modify the cleanup section:
```javascript
.slice(3);  // Keep 3 builds, change as needed
```

### Modify AtomicArch Configuration
Edit files in `arkdep-build.d/atomicarch/` to customize your build:
- `package.list` - Main packages
- `bootstrap.list` - Bootstrap packages  
- `pacman.conf` - Pacman configuration
- `overlay/` - Custom files and configurations

## Troubleshooting

### Build Failures
1. Check **Actions** tab for detailed error logs
2. Verify configuration files are valid
3. Test locally: `sudo arkdep-build atomicarch`
4. Use version comparison to see what changed

### No Releases Created
- Ensure repository has **Actions** enabled
- Check workflow permissions in repository settings
- Verify the workflow completed successfully

### Comparison Tool Issues
```bash
# Ensure dependencies are available
which curl diff comm sort grep

# Make script executable
chmod +x compare-versions.sh
```

## Architecture

This system provides:
- **Daily validation** of AtomicArch configurations
- **Lightweight builds** that fit GitHub Actions constraints  
- **Version tracking** for configuration changes
- **Foundation** for full builds on proper hardware
- **Change monitoring** through comparison tools

The approach solves the "50GB requirement vs 14GB available" problem by creating configuration-only builds that validate your setup and provide everything needed for full builds elsewhere.
