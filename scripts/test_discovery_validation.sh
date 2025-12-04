#!/bin/bash

# Tests for test discovery and cross-language validation
# This script tests input file discovery and answer comparison logic

set -uo pipefail  # Note: removed -e to allow test failures

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REAL_PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

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

# Test assertion for conditions
assert_true() {
    local condition="$1"
    local test_name="$2"

    TESTS_RUN=$((TESTS_RUN + 1))

    if [[ "$condition" == "true" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        log_success "PASS: $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        FAILED_TESTS+=("$test_name")
        log_error "FAIL: $test_name"
        log_error "  Condition was false"
        return 1
    fi
}

# Setup: Create temporary test directory structure
setup_test_challenges() {
    local test_dir
    test_dir=$(mktemp -d -t aoc-test-challenges.XXXXXX)

    # Create day01 with both input files
    mkdir -p "${test_dir}/challenges/day01"
    echo "test input data" > "${test_dir}/challenges/day01/input.txt"
    echo "sample input data" > "${test_dir}/challenges/day01/input-sample.txt"

    # Create day02 with only real input
    mkdir -p "${test_dir}/challenges/day02"
    echo "real input only" > "${test_dir}/challenges/day02/input.txt"

    # Create day03 with only sample input
    mkdir -p "${test_dir}/challenges/day03"
    echo "sample input only" > "${test_dir}/challenges/day03/input-sample.txt"

    # Create day04 with no inputs (empty directory)
    mkdir -p "${test_dir}/challenges/day04"

    echo "$test_dir"
}

# Cleanup: Remove temporary test directory
cleanup_test_challenges() {
    local test_dir="$1"
    if [[ -n "$test_dir" ]] && [[ -d "$test_dir" ]]; then
        rm -rf "$test_dir"
    fi
}

# Create mock test output directory for validation tests
create_mock_test_output() {
    local output_dir
    output_dir=$(mktemp -d -t aoc-test-output.XXXXXX)

    # Rust: success with answers
    echo '{"part1": 12345, "part2": 67890}' > "${output_dir}/rust_stdout.txt"
    echo "" > "${output_dir}/rust_stderr.txt"
    echo "0" > "${output_dir}/rust_exit_code.txt"

    # Gleam: success with matching answers
    echo '{"part1": 12345, "part2": 67890}' > "${output_dir}/gleam_stdout.txt"
    echo "" > "${output_dir}/gleam_stderr.txt"
    echo "0" > "${output_dir}/gleam_exit_code.txt"

    # Roc: success with divergent answer for part2
    echo '{"part1": 12345, "part2": 99999}' > "${output_dir}/roc_stdout.txt"
    echo "" > "${output_dir}/roc_stderr.txt"
    echo "0" > "${output_dir}/roc_exit_code.txt"

    # Carbon: partial implementation (part1 null)
    echo '{"part1": null, "part2": 67890}' > "${output_dir}/carbon_stdout.txt"
    echo "" > "${output_dir}/carbon_stderr.txt"
    echo "0" > "${output_dir}/carbon_exit_code.txt"

    # Bosque: compilation failure
    echo "" > "${output_dir}/bosque_stdout.txt"
    echo "Compilation error: undefined reference" > "${output_dir}/bosque_stderr.txt"
    echo "1" > "${output_dir}/bosque_exit_code.txt"

    echo "$output_dir"
}

# Test 1: Discover input.txt in challenges/dayXX/
test_discover_real_input() {
    log_info "Test 1: Discover input.txt in challenges/dayXX/"

    # Create temporary challenges directory
    local test_challenges
    test_challenges=$(setup_test_challenges)

    # Set PROJECT_ROOT and source discovery functions
    PROJECT_ROOT="$test_challenges"
    # shellcheck source=./test_discovery.sh
    source "${SCRIPT_DIR}/test_discovery.sh"

    # Test discovering day01 inputs
    set +e
    local result
    result=$(discover_test_inputs 1 2>&1)
    local exit_code=$?
    set -e

    assert_exit_code 0 "$exit_code" "Discover inputs for day 1"

    # Check if input.txt is in the results
    if echo "$result" | grep -q "input.txt"; then
        assert_true "true" "input.txt discovered"
    else
        assert_true "false" "input.txt discovered"
    fi

    # Cleanup
    cleanup_test_challenges "$test_challenges"

    # Reset PROJECT_ROOT
    PROJECT_ROOT="$REAL_PROJECT_ROOT"
}

# Test 2: Discover input-sample.txt
test_discover_sample_input() {
    log_info "Test 2: Discover input-sample.txt"

    # Create temporary challenges directory
    local test_challenges
    test_challenges=$(setup_test_challenges)

    # Set PROJECT_ROOT
    PROJECT_ROOT="$test_challenges"

    # Test discovering day01 inputs (has both)
    set +e
    local result
    result=$(discover_test_inputs 1 2>&1)
    set -e

    # Check if input-sample.txt is in the results
    if echo "$result" | grep -q "input-sample.txt"; then
        assert_true "true" "input-sample.txt discovered"
    else
        assert_true "false" "input-sample.txt discovered"
    fi

    # Cleanup
    cleanup_test_challenges "$test_challenges"

    # Reset PROJECT_ROOT
    PROJECT_ROOT="$REAL_PROJECT_ROOT"
}

# Test 3: Handle missing input files
test_missing_input_files() {
    log_info "Test 3: Handle missing input files"

    # Create temporary challenges directory
    local test_challenges
    test_challenges=$(setup_test_challenges)

    # Set PROJECT_ROOT
    PROJECT_ROOT="$test_challenges"

    # Test day04 which has no input files
    set +e
    discover_test_inputs 4 2>&1 >/dev/null
    local exit_code=$?
    set -e

    assert_exit_code 1 "$exit_code" "Fail gracefully for missing input files"

    # Test non-existent day
    set +e
    discover_test_inputs 99 2>&1 >/dev/null
    exit_code=$?
    set -e

    assert_exit_code 1 "$exit_code" "Fail gracefully for non-existent day"

    # Cleanup
    cleanup_test_challenges "$test_challenges"

    # Reset PROJECT_ROOT
    PROJECT_ROOT="$REAL_PROJECT_ROOT"
}

# Test 4: Cross-language answer comparison (all match)
test_all_answers_match() {
    log_info "Test 4: Cross-language answer comparison (all match)"

    # Source validation functions
    # shellcheck source=./validate_answers.sh
    source "${SCRIPT_DIR}/validate_answers.sh"

    # Create mock output with all matching answers
    local output_dir
    output_dir=$(mktemp -d -t aoc-test-output.XXXXXX)

    # All languages return the same answers
    for lang in rust gleam roc carbon bosque; do
        echo '{"part1": 42, "part2": 84}' > "${output_dir}/${lang}_stdout.txt"
        echo "" > "${output_dir}/${lang}_stderr.txt"
        echo "0" > "${output_dir}/${lang}_exit_code.txt"
    done

    # Compare answers
    set +e
    compare_all_answers "$output_dir"
    local compare_exit=$?
    set -e

    assert_exit_code 0 "$compare_exit" "Compare all answers successfully"

    # Check that all answers agree
    set +e
    all_answers_agree "part1"
    local agree_exit=$?
    set -e

    assert_exit_code 0 "$agree_exit" "All part1 answers agree"

    set +e
    all_answers_agree "part2"
    agree_exit=$?
    set -e

    assert_exit_code 0 "$agree_exit" "All part2 answers agree"

    # Cleanup
    rm -rf "$output_dir"
}

# Test 5: Cross-language answer comparison (divergence)
test_divergent_answers() {
    log_info "Test 5: Cross-language answer comparison (divergence)"

    # Create mock output with divergent answers
    local output_dir
    output_dir=$(create_mock_test_output)

    # Compare answers
    set +e
    compare_all_answers "$output_dir"
    local compare_exit=$?
    set -e

    assert_exit_code 0 "$compare_exit" "Compare divergent answers successfully"

    # Check for divergences in part2 (rust/gleam: 67890, roc: 99999)
    set +e
    local divergences
    divergences=$(find_divergences "part2" 2>&1)
    local diverge_exit=$?
    set -e

    assert_exit_code 0 "$diverge_exit" "Detect divergences in part2"

    # Verify divergences contain expected languages
    if echo "$divergences" | grep -q "roc:99999"; then
        assert_true "true" "Roc divergence detected"
    else
        assert_true "false" "Roc divergence detected"
    fi

    # Cleanup
    rm -rf "$output_dir"
}

# Test 6: Handle partial implementations (null values)
test_handle_null_values() {
    log_info "Test 6: Handle partial implementations (null values)"

    # Create mock output
    local output_dir
    output_dir=$(create_mock_test_output)

    # Compare answers
    compare_all_answers "$output_dir"

    # Check for null values in part1 (carbon has null)
    set +e
    local null_langs
    null_langs=$(handle_null_values "part1" 2>&1)
    local null_exit=$?
    set -e

    assert_exit_code 0 "$null_exit" "Detect null values in part1"

    # Verify carbon is listed
    if echo "$null_langs" | grep -q "carbon"; then
        assert_true "true" "Carbon null value detected"
    else
        assert_true "false" "Carbon null value detected"
    fi

    # Verify null is distinguished from 0
    local carbon_part1="${VALIDATION_PART1_VALUES[3]}"  # Carbon is 4th (index 3)
    assert_equals "null" "$carbon_part1" "Null value preserved (not converted to 0)"

    # Cleanup
    rm -rf "$output_dir"
}

# Test 7: Track failed languages
test_track_failed_languages() {
    log_info "Test 7: Track failed languages"

    # Create mock output
    local output_dir
    output_dir=$(create_mock_test_output)

    # Compare answers
    compare_all_answers "$output_dir"

    # Get failed languages
    set +e
    local failures
    failures=$(get_failed_languages 2>&1)
    local fail_exit=$?
    set -e

    assert_exit_code 0 "$fail_exit" "Get failed languages"

    # Verify bosque is listed as failed
    if echo "$failures" | grep -q "bosque"; then
        assert_true "true" "Bosque failure detected"
    else
        assert_true "false" "Bosque failure detected"
    fi

    # Cleanup
    rm -rf "$output_dir"
}

# Test 8: Get input path with type specification
test_get_input_path() {
    log_info "Test 8: Get input path with type specification"

    # Create temporary challenges directory
    local test_challenges
    test_challenges=$(setup_test_challenges)

    # Set PROJECT_ROOT
    PROJECT_ROOT="$test_challenges"

    # Test getting real input path
    set +e
    local real_path
    real_path=$(get_input_path 1 "real" 2>&1)
    local real_exit=$?
    set -e

    assert_exit_code 0 "$real_exit" "Get real input path"

    if echo "$real_path" | grep -q "input.txt"; then
        assert_true "true" "Real input path contains input.txt"
    else
        assert_true "false" "Real input path contains input.txt"
    fi

    # Test getting sample input path
    set +e
    local sample_path
    sample_path=$(get_input_path 1 "sample" 2>&1)
    local sample_exit=$?
    set -e

    assert_exit_code 0 "$sample_exit" "Get sample input path"

    if echo "$sample_path" | grep -q "input-sample.txt"; then
        assert_true "true" "Sample input path contains input-sample.txt"
    else
        assert_true "false" "Sample input path contains input-sample.txt"
    fi

    # Cleanup
    cleanup_test_challenges "$test_challenges"

    # Reset PROJECT_ROOT
    PROJECT_ROOT="$REAL_PROJECT_ROOT"
}

# Run all tests
main() {
    log_info "========================================"
    log_info "Running Discovery & Validation Test Suite"
    log_info "========================================"
    echo

    test_discover_real_input
    echo
    test_discover_sample_input
    echo
    test_missing_input_files
    echo
    test_all_answers_match
    echo
    test_divergent_answers
    echo
    test_handle_null_values
    echo
    test_track_failed_languages
    echo
    test_get_input_path
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
