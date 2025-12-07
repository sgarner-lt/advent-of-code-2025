#!/bin/bash

# Carbon Language Toolchain Installation Script
# ⚠️ DEPRECATED: This script installs Carbon locally on macOS
#
# As of December 2025, the preferred method is using Docker/Podman containers.
# Container benefits:
# - Consistent environment across all platforms
# - No manual installation of LLVM, Bazel, etc.
# - Isolated from host system
# - Reproducible builds
#
# To use the container approach instead:
#   1. Install Docker or Podman
#   2. Build the container: cd solutions/carbon && podman build -t carbon-aoc:day1 -f Dockerfile.minimal .
#   3. Run solutions: ./scripts/runners/run_carbon.sh <day> <input>
#
# See docs/languages/carbon.md for detailed container setup instructions.
#
# This script remains for backward compatibility and local development scenarios.

set -euo pipefail

# Get the absolute path to the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common utilities
# shellcheck source=./common.sh
source "${SCRIPT_DIR}/common.sh"

# Constants
readonly CARBON_REPO_URL="https://github.com/carbon-language/carbon-lang.git"
readonly TEMP_BUILD_DIR="/tmp/carbon-build"
readonly CARBON_INSTALL_DIR="${HOME}/.local/carbon"
readonly PYTHON_MIN_VERSION="3.9"

# Cleanup on exit
trap cleanup_on_exit EXIT

# Main installation function
main() {
    log_warn "╔════════════════════════════════════════════════════════════════╗"
    log_warn "║  DEPRECATION NOTICE: Container-based approach is preferred    ║"
    log_warn "║  This script installs Carbon locally on macOS (legacy)        ║"
    log_warn "║  See docs/languages/carbon.md for container setup instead     ║"
    log_warn "╚════════════════════════════════════════════════════════════════╝"
    log_warn ""

    log_info "Starting Carbon toolchain installation..."
    log_warn "Note: Carbon is an experimental language and build may take significant time"

    # Verify prerequisites
    verify_prerequisites
    install_dependencies

    # Check if Carbon is already installed
    if check_carbon_installed; then
        log_success "Carbon is already installed and working"
        return "$EXIT_SUCCESS"
    fi

    # Build Carbon from source
    build_carbon_from_source

    # Verify installation
    verify_carbon_installation

    log_success "Carbon toolchain installation complete!"
    log_info "Carbon install location: ${CARBON_INSTALL_DIR}"
    log_info "Make sure ${CARBON_INSTALL_DIR}/bin is in your PATH"
    log_info ""
    log_info "Add to your shell profile:"
    log_info "  export PATH=\"${CARBON_INSTALL_DIR}/bin:\${PATH}\""

    return "$EXIT_SUCCESS"
}

# Check if Carbon is already installed and working
check_carbon_installed() {
    if [[ -d "${CARBON_INSTALL_DIR}" ]] && [[ -d "${CARBON_INSTALL_DIR}/carbon-lang" ]]; then
        log_info "Carbon installation directory found at ${CARBON_INSTALL_DIR}"

        # Try to verify it works with bazel
        if cd "${CARBON_INSTALL_DIR}/carbon-lang" 2>/dev/null; then
            if check_command_exists "bazel"; then
                log_info "Verifying Carbon build..."
                if bazel version &>/dev/null; then
                    log_success "Carbon appears to be properly installed"
                    return 0
                fi
            fi
        fi
    fi

    log_info "Carbon not found or incomplete installation"
    return 1
}

# Verify prerequisites
verify_prerequisites() {
    log_info "Verifying macOS prerequisites..."

    require_command "brew" "Please install Homebrew from https://brew.sh"
    require_command "git" "Please install Git: brew install git"

    # Verify Xcode Command Line Tools
    if ! xcode-select -p &>/dev/null; then
        log_error "Xcode Command Line Tools not installed"
        log_error "Install with: xcode-select --install"
        exit "$EXIT_COMMAND_NOT_FOUND"
    fi

    log_success "All prerequisites verified"
}

# Install required dependencies
install_dependencies() {
    log_info "Installing Carbon build dependencies via Homebrew..."

    local dependencies=("bazelisk" "llvm" "python@3.11")
    local to_install=()

    # Check which dependencies need installation
    for dep in "${dependencies[@]}"; do
        if brew list "$dep" &>/dev/null; then
            log_info "$dep is already installed"
        else
            to_install+=("$dep")
        fi
    done

    # Install missing dependencies
    if [[ ${#to_install[@]} -gt 0 ]]; then
        log_info "Installing dependencies: ${to_install[*]}"
        if brew install "${to_install[@]}"; then
            log_success "Dependencies installed successfully"
        else
            log_error "Failed to install dependencies via Homebrew"
            exit "$EXIT_FAILURE"
        fi
    else
        log_success "All dependencies already installed"
    fi

    # Verify bazel/bazelisk is available
    if ! check_command_exists "bazel" && ! check_command_exists "bazelisk"; then
        log_error "Bazel/Bazelisk not found after installation"
        log_error "Try adding Homebrew bin to PATH: export PATH=\"/opt/homebrew/bin:/usr/local/bin:\${PATH}\""
        exit "$EXIT_COMMAND_NOT_FOUND"
    fi

    # Verify Python version
    local python_version
    if check_command_exists "python3"; then
        python_version=$(python3 --version | grep -oE '[0-9]+\.[0-9]+' | head -n 1)
        log_info "Python version: $python_version"

        if ! verify_version "$python_version" "$PYTHON_MIN_VERSION" "Python3"; then
            log_warn "Python version may be too old, but continuing anyway"
        fi
    else
        log_warn "python3 not found, but continuing with installation"
    fi

    # Verify LLVM is available
    if brew list llvm &>/dev/null; then
        local llvm_prefix
        llvm_prefix=$(brew --prefix llvm)
        log_success "LLVM installed at: $llvm_prefix"
        log_info "Make sure LLVM is in PATH: export PATH=\"${llvm_prefix}/bin:\${PATH}\""
    else
        log_warn "LLVM not found via Homebrew, Carbon build may fail"
    fi
}

# Build Carbon from source
build_carbon_from_source() {
    log_info "Building Carbon from source..."
    log_info "This may take 15-30 minutes depending on your system..."

    # Create installation directory
    ensure_directory "${CARBON_INSTALL_DIR}"

    # Clone repository if not already present
    if [[ ! -d "${CARBON_INSTALL_DIR}/carbon-lang" ]]; then
        log_info "Cloning Carbon repository to ${CARBON_INSTALL_DIR}/carbon-lang..."

        if git clone "${CARBON_REPO_URL}" "${CARBON_INSTALL_DIR}/carbon-lang"; then
            log_success "Repository cloned successfully"
        else
            log_error "Failed to clone Carbon repository"
            exit "$EXIT_FAILURE"
        fi
    else
        log_info "Carbon repository already exists, pulling latest changes..."
        cd "${CARBON_INSTALL_DIR}/carbon-lang"

        if git pull origin trunk; then
            log_success "Repository updated successfully"
        else
            log_warn "Failed to update repository, continuing with existing version"
        fi
    fi

    # Change to repository directory
    cd "${CARBON_INSTALL_DIR}/carbon-lang" || {
        log_error "Failed to change to Carbon repository directory"
        exit "$EXIT_FAILURE"
    }

    log_info "Testing Carbon build system..."
    log_info "Running: bazel version"

    if bazel version; then
        log_success "Bazel is working correctly"
    else
        log_error "Bazel version check failed"
        exit "$EXIT_FAILURE"
    fi

    log_info "Carbon source is ready at ${CARBON_INSTALL_DIR}/carbon-lang"
    log_info "Build will be performed on-demand when compiling Carbon programs"
}

# Verify Carbon installation
verify_carbon_installation() {
    log_info "Verifying Carbon installation..."

    if [[ ! -d "${CARBON_INSTALL_DIR}/carbon-lang" ]]; then
        log_error "Carbon source directory not found"
        exit "$EXIT_FAILURE"
    fi

    cd "${CARBON_INSTALL_DIR}/carbon-lang" || {
        log_error "Cannot access Carbon directory"
        exit "$EXIT_FAILURE"
    }

    # Test that we can query bazel targets
    log_info "Querying Carbon build targets..."
    if bazel query //... --output package 2>/dev/null | head -n 5 > /dev/null; then
        log_success "Carbon build system is functional"
    else
        log_warn "Could not query build targets, but installation may still work"
    fi

    log_success "Carbon installation verified"
}

# Run main function
main "$@"
