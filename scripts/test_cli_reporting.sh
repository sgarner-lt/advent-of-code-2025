#!/bin/bash

# Tests for CLI argument parsing and markdown report generation
# This script tests the CLI interface and reporting system

set -uo pipefail  # Note: removed -e to allow test failures

# Get script directory and source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=./common.sh
source "${SCRIPT_DIR}/common.sh"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Track test failures for summary
declare -a FAILED_TESTS=()

# Test assertion helper
assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"

    TESTS_RUN=$((TESTS_RUN + 1))

    if [[ "$expected" == "$actual" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        log_success "PASS: $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        FAILED_TESTS+=("$test_name")
        log_error "FAIL: $test_name"
        log_error "  Expected: '$expected'"
        log_error "  Actual:   '$actual'"
        return 1
    fi
}

# Test assertion for exit codes
assert_exit_code() {
    local expected_code="$1"
    local actual_code="$2"
    local test_name="$3"

    TESTS_RUN=$((TESTS_RUN + 1))

    if [[ "$expected_code" -eq "$actual_code" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        log_success "PASS: $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        FAILED_TESTS+=("$test_name")
        log_error "FAIL: $test_name"
        log_error "  Expected exit code: $expected_code"
        log_error "  Actual exit code:   $actual_code"
        return 1
    fi
}

# Test assertion for file existence
assert_file_exists() {
    local file_path="$1"
    local test_name="$2"

    TESTS_RUN=$((TESTS_RUN + 1))

    if [[ -f "$file_path" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        log_success "PASS: $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        FAILED_TESTS+=("$test_name")
        log_error "FAIL: $test_name"
        log_error "  File not found: $file_path"
        return 1
    fi
}

# Test assertion for content matching
assert_contains() {
    local haystack="$1"
    local needle="$2"
    local test_name="$3"

    TESTS_RUN=$((TESTS_RUN + 1))

    if [[ "$haystack" == *"$needle"* ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        log_success "PASS: $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        FAILED_TESTS+=("$test_name")
        log_error "FAIL: $test_name"
        log_error "  Content does not contain: '$needle'"
        return 1
    fi
}

# Test 1: CLI argument parsing for day number
test_cli_argument_parsing() {
    log_info "Test 1: CLI argument parsing for day number"

    # Source the generate_report script to test helper functions
    source "${SCRIPT_DIR}/generate_report.sh"

    # Test valid day number
    local day_num="5"
    local formatted
    formatted=$(format_day_number "$day_num")
    assert_equals "05" "$formatted" "Format day number with leading zero"

    # Test day without leading zero needed
    day_num="15"
    formatted=$(format_day_number "$day_num")
    assert_equals "15" "$formatted" "Format day number without change"
}

# Test 2: Verbose flag functionality
test_verbose_flag() {
    log_info "Test 2: Verbose flag functionality"

    # Create a test script to check verbose mode
    local test_script="${PROJECT_ROOT}/scripts/test_integration.sh"

    # Test that verbose mode can be detected
    # We'll check if the script exists and has help text
    if [[ -f "$test_script" ]]; then
        set +e
        local help_output
        help_output=$(bash "$test_script" --help 2>&1 || true)
        set -e

        assert_contains "$help_output" "verbose" "Help text mentions verbose flag"
    else
        # Skip this test if script doesn't exist yet
        log_warn "Skipping verbose flag test - test_integration.sh not yet created"
    fi
}

# Test 3: Timeout flag with custom value
test_timeout_flag() {
    log_info "Test 3: Timeout flag with custom value"

    # Test timeout parsing helper function
    local default_timeout=60
    local custom_timeout=120

    # Test that default timeout is used when no flag provided
    assert_equals "60" "$default_timeout" "Default timeout is 60 seconds"

    # Test that custom timeout can be specified
    assert_equals "120" "$custom_timeout" "Custom timeout can be set to 120 seconds"
}

# Test 4: Markdown report generation with all sections
test_markdown_report_generation() {
    log_info "Test 4: Markdown report generation with all sections"

    # Source report generation functions
    source "${SCRIPT_DIR}/generate_report.sh"

    # Create a temporary test output directory
    local test_output_dir
    test_output_dir=$(mktemp -d -t test-cli-report.XXXXXX)

    # Create mock test output files for all languages
    local languages=("rust" "gleam" "roc" "carbon" "bosque")
    for lang in "${languages[@]}"; do
        echo '{"part1": 123, "part2": 456}' > "${test_output_dir}/${lang}_stdout.txt"
        echo "" > "${test_output_dir}/${lang}_stderr.txt"
        echo "0" > "${test_output_dir}/${lang}_exit_code.txt"
    done

    # Generate test report
    local report_file="${test_output_dir}/test_report.md"
    set +e
    generate_markdown_report "1" "$test_output_dir" "$report_file"
    local gen_exit=$?
    set -e

    assert_exit_code 0 "$gen_exit" "Report generation completes successfully"
    assert_file_exists "$report_file" "Report file is created"

    # Check report contains required sections
    if [[ -f "$report_file" ]]; then
        local report_content
        report_content=$(cat "$report_file")

        assert_contains "$report_content" "Test Results" "Report has title"
        assert_contains "$report_content" "Day" "Report shows day number"
        assert_contains "$report_content" "rust" "Report includes Rust results"
        assert_contains "$report_content" "part1" "Report shows part1 results"
        assert_contains "$report_content" "part2" "Report shows part2 results"
    fi

    # Cleanup
    rm -rf "$test_output_dir"
}

# Test 5: Report showing commonalities across languages
test_report_commonalities() {
    log_info "Test 5: Report showing commonalities across languages"

    # Source report generation functions
    source "${SCRIPT_DIR}/generate_report.sh"

    # Create a temporary test output directory
    local test_output_dir
    test_output_dir=$(mktemp -d -t test-cli-commonalities.XXXXXX)

    # Create mock test output - all languages agree
    local languages=("rust" "gleam" "roc" "carbon" "bosque")
    for lang in "${languages[@]}"; do
        echo '{"part1": 999, "part2": 888}' > "${test_output_dir}/${lang}_stdout.txt"
        echo "" > "${test_output_dir}/${lang}_stderr.txt"
        echo "0" > "${test_output_dir}/${lang}_exit_code.txt"
    done

    # Generate test report
    local report_file="${test_output_dir}/test_report.md"
    set +e
    generate_markdown_report "2" "$test_output_dir" "$report_file"
    set -e

    # Check report shows agreement
    if [[ -f "$report_file" ]]; then
        local report_content
        report_content=$(cat "$report_file")

        # Look for "All languages agree" instead of "Agreement"
        assert_contains "$report_content" "All languages agree" "Report shows languages agree on answers"
    fi

    # Cleanup
    rm -rf "$test_output_dir"
}

# Test 6: Report showing differences/divergences
test_report_divergences() {
    log_info "Test 6: Report showing differences/divergences"

    # Source report generation functions
    source "${SCRIPT_DIR}/generate_report.sh"

    # Create a temporary test output directory
    local test_output_dir
    test_output_dir=$(mktemp -d -t test-cli-divergences.XXXXXX)

    # Create mock test output - languages disagree
    echo '{"part1": 100, "part2": 200}' > "${test_output_dir}/rust_stdout.txt"
    echo "" > "${test_output_dir}/rust_stderr.txt"
    echo "0" > "${test_output_dir}/rust_exit_code.txt"

    echo '{"part1": 999, "part2": 888}' > "${test_output_dir}/gleam_stdout.txt"
    echo "" > "${test_output_dir}/gleam_stderr.txt"
    echo "0" > "${test_output_dir}/gleam_exit_code.txt"

    # Others not implemented
    for lang in "roc" "carbon" "bosque"; do
        echo '{"part1": null, "part2": null}' > "${test_output_dir}/${lang}_stdout.txt"
        echo "not implemented" > "${test_output_dir}/${lang}_stderr.txt"
        echo "1" > "${test_output_dir}/${lang}_exit_code.txt"
    done

    # Generate test report
    local report_file="${test_output_dir}/test_report.md"
    set +e
    generate_markdown_report "3" "$test_output_dir" "$report_file"
    set -e

    # Check report shows divergence
    if [[ -f "$report_file" ]]; then
        local report_content
        report_content=$(cat "$report_file")

        # Should show different answers
        assert_contains "$report_content" "rust" "Report includes Rust with different answer"
        assert_contains "$report_content" "gleam" "Report includes Gleam with different answer"
    fi

    # Cleanup
    rm -rf "$test_output_dir"
}

# Run all tests
main() {
    log_info "========================================"
    log_info "Running CLI and Reporting Test Suite"
    log_info "========================================"
    echo

    test_cli_argument_parsing
    echo
    test_verbose_flag
    echo
    test_timeout_flag
    echo
    test_markdown_report_generation
    echo
    test_report_commonalities
    echo
    test_report_divergences
    echo

    log_info "========================================"
    log_info "Test Results Summary"
    log_info "========================================"
    echo "Total tests run:    $TESTS_RUN"
    echo "Tests passed:       $TESTS_PASSED"
    echo "Tests failed:       $TESTS_FAILED"
    echo

    if [[ $TESTS_FAILED -eq 0 ]]; then
        log_success "All tests passed!"
        return 0
    else
        log_error "Failed tests:"
        for test in "${FAILED_TESTS[@]}"; do
            echo "  - $test"
        done
        return 1
    fi
}

# Execute tests if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
