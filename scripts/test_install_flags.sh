#!/bin/bash

# Test Script for Selective Installation Flags
# Part of Task Group 8.2: Test selective installation flags
# Tests --only-[language] and --skip-[language] flags

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common utilities
source "${SCRIPT_DIR}/common.sh"

# Test results tracking
PASSED_TESTS=()
FAILED_TESTS=()

# Run a test case
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_pattern="$3"

    log_info "Testing: $test_name"

    # Run the command and capture output
    local output
    if output=$(eval "$test_command" 2>&1); then
        # Check if output matches expected pattern
        if echo "$output" | grep -q "$expected_pattern"; then
            log_success "PASS: $test_name"
            PASSED_TESTS+=("$test_name")
            return 0
        else
            log_error "FAIL: $test_name - Output did not match expected pattern"
            log_error "Expected pattern: $expected_pattern"
            FAILED_TESTS+=("$test_name")
            return 1
        fi
    else
        log_error "FAIL: $test_name - Command failed with exit code $?"
        FAILED_TESTS+=("$test_name")
        return 1
    fi
}

# Show test summary
show_summary() {
    echo ""
    log_info "=================================================="
    log_info "FLAG TESTING SUMMARY"
    log_info "=================================================="
    echo ""

    local pass_count=${#PASSED_TESTS[@]}
    local fail_count=${#FAILED_TESTS[@]}
    local total=$((pass_count + fail_count))

    log_info "Results: ${pass_count}/${total} tests passed"
    echo ""

    if [[ $pass_count -gt 0 ]]; then
        log_info "PASSED TESTS:"
        for test in "${PASSED_TESTS[@]}"; do
            log_success "  $test"
        done
        echo ""
    fi

    if [[ $fail_count -gt 0 ]]; then
        log_error "FAILED TESTS:"
        for test in "${FAILED_TESTS[@]}"; do
            log_error "  $test"
        done
        echo ""
        return 1
    fi

    log_success "All flag tests passed!"
    return 0
}

# Main test logic
main() {
    log_info "=================================================="
    log_info "Selective Installation Flags Test Suite"
    log_info "=================================================="
    echo ""

    # Test 1: --help flag
    log_info "Test Group 1: Help and Usage"
    run_test \
        "Help flag (--help)" \
        "bash ${SCRIPT_DIR}/install_all.sh --help" \
        "Usage:"
    echo ""

    # Test 2: --only-rust flag (dry-run style test)
    log_info "Test Group 2: --only-* Flags"
    run_test \
        "Only Rust flag (--only-rust)" \
        "bash ${SCRIPT_DIR}/install_all.sh --only-rust 2>&1 | head -30" \
        "Languages to install: rust"
    echo ""

    run_test \
        "Only Gleam flag (--only-gleam)" \
        "bash ${SCRIPT_DIR}/install_all.sh --only-gleam 2>&1 | head -30" \
        "Languages to install: gleam"
    echo ""

    run_test \
        "Multiple --only flags (--only-rust --only-gleam)" \
        "bash ${SCRIPT_DIR}/install_all.sh --only-rust --only-gleam 2>&1 | head -30" \
        "Languages to install: rust gleam"
    echo ""

    # Test 3: --skip-* flags
    log_info "Test Group 3: --skip-* Flags"
    run_test \
        "Skip Carbon flag (--skip-carbon)" \
        "bash ${SCRIPT_DIR}/install_all.sh --skip-carbon 2>&1 | head -30" \
        "rust gleam roc"
    echo ""

    run_test \
        "Skip Bosque flag (--skip-bosque)" \
        "bash ${SCRIPT_DIR}/install_all.sh --skip-bosque 2>&1 | head -30" \
        "rust gleam roc carbon"
    echo ""

    # Test 4: Error handling
    log_info "Test Group 4: Error Handling"

    # Test invalid flag
    if bash "${SCRIPT_DIR}/install_all.sh" --invalid-flag 2>&1 | grep -q "Unknown option"; then
        log_success "PASS: Invalid flag error handling"
        PASSED_TESTS+=("Invalid flag error handling")
    else
        log_error "FAIL: Invalid flag error handling"
        FAILED_TESTS+=("Invalid flag error handling")
    fi
    echo ""

    # Test conflicting flags
    if bash "${SCRIPT_DIR}/install_all.sh" --only-rust --skip-gleam 2>&1 | grep -q "Cannot combine"; then
        log_success "PASS: Conflicting flags error handling"
        PASSED_TESTS+=("Conflicting flags error handling")
    else
        log_error "FAIL: Conflicting flags error handling"
        FAILED_TESTS+=("Conflicting flags error handling")
    fi
    echo ""

    # Test 5: Verify helpful error messages
    log_info "Test Group 5: Error Message Quality"

    local error_output
    error_output=$(bash "${SCRIPT_DIR}/install_all.sh" --invalid 2>&1 || true)

    if echo "$error_output" | grep -q "Unknown option"; then
        log_success "PASS: Clear error message for unknown option"
        PASSED_TESTS+=("Clear error message for unknown option")
    else
        log_error "FAIL: Error message for unknown option not clear"
        FAILED_TESTS+=("Clear error message for unknown option")
    fi
    echo ""

    if echo "$error_output" | grep -q "help"; then
        log_success "PASS: Error message suggests using --help"
        PASSED_TESTS+=("Error message suggests using --help")
    else
        log_error "FAIL: Error message does not suggest --help"
        FAILED_TESTS+=("Error message does not suggest --help")
    fi
    echo ""

    # Show summary
    if show_summary; then
        exit 0
    else
        exit 1
    fi
}

# Run main function
main "$@"
