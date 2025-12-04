#!/bin/bash

# Roc test runner for Advent of Code solutions
# Executes Roc unit tests and integration tests via Podman
# Unit test: podman run ... roc test <file>
# Integration test: podman run ... roc run <file> <input_path>
# Note: Uses roclang/nightly-ubuntu-latest Docker image

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

Requirements:
  - Podman must be installed and available in PATH
  - Docker image: roclang/nightly-ubuntu-latest
  - Input files must be under the project root directory

Note: This runner executes Roc via Podman to ensure platform compatibility.
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

# Check for solution file (try both naming conventions)
ROC_FILE=""
if [[ -f "$ROC_DIR/solution.roc" ]]; then
    ROC_FILE="solution.roc"
elif [[ -f "$ROC_DIR/${DAY_FORMATTED}.roc" ]]; then
    ROC_FILE="${DAY_FORMATTED}.roc"
else
    log_error "No Roc file found in: $ROC_DIR (tried solution.roc and ${DAY_FORMATTED}.roc)"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Check if Podman is available
if ! command -v podman &> /dev/null; then
    log_error "podman command not found"
    log_error "Please ensure Podman is installed correctly"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Change to Roc project directory
cd "$ROC_DIR" || exit 1

# Run unit tests if requested
if [[ "$UNIT_TEST_ONLY" == true ]]; then
    log_info "Running Roc unit tests for $DAY_FORMATTED via Podman"

    set +e
    podman run --rm \
        -v "${PROJECT_ROOT}:/workspace" \
        -w "/workspace/roc/${DAY_FORMATTED}" \
        roclang/nightly-ubuntu-latest \
        roc test "$ROC_FILE" 2>&1
    exit_code=$?
    set -e

    # Handle known platform version issues gracefully
    if [[ $exit_code -ne 0 ]]; then
        log_warn "Roc unit tests may have failed due to platform version issues"
    fi

    exit $exit_code
fi

# Run integration test (roc run with input file)
# Convert relative input path to absolute if needed
if [[ "$INPUT_PATH" != /* ]]; then
    # Relative path, convert to absolute from project root
    INPUT_PATH="${PROJECT_ROOT}/${INPUT_PATH}"
fi

if [[ ! -f "$INPUT_PATH" ]]; then
    log_error "Input file not found: $INPUT_PATH"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Convert input path to relative path from project root for container
RELATIVE_INPUT_PATH="${INPUT_PATH#${PROJECT_ROOT}/}"
if [[ "$RELATIVE_INPUT_PATH" == "$INPUT_PATH" ]]; then
    # Input path is not under project root, this won't work with container
    log_error "Input path must be under project root: $PROJECT_ROOT"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

log_info "Running Roc integration test for $DAY_FORMATTED with input: $INPUT_PATH via Podman"

# Run roc via Podman and capture output
set +e
OUTPUT=$(podman run --rm \
    -v "${PROJECT_ROOT}:/workspace" \
    -w "/workspace/roc/${DAY_FORMATTED}" \
    roclang/nightly-ubuntu-latest \
    roc run "$ROC_FILE" -- "/workspace/${RELATIVE_INPUT_PATH}" 2>&1)
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
