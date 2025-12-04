#!/bin/bash

# Rust test runner for Advent of Code solutions
# Executes Rust unit tests and integration tests
# Unit test: cargo test
# Integration test: cat <input_path> | cargo run

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

Run Rust solution for a specific Advent of Code day.

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

# Determine Rust project directory
RUST_DIR="${PROJECT_ROOT}/rust/${DAY_FORMATTED}"

# Check if directory exists
if [[ ! -d "$RUST_DIR" ]]; then
    log_error "Rust implementation not found: $RUST_DIR"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Check for Cargo.toml
if [[ ! -f "$RUST_DIR/Cargo.toml" ]]; then
    log_error "Cargo.toml not found in: $RUST_DIR"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Check if cargo is available
if ! check_command_exists "cargo"; then
    log_error "cargo command not found - is Rust installed?"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Convert input path to absolute before changing directories
if [[ "$UNIT_TEST_ONLY" == false ]] && [[ -n "$INPUT_PATH" ]]; then
    # Convert relative path to absolute if needed
    if [[ "$INPUT_PATH" != /* ]]; then
        INPUT_PATH="${PROJECT_ROOT}/${INPUT_PATH}"
    fi
fi

# Change to Rust project directory
cd "$RUST_DIR" || exit 1

# Run unit tests if requested
if [[ "$UNIT_TEST_ONLY" == true ]]; then
    log_info "Running Rust unit tests for $DAY_FORMATTED"

    set +e
    cargo test 2>&1
    local exit_code=$?
    set -e

    exit $exit_code
fi

# Run integration test (cargo run with input file)
if [[ ! -f "$INPUT_PATH" ]]; then
    log_error "Input file not found: $INPUT_PATH"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

log_info "Running Rust integration test for $DAY_FORMATTED with input: $INPUT_PATH" >&2

# Run cargo and capture output (pipe input file to stdin)
set +e
OUTPUT=$(cat "$INPUT_PATH" | cargo run --quiet 2>&1)
EXIT_CODE=$?
set -e

# Check for compilation errors
if [[ $EXIT_CODE -ne 0 ]]; then
    log_error "Rust execution failed with exit code: $EXIT_CODE"
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
