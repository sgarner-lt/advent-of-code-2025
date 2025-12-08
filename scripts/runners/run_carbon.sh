#!/bin/bash

# Carbon test runner for Advent of Code solutions
#
# NOTE: Carbon is an experimental language. This runner builds and executes
# real Carbon code in a Docker/Podman container that includes the Carbon toolchain.
#
# The container build takes ~5 hours initially but is cached after the first build.

set -eo pipefail

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# shellcheck source=../common.sh
source "${SCRIPT_DIR}/../common.sh"

# Usage information
usage() {
    cat << EOF
Usage: $0 <day_number> <input_path>

Run Carbon solution for a specific Advent of Code day.

Arguments:
  day_number    Day number (1-25)
  input_path    Path to input file

Examples:
  $0 1 challenges/day01/input.txt          # Run with real input
  $0 1 challenges/day01/input-sample.txt   # Run with sample input

Exit codes:
  0  - Execution successful
  1  - Execution failed or error occurred
  2  - Missing arguments or invalid input

Requirements:
  - Docker or Podman must be installed
  - Carbon container must be built (carbon-aoc:day1)
  - 4GB+ RAM allocated to container runtime

Note: Carbon solutions are compiled and run inside a container using Bazel.
      The first build takes ~5 hours but subsequent builds are fast (~2-3 min).
EOF
}

# Parse arguments
DAY_NUMBER=""
INPUT_PATH=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h)
            usage
            exit 0
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

if [[ -z "$INPUT_PATH" ]]; then
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
CARBON_DIR="${PROJECT_ROOT}/solutions/carbon/${DAY_FORMATTED}"

# Check if directory exists
if [[ ! -d "$CARBON_DIR" ]]; then
    log_error "Carbon implementation not found: $CARBON_DIR"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Check if Carbon source file exists (look for .carbon files)
CARBON_SOURCE=$(find "$CARBON_DIR" -name "*.carbon" -type f | grep -v test | head -1)
if [[ -z "$CARBON_SOURCE" ]]; then
    log_error "No Carbon source file found in: $CARBON_DIR"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

CARBON_BASENAME=$(basename "$CARBON_SOURCE")

# Check if input file exists
if [[ ! -f "$INPUT_PATH" ]]; then
    log_error "Input file not found: $INPUT_PATH"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Convert paths to absolute
CARBON_DIR_ABS=$(cd "$CARBON_DIR" && pwd)
INPUT_DIR_ABS=$(cd "$(dirname "$INPUT_PATH")" && pwd)
INPUT_FILENAME=$(basename "$INPUT_PATH")

# Detect container runtime (podman or docker)
CONTAINER_CMD=""
if command -v podman &> /dev/null; then
    CONTAINER_CMD="podman"
elif command -v docker &> /dev/null; then
    CONTAINER_CMD="docker"
else
    log_error "Neither podman nor docker found - please install a container runtime"
    echo '{"part1": null, "part2": null}'
    exit 1
fi

# Check if container image exists
# Temporarily disable pipefail for this check (podman images may write to stderr)
set +o pipefail
if ! $CONTAINER_CMD images | grep -q "carbon-aoc"; then
    set -o pipefail
    log_error "Carbon container image not found: carbon-aoc:day1"
    log_error "Please build the container first:"
    log_error "  cd ${PROJECT_ROOT}/solutions/carbon"
    log_error "  $CONTAINER_CMD build -t carbon-aoc:day1 -f Dockerfile.minimal ."
    echo '{"part1": null, "part2": null}'
    exit 1
fi
set -o pipefail

log_info "Running Carbon solution for $DAY_FORMATTED with input: $INPUT_PATH" >&2
log_info "Using container runtime: $CONTAINER_CMD" >&2

# Run Carbon solution in container
# This command:
# 1. Mounts the Carbon source directory
# 2. Mounts the input directory
# 3. Copies source to Carbon repo inside container
# 4. Creates Bazel BUILD file
# 5. Compiles with Bazel
# 6. Runs the compiled binary
set +e
OUTPUT=$($CONTAINER_CMD run --rm \
  -v "$CARBON_DIR_ABS:/host:Z" \
  -v "$INPUT_DIR_ABS:/input:Z" \
  carbon-aoc:day1 bash -c "
    set -e
    mkdir -p /opt/carbon-lang/examples/aoc2025/$DAY_FORMATTED &&
    cp /host/$CARBON_BASENAME /opt/carbon-lang/examples/aoc2025/$DAY_FORMATTED/ &&
    cd /opt/carbon-lang/examples/aoc2025/$DAY_FORMATTED &&
    echo 'load(\"//bazel/carbon_rules:defs.bzl\", \"carbon_binary\")

carbon_binary(
    name = \"$DAY_FORMATTED\",
    srcs = [\"$CARBON_BASENAME\"],
)' > BUILD &&
    cd /opt/carbon-lang &&
    ./scripts/run_bazelisk.py build --jobs=2 --local_ram_resources=3500 //examples/aoc2025/$DAY_FORMATTED:$DAY_FORMATTED > /dev/null 2>&1 &&
    ./bazel-bin/examples/aoc2025/$DAY_FORMATTED/$DAY_FORMATTED < /input/$INPUT_FILENAME
" 2>&1)
EXIT_CODE=$?
set -e

# Check for execution errors
# Note: Carbon binaries currently exit with code 10 even on success
# This appears to be a Carbon runtime behavior, not an error
if [[ $EXIT_CODE -ne 0 ]] && [[ $EXIT_CODE -ne 10 ]]; then
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
