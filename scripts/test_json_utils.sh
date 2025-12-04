#!/bin/bash

# Tests for JSON utility functions
# This script tests the core JSON parsing and validation functions in json_utils.sh

set -uo pipefail  # Note: removed -e to allow test failures

# Get script directory and source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "${SCRIPT_DIR}/common.sh"
# shellcheck source=./json_utils.sh
source "${SCRIPT_DIR}/json_utils.sh"

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

# Test 1: Parse valid JSON with integer values
test_parse_valid_json_integers() {
    log_info "Test 1: Parse valid JSON with integer values"

    local json='{"part1": 123, "part2": 456}'
    local result
    result=$(parse_json_answer "$json" "part1" 2>&1)
    assert_equals "123" "$result" "Parse part1 from valid JSON"

    result=$(parse_json_answer "$json" "part2" 2>&1)
    assert_equals "456" "$result" "Parse part2 from valid JSON"
}

# Test 2: Parse JSON with null values
test_parse_json_with_null() {
    log_info "Test 2: Parse JSON with null values"

    local json='{"part1": null, "part2": 789}'
    local result
    result=$(parse_json_answer "$json" "part1" 2>&1)
    assert_equals "null" "$result" "Parse null value for part1"

    result=$(parse_json_answer "$json" "part2" 2>&1)
    assert_equals "789" "$result" "Parse integer value for part2"
}

# Test 3: Parse JSON with string values
test_parse_json_with_strings() {
    log_info "Test 3: Parse JSON with string values"

    local json='{"part1": "abc123", "part2": "xyz789"}'
    local result
    result=$(parse_json_answer "$json" "part1" 2>&1)
    assert_equals "abc123" "$result" "Parse string value for part1"

    result=$(parse_json_answer "$json" "part2" 2>&1)
    assert_equals "xyz789" "$result" "Parse string value for part2"
}

# Test 4: Handle malformed JSON
test_malformed_json() {
    log_info "Test 4: Handle malformed JSON"

    local json='{"part1": 123, "part2": INVALID}'

    # Test detection function
    local malformed_result
    if is_json_malformed "$json"; then
        malformed_result=0
    else
        malformed_result=1
    fi
    assert_exit_code 0 "$malformed_result" "Detect malformed JSON"

    # Test parsing malformed JSON returns error
    local result
    set +e  # Temporarily disable exit on error
    result=$(parse_json_answer "$json" "part1" 2>&1)
    local parse_exit=$?
    set -e

    if [[ $parse_exit -ne 0 ]]; then
        assert_exit_code 1 1 "Parse malformed JSON fails gracefully"
    else
        assert_exit_code 1 0 "Parse malformed JSON fails gracefully"
    fi
}

# Test 5: Handle missing keys
test_missing_keys() {
    log_info "Test 5: Handle missing keys"

    # JSON with only part1
    local json='{"part1": 123}'

    set +e  # Temporarily disable exit on error
    validate_json_format "$json" 2>&1 >/dev/null
    local exit_code=$?
    set -e
    assert_exit_code 1 "$exit_code" "Validation fails for missing part2 key"

    # JSON with only part2
    json='{"part2": 456}'
    set +e
    validate_json_format "$json" 2>&1 >/dev/null
    exit_code=$?
    set -e
    assert_exit_code 1 "$exit_code" "Validation fails for missing part1 key"
}

# Test 6: Validate correct JSON format
test_validate_correct_format() {
    log_info "Test 6: Validate correct JSON format"

    local json='{"part1": 123, "part2": 456}'
    set +e
    validate_json_format "$json" 2>&1 >/dev/null
    local exit_code=$?
    set -e
    assert_exit_code 0 "$exit_code" "Valid format with integers"

    json='{"part1": null, "part2": null}'
    set +e
    validate_json_format "$json" 2>&1 >/dev/null
    exit_code=$?
    set -e
    assert_exit_code 0 "$exit_code" "Valid format with null values"

    json='{"part1": "answer1", "part2": "answer2"}'
    set +e
    validate_json_format "$json" 2>&1 >/dev/null
    exit_code=$?
    set -e
    assert_exit_code 0 "$exit_code" "Valid format with strings"
}

# Test 7: Detect empty and invalid input
test_empty_invalid_input() {
    log_info "Test 7: Detect empty and invalid input"

    # Empty string
    local empty_result
    if is_json_malformed ""; then
        empty_result=0
    else
        empty_result=1
    fi
    assert_exit_code 0 "$empty_result" "Empty string is malformed"

    # Invalid JSON (not even JSON)
    local invalid_result
    if is_json_malformed "not json at all"; then
        invalid_result=0
    else
        invalid_result=1
    fi
    assert_exit_code 0 "$invalid_result" "Non-JSON string is malformed"
}

# Test 8: Extract both parts simultaneously
test_extract_both_parts() {
    log_info "Test 8: Extract both parts simultaneously"

    local json='{"part1": 111, "part2": 222}'
    local result
    result=$(extract_both_parts "$json" 2>&1)
    assert_equals "111 222" "$result" "Extract both parts from valid JSON"

    json='{"part1": null, "part2": 333}'
    result=$(extract_both_parts "$json" 2>&1)
    assert_equals "null 333" "$result" "Extract both parts with null value"
}

# Run all tests
main() {
    log_info "========================================"
    log_info "Running JSON Utilities Test Suite"
    log_info "========================================"
    echo

    test_parse_valid_json_integers
    echo
    test_parse_json_with_null
    echo
    test_parse_json_with_strings
    echo
    test_malformed_json
    echo
    test_missing_keys
    echo
    test_validate_correct_format
    echo
    test_empty_invalid_input
    echo
    test_extract_both_parts
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
