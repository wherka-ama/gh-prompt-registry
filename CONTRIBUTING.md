# Contributing to gh-prompt-registry

Thanks for contributing.

This repository packages and distributes `prompt-registry` as a GitHub CLI extension.

## Ways to Contribute

1. Improve build/release workflows in this repository.
2. Improve documentation and onboarding.
3. Propose fixes that improve extension installation and runtime behavior.

For feature and bug discussions in the core CLI, use the upstream repository:
https://github.com/AmadeusITGroup/prompt-registry/issues

## Development Setup

### Prerequisites

- Git
- GitHub CLI (`gh`)
- `make`
- Node.js LTS (used by the build process in the upstream cloned repository)

### Clone and prepare

```bash
git clone https://github.com/YOUR_USERNAME/gh-prompt-registry.git
cd gh-prompt-registry
git remote add upstream https://github.com/AmadeusITGroup/gh-prompt-registry.git
```

### Build and test locally

For a quick build using the official repository:

```bash
# Build extension artifact for your local platform
make build-local

# Install built extension locally
gh extension install ./gh-prompt-registry

# On Windows, use the executable name instead
# gh extension install ./gh-prompt-registry.exe

# Smoke test
gh prompt-registry --help

# Cleanup local extension install when done
gh extension remove gh-prompt-registry
```

### Build and test with your fork

To develop against your own fork of prompt-registry:

```bash
# Create .env.local from the template
cp .env.local.example .env.local

# Edit .env.local with your fork details
# REPO_URL="https://github.com/your-username/prompt-registry.git"
# BRANCH="feature/your-branch"

# Build uses your fork automatically
make build-local

# Install and test
gh extension install ./gh-prompt-registry
gh prompt-registry --help
gh extension remove gh-prompt-registry

# Or use CLI arguments directly:
./scripts/build.sh --repo-url "https://github.com/your-username/prompt-registry.git" --branch "feature/your-branch" --local
```

The `.env.local` file is git-ignored, so it won't be committed. This is useful for persistent local configuration across builds.

## Pull Request Process

1. Create a branch from `main`.
2. Keep changes focused and include documentation updates when behavior changes.
3. Open a pull request with context, scope, and validation details.
4. Address review feedback and keep the branch up to date.

### Review expectations

- First maintainer response target: within 3 business days.
- If a PR is blocked longer than 5 business days, mention maintainers in the PR thread.

## Code and Commit Guidelines

- Prefer small, reviewable commits.
- Keep scripts portable across Linux/macOS/Windows where practical.
- Use descriptive commit messages (Conventional Commits encouraged).

## Code of Conduct

By participating, you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md).
