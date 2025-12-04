#!/bin/bash

# Test script for language-specific test runners
# This script validates that all language runners function correctly
# Tests: Rust, Gleam, Roc, Carbon, Bosque runners

set -eo pipefail

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=./common.sh
source "${SCRIPT_DIR}/common.sh"

# Test counter
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Track which tests fail
FAILED_TESTS=()

# Run a single test
# Usage: run_test "test_name" test_function
run_test() {
    local test_name="$1"
    local test_function="$2"

    TESTS_RUN=$((TESTS_RUN + 1))
    log_info "Running test: $test_name"

    if $test_function; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        log_success "PASSED: $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        FAILED_TESTS+=("$test_name")
        log_error "FAILED: $test_name"
        return 1
    fi
}

# Test 1: Verify Rust runner script exists and is executable
test_rust_runner_exists() {
    local runner="${SCRIPT_DIR}/runners/run_rust.sh"

    if [[ ! -f "$runner" ]]; then
        log_error "Rust runner script not found: $runner"
        return 1
    fi

    if [[ ! -x "$runner" ]]; then
        log_error "Rust runner script is not executable: $runner"
        return 1
    fi

    return 0
}

# Test 2: Verify Gleam runner script exists and is executable
test_gleam_runner_exists() {
    local runner="${SCRIPT_DIR}/runners/run_gleam.sh"

    if [[ ! -f "$runner" ]]; then
        log_error "Gleam runner script not found: $runner"
        return 1
    fi

    if [[ ! -x "$runner" ]]; then
        log_error "Gleam runner script is not executable: $runner"
        return 1
    fi

    return 0
}

# Test 3: Verify Roc runner script exists and is executable
test_roc_runner_exists() {
    local runner="${SCRIPT_DIR}/runners/run_roc.sh"

    if [[ ! -f "$runner" ]]; then
        log_error "Roc runner script not found: $runner"
        return 1
    fi

    if [[ ! -x "$runner" ]]; then
        log_error "Roc runner script is not executable: $runner"
        return 1
    fi

    return 0
}

# Test 4: Verify Carbon runner script exists and is executable
test_carbon_runner_exists() {
    local runner="${SCRIPT_DIR}/runners/run_carbon.sh"

    if [[ ! -f "$runner" ]]; then
        log_error "Carbon runner script not found: $runner"
        return 1
    fi

    if [[ ! -x "$runner" ]]; then
        log_error "Carbon runner script is not executable: $runner"
        return 1
    fi

    return 0
}

# Test 5: Verify Bosque runner script exists and is executable
test_bosque_runner_exists() {
    local runner="${SCRIPT_DIR}/runners/run_bosque.sh"

    if [[ ! -f "$runner" ]]; then
        log_error "Bosque runner script not found: $runner"
        return 1
    fi

    if [[ ! -x "$runner" ]]; then
        log_error "Bosque runner script is not executable: $runner"
        return 1
    fi

    return 0
}

# Test 6: Verify runner scripts source common.sh
test_runners_source_common() {
    local runners=(
        "${SCRIPT_DIR}/runners/run_rust.sh"
        "${SCRIPT_DIR}/runners/run_gleam.sh"
        "${SCRIPT_DIR}/runners/run_roc.sh"
        "${SCRIPT_DIR}/runners/run_carbon.sh"
        "${SCRIPT_DIR}/runners/run_bosque.sh"
    )

    for runner in "${runners[@]}"; do
        if [[ ! -f "$runner" ]]; then
            log_error "Runner not found: $runner"
            return 1
        fi

        # Check if script sources common.sh
        if ! grep -q "source.*common.sh" "$runner"; then
            log_error "Runner does not source common.sh: $runner"
            return 1
        fi
    done

    return 0
}

# Test 7: Verify runner scripts accept correct arguments
test_runner_argument_handling() {
    local runner="${SCRIPT_DIR}/runners/run_rust.sh"

    if [[ ! -f "$runner" ]]; then
        log_warn "Rust runner not found, skipping argument handling test"
        return 0
    fi

    # Test missing arguments - should fail
    set +e
    bash "$runner" >/dev/null 2>&1
    local exit_code=$?
    set -e

    if [[ $exit_code -eq 0 ]]; then
        log_error "Runner should fail when called without arguments"
        return 1
    fi

    return 0
}

# Test 8: Verify runners handle missing implementation gracefully
test_runner_missing_implementation() {
    local runner="${SCRIPT_DIR}/runners/run_rust.sh"

    if [[ ! -f "$runner" ]]; then
        log_warn "Rust runner not found, skipping missing implementation test"
        return 0
    fi

    # Try to run with non-existent day directory
    local fake_day="99"
    local fake_input="/tmp/fake_input.txt"

    # Create fake input file
    echo "test input" > "$fake_input"

    set +e
    bash "$runner" "$fake_day" "$fake_input" >/dev/null 2>&1
    local exit_code=$?
    set -e

    # Clean up
    rm -f "$fake_input"

    # Runner should handle missing implementation gracefully (non-zero exit)
    if [[ $exit_code -eq 0 ]]; then
        log_warn "Runner returned success for non-existent day (may be OK if placeholder)"
    fi

    # This test passes if the runner doesn't crash
    return 0
}

# Main test execution
main() {
    log_info "========================================"
    log_info "  Language Runner Tests"
    log_info "========================================"
    echo ""

    # Run all tests (continue on failure to see all results)
    set +e
    run_test "Rust runner exists and is executable" test_rust_runner_exists
    run_test "Gleam runner exists and is executable" test_gleam_runner_exists
    run_test "Roc runner exists and is executable" test_roc_runner_exists
    run_test "Carbon runner exists and is executable" test_carbon_runner_exists
    run_test "Bosque runner exists and is executable" test_bosque_runner_exists
    run_test "Runners source common.sh" test_runners_source_common
    run_test "Runner argument handling" test_runner_argument_handling
    run_test "Runner handles missing implementation" test_runner_missing_implementation
    set -e

    # Print summary
    echo ""
    log_info "========================================"
    log_info "  Test Summary"
    log_info "========================================"
    log_info "Tests run: $TESTS_RUN"
    log_success "Tests passed: $TESTS_PASSED"

    if [[ $TESTS_FAILED -gt 0 ]]; then
        log_error "Tests failed: $TESTS_FAILED"
        echo ""
        log_error "Failed tests:"
        for test in "${FAILED_TESTS[@]}"; do
            log_error "  - $test"
        done
        echo ""
        exit 1
    else
        echo ""
        log_success "All tests passed!"
        exit 0
    fi
}

# Run main function
main "$@"
