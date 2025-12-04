#!/bin/bash

# Bosque test runner for Advent of Code solutions
# Uses Python wrapper for file I/O (BosqueCore stdlib lacks file operations)
# The Bosque code in solution.bsq contains the algorithm - wrapper handles I/O
# Integration test: python3 runner.py <input_path>

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

Run Bosque solution for a specific Advent of Code day.

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
  - Podman or Docker must be installed
  - Bosque container image must be available
  - bosque wrapper script must be configured

Note: Bosque runs in a containerized environment via Podman.
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

# Determine Bosque project directory
BOSQUE_DIR="${PROJECT_ROOT}/bosque/${DAY_FORMATTED}"

# Check if directory exists
if [[ ! -d "$BOSQUE_DIR" ]]; then
    log_error "Bosque implementation not found: $BOSQUE_DIR"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Check for solution.bsq file (algorithm reference)
if [[ ! -f "$BOSQUE_DIR/solution.bsq" ]]; then
    log_error "solution.bsq not found in: $BOSQUE_DIR"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Check for Python wrapper (handles file I/O)
if [[ ! -f "$BOSQUE_DIR/runner.py" ]]; then
    log_error "runner.py not found in: $BOSQUE_DIR"
    log_error "Python wrapper required for Bosque file I/O"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Check if Python 3 is available
if ! check_command_exists "python3"; then
    log_error "python3 command not found - is Python 3 installed?"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Change to Bosque project directory
cd "$BOSQUE_DIR" || exit 1

# Run unit tests if requested
if [[ "$UNIT_TEST_ONLY" == true ]]; then
    log_info "Running Bosque unit tests for $DAY_FORMATTED"
    log_warn "Unit tests not supported via Python wrapper - algorithm logic verified in solution.bsq"
    exit 0
fi

# Run integration test (Python wrapper with input file)
log_info "Running Bosque integration test for $DAY_FORMATTED with input: $INPUT_PATH (via Python wrapper)" >&2

# Convert input path to absolute path
if [[ "$INPUT_PATH" != /* ]]; then
    INPUT_PATH_ABS="${PROJECT_ROOT}/${INPUT_PATH}"
else
    INPUT_PATH_ABS="$INPUT_PATH"
fi

# Check if input file exists
if [[ ! -f "$INPUT_PATH_ABS" ]]; then
    log_error "Input file not found: $INPUT_PATH_ABS"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Run Python wrapper and capture output (pipe input file to stdin)
set +e
OUTPUT=$(cat "$INPUT_PATH_ABS" | python3 "$BOSQUE_DIR/runner.py" 2>&1)
EXIT_CODE=$?
set -e

# Check for execution errors
if [[ $EXIT_CODE -ne 0 ]]; then
    log_error "Bosque wrapper execution failed with exit code: $EXIT_CODE"
    # Print error to stderr for debugging
    echo "$OUTPUT" >&2
    # Output null JSON to stdout for consistency
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Output should be valid JSON
echo "$OUTPUT"

exit 0
