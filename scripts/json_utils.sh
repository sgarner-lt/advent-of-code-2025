#!/bin/bash

# JSON utility functions for parsing and validating Advent of Code solution output
# This script provides reusable functions for handling JSON output from language implementations
# Safe to source multiple times (idempotent)

# Prevent multiple sourcing
if [[ -n "${JSON_UTILS_SH_LOADED:-}" ]]; then
    return 0
fi
readonly JSON_UTILS_SH_LOADED=1

# Get script directory to source common.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "${SCRIPT_DIR}/common.sh"

# Parse JSON answer from solution output
# Usage: parse_json_answer "json_string" "part_number"
# Returns: the answer value for the specified part, or empty string on error
# Example: parse_json_answer '{"part1": 123, "part2": 456}' "part1" -> "123"
parse_json_answer() {
    local json_string="$1"
    local part_number="$2"

    if [[ -z "$json_string" ]]; then
        log_error "parse_json_answer: No JSON string provided"
        return 1
    fi

    if [[ -z "$part_number" ]]; then
        log_error "parse_json_answer: No part number specified (expected 'part1' or 'part2')"
        return 1
    fi

    if [[ "$part_number" != "part1" && "$part_number" != "part2" ]]; then
        log_error "parse_json_answer: Invalid part number '$part_number' (must be 'part1' or 'part2')"
        return 1
    fi

    # Use Python to parse JSON (available on macOS by default)
    local answer
    answer=$(echo "$json_string" | python3 -c "
import sys
import json
try:
    data = json.load(sys.stdin)
    value = data.get('$part_number')
    if value is None:
        print('null')
    else:
        print(value)
except (json.JSONDecodeError, KeyError) as e:
    sys.exit(1)
" 2>/dev/null)

    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        log_error "parse_json_answer: Failed to parse JSON or missing key '$part_number'"
        return 1
    fi

    echo "$answer"
    return 0
}

# Validate JSON format matches expected contract
# Usage: validate_json_format "json_string"
# Returns: 0 if valid format, 1 otherwise
# Expected format: {"part1": <value>, "part2": <value>}
validate_json_format() {
    local json_string="$1"

    if [[ -z "$json_string" ]]; then
        log_error "validate_json_format: No JSON string provided"
        return 1
    fi

    # Use Python to validate JSON structure
    local validation_result
    validation_result=$(echo "$json_string" | python3 -c "
import sys
import json
try:
    data = json.load(sys.stdin)

    # Check if it's a dictionary/object
    if not isinstance(data, dict):
        print('ERROR: JSON must be an object')
        sys.exit(1)

    # Check for required keys
    if 'part1' not in data:
        print('ERROR: Missing required key: part1')
        sys.exit(1)

    if 'part2' not in data:
        print('ERROR: Missing required key: part2')
        sys.exit(1)

    # Check value types (int, str, or null)
    for key in ['part1', 'part2']:
        value = data[key]
        if value is not None and not isinstance(value, (int, str)):
            print(f'ERROR: Invalid type for {key}: {type(value).__name__}')
            sys.exit(1)

    print('VALID')
    sys.exit(0)

except json.JSONDecodeError as e:
    print(f'ERROR: Invalid JSON syntax: {e}')
    sys.exit(1)
except Exception as e:
    print(f'ERROR: Validation failed: {e}')
    sys.exit(1)
" 2>&1)

    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        log_error "validate_json_format: $validation_result"
        return 1
    fi

    return 0
}

# Check if JSON is malformed
# Usage: is_json_malformed "json_string"
# Returns: 0 if malformed, 1 if valid JSON
is_json_malformed() {
    local json_string="$1"

    if [[ -z "$json_string" ]]; then
        return 0  # Empty string is malformed
    fi

    # Use Python to detect JSON parsing errors
    echo "$json_string" | python3 -c "
import sys
import json
try:
    json.load(sys.stdin)
    sys.exit(1)  # Valid JSON
except json.JSONDecodeError:
    sys.exit(0)  # Malformed JSON
except Exception:
    sys.exit(0)  # Any other error means malformed
" 2>/dev/null

    return $?
}

# Extract both parts from JSON output
# Usage: extract_both_parts "json_string"
# Prints: "part1_value part2_value" or returns error
extract_both_parts() {
    local json_string="$1"

    if [[ -z "$json_string" ]]; then
        log_error "extract_both_parts: No JSON string provided"
        return 1
    fi

    local part1
    local part2

    part1=$(parse_json_answer "$json_string" "part1")
    local part1_exit=$?

    part2=$(parse_json_answer "$json_string" "part2")
    local part2_exit=$?

    if [[ $part1_exit -ne 0 ]] || [[ $part2_exit -ne 0 ]]; then
        return 1
    fi

    echo "$part1 $part2"
    return 0
}
