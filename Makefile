.PHONY: help build build-local clean release

help:
	@echo "Available targets:"
	@echo "  make build-local  - Build for current platform only"
	@echo "  make build        - Build for all platforms (not yet implemented)"
	@echo "  make clean        - Remove build artifacts"
	@echo "  make release      - Create release with proper naming"

build-local:
	@echo "Building for current platform..."
	./scripts/build.sh --local

build:
	@echo "Building for all platforms..."
	./scripts/build.sh

clean:
	@echo "Cleaning build artifacts..."
	rm -f gh-prompt-registry-*
	rm -rf prompt-registry

release:
	@echo "Creating release..."
	./scripts/build.sh
	@echo "Release artifacts ready in current directory"
	ls -lh gh-prompt-registry-*
