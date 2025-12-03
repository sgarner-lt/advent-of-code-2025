#!/bin/bash

# Common utilities for language toolchain installation scripts
# This script provides reusable functions for checking commands, logging, and version validation.
# Safe to source multiple times (idempotent).

# Prevent multiple sourcing
if [[ -n "${COMMON_SH_LOADED:-}" ]]; then
    return 0
fi
readonly COMMON_SH_LOADED=1

# Exit codes
readonly EXIT_SUCCESS=0
readonly EXIT_FAILURE=1
readonly EXIT_COMMAND_NOT_FOUND=127
readonly EXIT_VERSION_MISMATCH=2

# Color codes for logging
readonly COLOR_RESET="\033[0m"
readonly COLOR_INFO="\033[34m"     # Blue
readonly COLOR_SUCCESS="\033[32m"  # Green
readonly COLOR_ERROR="\033[31m"    # Red
readonly COLOR_WARN="\033[33m"     # Yellow

# Log informational message to stdout
# Usage: log_info "message"
log_info() {
    echo -e "${COLOR_INFO}[INFO]${COLOR_RESET} $*"
}

# Log success message to stdout
# Usage: log_success "message"
log_success() {
    echo -e "${COLOR_SUCCESS}[SUCCESS]${COLOR_RESET} $*"
}

# Log error message to stderr
# Usage: log_error "message"
log_error() {
    echo -e "${COLOR_ERROR}[ERROR]${COLOR_RESET} $*" >&2
}

# Log warning message to stdout
# Usage: log_warn "message"
log_warn() {
    echo -e "${COLOR_WARN}[WARN]${COLOR_RESET} $*"
}

# Check if a command exists in PATH
# Usage: check_command_exists "command_name"
# Returns: 0 if command exists, 1 otherwise
check_command_exists() {
    local cmd="$1"

    if [[ -z "$cmd" ]]; then
        log_error "check_command_exists: No command specified"
        return 1
    fi

    if command -v "$cmd" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Verify a version meets minimum requirements
# Compares version strings in format X.Y.Z
# Usage: verify_version "current_version" "minimum_version" "tool_name"
# Returns: 0 if current >= minimum, 1 otherwise
verify_version() {
    local current="$1"
    local minimum="$2"
    local tool_name="${3:-tool}"

    if [[ -z "$current" ]] || [[ -z "$minimum" ]]; then
        log_error "verify_version: Missing version arguments"
        return 1
    fi

    # Remove any leading 'v' or other non-numeric prefixes
    current="${current#v}"
    minimum="${minimum#v}"

    # Split versions into components
    IFS='.' read -ra current_parts <<< "$current"
    IFS='.' read -ra minimum_parts <<< "$minimum"

    # Compare major, minor, patch versions
    for i in {0..2}; do
        local curr_part="${current_parts[$i]:-0}"
        local min_part="${minimum_parts[$i]:-0}"

        # Extract numeric portion only (handles cases like "1.83.0-beta")
        curr_part="${curr_part%%[^0-9]*}"
        min_part="${min_part%%[^0-9]*}"

        if (( curr_part > min_part )); then
            log_success "$tool_name version $current meets minimum requirement ($minimum)"
            return 0
        elif (( curr_part < min_part )); then
            log_error "$tool_name version $current is below minimum requirement ($minimum)"
            return 1
        fi
    done

    # Versions are equal
    log_success "$tool_name version $current meets minimum requirement ($minimum)"
    return 0
}

# Require command to exist, exit script if not found
# Usage: require_command "command_name" "installation_instructions"
require_command() {
    local cmd="$1"
    local install_msg="${2:-Please install $cmd and try again.}"

    if ! check_command_exists "$cmd"; then
        log_error "$cmd is not installed or not in PATH"
        log_error "$install_msg"
        exit "$EXIT_COMMAND_NOT_FOUND"
    fi
}

# Verify prerequisites are installed
# Usage: verify_prerequisites
# Checks: Homebrew, Git, Xcode Command Line Tools
verify_prerequisites() {
    log_info "Verifying macOS prerequisites..."

    local all_ok=0

    # Check Homebrew
    if check_command_exists "brew"; then
        local brew_version
        brew_version=$(brew --version | head -n 1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        log_success "Homebrew $brew_version is installed"
    else
        log_error "Homebrew is not installed"
        log_error "Install from: https://brew.sh"
        all_ok=1
    fi

    # Check Git
    if check_command_exists "git"; then
        local git_version
        git_version=$(git --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        log_success "Git $git_version is installed"
    else
        log_error "Git is not installed"
        log_error "Install via: brew install git"
        all_ok=1
    fi

    # Check Xcode Command Line Tools
    if xcode-select -p &> /dev/null; then
        local xcode_path
        xcode_path=$(xcode-select -p)
        log_success "Xcode Command Line Tools installed at: $xcode_path"
    else
        log_error "Xcode Command Line Tools are not installed"
        log_error "Install via: xcode-select --install"
        all_ok=1
    fi

    if [[ $all_ok -eq 0 ]]; then
        log_success "All prerequisites verified"
        return 0
    else
        log_error "Some prerequisites are missing"
        return 1
    fi
}

# Create directory if it doesn't exist
# Usage: ensure_directory "/path/to/directory"
ensure_directory() {
    local dir="$1"

    if [[ -z "$dir" ]]; then
        log_error "ensure_directory: No directory specified"
        return 1
    fi

    if [[ ! -d "$dir" ]]; then
        if mkdir -p "$dir"; then
            log_info "Created directory: $dir"
            return 0
        else
            log_error "Failed to create directory: $dir"
            return 1
        fi
    fi

    return 0
}

# Clean up temporary directory
# Usage: cleanup_temp_dir "/path/to/temp"
cleanup_temp_dir() {
    local temp_dir="$1"

    if [[ -z "$temp_dir" ]]; then
        log_warn "cleanup_temp_dir: No directory specified"
        return 0
    fi

    if [[ -d "$temp_dir" ]]; then
        log_info "Cleaning up temporary directory: $temp_dir"
        if rm -rf "$temp_dir"; then
            log_success "Temporary directory cleaned up"
            return 0
        else
            log_error "Failed to clean up temporary directory: $temp_dir"
            return 1
        fi
    fi

    return 0
}

# Exit handler for cleanup
# Usage: trap 'cleanup_on_exit' EXIT
cleanup_on_exit() {
    if [[ -n "${TEMP_BUILD_DIR:-}" ]] && [[ -d "$TEMP_BUILD_DIR" ]]; then
        cleanup_temp_dir "$TEMP_BUILD_DIR"
    fi
}
