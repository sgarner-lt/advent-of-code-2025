#!/bin/bash

# Roc Language Installation Script
# Installs the latest nightly build of Roc for macOS
# Handles both Homebrew installation (if available) and direct binary download

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common utilities
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

# Configuration
readonly ROC_MIN_VERSION="nightly"
readonly ROC_INSTALL_DIR="$HOME/.local/bin"
readonly ROC_GITHUB_REPO="roc-lang/roc"
readonly ROC_ARCH="macos_x86_64"

# Detect architecture
detect_architecture() {
    local arch
    arch=$(uname -m)

    case "$arch" in
        arm64|aarch64)
            echo "macos_apple_silicon"
            ;;
        x86_64)
            echo "macos_x86_64"
            ;;
        *)
            log_error "Unsupported architecture: $arch"
            exit "$EXIT_FAILURE"
            ;;
    esac
}

# Get latest Roc release information from GitHub
get_latest_release_info() {
    local arch="$1"
    local api_url="https://api.github.com/repos/$ROC_GITHUB_REPO/releases/latest"

    local release_info
    if ! release_info=$(curl -s "$api_url" 2>&1); then
        return 1
    fi

    local tag_name
    tag_name=$(echo "$release_info" | grep -o '"tag_name": *"[^"]*"' | sed 's/"tag_name": *"\(.*\)"/\1/')

    if [[ -z "$tag_name" ]]; then
        return 1
    fi

    local download_url
    download_url=$(echo "$release_info" | grep -o "\"browser_download_url\": *\"[^\"]*${arch}[^\"]*\.tar\.gz\"" | sed 's/"browser_download_url": *"\(.*\)"/\1/')

    if [[ -z "$download_url" ]]; then
        return 1
    fi

    echo "$tag_name|$download_url"
}

# Check if Roc is already installed
check_roc_installed() {
    if check_command_exists "roc"; then
        local roc_version
        roc_version=$(roc version 2>/dev/null || echo "unknown")
        log_info "Roc is already installed: $roc_version"
        return 0
    else
        return 1
    fi
}

# Install Roc via Homebrew
install_via_homebrew() {
    log_info "Checking for Roc in Homebrew..."

    if ! check_command_exists "brew"; then
        log_warn "Homebrew is not installed, skipping Homebrew installation method"
        return 1
    fi

    # Check if roc formula exists
    if ! brew search roc | grep -q "^roc$"; then
        log_info "Roc is not available in Homebrew"
        return 1
    fi

    log_info "Installing Roc via Homebrew..."
    if brew install roc; then
        log_success "Roc installed successfully via Homebrew"
        return 0
    else
        log_error "Homebrew installation failed"
        return 1
    fi
}

# Download and install Roc from GitHub releases
install_from_github() {
    local arch
    arch=$(detect_architecture)
    log_info "Detected architecture: $arch"

    log_info "Fetching latest Roc release information..."
    local release_info
    if ! release_info=$(get_latest_release_info "$arch"); then
        log_error "Failed to get release information"
        return 1
    fi

    local tag_name
    local download_url
    tag_name=$(echo "$release_info" | cut -d'|' -f1)
    download_url=$(echo "$release_info" | cut -d'|' -f2)

    log_info "Latest release: $tag_name"
    log_info "Download URL: $download_url"

    # Create temporary directory for download
    local temp_dir
    temp_dir=$(mktemp -d)
    export TEMP_BUILD_DIR="$temp_dir"
    trap cleanup_on_exit EXIT

    log_info "Downloading Roc to: $temp_dir"

    local archive_name="roc-${arch}-${tag_name}.tar.gz"
    local archive_path="$temp_dir/$archive_name"

    if ! curl -L -o "$archive_path" "$download_url" 2>&1 | grep -v "^  % Total"; then
        log_error "Failed to download Roc"
        return 1
    fi

    log_success "Downloaded Roc successfully"

    # Extract archive
    log_info "Extracting Roc..."
    if ! tar -xzf "$archive_path" -C "$temp_dir"; then
        log_error "Failed to extract Roc archive"
        return 1
    fi

    # Find the extracted directory (it should be named 'roc' or similar)
    local extracted_dir
    extracted_dir=$(find "$temp_dir" -maxdepth 1 -type d -name "roc*" | grep -v ".tar.gz" | head -1)

    if [[ -z "$extracted_dir" ]] || [[ ! -d "$extracted_dir" ]]; then
        # Sometimes the archive extracts to temp_dir directly
        if [[ -f "$temp_dir/roc" ]]; then
            extracted_dir="$temp_dir"
        else
            log_error "Could not find extracted Roc directory"
            return 1
        fi
    fi

    # Ensure install directory exists
    ensure_directory "$ROC_INSTALL_DIR"

    # Copy Roc binary to install location
    local roc_binary="$extracted_dir/roc"
    if [[ ! -f "$roc_binary" ]]; then
        log_error "Roc binary not found in extracted archive"
        return 1
    fi

    log_info "Installing Roc to: $ROC_INSTALL_DIR/roc"
    if ! cp "$roc_binary" "$ROC_INSTALL_DIR/roc"; then
        log_error "Failed to copy Roc binary to install directory"
        return 1
    fi

    # Make binary executable
    chmod +x "$ROC_INSTALL_DIR/roc"

    # Remove macOS quarantine attribute if present
    if xattr "$ROC_INSTALL_DIR/roc" 2>/dev/null | grep -q "com.apple.quarantine"; then
        log_info "Removing macOS quarantine attribute..."
        xattr -d com.apple.quarantine "$ROC_INSTALL_DIR/roc" 2>/dev/null || true
    fi

    # Check if install directory is in PATH
    if [[ ":$PATH:" != *":$ROC_INSTALL_DIR:"* ]]; then
        log_warn "Warning: $ROC_INSTALL_DIR is not in your PATH"
        log_warn "Add the following to your ~/.zshrc or ~/.bash_profile:"
        log_warn "  export PATH=\"\$PATH:$ROC_INSTALL_DIR\""
    fi

    log_success "Roc installed successfully"
    return 0
}

# Verify Roc installation
verify_installation() {
    log_info "Verifying Roc installation..."

    # Add install directory to PATH for this session if needed
    if [[ ":$PATH:" != *":$ROC_INSTALL_DIR:"* ]]; then
        export PATH="$PATH:$ROC_INSTALL_DIR"
    fi

    if ! check_command_exists "roc"; then
        log_error "Roc command not found after installation"
        log_error "Please ensure $ROC_INSTALL_DIR is in your PATH"
        return 1
    fi

    local roc_version
    if ! roc_version=$(roc version 2>&1); then
        log_error "Failed to get Roc version"
        return 1
    fi

    log_success "Roc is installed: $roc_version"

    # Test basic functionality
    log_info "Testing Roc basic functionality..."
    if roc help &> /dev/null; then
        log_success "Roc help command works"
    else
        log_warn "Roc help command failed, but binary is present"
    fi

    return 0
}

# Main installation logic
main() {
    log_info "Starting Roc installation..."
    log_info "Platform: macOS"

    # Check if already installed
    if check_roc_installed; then
        log_info "Roc is already installed (idempotent check passed)"
        log_info "To reinstall, remove the existing installation first"
        exit "$EXIT_SUCCESS"
    fi

    # Try Homebrew first (though it likely won't work for Roc)
    log_info "Attempting Homebrew installation..."
    if install_via_homebrew; then
        if verify_installation; then
            log_success "Roc installation complete via Homebrew"
            exit "$EXIT_SUCCESS"
        fi
    fi

    # Fall back to GitHub release download
    log_info "Attempting installation from GitHub releases..."
    if install_from_github; then
        if verify_installation; then
            log_success "Roc installation complete from GitHub"
            exit "$EXIT_SUCCESS"
        fi
    fi

    # If we get here, installation failed
    log_error "Roc installation failed"
    log_error "Please check the error messages above and try manual installation"
    log_error "Visit: https://www.roc-lang.org/install"
    exit "$EXIT_FAILURE"
}

# Run main installation
main
