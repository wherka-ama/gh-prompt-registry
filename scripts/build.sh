#!/bin/bash
set -e

# Build script for gh-prompt-registry sidecar repository
# This script clones the official prompt-registry repository and builds CLI binaries

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Load .env.local if it exists
if [ -f "$REPO_DIR/.env.local" ]; then
  source "$REPO_DIR/.env.local"
fi

# Set defaults (can be overridden by .env.local or command-line args)
OFFICIAL_REPO_URL="${REPO_URL:-https://github.com/AmadeusITGroup/prompt-registry.git}"
OFFICIAL_REPO_DIR="$REPO_DIR/prompt-registry"
BRANCH="${BRANCH:-}"

# Parse arguments
TAG=""
LOCAL=false
PLATFORM=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --tag)
      TAG="$2"
      shift 2
      ;;
    --branch)
      BRANCH="$2"
      shift 2
      ;;
    --repo-url)
      OFFICIAL_REPO_URL="$2"
      shift 2
      ;;
    --local)
      LOCAL=true
      shift
      ;;
    --platform)
      PLATFORM="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Clone official repository if not already present
if [ ! -d "$OFFICIAL_REPO_DIR" ]; then
  echo "Cloning official repository..."
  git clone "$OFFICIAL_REPO_URL" "$OFFICIAL_REPO_DIR"
fi

cd "$OFFICIAL_REPO_DIR"

# Fetch latest tags and branches
echo "Fetching latest tags and branches..."
git fetch --tags
git fetch origin

# Determine what to checkout
if [ -n "$TAG" ]; then
  echo "Checking out tag: $TAG"
  git checkout "$TAG"
elif [ -n "$BRANCH" ]; then
  echo "Checking out branch: $BRANCH"
  # Try to checkout the branch, creating a local tracking branch if needed
  if git show-ref --quiet --verify "refs/remotes/origin/$BRANCH"; then
    # Remote branch exists, create local tracking branch
    git checkout -b "$BRANCH" "origin/$BRANCH" 2>/dev/null || git checkout "$BRANCH"
  else
    # Try direct checkout (in case it's already a local branch or detached)
    git checkout "$BRANCH"
  fi
else
  echo "Checking out latest tag..."
  LATEST_TAG=$(git describe --tags --abbrev=0)
  git checkout "$LATEST_TAG"
fi

cd lib

# Install dependencies
echo "Installing dependencies..."
npm ci

# Build CLI
echo "Building CLI..."
npm run build

# Build SEA binaries
echo "Building SEA binaries..."
if [ "$LOCAL" = true ]; then
  # Build for current platform only
  echo "Building for current platform only..."
  npm run build:sea
else
  # Build for all platforms
  echo "Building for all platforms..."
  # Add platform-specific build commands here
  # This will be implemented in Phase 3
  echo "Cross-platform build not yet implemented (Phase 3)"
fi

# Rename binaries to gh extension naming convention
echo "Renaming binaries to gh extension naming convention..."
cd dist

# Detect current platform to generate proper binary name
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Handle architecture name mappings
case "$ARCH" in
  x86_64)
    ARCH="amd64"
    ;;
  aarch64)
    ARCH="arm64"
    ;;
esac

CURRENT_BINARY_NAME="$OS-$ARCH"
if [ "$OS" = "windows" ] || [ "$OS" = "msys" ] || [ "$OS" = "cygwin" ]; then
  CURRENT_BINARY_NAME="$CURRENT_BINARY_NAME.exe"
fi

# Rename existing binaries to gh extension convention
for file in prompt-registry-*; do
  if [ -f "$file" ]; then
    # Rename to OS-ARCH[.exe] (extension name is inferred from repo name)
    new_name="${file#prompt-registry-}"
    mv "$file" "$new_name"
    echo "Renamed: $file -> $new_name"
  fi
done

# Also handle the case where binary is named 'prompt-registry' (current platform build)
if [ -f "prompt-registry" ]; then
  # Rename to OS-ARCH convention
  new_binary_name="$CURRENT_BINARY_NAME"
  mv "prompt-registry" "$new_binary_name"
  echo "Renamed: prompt-registry -> $new_binary_name"
fi

cd "$REPO_DIR"

# Move only binary files to repository root
echo "Moving binaries to repository root..."
cd "$OFFICIAL_REPO_DIR/lib/dist"

# Find and move only files that look like binaries (not directories, not .js, .d.ts, .sha256, etc.)
# Binary files are: linux-*, darwin-*, windows-*.exe
for binary in linux-* darwin-* windows-*.exe; do
  if [ -f "$binary" ]; then
    mv "$binary" "$REPO_DIR/"
    echo "Moved: $binary"
  fi
done

# Move checksum file if it exists
for checksum in *.sha256; do
  if [ -f "$checksum" ]; then
    mv "$checksum" "$REPO_DIR/"
    echo "Moved: $checksum"
  fi
done

cd "$REPO_DIR"

# For local development, create a gh extension-friendly alias
if [ "$LOCAL" = true ]; then
  echo "Creating local extension alias..."
  LOCAL_ALIAS_NAME="gh-prompt-registry"
  if [ "$CURRENT_BINARY_NAME" != "${CURRENT_BINARY_NAME%.exe}" ]; then
    LOCAL_ALIAS_NAME="$LOCAL_ALIAS_NAME.exe"
  fi

  if [ -f "$REPO_DIR/$CURRENT_BINARY_NAME" ]; then
    cp "$REPO_DIR/$CURRENT_BINARY_NAME" "$REPO_DIR/$LOCAL_ALIAS_NAME"
    chmod +x "$REPO_DIR/$LOCAL_ALIAS_NAME"
    echo "Created: $LOCAL_ALIAS_NAME"
  fi
fi

echo "Build complete!"
