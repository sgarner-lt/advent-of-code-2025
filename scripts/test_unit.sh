#!/bin/bash

# Unit test script for Advent of Code solutions
# Runs language-specific unit tests without cross-language validation
# Usage: ./scripts/test_unit.sh <day_number> [--verbose]

set -eo pipefail

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=./common.sh
source "${SCRIPT_DIR}/common.sh"

# Default values
VERBOSE=false
DAY_NUMBER=""

# Usage information
usage() {
    cat << EOF
Usage: $0 <day_number> [options]

Run unit tests for a specific Advent of Code day across all languages.
This runs language-specific test frameworks without cross-language validation.

Arguments:
  day_number    Day number (1-25)

Options:
  --verbose     Show detailed output from test commands
  --help        Show this help message

Examples:
  $0 1                       # Run unit tests for day 1
  $0 5 --verbose             # Run day 5 tests with detailed output

Exit codes:
  0  - All unit tests passed
  1  - One or more unit tests failed

For TDD workflow:
  - Use this command during development to quickly run unit tests
  - Use ./test_integration.sh for full cross-language validation

For more information, see: docs/testing-framework.md
EOF
}

# Parse command-line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|-h)
                usage
                exit 0
                ;;
            --verbose|-v)
                VERBOSE=true
                shift
                ;;
            -*)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
            *)
                if [[ -z "$DAY_NUMBER" ]]; then
                    DAY_NUMBER="$1"
                else
                    log_error "Unexpected argument: $1"
                    usage
                    exit 1
                fi
                shift
                ;;
        esac
    done

    # Validate required arguments
    if [[ -z "$DAY_NUMBER" ]]; then
        log_error "Missing required argument: day_number"
        usage
        exit 1
    fi

    # Validate day number format
    if ! [[ "$DAY_NUMBER" =~ ^[0-9]+$ ]] || [[ "$DAY_NUMBER" -lt 1 ]] || [[ "$DAY_NUMBER" -gt 25 ]]; then
        log_error "Invalid day number: $DAY_NUMBER (must be 1-25)"
        exit 1
    fi
}

# Run unit tests for a specific language
# Usage: run_language_unit_tests <language> <day_number>
run_language_unit_tests() {
    local language="$1"
    local day_number="$2"

    log_info "Testing $language..."

    local day_formatted
    day_formatted=$(printf "day%02d" "$day_number")

    local runner_script="${SCRIPT_DIR}/runners/run_${language}.sh"

    if [[ ! -f "$runner_script" ]]; then
        log_warn "$language: Runner script not found, skipping"
        return 2
    fi

    # Check if language implementation exists
    local impl_dir="${PROJECT_ROOT}/${language}/${day_formatted}"
    if [[ ! -d "$impl_dir" ]]; then
        log_warn "$language: Implementation not found at $impl_dir, skipping"
        return 2
    fi

    # Run unit tests with --unit-test flag
    # We pass /dev/null as input path since unit tests don't need it
    set +e
    if [[ "$VERBOSE" == true ]]; then
        bash "$runner_script" "$day_number" "/dev/null" --unit-test
    else
        bash "$runner_script" "$day_number" "/dev/null" --unit-test > /dev/null 2>&1
    fi
    local exit_code=$?
    set -e

    if [[ $exit_code -eq 0 ]]; then
        log_success "$language: Unit tests passed"
        return 0
    elif [[ $exit_code -eq 2 ]]; then
        log_warn "$language: Skipped (not implemented)"
        return 2
    else
        log_error "$language: Unit tests failed (exit code: $exit_code)"
        return 1
    fi
}

# Main execution
main() {
    parse_arguments "$@"

    log_info "========================================"
    log_info "Advent of Code Unit Test Runner"
    log_info "========================================"
    echo ""
    log_info "Day: $DAY_NUMBER"
    log_info "Mode: Unit tests only (no cross-language validation)"
    log_info "Verbose: $VERBOSE"
    echo ""

    # Track results
    local total=0
    local passed=0
    local failed=0
    local skipped=0

    local languages=("rust" "gleam" "roc" "carbon" "bosque")

    # Run unit tests for each language sequentially
    for language in "${languages[@]}"; do
        total=$((total + 1))

        set +e
        run_language_unit_tests "$language" "$DAY_NUMBER"
        local result=$?
        set -e

        case $result in
            0)
                passed=$((passed + 1))
                ;;
            1)
                failed=$((failed + 1))
                ;;
            2)
                skipped=$((skipped + 1))
                ;;
        esac

        echo ""
    done

    # Print summary
    log_info "========================================"
    log_info "Unit Test Summary"
    log_info "========================================"
    echo "Total languages: $total"
    echo "Passed:          $passed"
    echo "Failed:          $failed"
    echo "Skipped:         $skipped"
    echo ""

    # Determine exit code
    if [[ $failed -eq 0 ]]; then
        log_success "All unit tests passed!"
        exit 0
    else
        log_error "$failed language(s) failed unit tests"
        exit 1
    fi
}

# Execute main function
main "$@"
