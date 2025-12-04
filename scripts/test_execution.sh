#!/bin/bash

# Test execution framework for parallel language test running
# This script provides functions to execute tests across all 5 languages in parallel
# Safe to source multiple times (idempotent)

# Prevent multiple sourcing
if [[ -n "${TEST_EXECUTION_SH_LOADED:-}" ]]; then
    return 0
fi
readonly TEST_EXECUTION_SH_LOADED=1

# Get script directory to source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=./common.sh
source "${SCRIPT_DIR}/common.sh"

# Default timeout in seconds
DEFAULT_TIMEOUT=60

# Temporary directory for process output
TEST_OUTPUT_DIR=""

# Arrays for tracking parallel execution (bash 3.2+ compatible)
# We'll use indexed arrays and maintain consistent ordering
PROCESS_PIDS=()
PROCESS_LANGUAGES=()
PROCESS_EXIT_CODES=()

# Initialize test output directory
# Usage: init_test_output_dir
init_test_output_dir() {
    TEST_OUTPUT_DIR=$(mktemp -d -t aoc-test-output.XXXXXX)
    if [[ ! -d "$TEST_OUTPUT_DIR" ]]; then
        log_error "Failed to create temporary output directory"
        return 1
    fi
    log_info "Test output directory: $TEST_OUTPUT_DIR"
    return 0
}

# Clean up test output directory
# Usage: cleanup_test_output_dir
cleanup_test_output_dir() {
    if [[ -n "$TEST_OUTPUT_DIR" ]] && [[ -d "$TEST_OUTPUT_DIR" ]]; then
        rm -rf "$TEST_OUTPUT_DIR"
        log_info "Cleaned up test output directory"
    fi
}

# Execute a single language test
# Usage: run_language_test <language> <day_number> <input_path>
# Returns: exit code from the language test runner
run_language_test() {
    local language="$1"
    local day_number="$2"
    local input_path="$3"

    if [[ -z "$language" ]] || [[ -z "$day_number" ]] || [[ -z "$input_path" ]]; then
        log_error "run_language_test: Missing required arguments"
        log_error "Usage: run_language_test <language> <day_number> <input_path>"
        return 1
    fi

    # Validate language
    case "$language" in
        rust|gleam|roc|carbon|bosque)
            ;;
        *)
            log_error "run_language_test: Invalid language '$language'"
            return 1
            ;;
    esac

    # Validate input file exists
    if [[ ! -f "$input_path" ]]; then
        log_error "run_language_test: Input file not found: $input_path"
        return 1
    fi

    log_info "Running $language test for day $day_number with input: $input_path"

    # Execute language-specific test runner
    # For now, this is a placeholder - actual runners will be in Task Group 3
    # We'll simulate execution here for testing the framework
    local runner_script="${SCRIPT_DIR}/runners/run_${language}.sh"

    if [[ -f "$runner_script" ]]; then
        # Call the actual runner
        bash "$runner_script" "$day_number" "$input_path"
        return $?
    else
        # Placeholder behavior for testing - simulate execution
        log_warn "Runner not found: $runner_script (using placeholder)"
        echo '{"part1": null, "part2": null}'
        return 0
    fi
}

# Launch all 5 languages in background processes
# Usage: run_all_tests_parallel <day_number> <input_path> [timeout_seconds]
# Sets: PROCESS_PIDS, PROCESS_LANGUAGES arrays
run_all_tests_parallel() {
    local day_number="$1"
    local input_path="$2"
    local timeout="${3:-$DEFAULT_TIMEOUT}"

    if [[ -z "$day_number" ]] || [[ -z "$input_path" ]]; then
        log_error "run_all_tests_parallel: Missing required arguments"
        log_error "Usage: run_all_tests_parallel <day_number> <input_path> [timeout_seconds]"
        return 1
    fi

    # Initialize output directory
    if ! init_test_output_dir; then
        return 1
    fi

    log_info "Launching parallel tests for day $day_number (timeout: ${timeout}s)"

    # Clear arrays
    PROCESS_PIDS=()
    PROCESS_LANGUAGES=()
    PROCESS_EXIT_CODES=()

    # Launch each language in background
    local languages=("rust" "gleam" "roc" "carbon" "bosque")

    for language in "${languages[@]}"; do
        local stdout_file="${TEST_OUTPUT_DIR}/${language}_stdout.txt"
        local stderr_file="${TEST_OUTPUT_DIR}/${language}_stderr.txt"
        local exit_code_file="${TEST_OUTPUT_DIR}/${language}_exit_code.txt"

        # Launch test in background, capturing stdout and stderr
        (
            # Run the test and capture its exit code
            set +e
            run_language_test "$language" "$day_number" "$input_path" \
                > "$stdout_file" 2> "$stderr_file"
            local test_exit=$?
            set -e

            # Write exit code and sync to ensure it's on disk
            echo "$test_exit" > "$exit_code_file"
            sync "$exit_code_file" 2>/dev/null || true
        ) &

        local pid=$!
        PROCESS_PIDS+=("$pid")
        PROCESS_LANGUAGES+=("$language")

        log_info "Started $language test (PID: $pid)"

        # Start timeout monitor in background
        kill_on_timeout "$pid" "$timeout" "$language" &
    done

    log_success "All 5 language tests launched in parallel"
    return 0
}

# Kill a process if it exceeds timeout
# Usage: kill_on_timeout <pid> <timeout_seconds> <language_name>
kill_on_timeout() {
    local pid="$1"
    local timeout="$2"
    local language="${3:-process}"

    if [[ -z "$pid" ]] || [[ -z "$timeout" ]]; then
        log_error "kill_on_timeout: Missing required arguments"
        return 1
    fi

    # Wait for timeout duration
    sleep "$timeout"

    # Check if process still exists
    if ps -p "$pid" > /dev/null 2>&1; then
        log_warn "Timeout exceeded for $language (PID: $pid) - killing process"
        kill -9 "$pid" 2>/dev/null || true

        # Write timeout indicator to exit code file
        if [[ -n "$TEST_OUTPUT_DIR" ]]; then
            echo "124" > "${TEST_OUTPUT_DIR}/${language}_exit_code.txt"
            echo "TIMEOUT: Test exceeded ${timeout} second limit" > "${TEST_OUTPUT_DIR}/${language}_stderr.txt"
            sync "${TEST_OUTPUT_DIR}/${language}_exit_code.txt" 2>/dev/null || true
        fi
    fi
}

# Wait for all background processes to complete
# Usage: wait_for_all_tests
# Sets: PROCESS_EXIT_CODES array with exit codes for each process
wait_for_all_tests() {
    if [[ ${#PROCESS_PIDS[@]} -eq 0 ]]; then
        log_error "wait_for_all_tests: No processes to wait for"
        return 1
    fi

    log_info "Waiting for all ${#PROCESS_PIDS[@]} test processes to complete..."

    # Wait for each process
    local index=0
    for pid in "${PROCESS_PIDS[@]}"; do
        local language="${PROCESS_LANGUAGES[$index]}"

        # Wait for process (ignore exit code as we read from file)
        wait "$pid" 2>/dev/null || true

        # Give a moment for file writes to complete
        sleep 0.1

        # Read exit code from file (handles timeout case)
        local exit_code_file="${TEST_OUTPUT_DIR}/${language}_exit_code.txt"

        # Try reading with retries (max 3 attempts)
        local attempts=0
        local max_attempts=3
        local exit_code=""

        while [[ $attempts -lt $max_attempts ]]; do
            if [[ -f "$exit_code_file" ]]; then
                exit_code=$(cat "$exit_code_file" 2>/dev/null || echo "")
                if [[ -n "$exit_code" ]]; then
                    break
                fi
            fi
            attempts=$((attempts + 1))
            sleep 0.1
        done

        if [[ -n "$exit_code" ]]; then
            PROCESS_EXIT_CODES+=("$exit_code")

            if [[ "$exit_code" -eq 0 ]]; then
                log_success "$language test completed successfully"
            elif [[ "$exit_code" -eq 124 ]]; then
                log_error "$language test timed out"
            else
                log_error "$language test failed with exit code: $exit_code"
            fi
        else
            log_error "$language test exit code not found"
            PROCESS_EXIT_CODES+=("1")
        fi

        index=$((index + 1))
    done

    log_success "All test processes completed"
    return 0
}

# Get stdout output for a language
# Usage: get_language_stdout <language>
get_language_stdout() {
    local language="$1"

    if [[ -z "$language" ]]; then
        log_error "get_language_stdout: No language specified"
        return 1
    fi

    local stdout_file="${TEST_OUTPUT_DIR}/${language}_stdout.txt"
    if [[ -f "$stdout_file" ]]; then
        cat "$stdout_file"
        return 0
    else
        log_error "get_language_stdout: Output file not found for $language"
        return 1
    fi
}

# Get stderr output for a language
# Usage: get_language_stderr <language>
get_language_stderr() {
    local language="$1"

    if [[ -z "$language" ]]; then
        log_error "get_language_stderr: No language specified"
        return 1
    fi

    local stderr_file="${TEST_OUTPUT_DIR}/${language}_stderr.txt"
    if [[ -f "$stderr_file" ]]; then
        cat "$stderr_file"
        return 0
    else
        log_error "get_language_stderr: Error file not found for $language"
        return 1
    fi
}

# Get exit code for a language by index
# Usage: get_exit_code_by_index <index>
get_exit_code_by_index() {
    local index="$1"

    if [[ -z "$index" ]]; then
        log_error "get_exit_code_by_index: No index specified"
        return 1
    fi

    if [[ "$index" -ge ${#PROCESS_EXIT_CODES[@]} ]]; then
        log_error "get_exit_code_by_index: Index out of bounds"
        return 1
    fi

    echo "${PROCESS_EXIT_CODES[$index]}"
    return 0
}

# Check if all tests passed
# Usage: all_tests_passed
# Returns: 0 if all exit codes are 0, 1 otherwise
all_tests_passed() {
    for exit_code in "${PROCESS_EXIT_CODES[@]}"; do
        if [[ "$exit_code" -ne 0 ]]; then
            return 1
        fi
    done
    return 0
}

# Get count of failed tests
# Usage: get_failed_count
get_failed_count() {
    local failed=0
    for exit_code in "${PROCESS_EXIT_CODES[@]}"; do
        if [[ "$exit_code" -ne 0 ]]; then
            failed=$((failed + 1))
        fi
    done
    echo "$failed"
}
