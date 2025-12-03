#!/bin/bash

# Gleam Language Toolchain Installation Script
# Installs Gleam 1.13.0+ via Homebrew and verifies installation
# This script is idempotent and safe to run multiple times

set -euo pipefail

# Get the absolute path to the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common utilities
# shellcheck source=./common.sh
source "${SCRIPT_DIR}/common.sh"

# Constants
readonly GLEAM_MIN_VERSION="1.13.0"
readonly ERLANG_MIN_VERSION="24.0"

# Main installation function
main() {
    log_info "Starting Gleam toolchain installation..."

    # Verify prerequisites
    require_command "brew" "Please install Homebrew from https://brew.sh"

    # Check if Gleam is already installed
    if check_command_exists "gleam"; then
        local current_version
        current_version=$(gleam --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)

        if verify_version "$current_version" "$GLEAM_MIN_VERSION" "Gleam"; then
            log_success "Gleam is already installed and meets version requirements"
            verify_erlang_installation
            return "$EXIT_SUCCESS"
        else
            log_warn "Gleam version $current_version is below minimum requirement"
            log_info "Attempting to upgrade Gleam..."
        fi
    fi

    # Install or upgrade Gleam via Homebrew
    log_info "Installing Gleam via Homebrew..."
    if brew install gleam; then
        log_success "Gleam installed successfully"
    else
        log_error "Failed to install Gleam via Homebrew"
        exit "$EXIT_FAILURE"
    fi

    # Verify installation
    if ! check_command_exists "gleam"; then
        log_error "Gleam installation failed - command not found in PATH"
        log_error "Try adding Homebrew bin to PATH: export PATH=\"/usr/local/bin:\$PATH\""
        exit "$EXIT_COMMAND_NOT_FOUND"
    fi

    # Check version
    local installed_version
    installed_version=$(gleam --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)

    if ! verify_version "$installed_version" "$GLEAM_MIN_VERSION" "Gleam"; then
        log_error "Installed Gleam version $installed_version does not meet minimum requirement ($GLEAM_MIN_VERSION)"
        exit "$EXIT_VERSION_MISMATCH"
    fi

    log_success "Gleam $installed_version installed and verified"

    # Verify Erlang installation
    verify_erlang_installation

    log_success "Gleam toolchain installation complete!"
    return "$EXIT_SUCCESS"
}

# Verify Erlang runtime is installed (required dependency for Gleam)
verify_erlang_installation() {
    log_info "Checking Erlang runtime (required by Gleam)..."

    if check_command_exists "erl"; then
        local erlang_version
        erlang_version=$(erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell 2>/dev/null | tr -d '"' || echo "unknown")
        log_success "Erlang/OTP is installed (version: $erlang_version)"
        return 0
    fi

    log_warn "Erlang runtime not found - installing via Homebrew..."
    log_info "Gleam requires Erlang to run compiled programs"

    if brew install erlang; then
        log_success "Erlang installed successfully"

        if check_command_exists "erl"; then
            local erlang_version
            erlang_version=$(erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell 2>/dev/null | tr -d '"' || echo "unknown")
            log_success "Erlang/OTP version: $erlang_version"
        fi

        return 0
    else
        log_error "Failed to install Erlang runtime"
        log_error "Gleam requires Erlang to run compiled programs"
        log_error "You may need to install Erlang manually: brew install erlang"
        return "$EXIT_FAILURE"
    fi
}

# Run main function
main "$@"
