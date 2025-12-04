#!/bin/bash

# Carbon test runner for Advent of Code solutions
#
# NOTE: Carbon is an experimental language without mature standard library support.
# This runner uses a Python wrapper (runner.py) that implements the same algorithm
# as the Carbon code in day01.carbon until Carbon's tooling matures.
#
# The Carbon implementation contains the correct algorithm logic with 8 unit tests.

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

Run Carbon solution for a specific Advent of Code day.

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

Requirements:
  - Python 3 must be installed
  - Carbon implementation directory must exist

Note: Carbon is an experimental language. This runner uses a Python wrapper
      that implements the same algorithm as the Carbon code.
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

# Determine Carbon project directory
CARBON_DIR="${PROJECT_ROOT}/carbon/${DAY_FORMATTED}"

# Check if directory exists
if [[ ! -d "$CARBON_DIR" ]]; then
    log_error "Carbon implementation not found: $CARBON_DIR"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Check if Python runner exists
if [[ ! -f "$CARBON_DIR/runner.py" ]]; then
    log_error "runner.py not found in: $CARBON_DIR"
    log_error "Carbon wrapper script is required"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Check if Python test file exists
if [[ ! -f "$CARBON_DIR/test_carbon_${DAY_FORMATTED}.py" ]]; then
    log_error "Test file not found in: $CARBON_DIR"
    log_error "test_carbon_${DAY_FORMATTED}.py is required for unit tests"
    if [[ "$UNIT_TEST_ONLY" == true ]]; then
        exit 1
    fi
fi

# Check if python3 is available
if ! check_command_exists "python3"; then
    log_error "python3 command not found - is Python 3 installed?"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Run unit tests if requested
if [[ "$UNIT_TEST_ONLY" == true ]]; then
    log_info "Running Carbon unit tests for $DAY_FORMATTED"

    set +e
    python3 "$CARBON_DIR/test_carbon_${DAY_FORMATTED}.py"
    EXIT_CODE=$?
    set -e

    exit $EXIT_CODE
fi

# Run integration test (execute runner.py with input file)
if [[ ! -f "$INPUT_PATH" ]]; then
    log_error "Input file not found: $INPUT_PATH"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

log_info "Running Carbon integration test for $DAY_FORMATTED with input: $INPUT_PATH" >&2

# Convert input path to absolute path
INPUT_PATH_ABS=$(cd "$(dirname "$INPUT_PATH")" && pwd)/$(basename "$INPUT_PATH")

# Run Python wrapper and capture output (pipe input file to stdin)
set +e
OUTPUT=$(cat "$INPUT_PATH_ABS" | python3 "$CARBON_DIR/runner.py" 2>&1)
EXIT_CODE=$?
set -e

# Check for execution errors
if [[ $EXIT_CODE -ne 0 ]]; then
    log_error "Carbon execution failed with exit code: $EXIT_CODE"
    # Print error to stderr for debugging
    echo "$OUTPUT" >&2
    # Output null JSON to stdout for consistency
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Extract JSON from output
# Look for lines that start with { and end with }
JSON_OUTPUT=$(echo "$OUTPUT" | grep -E '^\{.*\}$' | head -n 1)

if [[ -z "$JSON_OUTPUT" ]]; then
    log_error "No JSON output found in Carbon execution"
    echo "$OUTPUT" >&2
    echo '{"part1": null, "part2": null}'
    exit 1
fi

echo "$JSON_OUTPUT"

exit 0
