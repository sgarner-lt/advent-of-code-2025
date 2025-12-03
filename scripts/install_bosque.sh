#!/bin/bash

# Bosque Language Toolchain Installation Script (Containerized)
#
# Installs Bosque research language via Podman/Docker container
# for macOS compatibility (BosqueCore officially supports Linux only)
#
# Requires: Podman (or Docker)

set -euo pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=scripts/common.sh
source "$SCRIPT_DIR/common.sh"

# Configuration
readonly DOCKERFILE_PATH="$PROJECT_ROOT/docker/bosque/Dockerfile"
readonly CONTAINER_IMAGE="bosque-toolchain:latest"
readonly WRAPPER_SCRIPT="$SCRIPT_DIR/bosque-wrapper.sh"
readonly WRAPPER_LINK="$HOME/.local/bin/bosque"

# Check if Podman is installed
check_podman() {
    log_info "Checking for Podman..."

    if check_command_exists "podman"; then
        local podman_version
        podman_version=$(podman --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
        log_success "Podman $podman_version is installed"
        return 0
    fi

    log_error "Podman is not installed"
    log_error ""
    log_error "Install Podman via Homebrew:"
    log_error "  brew install podman"
    log_error ""
    log_error "After installation, initialize and start the Podman machine:"
    log_error "  podman machine init"
    log_error "  podman machine start"
    log_error ""
    log_info "Note: Docker can also be used as an alternative to Podman"
    return 1
}

# Check if Podman machine is running
check_podman_machine() {
    log_info "Checking Podman machine status..."

    if ! podman machine info &> /dev/null; then
        log_warn "Podman machine is not running"
        log_info "Attempting to start Podman machine..."

        if podman machine start; then
            log_success "Podman machine started successfully"
            return 0
        else
            log_error "Failed to start Podman machine"
            log_error "Try manually: podman machine start"
            return 1
        fi
    fi

    log_success "Podman machine is running"
    return 0
}

# Build Bosque container image
build_bosque_image() {
    log_info "Building Bosque container image..."
    log_info "This may take 5-10 minutes on first build (Node.js + BosqueCore compilation)"

    if [[ ! -f "$DOCKERFILE_PATH" ]]; then
        log_error "Dockerfile not found at: $DOCKERFILE_PATH"
        return 1
    fi

    # Check if image already exists
    if podman image exists "$CONTAINER_IMAGE"; then
        log_info "Container image '$CONTAINER_IMAGE' already exists"
        log_info "To rebuild, remove it first: podman rmi $CONTAINER_IMAGE"
        log_success "Using existing container image"
        return 0
    fi

    log_info "Building container image from: $DOCKERFILE_PATH"

    # Build the image with progress output
    if podman build \
        -t "$CONTAINER_IMAGE" \
        -f "$DOCKERFILE_PATH" \
        "$(dirname "$DOCKERFILE_PATH")"; then
        log_success "Container image built successfully"
        return 0
    else
        log_error "Failed to build container image"
        log_error "Check the Dockerfile at: $DOCKERFILE_PATH"
        return 1
    fi
}

# Verify container image works
verify_container_image() {
    log_info "Verifying Bosque container image..."

    # Test that the container runs and Bosque command exists
    if podman run --rm "$CONTAINER_IMAGE" which bosque > /dev/null 2>&1; then
        log_success "Bosque container is working correctly"
        return 0
    else
        log_error "Bosque container failed verification"
        log_error "Try rebuilding: podman rmi $CONTAINER_IMAGE && ./scripts/install_bosque.sh"
        return 1
    fi
}

# Set up wrapper script
setup_wrapper_script() {
    log_info "Setting up Bosque wrapper script..."

    # Ensure ~/.local/bin exists
    ensure_directory "$HOME/.local/bin"

    # Check if wrapper script exists
    if [[ ! -f "$WRAPPER_SCRIPT" ]]; then
        log_error "Wrapper script not found at: $WRAPPER_SCRIPT"
        return 1
    fi

    # Make wrapper script executable (should already be, but ensure)
    chmod +x "$WRAPPER_SCRIPT"

    # Create symlink to wrapper script
    if [[ -L "$WRAPPER_LINK" ]]; then
        log_info "Removing existing symlink: $WRAPPER_LINK"
        rm "$WRAPPER_LINK"
    elif [[ -f "$WRAPPER_LINK" ]]; then
        log_warn "File exists at $WRAPPER_LINK (not a symlink)"
        log_warn "Backing up to ${WRAPPER_LINK}.backup"
        mv "$WRAPPER_LINK" "${WRAPPER_LINK}.backup"
    fi

    log_info "Creating symlink: $WRAPPER_LINK -> $WRAPPER_SCRIPT"
    if ln -s "$WRAPPER_SCRIPT" "$WRAPPER_LINK"; then
        log_success "Wrapper script linked successfully"
    else
        log_error "Failed to create symlink"
        return 1
    fi

    # Check if ~/.local/bin is in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        log_warn "$HOME/.local/bin is not in your PATH"
        log_warn "Add it to your PATH by adding this line to your ~/.zshrc or ~/.bashrc:"
        log_warn "  export PATH=\"\$HOME/.local/bin:\$PATH\""
        log_warn ""
        log_warn "Then reload your shell: source ~/.zshrc (or source ~/.bashrc)"
    else
        log_success "$HOME/.local/bin is in your PATH"
    fi

    return 0
}

# Verify complete installation
verify_installation() {
    log_info "Verifying complete Bosque installation..."

    # Check container image exists
    if ! podman image exists "$CONTAINER_IMAGE"; then
        log_error "Container image not found: $CONTAINER_IMAGE"
        return 1
    fi

    # Check wrapper script is accessible
    if check_command_exists "bosque"; then
        log_success "Bosque command is available in PATH"
    else
        log_warn "Bosque command not in PATH"
        log_warn "You can still use it via: $WRAPPER_SCRIPT"
    fi

    # Test that wrapper script exists and is executable
    log_info "Testing Bosque wrapper script..."
    if [[ -x "$WRAPPER_SCRIPT" ]]; then
        log_success "Bosque wrapper script is executable"
    else
        log_error "Bosque wrapper script is not executable"
        return 1
    fi

    log_success "Bosque installation verified successfully"
    return 0
}

# Main installation flow
main() {
    log_info "=========================================="
    log_info "Bosque Toolchain Installation (Containerized)"
    log_info "=========================================="
    log_info ""
    log_info "This script installs Bosque via Podman/Docker container"
    log_info "because BosqueCore only supports Linux (Ubuntu 24) natively."
    log_info ""

    # Step 1: Check Podman is installed
    if ! check_podman; then
        log_error "Podman installation check failed"
        exit "$EXIT_FAILURE"
    fi

    # Step 2: Check Podman machine is running
    if ! check_podman_machine; then
        log_error "Podman machine check failed"
        exit "$EXIT_FAILURE"
    fi

    # Step 3: Build container image
    if ! build_bosque_image; then
        log_error "Container image build failed"
        exit "$EXIT_FAILURE"
    fi

    # Step 4: Verify container image
    if ! verify_container_image; then
        log_error "Container image verification failed"
        exit "$EXIT_FAILURE"
    fi

    # Step 5: Set up wrapper script
    if ! setup_wrapper_script; then
        log_error "Wrapper script setup failed"
        exit "$EXIT_FAILURE"
    fi

    # Step 6: Verify complete installation
    if ! verify_installation; then
        log_error "Installation verification failed"
        exit "$EXIT_FAILURE"
    fi

    log_success ""
    log_success "=========================================="
    log_success "Bosque installation complete!"
    log_success "=========================================="
    log_info ""
    log_info "Usage:"
    log_info "  bosque compile <file.bsq>"
    log_info ""
    log_info "Example:"
    log_info "  cd hello/bosque"
    log_info "  bosque compile hello.bsq"
    log_info "  node jsout/Main.mjs"
    log_info ""
    log_info "The Bosque toolchain runs inside a Linux container and has"
    log_info "access to files in your current directory when you run commands."
    log_info ""
    log_info "Container image: $CONTAINER_IMAGE"
    log_info "Wrapper script:  $WRAPPER_SCRIPT"
    log_info "Command symlink: $WRAPPER_LINK"
    log_info ""
    log_info "For more information, see: docs/languages/bosque.md"

    exit "$EXIT_SUCCESS"
}

# Run main function
main "$@"
