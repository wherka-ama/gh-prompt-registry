# gh-prompt-registry

GitHub CLI extension for the Prompt Registry CLI tool.

## Purpose

This is a **sidecar repository** that builds and distributes the Prompt Registry CLI as a GitHub CLI extension. The main Prompt Registry repository is at [AmadeusITGroup/prompt-registry](https://github.com/AmadeusITGroup/prompt-registry).

## Installation

```bash
gh extension install AmadeusITGroup/gh-prompt-registry
```

## Usage

```bash
# Show help
gh prompt-registry --help

# Validate collections
gh prompt-registry collection validate

# Build bundles
gh prompt-registry bundle build

# Install bundles
gh prompt-registry install
```

## Development

### Local Build

```bash
# Build for current platform only
make build-local

# Build for all platforms (requires Phase 3 implementation)
make build

# Clean build artifacts
make clean
```

### Manual Build

```bash
# Build from specific tag
./scripts/build.sh --tag v1.0.4

# Build for current platform
./scripts/build.sh --local
```

### Testing GitHub CLI Extension Locally

```bash
# Build locally
make build-local

# Install as local extension
gh extension install ./gh-prompt-registry-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m)

# Test the extension
gh prompt-registry --help

# Uninstall when done
gh extension remove gh-prompt-registry
```

## Binary Naming Convention

GitHub CLI extensions require specific naming for binary assets:
```
OS-ARCH[.exe]

Examples:
linux-amd64
linux-arm64
darwin-amd64
darwin-arm64
windows-amd64.exe
windows-arm64.exe
```

The extension name is inferred from the repository name (`gh-prompt-registry`), not part of the binary filename.

## Release Process

Releases are automated via GitHub Actions:
1. Create a release in the main Prompt Registry repository
2. This repository's workflow triggers on the release
3. Binaries are built for all platforms
4. Binaries are renamed to gh extension naming convention
5. Checksums are generated
6. Assets are uploaded to the release

## Repository Structure

```
gh-prompt-registry/
├── .github/
│   └── workflows/
│       └── release.yml          # CI/CD for building and releasing
├── scripts/
│   └── build.sh                  # Build script for all platforms
├── Makefile                      # Build targets for local development
└── README.md                     # This file
```

## License

MIT License - see the main Prompt Registry repository for details.
