# Automated AtomicArch Builds

This repository includes GitHub Actions workflows that automatically build AtomicArch images daily.

## Workflows

### 1. `build-atomicarch-simple.yml` (Recommended)
- Uses an Arch Linux container with proper loop device support
- Simplified setup with explicit dependency installation
- Runs daily at 2:00 AM UTC
- Can be triggered manually via GitHub Actions tab
- Creates releases with build artifacts

### 2. `build-atomicarch-container.yml` (Fixed)
- Updated to install arch-install-scripts properly
- Same functionality as simple version
- Use if simple version fails

### 3. `build-atomicarch.yml` (Complex fallback)
- Attempts to set up Arch Linux tools on Ubuntu
- More complex setup, use only if container approaches fail
- Same scheduling and functionality

## Features

- **Daily automated builds** at 2:00 AM UTC
- **Manual triggering** via GitHub Actions interface
- **Automatic releases** with downloadable artifacts
- **Cleanup** - keeps only the latest 7 builds
- **Triggered on changes** to atomicarch configuration

## Build Artifacts

Each successful build creates:
1. **GitHub Release** with timestamp tag (e.g., `atomicarch-20250706021500`)
2. **Compressed archive** containing the built image
3. **Build artifacts** available for 30 days in Actions tab

## Manual Triggering

1. Go to your repository on GitHub
2. Click "Actions" tab
3. Select "Build AtomicArch Daily (Container)"
4. Click "Run workflow"
5. Select branch and click "Run workflow"

## Download Built Images

1. Go to "Releases" section of your repository
2. Download the latest `atomicarch-*.tar.gz` file
3. Extract: `tar -xzf atomicarch-*.tar.gz`
4. Use with arkdep as normal

## Customization

### Change Build Schedule
Edit the cron expression in the workflow files:
```yaml
schedule:
  - cron: '0 2 * * *'  # Daily at 2:00 AM UTC
```

### Keep More/Fewer Builds
Modify the cleanup script in the workflow:
```javascript
.slice(7);  // Keep 7 builds, change as needed
```

### Modify Build Parameters
Edit `arkdep-build.d/atomicarch/` configuration files to customize the build.

## Troubleshooting

If builds fail:
1. Check the Actions tab for error logs
2. Ensure arkdep-build script is executable
3. Verify atomicarch configuration is valid
4. Try running manually to test

## Requirements

- Repository must be public or have GitHub Actions enabled
- Default GitHub token permissions are sufficient
- No additional secrets required
