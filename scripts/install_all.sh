#!/bin/bash

# Master Installation Script for All Language Toolchains
# Installs all 5 languages (Rust, Gleam, Roc, Carbon, Bosque) for Advent of Code 2025
# Supports selective installation via command-line flags
# Safe to run multiple times (idempotent)
# Compatible with bash 3.2+ (macOS default)

set -eo pipefail

# Get the absolute path to the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common utilities
# shellcheck source=./common.sh
source "${SCRIPT_DIR}/common.sh"

# Language list
readonly ALL_LANGUAGES=("rust" "gleam" "roc" "carbon" "bosque")

# Installation results tracking (using arrays instead of associative arrays for bash 3.2 compatibility)
INSTALLED_LANGUAGES=()
FAILED_LANGUAGES=()
FAILED_ERRORS=()

# Utility function for uppercase (bash 3.2 compatible)
to_upper() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

# Parse command-line arguments
LANGUAGES_TO_INSTALL=()
LANGUAGES_TO_SKIP=()
SHOW_HELP=false

# Show usage information
show_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Master installation script for all 5 language toolchains (Rust, Gleam, Roc, Carbon, Bosque).

OPTIONS:
    --only-rust         Install only Rust
    --only-gleam        Install only Gleam
    --only-roc          Install only Roc
    --only-carbon       Install only Carbon
    --only-bosque       Install only Bosque

    --skip-rust         Skip Rust installation
    --skip-gleam        Skip Gleam installation
    --skip-roc          Skip Roc installation
    --skip-carbon       Skip Carbon installation
    --skip-bosque       Skip Bosque installation

    --help              Show this help message

EXAMPLES:
    # Install all languages
    $(basename "$0")

    # Install only Rust and Gleam
    $(basename "$0") --only-rust --only-gleam

    # Install all except Carbon
    $(basename "$0") --skip-carbon

    # Cannot combine --only and --skip flags
    # Use one approach or the other

NOTES:
    - Script continues on error and tracks which languages failed
    - Summary report shows installation status for all languages
    - Individual language installation scripts can be found in the scripts/ directory
    - All installations are idempotent and safe to run multiple times
    - Bosque runs via Podman/Docker container on macOS (fully functional)

For detailed documentation, see:
    - docs/languages/<language>.md for per-language guides
    - docs/vscode-setup.md for VS Code configuration
    - README.md for project overview

EOF
}

# Parse command-line flags
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --only-rust)
                LANGUAGES_TO_INSTALL+=("rust")
                shift
                ;;
            --only-gleam)
                LANGUAGES_TO_INSTALL+=("gleam")
                shift
                ;;
            --only-roc)
                LANGUAGES_TO_INSTALL+=("roc")
                shift
                ;;
            --only-carbon)
                LANGUAGES_TO_INSTALL+=("carbon")
                shift
                ;;
            --only-bosque)
                LANGUAGES_TO_INSTALL+=("bosque")
                shift
                ;;
            --skip-rust)
                LANGUAGES_TO_SKIP+=("rust")
                shift
                ;;
            --skip-gleam)
                LANGUAGES_TO_SKIP+=("gleam")
                shift
                ;;
            --skip-roc)
                LANGUAGES_TO_SKIP+=("roc")
                shift
                ;;
            --skip-carbon)
                LANGUAGES_TO_SKIP+=("carbon")
                shift
                ;;
            --skip-bosque)
                LANGUAGES_TO_SKIP+=("bosque")
                shift
                ;;
            --help)
                SHOW_HELP=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                log_error "Use --help to see available options"
                exit "$EXIT_FAILURE"
                ;;
        esac
    done

    # Validate arguments
    if [[ ${#LANGUAGES_TO_INSTALL[@]} -gt 0 ]] && [[ ${#LANGUAGES_TO_SKIP[@]} -gt 0 ]]; then
        log_error "Cannot combine --only-* and --skip-* flags"
        log_error "Use --only-* to install specific languages, or --skip-* to skip specific languages"
        exit "$EXIT_FAILURE"
    fi

    # If no --only flags specified, install all languages (minus any skipped)
    if [[ ${#LANGUAGES_TO_INSTALL[@]} -eq 0 ]]; then
        for lang in "${ALL_LANGUAGES[@]}"; do
            # Check if language should be skipped
            local skip=false
            if [[ ${#LANGUAGES_TO_SKIP[@]} -gt 0 ]]; then
                for skip_lang in "${LANGUAGES_TO_SKIP[@]}"; do
                    if [[ "$lang" == "$skip_lang" ]]; then
                        skip=true
                        break
                    fi
                done
            fi

            if [[ "$skip" == false ]]; then
                LANGUAGES_TO_INSTALL+=("$lang")
            fi
        done
    fi
}

# Install a single language
install_language() {
    local language="$1"
    local lang_upper
    lang_upper=$(to_upper "$language")
    local script_name="install_${language}.sh"
    local script_path="${SCRIPT_DIR}/${script_name}"

    log_info "=================================================="
    log_info "Installing: $lang_upper"
    log_info "=================================================="

    if [[ ! -f "$script_path" ]]; then
        log_error "Installation script not found: $script_path"
        FAILED_LANGUAGES+=("$language")
        FAILED_ERRORS+=("${language}:Installation script not found")
        return 1
    fi

    if [[ ! -x "$script_path" ]]; then
        log_warn "Installation script is not executable, fixing permissions..."
        chmod +x "$script_path"
    fi

    # Run installation script and capture result
    if bash "$script_path"; then
        INSTALLED_LANGUAGES+=("$language")
        log_success "$lang_upper installation completed successfully"
        return 0
    else
        local exit_code=$?
        FAILED_LANGUAGES+=("$language")
        FAILED_ERRORS+=("${language}:Installation script exited with code $exit_code")
        log_error "$lang_upper installation failed"
        return 1
    fi
}

# Display installation summary
show_summary() {
    echo ""
    log_info "=================================================="
    log_info "INSTALLATION SUMMARY"
    log_info "=================================================="
    echo ""

    local success_count=${#INSTALLED_LANGUAGES[@]}
    local failure_count=${#FAILED_LANGUAGES[@]}

    # Display successful installations
    if [[ $success_count -gt 0 ]]; then
        for language in "${INSTALLED_LANGUAGES[@]}"; do
            local lang_upper
            lang_upper=$(to_upper "$language")
            log_success "$lang_upper: Installed successfully"
        done
    fi

    # Display failed installations
    if [[ $failure_count -gt 0 ]]; then
        for error_entry in "${FAILED_ERRORS[@]}"; do
            local lang="${error_entry%%:*}"
            local error="${error_entry#*:}"
            local lang_upper
            lang_upper=$(to_upper "$lang")
            log_error "$lang_upper: $error"
        done
    fi

    # Show skipped languages
    for language in "${ALL_LANGUAGES[@]}"; do
        local was_attempted=false
        if [[ ${#LANGUAGES_TO_INSTALL[@]} -gt 0 ]]; then
            for installed in "${LANGUAGES_TO_INSTALL[@]}"; do
                if [[ "$language" == "$installed" ]]; then
                    was_attempted=true
                    break
                fi
            done
        fi

        if [[ "$was_attempted" == false ]]; then
            local lang_upper
            lang_upper=$(to_upper "$language")
            log_info "$lang_upper: Skipped"
        fi
    done

    echo ""
    log_info "=================================================="
    log_info "RESULTS: ${success_count}/${#LANGUAGES_TO_INSTALL[@]} languages working"
    log_info "=================================================="

    if [[ $failure_count -gt 0 ]]; then
        echo ""
        log_warn "Some languages failed to install. See error details above."
        log_warn ""
        log_warn "Troubleshooting steps:"
        log_warn "  1. Review per-language documentation in docs/languages/"
        log_warn "  2. Retry individual installations: ./scripts/install_<language>.sh"
        log_warn "  3. Check that all prerequisites are installed (Homebrew, Git, Xcode CLI)"
        log_warn "  4. For Bosque: Ensure Podman is installed and running"
        echo ""
        return 1
    else
        echo ""
        log_success "All selected languages installed successfully!"
        echo ""
        log_info "Next steps:"
        log_info "  1. Restart your terminal or source shell configuration files"
        log_info "  2. Test hello world programs: cd hello/<language> && follow instructions"
        log_info "  3. Set up VS Code: see docs/vscode-setup.md"
        log_info "  4. Read language guides: docs/languages/<language>.md"
        echo ""
        return 0
    fi
}

# Main installation logic
main() {
    # Parse arguments
    parse_arguments "$@"

    # Show help if requested
    if [[ "$SHOW_HELP" == true ]]; then
        show_usage
        exit 0
    fi

    # Display banner
    echo ""
    log_info "=================================================="
    log_info "Advent of Code 2025 - Language Toolchain Setup"
    log_info "Master Installation Script"
    log_info "=================================================="
    echo ""
    log_info "Platform: macOS only"
    log_info "Languages: Rust, Gleam, Roc, Carbon, Bosque"
    echo ""

    # Verify macOS prerequisites
    log_info "Verifying prerequisites..."
    if ! verify_prerequisites; then
        log_error "Prerequisites check failed"
        log_error "Please install required tools and try again:"
        log_error "  - Homebrew: https://brew.sh"
        log_error "  - Git: brew install git"
        log_error "  - Xcode CLI: xcode-select --install"
        exit "$EXIT_FAILURE"
    fi

    echo ""
    log_info "Languages to install: ${LANGUAGES_TO_INSTALL[*]}"
    echo ""

    # Install each language
    if [[ ${#LANGUAGES_TO_INSTALL[@]} -gt 0 ]]; then
        for language in "${LANGUAGES_TO_INSTALL[@]}"; do
            # Continue on error but track failures
            install_language "$language" || true
            echo ""
        done
    fi

    # Show summary and exit with appropriate code
    if show_summary; then
        exit "$EXIT_SUCCESS"
    else
        exit "$EXIT_FAILURE"
    fi
}

# Run main function
main "$@"
