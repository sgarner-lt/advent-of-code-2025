#!/bin/bash

# Tests for parallel test execution framework
# This script tests the core parallel execution and process management functions

set -uo pipefail  # Note: removed -e to allow test failures

# Get script directory and source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=./common.sh
source "${SCRIPT_DIR}/common.sh"
# shellcheck source=./test_execution.sh
source "${SCRIPT_DIR}/test_execution.sh"

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

# Create mock test input file for testing
create_test_input() {
    local temp_input
    temp_input=$(mktemp -t test-input.XXXXXX)
    echo "test input data" > "$temp_input"
    echo "$temp_input"
}

# Create mock language runner script for testing
create_mock_runner() {
    local language="$1"
    local exit_code="${2:-0}"
    local delay="${3:-0}"

    local runners_dir="${SCRIPT_DIR}/runners"
    mkdir -p "$runners_dir"

    local runner_script="${runners_dir}/run_${language}.sh"

    cat > "$runner_script" << EOF
#!/bin/bash
# Mock runner for $language (test purposes only)
sleep $delay
echo '{"part1": 123, "part2": 456}'
exit $exit_code
EOF

    chmod +x "$runner_script"
}

# Clean up mock runners
cleanup_mock_runners() {
    local runners_dir="${SCRIPT_DIR}/runners"
    if [[ -d "$runners_dir" ]]; then
        rm -rf "$runners_dir"
    fi
}

# Setup function - create all mock runners once
setup_all_mock_runners() {
    cleanup_mock_runners  # Clean first
    create_mock_runner "rust" 0 0.1
    create_mock_runner "gleam" 0 0.1
    create_mock_runner "roc" 0 0.1
    create_mock_runner "carbon" 0 0.1
    create_mock_runner "bosque" 0 0.1
}

# Test 1: Initialize and cleanup test output directory
test_output_directory_management() {
    log_info "Test 1: Initialize and cleanup test output directory"

    # Test initialization
    set +e
    init_test_output_dir
    local init_exit=$?
    set -e
    assert_exit_code 0 "$init_exit" "Initialize test output directory"

    # Verify directory was created
    if [[ -d "$TEST_OUTPUT_DIR" ]]; then
        assert_true "true" "Test output directory exists"
    else
        assert_true "false" "Test output directory exists"
    fi

    # Test cleanup
    local temp_dir="$TEST_OUTPUT_DIR"
    cleanup_test_output_dir

    if [[ ! -d "$temp_dir" ]]; then
        assert_true "true" "Test output directory cleaned up"
    else
        assert_true "false" "Test output directory cleaned up"
    fi
}

# Test 2: Launch 5 background processes
test_launch_five_processes() {
    log_info "Test 2: Launch 5 background processes"

    # Create mock runners for all 5 languages (fast execution)
    setup_all_mock_runners

    # Create test input
    local test_input
    test_input=$(create_test_input)

    # Launch parallel tests
    set +e
    run_all_tests_parallel 1 "$test_input" 10
    local launch_exit=$?
    set -e
    assert_exit_code 0 "$launch_exit" "Launch parallel tests"

    # Verify 5 processes were launched
    local process_count=${#PROCESS_PIDS[@]}
    assert_equals "5" "$process_count" "5 processes launched"

    # Verify 5 languages were tracked
    local language_count=${#PROCESS_LANGUAGES[@]}
    assert_equals "5" "$language_count" "5 languages tracked"

    # Wait for completion
    wait_for_all_tests
    cleanup_test_output_dir
    rm -f "$test_input"
}

# Test 3: Wait for all processes to complete
test_wait_for_completion() {
    log_info "Test 3: Wait for all processes to complete"

    # Recreate mock runners with varied delays
    cleanup_mock_runners
    create_mock_runner "rust" 0 0.1
    create_mock_runner "gleam" 0 0.2
    create_mock_runner "roc" 0 0.3
    create_mock_runner "carbon" 0 0.1
    create_mock_runner "bosque" 0 0.2

    # Create test input
    local test_input
    test_input=$(create_test_input)

    # Launch and wait
    run_all_tests_parallel 1 "$test_input" 10

    set +e
    wait_for_all_tests
    local wait_exit=$?
    set -e
    assert_exit_code 0 "$wait_exit" "Wait for all processes to complete"

    # Verify exit codes were captured
    local exit_code_count=${#PROCESS_EXIT_CODES[@]}
    assert_equals "5" "$exit_code_count" "5 exit codes captured"

    # Cleanup
    cleanup_test_output_dir
    rm -f "$test_input"
}

# Test 4: Capture exit codes from each process
test_capture_exit_codes() {
    log_info "Test 4: Capture exit codes from each process"

    # Create mock runners with different exit codes
    cleanup_mock_runners
    create_mock_runner "rust" 0 0.1
    create_mock_runner "gleam" 1 0.1
    create_mock_runner "roc" 0 0.1
    create_mock_runner "carbon" 2 0.1
    create_mock_runner "bosque" 0 0.1

    # Create test input
    local test_input
    test_input=$(create_test_input)

    # Launch and wait
    run_all_tests_parallel 1 "$test_input" 10
    wait_for_all_tests

    # Verify specific exit codes
    local rust_exit
    rust_exit=$(get_exit_code_by_index 0)
    assert_equals "0" "$rust_exit" "Rust exit code is 0"

    local gleam_exit
    gleam_exit=$(get_exit_code_by_index 1)
    assert_equals "1" "$gleam_exit" "Gleam exit code is 1"

    local carbon_exit
    carbon_exit=$(get_exit_code_by_index 3)
    assert_equals "2" "$carbon_exit" "Carbon exit code is 2"

    # Verify not all passed
    set +e
    all_tests_passed
    local all_passed=$?
    set -e
    assert_exit_code 1 "$all_passed" "Not all tests passed (as expected)"

    # Verify failed count
    local failed_count
    failed_count=$(get_failed_count)
    assert_equals "2" "$failed_count" "2 tests failed"

    # Cleanup
    cleanup_test_output_dir
    rm -f "$test_input"
}

# Test 5: Timeout handling
test_timeout_enforcement() {
    log_info "Test 5: Timeout handling (short timeout)"

    # Create mock runners - one slow process
    cleanup_mock_runners
    create_mock_runner "rust" 0 0.1
    create_mock_runner "gleam" 0 0.1
    create_mock_runner "roc" 0 10  # This will timeout
    create_mock_runner "carbon" 0 0.1
    create_mock_runner "bosque" 0 0.1

    # Create test input
    local test_input
    test_input=$(create_test_input)

    # Launch with short timeout (2 seconds)
    run_all_tests_parallel 1 "$test_input" 2

    # Wait a bit longer to ensure timeout handler executes
    sleep 3
    wait_for_all_tests

    # Verify roc (index 2) timed out with exit code 124
    local roc_exit
    roc_exit=$(get_exit_code_by_index 2)
    assert_equals "124" "$roc_exit" "Roc test timed out (exit code 124)"

    # Verify error message mentions timeout
    local roc_stderr
    roc_stderr=$(get_language_stderr "roc")
    if echo "$roc_stderr" | grep -q "TIMEOUT"; then
        assert_true "true" "Timeout message in stderr"
    else
        assert_true "false" "Timeout message in stderr"
    fi

    # Cleanup
    cleanup_test_output_dir
    rm -f "$test_input"
}

# Test 6: No fail-fast behavior
test_no_fail_fast() {
    log_info "Test 6: No fail-fast behavior (all processes run despite failures)"

    # Create mock runners - first one fails
    cleanup_mock_runners
    create_mock_runner "rust" 1 0.1    # Fails
    create_mock_runner "gleam" 0 0.2
    create_mock_runner "roc" 0 0.3
    create_mock_runner "carbon" 0 0.4
    create_mock_runner "bosque" 0 0.5

    # Create test input
    local test_input
    test_input=$(create_test_input)

    # Launch and wait
    run_all_tests_parallel 1 "$test_input" 10
    wait_for_all_tests

    # Verify all 5 processes completed (not just the first one)
    local exit_code_count=${#PROCESS_EXIT_CODES[@]}
    assert_equals "5" "$exit_code_count" "All 5 processes completed despite first failure"

    # Verify the last process (bosque) also ran
    local bosque_exit
    bosque_exit=$(get_exit_code_by_index 4)
    assert_equals "0" "$bosque_exit" "Bosque test ran (no fail-fast)"

    # Cleanup
    cleanup_test_output_dir
    rm -f "$test_input"
}

# Test 7: Capture stdout from each language
test_capture_stdout() {
    log_info "Test 7: Capture stdout from each language"

    # Create mock runners
    setup_all_mock_runners

    # Create test input
    local test_input
    test_input=$(create_test_input)

    # Launch and wait
    run_all_tests_parallel 1 "$test_input" 10
    wait_for_all_tests

    # Verify stdout was captured for each language
    local rust_stdout
    rust_stdout=$(get_language_stdout "rust")
    if echo "$rust_stdout" | grep -q "part1"; then
        assert_true "true" "Rust stdout captured with JSON"
    else
        assert_true "false" "Rust stdout captured with JSON"
    fi

    local gleam_stdout
    gleam_stdout=$(get_language_stdout "gleam")
    if echo "$gleam_stdout" | grep -q "part2"; then
        assert_true "true" "Gleam stdout captured with JSON"
    else
        assert_true "false" "Gleam stdout captured with JSON"
    fi

    # Cleanup
    cleanup_test_output_dir
    rm -f "$test_input"
}

# Test 8: Single language test execution
test_single_language_execution() {
    log_info "Test 8: Single language test execution"

    # Create mock runner for rust
    cleanup_mock_runners
    create_mock_runner "rust" 0 0.1

    # Create test input
    local test_input
    test_input=$(create_test_input)

    # Initialize output directory manually for single test
    init_test_output_dir

    # Run single language test
    set +e
    local output
    output=$(run_language_test "rust" 1 "$test_input" 2>&1)
    local test_exit=$?
    set -e

    assert_exit_code 0 "$test_exit" "Single language test executed"

    # Verify output contains JSON
    if echo "$output" | grep -q "part1"; then
        assert_true "true" "Single test output contains JSON"
    else
        assert_true "false" "Single test output contains JSON"
    fi

    # Cleanup
    cleanup_test_output_dir
    rm -f "$test_input"
}

# Run all tests
main() {
    log_info "========================================"
    log_info "Running Parallel Execution Test Suite"
    log_info "========================================"
    echo

    test_output_directory_management
    echo
    test_launch_five_processes
    echo
    test_wait_for_completion
    echo
    test_capture_exit_codes
    echo
    test_timeout_enforcement
    echo
    test_no_fail_fast
    echo
    test_capture_stdout
    echo
    test_single_language_execution
    echo

    # Final cleanup
    cleanup_mock_runners

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
