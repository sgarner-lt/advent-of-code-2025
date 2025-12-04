#!/bin/bash

# Roc test runner for Advent of Code solutions
# Executes Roc unit tests and integration tests
# Unit test: roc test solution.roc
# Integration test: roc run solution.roc <input_path>

set -eo pipefail

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# shellcheck source=../common.sh
source "${SCRIPT_DIR}/../common.sh"

# Usage information
usage() {
    cat << EOF
Usage: $0 <day_number> <input_path> [--unit-test]

Run Roc solution for a specific Advent of Code day.

Arguments:
  day_number    Day number (1-25)
  input_path    Path to input file for integration test
  --unit-test   Run unit tests only (optional)

Examples:
  $0 1 challenges/day01/input.txt          # Run integration test
  $0 1 /dev/null --unit-test               # Run unit tests only

Exit codes:
  0  - Tests passed
  1  - Tests failed or error occurred
  2  - Missing arguments or invalid input

Note: This runner handles known Roc platform version issues gracefully.
EOF
}

# Parse arguments
DAY_NUMBER=""
INPUT_PATH=""
UNIT_TEST_ONLY=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h)
            usage
            exit 0
            ;;
        --unit-test)
            UNIT_TEST_ONLY=true
            shift
            ;;
        *)
            if [[ -z "$DAY_NUMBER" ]]; then
                DAY_NUMBER="$1"
            elif [[ -z "$INPUT_PATH" ]]; then
                INPUT_PATH="$1"
            else
                log_error "Unexpected argument: $1"
                usage
                exit 2
            fi
            shift
            ;;
    esac
done

# Validate arguments
if [[ -z "$DAY_NUMBER" ]]; then
    log_error "Missing required argument: day_number"
    usage
    exit 2
fi

if [[ -z "$INPUT_PATH" ]] && [[ "$UNIT_TEST_ONLY" == false ]]; then
    log_error "Missing required argument: input_path"
    usage
    exit 2
fi

# Validate day number format
if ! [[ "$DAY_NUMBER" =~ ^[0-9]+$ ]] || [[ "$DAY_NUMBER" -lt 1 ]] || [[ "$DAY_NUMBER" -gt 25 ]]; then
    log_error "Invalid day number: $DAY_NUMBER (must be 1-25)"
    exit 2
fi

# Format day with leading zero
DAY_FORMATTED=$(printf "day%02d" "$DAY_NUMBER")

# Determine Roc project directory
ROC_DIR="${PROJECT_ROOT}/roc/${DAY_FORMATTED}"

# Check if directory exists
if [[ ! -d "$ROC_DIR" ]]; then
    log_error "Roc implementation not found: $ROC_DIR"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Check for solution.roc file
if [[ ! -f "$ROC_DIR/solution.roc" ]]; then
    log_error "solution.roc not found in: $ROC_DIR"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Check if roc is available
ROC_BIN="${HOME}/.local/bin/roc"
if [[ ! -x "$ROC_BIN" ]]; then
    log_error "roc binary not found at: $ROC_BIN"
    log_error "Please ensure Roc is installed correctly"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Change to Roc project directory
cd "$ROC_DIR" || exit 1

# Run unit tests if requested
if [[ "$UNIT_TEST_ONLY" == true ]]; then
    log_info "Running Roc unit tests for $DAY_FORMATTED"

    set +e
    "$ROC_BIN" test solution.roc 2>&1
    local exit_code=$?
    set -e

    # Handle known platform version issues gracefully
    if [[ $exit_code -ne 0 ]]; then
        log_warn "Roc unit tests may have failed due to platform version issues"
    fi

    exit $exit_code
fi

# Run integration test (roc run with input file)
if [[ ! -f "$INPUT_PATH" ]]; then
    log_error "Input file not found: $INPUT_PATH"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

log_info "Running Roc integration test for $DAY_FORMATTED with input: $INPUT_PATH"

# Run roc and capture output
set +e
OUTPUT=$("$ROC_BIN" run solution.roc "$INPUT_PATH" 2>&1)
EXIT_CODE=$?
set -e

# Check for execution errors
if [[ $EXIT_CODE -ne 0 ]]; then
    log_error "Roc execution failed with exit code: $EXIT_CODE"
    # Check for platform version issues
    if echo "$OUTPUT" | grep -qi "platform.*version"; then
        log_warn "This may be due to known Roc platform version compatibility issues"
    fi
    # Print error to stderr for debugging
    echo "$OUTPUT" >&2
    # Output null JSON to stdout for consistency
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Extract JSON from output (should be on stdout)
# The solution should print JSON to stdout
echo "$OUTPUT"

exit 0
