#!/bin/bash

# Test data discovery functions for Advent of Code challenges
# This script provides functions to locate and validate test input files
# Safe to source multiple times (idempotent)

# Prevent multiple sourcing
if [[ -n "${TEST_DISCOVERY_SH_LOADED:-}" ]]; then
    return 0
fi
readonly TEST_DISCOVERY_SH_LOADED=1

# Get script directory to source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Allow PROJECT_ROOT to be set externally for testing, otherwise compute it
if [[ -z "${PROJECT_ROOT:-}" ]]; then
    PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
fi

# shellcheck source=./common.sh
source "${SCRIPT_DIR}/common.sh"

# Input file types
readonly INPUT_TYPE_REAL="input.txt"
readonly INPUT_TYPE_SAMPLE="input-sample.txt"

# Discover test input files for a given day
# Usage: discover_test_inputs <day_number>
# Returns: 0 if at least one input file found, 1 otherwise
# Prints: List of discovered input files (one per line)
discover_test_inputs() {
    local day_number="$1"

    if [[ -z "$day_number" ]]; then
        log_error "discover_test_inputs: No day number specified"
        return 1
    fi

    # Format day number with leading zero (e.g., 01, 02, ..., 25)
    local day_padded
    day_padded=$(printf "%02d" "$day_number")

    local challenges_dir="${PROJECT_ROOT}/challenges/day${day_padded}"

    if [[ ! -d "$challenges_dir" ]]; then
        log_error "discover_test_inputs: Challenge directory not found: $challenges_dir"
        return 1
    fi

    local found_files=()

    # Check for real puzzle input
    local real_input="${challenges_dir}/${INPUT_TYPE_REAL}"
    if [[ -f "$real_input" ]]; then
        found_files+=("$real_input")
    fi

    # Check for sample puzzle input
    local sample_input="${challenges_dir}/${INPUT_TYPE_SAMPLE}"
    if [[ -f "$sample_input" ]]; then
        found_files+=("$sample_input")
    fi

    if [[ ${#found_files[@]} -eq 0 ]]; then
        log_error "discover_test_inputs: No input files found in $challenges_dir"
        return 1
    fi

    # Print discovered files
    for file in "${found_files[@]}"; do
        echo "$file"
    done

    return 0
}

# Get path to a specific input file
# Usage: get_input_path <day_number> <input_type>
# Returns: 0 if file exists, 1 otherwise
# Prints: Full path to the input file
get_input_path() {
    local day_number="$1"
    local input_type="$2"

    if [[ -z "$day_number" ]]; then
        log_error "get_input_path: No day number specified"
        return 1
    fi

    if [[ -z "$input_type" ]]; then
        log_error "get_input_path: No input type specified (expected 'real' or 'sample')"
        return 1
    fi

    # Validate input type
    local input_filename
    case "$input_type" in
        real)
            input_filename="$INPUT_TYPE_REAL"
            ;;
        sample)
            input_filename="$INPUT_TYPE_SAMPLE"
            ;;
        *)
            log_error "get_input_path: Invalid input type '$input_type' (must be 'real' or 'sample')"
            return 1
            ;;
    esac

    # Format day number with leading zero
    local day_padded
    day_padded=$(printf "%02d" "$day_number")

    local input_path="${PROJECT_ROOT}/challenges/day${day_padded}/${input_filename}"

    if [[ ! -f "$input_path" ]]; then
        log_error "get_input_path: Input file not found: $input_path"
        return 1
    fi

    echo "$input_path"
    return 0
}

# Validate that an input file exists
# Usage: validate_input_exists <input_path>
# Returns: 0 if file exists and is readable, 1 otherwise
validate_input_exists() {
    local input_path="$1"

    if [[ -z "$input_path" ]]; then
        log_error "validate_input_exists: No input path specified"
        return 1
    fi

    if [[ ! -e "$input_path" ]]; then
        log_error "validate_input_exists: File does not exist: $input_path"
        return 1
    fi

    if [[ ! -f "$input_path" ]]; then
        log_error "validate_input_exists: Path is not a regular file: $input_path"
        return 1
    fi

    if [[ ! -r "$input_path" ]]; then
        log_error "validate_input_exists: File is not readable: $input_path"
        return 1
    fi

    return 0
}

# Check if challenges directory exists for a given day
# Usage: day_exists <day_number>
# Returns: 0 if directory exists, 1 otherwise
day_exists() {
    local day_number="$1"

    if [[ -z "$day_number" ]]; then
        log_error "day_exists: No day number specified"
        return 1
    fi

    local day_padded
    day_padded=$(printf "%02d" "$day_number")

    local challenges_dir="${PROJECT_ROOT}/challenges/day${day_padded}"

    if [[ -d "$challenges_dir" ]]; then
        return 0
    else
        return 1
    fi
}

# Get the challenges directory path for a given day
# Usage: get_challenges_dir <day_number>
# Prints: Full path to the challenges directory
get_challenges_dir() {
    local day_number="$1"

    if [[ -z "$day_number" ]]; then
        log_error "get_challenges_dir: No day number specified"
        return 1
    fi

    local day_padded
    day_padded=$(printf "%02d" "$day_number")

    echo "${PROJECT_ROOT}/challenges/day${day_padded}"
    return 0
}
