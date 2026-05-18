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

## Contributing

Contributions are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for setup, workflow, and review expectations.

For issues and feature requests in the core CLI project, use:
https://github.com/AmadeusITGroup/prompt-registry/issues

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

### Local Development with Fork

For local development, you can override the repository URL and branch:

```bash
# Copy the example configuration
cp .env.local.example .env.local

# Edit .env.local with your fork details
REPO_URL="https://github.com/your-username/prompt-registry.git"
BRANCH="feature/my-feature"

# Build uses your fork and branch automatically
make build-local
```

Alternatively, use CLI arguments:

```bash
# Override repository and branch via CLI
./scripts/build.sh --repo-url "https://github.com/your-username/prompt-registry.git" --branch "feature/my-feature" --local

# Or build from a specific tag
./scripts/build.sh --tag v1.0.4 --local
```

Note: CLI arguments take precedence over `.env.local` settings.

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
gh extension install ./gh-prompt-registry

# On Windows, use the executable name instead
# gh extension install ./gh-prompt-registry.exe

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

For local development, `make build-local` also creates a `gh-prompt-registry` (or `gh-prompt-registry.exe` on Windows) alias alongside the release-style binary name so it can be installed directly with `gh extension install`.

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
│   ├── CODEOWNERS               # Default code owners
│   ├── PULL_REQUEST_TEMPLATE.md # PR checklist and context
│   └── workflows/
│       └── release.yml          # CI/CD for building and releasing
├── scripts/
│   └── build.sh                  # Build script for all platforms
├── Makefile                      # Build targets for local development
├── CONTRIBUTING.md               # Contributor workflow
├── CODE_OF_CONDUCT.md            # Community behavior expectations
├── SECURITY.md                   # Vulnerability reporting policy
├── LICENSE                       # MIT license
└── README.md                     # This file
```

## Maintainers

- [@wherka-ama](https://github.com/wherka-ama)

## Security

For responsible disclosure guidance, see [SECURITY.md](SECURITY.md).

## License

MIT License. See [LICENSE](LICENSE).
