#!/bin/bash

# Carbon test runner for Advent of Code solutions
# Executes Carbon unit tests and integration tests via Bazel
# Unit test: bazel test //...
# Integration test: bazel run //:main -- <input_path>

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
  - Bazel build system must be installed
  - Carbon toolchain must be configured in Bazel workspace
  - BUILD.bazel file must exist in the day directory

Note: Carbon is an experimental language. Build requirements may change.
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

# Check for BUILD.bazel file
if [[ ! -f "$CARBON_DIR/BUILD.bazel" ]]; then
    log_error "BUILD.bazel not found in: $CARBON_DIR"
    log_error "Carbon projects require Bazel build configuration"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Check if bazel is available
if ! check_command_exists "bazel"; then
    log_error "bazel command not found - is Bazel installed?"
    log_error "Install via: brew install bazel"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Change to Carbon project directory
cd "$CARBON_DIR" || exit 1

# Run unit tests if requested
if [[ "$UNIT_TEST_ONLY" == true ]]; then
    log_info "Running Carbon unit tests for $DAY_FORMATTED"

    set +e
    bazel test //... 2>&1
    local exit_code=$?
    set -e

    exit $exit_code
fi

# Run integration test (bazel run with input file)
if [[ ! -f "$INPUT_PATH" ]]; then
    log_error "Input file not found: $INPUT_PATH"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

log_info "Running Carbon integration test for $DAY_FORMATTED with input: $INPUT_PATH"

# Convert input path to absolute path (Bazel needs this)
INPUT_PATH_ABS=$(cd "$(dirname "$INPUT_PATH")" && pwd)/$(basename "$INPUT_PATH")

# Run bazel and capture output
set +e
OUTPUT=$(bazel run //:main -- "$INPUT_PATH_ABS" 2>&1)
EXIT_CODE=$?
set -e

# Check for build/execution errors
if [[ $EXIT_CODE -ne 0 ]]; then
    log_error "Carbon execution failed with exit code: $EXIT_CODE"
    # Print error to stderr for debugging
    echo "$OUTPUT" >&2
    # Output null JSON to stdout for consistency
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Extract JSON from output (should be on stdout)
# Bazel output may include build messages, so we need to extract just the JSON
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
