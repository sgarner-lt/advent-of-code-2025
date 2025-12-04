#!/bin/bash

# Main integration test script for Advent of Code cross-language validation
# Runs all 5 languages in parallel, validates answers, and generates markdown report
# Usage: ./scripts/test_integration.sh <day_number> [--verbose] [--timeout <seconds>]

set -eo pipefail

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=./common.sh
source "${SCRIPT_DIR}/common.sh"
# shellcheck source=./test_discovery.sh
source "${SCRIPT_DIR}/test_discovery.sh"
# shellcheck source=./test_execution.sh
source "${SCRIPT_DIR}/test_execution.sh"
# shellcheck source=./generate_report.sh
source "${SCRIPT_DIR}/generate_report.sh"

# Default values
VERBOSE=false
TIMEOUT=60
DAY_NUMBER=""
INPUT_TYPE="real"  # Default to real puzzle input

# Usage information
usage() {
    cat << EOF
Usage: $0 <day_number> [options]

Run integration tests across all 5 languages for a specific Advent of Code day.

Arguments:
  day_number    Day number (1-25)

Options:
  --verbose     Show detailed output from all commands
  --timeout N   Set custom timeout in seconds (default: 60)
  --sample      Use sample input instead of real input
  --help        Show this help message

Examples:
  $0 1                       # Test day 1 with real input
  $0 5 --verbose             # Test day 5 with detailed output
  $0 3 --timeout 120         # Test day 3 with 2 minute timeout
  $0 1 --sample              # Test day 1 with sample input

Exit codes:
  0  - All tests passed and all languages agree
  1  - One or more tests failed or answers diverge

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
            --timeout)
                if [[ -z "$2" ]] || [[ ! "$2" =~ ^[0-9]+$ ]]; then
                    log_error "Invalid timeout value: $2"
                    usage
                    exit 1
                fi
                TIMEOUT="$2"
                shift 2
                ;;
            --sample)
                INPUT_TYPE="sample"
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

# Main execution
main() {
    parse_arguments "$@"

    log_info "========================================"
    log_info "Advent of Code Integration Test Runner"
    log_info "========================================"
    echo ""
    log_info "Day: $DAY_NUMBER"
    log_info "Timeout: ${TIMEOUT}s"
    log_info "Verbose: $VERBOSE"
    log_info "Input Type: $INPUT_TYPE"
    echo ""

    # Verify that the day's challenge directory exists
    if ! day_exists "$DAY_NUMBER"; then
        log_error "Challenge directory not found for day $DAY_NUMBER"
        log_error "Expected: ${PROJECT_ROOT}/challenges/day$(printf "%02d" "$DAY_NUMBER")"
        exit 1
    fi

    # Discover test input file
    log_info "Discovering test input files..."
    local input_path
    set +e
    input_path=$(get_input_path "$DAY_NUMBER" "$INPUT_TYPE" 2>&1)
    local discovery_exit=$?
    set -e

    if [[ $discovery_exit -ne 0 ]]; then
        log_error "Failed to find $INPUT_TYPE input file for day $DAY_NUMBER"
        log_error "$input_path"
        exit 1
    fi

    log_success "Using input file: $input_path"
    echo ""

    # Validate input file exists
    if ! validate_input_exists "$input_path"; then
        log_error "Input file validation failed"
        exit 1
    fi

    # Run all languages in parallel
    log_info "Launching parallel test execution..."
    echo ""

    if [[ "$VERBOSE" == true ]]; then
        log_info "Running with verbose output enabled"
        echo ""
    fi

    # Execute tests in parallel
    if ! run_all_tests_parallel "$DAY_NUMBER" "$input_path" "$TIMEOUT"; then
        log_error "Failed to launch parallel tests"
        exit 1
    fi

    # Wait for all tests to complete
    if ! wait_for_all_tests; then
        log_error "Test execution encountered errors"
        # Continue to generate report even if some tests failed
    fi

    echo ""
    log_info "All test processes completed"
    echo ""

    # Show verbose output if requested
    if [[ "$VERBOSE" == true ]]; then
        log_info "========================================"
        log_info "Detailed Output (Verbose Mode)"
        log_info "========================================"
        echo ""

        local languages=("rust" "gleam" "roc" "carbon" "bosque")
        for language in "${languages[@]}"; do
            log_info "--- $language stdout ---"
            get_language_stdout "$language" 2>/dev/null || echo "(no output)"
            echo ""

            local stderr_content
            stderr_content=$(get_language_stderr "$language" 2>/dev/null || echo "")
            if [[ -n "$stderr_content" ]]; then
                log_info "--- $language stderr ---"
                echo "$stderr_content"
                echo ""
            fi
        done
    fi

    # Generate markdown report
    log_info "Generating markdown report..."
    local report_file="${PROJECT_ROOT}/test_results.md"

    if ! generate_markdown_report "$DAY_NUMBER" "$TEST_OUTPUT_DIR" "$report_file"; then
        log_error "Failed to generate markdown report"
        cleanup_test_output_dir
        exit 1
    fi

    # Print summary to stdout
    print_report_summary "$DAY_NUMBER" "$TEST_OUTPUT_DIR"

    # Cleanup temporary files
    cleanup_test_output_dir

    log_info "========================================"
    log_info "Integration Test Complete"
    log_info "========================================"
    echo ""
    log_info "Full report available at: $report_file"
    echo ""

    # Determine exit code based on results
    if all_tests_passed; then
        # All tests passed, now check if answers agree
        source "${SCRIPT_DIR}/validate_answers.sh"
        compare_all_answers "$TEST_OUTPUT_DIR" > /dev/null 2>&1 || true

        if all_answers_agree "part1" && all_answers_agree "part2"; then
            log_success "All tests passed and all languages agree!"
            exit 0
        else
            log_warn "All tests passed but some answers diverge - check report for details"
            exit 1
        fi
    else
        local failed_count
        failed_count=$(get_failed_count)
        log_error "$failed_count language(s) failed - see report for details"
        exit 1
    fi
}

# Trap to ensure cleanup on exit
trap cleanup_test_output_dir EXIT

# Execute main function
main "$@"
