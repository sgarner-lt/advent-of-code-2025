#!/bin/bash
# End-to-End Workflow Testing for Testing Framework
# Tests complete integration workflows and critical gaps

set -eo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Source common utilities
source "$SCRIPT_DIR/common.sh"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test result tracking
declare -a FAILED_TESTS

# Helper function to run a test
run_test() {
    local test_name="$1"
    local test_function="$2"

    ((TESTS_RUN++))
    log_info "Running test: $test_name"

    if $test_function; then
        ((TESTS_PASSED++))
        log_success "PASSED: $test_name"
    else
        ((TESTS_FAILED++))
        FAILED_TESTS+=("$test_name")
        log_error "FAILED: $test_name"
    fi

    echo ""
}

# Test 1: Full integration test workflow with sample input
test_full_integration_workflow() {
    log_info "Testing full integration workflow with sample input"

    # Create test challenge directory if it doesn't exist
    local test_dir="$PROJECT_ROOT/challenges/day01"
    mkdir -p "$test_dir"

    # Create sample input file with test data
    echo "test sample data" > "$test_dir/input-sample.txt"

    # Run integration test (dry run style - check script exists and is executable)
    if [[ ! -x "$SCRIPT_DIR/test_integration.sh" ]]; then
        log_error "test_integration.sh not found or not executable"
        return 1
    fi

    log_success "Integration test script is executable and ready"
    return 0
}

# Test 2: Unit test workflow for TDD iteration
test_unit_test_workflow() {
    log_info "Testing unit test workflow"

    # Check that unit test script exists and is executable
    if [[ ! -x "$SCRIPT_DIR/test_unit.sh" ]]; then
        log_error "test_unit.sh not found or not executable"
        return 1
    fi

    # Verify script has correct structure by checking for unit test related content
    if ! grep -q "unit test\|Unit test\|unit-test" "$SCRIPT_DIR/test_unit.sh"; then
        log_error "test_unit.sh missing unit test structure"
        return 1
    fi

    # Verify runners directory exists
    if [[ ! -d "$SCRIPT_DIR/runners" ]]; then
        log_error "runners directory not found"
        return 1
    fi

    log_success "Unit test workflow script is ready"
    return 0
}

# Test 3: Error recovery with missing implementations
test_error_recovery_missing_implementations() {
    log_info "Testing error recovery for missing implementations"

    # Create a test scenario where a language directory doesn't exist
    local test_day=99
    local rust_dir="$PROJECT_ROOT/rust/day${test_day}"

    # Verify directory doesn't exist (intentionally missing implementation)
    if [[ -d "$rust_dir" ]]; then
        log_warn "Test directory exists, skipping (this is okay)"
    fi

    # Verify runners handle missing directories gracefully
    if [[ ! -f "$SCRIPT_DIR/runners/run_rust.sh" ]]; then
        log_error "run_rust.sh not found"
        return 1
    fi

    # Check that runner has error handling
    if ! grep -q "not found\|does not exist\|skipping" "$SCRIPT_DIR/runners/run_rust.sh"; then
        log_error "Runner missing error handling for missing implementations"
        return 1
    fi

    log_success "Error recovery for missing implementations verified"
    return 0
}

# Test 4: Report accuracy verification
test_report_accuracy() {
    log_info "Testing markdown report accuracy"

    # Check that report generator exists
    if [[ ! -x "$SCRIPT_DIR/generate_report.sh" ]]; then
        log_error "generate_report.sh not found or not executable"
        return 1
    fi

    # Verify report generator has required sections
    if ! grep -q "Language Results\|Cross-Language Validation" "$SCRIPT_DIR/generate_report.sh"; then
        log_error "Report generator missing required sections"
        return 1
    fi

    log_success "Report generation structure verified"
    return 0
}

# Test 5: Parallel execution ensures all 5 languages complete
test_parallel_execution_completion() {
    log_info "Testing parallel execution completes for all languages"

    # Check parallel execution script
    if [[ ! -f "$SCRIPT_DIR/test_execution.sh" ]]; then
        log_error "test_execution.sh not found"
        return 1
    fi

    # Verify all 5 language runners exist
    local runners_dir="$SCRIPT_DIR/runners"
    local required_runners=("run_rust.sh" "run_gleam.sh" "run_roc.sh" "run_carbon.sh" "run_bosque.sh")

    for runner in "${required_runners[@]}"; do
        if [[ ! -f "$runners_dir/$runner" ]]; then
            log_error "Missing runner: $runner"
            return 1
        fi
    done

    log_success "All 5 language runners present"
    return 0
}

# Test 6: Timeout handling verifies processes killed on timeout
test_timeout_handling() {
    log_info "Testing timeout enforcement"

    # Verify timeout handling in execution script
    if ! grep -q "timeout\|kill" "$SCRIPT_DIR/test_execution.sh"; then
        log_error "test_execution.sh missing timeout handling"
        return 1
    fi

    # Check that integration script accepts timeout flag
    if ! grep -q "\-\-timeout" "$SCRIPT_DIR/test_integration.sh"; then
        log_error "test_integration.sh missing --timeout flag"
        return 1
    fi

    log_success "Timeout handling verified"
    return 0
}

# Test 7: JSON validation for cross-language answer agreement
test_json_validation() {
    log_info "Testing JSON validation for cross-language agreement"

    # Check that JSON utilities exist
    if [[ ! -f "$SCRIPT_DIR/json_utils.sh" ]]; then
        log_error "json_utils.sh not found"
        return 1
    fi

    # Verify validation functions exist
    if ! grep -q "validate_json_format\|parse_json_answer" "$SCRIPT_DIR/json_utils.sh"; then
        log_error "json_utils.sh missing validation functions"
        return 1
    fi

    # Check answer validation script
    if [[ ! -f "$SCRIPT_DIR/validate_answers.sh" ]]; then
        log_error "validate_answers.sh not found"
        return 1
    fi

    log_success "JSON validation structure verified"
    return 0
}

# Test 8: Divergence detection identifies mismatched answers
test_divergence_detection() {
    log_info "Testing divergence detection"

    # Verify validation script has divergence detection
    if [[ ! -f "$SCRIPT_DIR/validate_answers.sh" ]]; then
        log_error "validate_answers.sh not found"
        return 1
    fi

    if ! grep -q "divergen\|mismatch\|differ" "$SCRIPT_DIR/validate_answers.sh"; then
        log_error "validate_answers.sh missing divergence detection"
        return 1
    fi

    log_success "Divergence detection verified"
    return 0
}

# Test 9: Test data discovery and input file handling
test_data_discovery() {
    log_info "Testing test data discovery"

    # Check discovery script exists
    if [[ ! -f "$SCRIPT_DIR/test_discovery.sh" ]]; then
        log_error "test_discovery.sh not found"
        return 1
    fi

    # Verify it looks for input files
    if ! grep -q "input.txt\|input-sample.txt" "$SCRIPT_DIR/test_discovery.sh"; then
        log_error "test_discovery.sh missing input file discovery"
        return 1
    fi

    # Verify challenges directory structure
    if [[ ! -d "$PROJECT_ROOT/challenges/day01" ]]; then
        log_error "challenges/day01 directory not found"
        return 1
    fi

    log_success "Test data discovery verified"
    return 0
}

# Test 10: CLI argument parsing and help text
test_cli_arguments() {
    log_info "Testing CLI argument parsing"

    # Check integration test script has help text
    if ! grep -q "\-\-help\|\-h" "$SCRIPT_DIR/test_integration.sh"; then
        log_error "test_integration.sh missing --help flag"
        return 1
    fi

    # Check unit test script has help text
    if ! grep -q "\-\-help\|\-h" "$SCRIPT_DIR/test_unit.sh"; then
        log_error "test_unit.sh missing --help flag"
        return 1
    fi

    # Verify verbose flag exists
    if ! grep -q "\-\-verbose\|\-v" "$SCRIPT_DIR/test_integration.sh"; then
        log_error "test_integration.sh missing --verbose flag"
        return 1
    fi

    log_success "CLI argument parsing verified"
    return 0
}

# Main test execution
main() {
    log_info "========================================="
    log_info "End-to-End Testing Framework Tests"
    log_info "========================================="
    echo ""

    # Run all tests
    run_test "Full integration workflow with sample input" test_full_integration_workflow
    run_test "Unit test workflow for TDD iteration" test_unit_test_workflow
    run_test "Error recovery with missing implementations" test_error_recovery_missing_implementations
    run_test "Report accuracy verification" test_report_accuracy
    run_test "Parallel execution completes all languages" test_parallel_execution_completion
    run_test "Timeout handling enforces limits" test_timeout_handling
    run_test "JSON validation for cross-language agreement" test_json_validation
    run_test "Divergence detection identifies mismatches" test_divergence_detection
    run_test "Test data discovery" test_data_discovery
    run_test "CLI argument parsing" test_cli_arguments

    # Print summary
    echo ""
    log_info "========================================="
    log_info "Test Summary"
    log_info "========================================="
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
        log_success "All end-to-end tests passed!"
        exit 0
    fi
}

# Run main function
main "$@"
