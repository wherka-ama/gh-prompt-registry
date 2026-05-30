.PHONY: help build build-local clean release

help:
	@echo "Available targets:"
	@echo "  make build-local  - Build for current platform only"
	@echo "  make build        - Build for all platforms (handled by CI matrix)"
	@echo "  make clean        - Remove build artifacts"
	@echo "  make release      - Create release with proper naming"
	@echo ""
	@echo "Environment variables:"
	@echo "  PROMPT_REGISTRY_REPO  - Path or URL to prompt-registry repository"
	@echo "  PROMPT_REGISTRY_REF   - Git ref (tag or branch) to checkout"
	@echo ""
	@echo "Examples:"
	@echo "  make build-local"
	@echo "  PROMPT_REGISTRY_REPO=/path/to/prompt-registry make build-local"
	@echo "  PROMPT_REGISTRY_REPO=/path/to/prompt-registry PROMPT_REGISTRY_REF=v1.0.0 make build-local"
	@echo "  PROMPT_REGISTRY_REPO=/path/to/prompt-registry PROMPT_REGISTRY_REF=main make build-local"

build-local:
	@echo "Building for current platform..."
	./scripts/build.sh --local
	@echo "Local install artifact ready: gh-prompt-registry (or gh-prompt-registry.exe on Windows)"

build:
	@echo "Building for all platforms..."
	./scripts/build.sh

clean:
	@echo "Cleaning build artifacts..."
	rm -f linux-* darwin-* windows-* *.sha256
	rm -rf prompt-registry

release:
	@echo "Creating release..."
	./scripts/build.sh
	@echo "Release artifacts ready in current directory"
	ls -lh linux-* darwin-* windows-* 2>/dev/null || true
