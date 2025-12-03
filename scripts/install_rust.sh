#!/bin/bash

# Rust installation script for macOS
# Installs Rust 1.83.0+ via rustup using Homebrew
# Safe to run multiple times (idempotent)

set -e  # Exit on error

# Get absolute path to script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common utilities
# shellcheck source=scripts/common.sh
source "$SCRIPT_DIR/common.sh"

# Minimum required version
readonly MIN_RUST_VERSION="1.83.0"

# Main installation function
main() {
    log_info "Starting Rust installation..."

    # Verify prerequisites
    require_command "brew" "Homebrew is required. Install from: https://brew.sh"

    # Check if rustup is already installed
    if check_command_exists "rustup"; then
        log_info "rustup is already installed"

        # Update rustup and Rust to latest stable
        log_info "Updating rustup and Rust..."
        if rustup update stable; then
            log_success "rustup and Rust updated successfully"
        else
            log_error "Failed to update rustup"
            exit "$EXIT_FAILURE"
        fi
    else
        log_info "Installing rustup via Homebrew..."

        # Install rustup-init via Homebrew
        if brew install rustup-init; then
            log_success "rustup-init installed via Homebrew"
        else
            log_error "Failed to install rustup-init via Homebrew"
            exit "$EXIT_FAILURE"
        fi

        # Run rustup-init with default settings
        log_info "Running rustup-init to install Rust..."
        if rustup-init -y --default-toolchain stable; then
            log_success "rustup-init completed successfully"
        else
            log_error "rustup-init failed"
            exit "$EXIT_FAILURE"
        fi
    fi

    # Source the cargo environment for current shell if available
    # shellcheck source=/dev/null
    if [[ -f "$HOME/.cargo/env" ]]; then
        source "$HOME/.cargo/env"
        log_info "Sourced cargo environment"
    fi

    # Verify rustc is available
    if ! check_command_exists "rustc"; then
        log_error "rustc not found after installation"
        log_error "Try sourcing the environment: source \$HOME/.cargo/env"
        log_error "Or restart your terminal and try again"
        exit "$EXIT_COMMAND_NOT_FOUND"
    fi

    # Get and verify rustc version
    local rustc_version
    rustc_version=$(rustc --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)

    if [[ -z "$rustc_version" ]]; then
        log_error "Could not determine rustc version"
        exit "$EXIT_FAILURE"
    fi

    log_info "Installed rustc version: $rustc_version"

    if ! verify_version "$rustc_version" "$MIN_RUST_VERSION" "rustc"; then
        log_error "Rust version $rustc_version does not meet minimum requirement ($MIN_RUST_VERSION)"
        exit "$EXIT_VERSION_MISMATCH"
    fi

    # Verify cargo is available
    if ! check_command_exists "cargo"; then
        log_error "cargo not found after installation"
        exit "$EXIT_COMMAND_NOT_FOUND"
    fi

    # Get and display cargo version
    local cargo_version
    cargo_version=$(cargo --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)

    if [[ -z "$cargo_version" ]]; then
        log_error "Could not determine cargo version"
        exit "$EXIT_FAILURE"
    fi

    log_success "Cargo version: $cargo_version"

    # Verify rustup is available and show installed toolchains
    if check_command_exists "rustup"; then
        log_info "Installed Rust toolchains:"
        rustup show
    fi

    log_success "Rust installation completed successfully!"
    log_info "rustc version: $rustc_version"
    log_info "cargo version: $cargo_version"
    log_info ""
    log_info "If you just installed Rust, you may need to:"
    log_info "  - Restart your terminal, or"
    log_info "  - Run: source \$HOME/.cargo/env"

    return "$EXIT_SUCCESS"
}

# Run main function
main "$@"
