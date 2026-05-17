#!/bin/bash
set -e

# Build script for gh-prompt-registry sidecar repository
# This script clones the official prompt-registry repository and builds CLI binaries

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
OFFICIAL_REPO_URL="https://github.com/AmadeusITGroup/prompt-registry.git"
OFFICIAL_REPO_DIR="$REPO_DIR/prompt-registry"

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

# Fetch latest tags
echo "Fetching latest tags..."
git fetch --tags

# Checkout specific tag if provided
if [ -n "$TAG" ]; then
  echo "Checking out tag: $TAG"
  git checkout "$TAG"
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
for file in prompt-registry-*; do
  if [ -f "$file" ]; then
    # Rename to OS-ARCH[.exe] (extension name is inferred from repo name)
    new_name="${file#prompt-registry-}"
    mv "$file" "$new_name"
    echo "Renamed: $file -> $new_name"
  fi
done

cd "$REPO_DIR"

# Move binaries to repository root
echo "Moving binaries to repository root..."
mv "$OFFICIAL_REPO_DIR/lib/dist/"* "$REPO_DIR/" 2>/dev/null || true

echo "Build complete!"
