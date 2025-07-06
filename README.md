<div align="center">
	<a href="https://arkanelinux.org" align="center">
		<center align="center">
			<picture>
			 	<img src="https://raw.githubusercontent.com/arkanelinux/artwork/main/originals/arkdep-logo-small.png" alt="Arkdep Logo" align="center" height="200">
			</picture>
		</center>
	</a>
	<br>
	<h1 align="center"><center>Arkdep</center></h1>
</div>
<br>

Arkdep is the set of tools providing immutability to Arkane Linux. It attempts to differentiate itself from other similar tools by being "stupidly simple", hackable, flexible and easy to adopt for personal projects.

> [!NOTE]
> Arkdep is still in active development, breaking changes might still happen as the project moves toward stable. The current codebase has yet to be thoroughly tested, there may be lingering bugs or other issues.

## Documentation and usage
For documentation refer to the [Arkane Linux Arkdep Documentation](https://docs.arkanelinux.org/arkdep/arkdep-usage/).

## Automated AtomicArch Builds

This repository includes automated daily builds of AtomicArch configurations via GitHub Actions.

### 🚀 Quick Start

**Download latest configuration:**
```bash
# Get the latest daily build
curl -L "https://github.com/whelanh/arkdep/releases/latest/download/atomicarch-minimal-*.tar.gz" -o atomicarch-latest.tar.gz
tar -xzf atomicarch-latest.tar.gz
```

**Compare versions:**
```bash
# See what changed between builds
./compare-versions.sh -v
```

**Create full system build:**
```bash
# On a system with 50GB+ storage
sudo arkdep-build atomicarch
```

### 📦 What You Get

- **Daily configuration validation** - Ensures your AtomicArch setup works
- **Lightweight archives** - Configuration files only (MB not GB)
- **Version tracking** - Compare changes between daily builds  
- **Foundation for full builds** - Everything needed for complete system images

### 🔄 Automated Features

- **Runs daily at 2:00 AM UTC** - Stay current with changes
- **Manual triggering** - Build on-demand via GitHub Actions
- **Automatic cleanup** - Keeps latest 5 builds
- **Change detection** - Triggers on configuration updates
- **Release creation** - Downloadable archives with each build

### 📊 Build Status

![Build Status](https://github.com/whelanh/arkdep/actions/workflows/build-atomicarch.yml/badge.svg)

[View Latest Builds](https://github.com/whelanh/arkdep/actions/workflows/build-atomicarch.yml) | [Download Releases](https://github.com/whelanh/arkdep/releases)

### 📖 More Information

See [.github/README.md](.github/README.md) for detailed documentation about automated builds, version comparison, and customization options.
