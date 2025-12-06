#!/bin/bash

# Cross-language answer validation for Advent of Code solutions
# This script provides functions to compare JSON outputs across all 4 languages
# Safe to source multiple times (idempotent)

# Prevent multiple sourcing
if [[ -n "${VALIDATE_ANSWERS_SH_LOADED:-}" ]]; then
    return 0
fi
readonly VALIDATE_ANSWERS_SH_LOADED=1

# Get script directory to source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=./common.sh
source "${SCRIPT_DIR}/common.sh"
# shellcheck source=./json_utils.sh
source "${SCRIPT_DIR}/json_utils.sh"

# Validation result tracking (bash 3.2+ compatible - using indexed arrays)
VALIDATION_LANGUAGES=()
VALIDATION_PART1_VALUES=()
VALIDATION_PART2_VALUES=()
VALIDATION_EXIT_CODES=()
VALIDATION_ERRORS=()

# Initialize validation tracking arrays
# Usage: init_validation_tracking
init_validation_tracking() {
    VALIDATION_LANGUAGES=()
    VALIDATION_PART1_VALUES=()
    VALIDATION_PART2_VALUES=()
    VALIDATION_EXIT_CODES=()
    VALIDATION_ERRORS=()
}

# Store validation result for a language
# Usage: store_validation_result <language> <part1_value> <part2_value> <exit_code> <error_message>
store_validation_result() {
    local language="$1"
    local part1_value="$2"
    local part2_value="$3"
    local exit_code="$4"
    local error_message="${5:-}"

    VALIDATION_LANGUAGES+=("$language")
    VALIDATION_PART1_VALUES+=("$part1_value")
    VALIDATION_PART2_VALUES+=("$part2_value")
    VALIDATION_EXIT_CODES+=("$exit_code")
    VALIDATION_ERRORS+=("$error_message")
}

# Compare all answers across languages
# Usage: compare_all_answers <test_output_dir>
# Expects: TEST_OUTPUT_DIR from test_execution.sh with JSON outputs
# Returns: 0 if comparison successful, 1 on error
compare_all_answers() {
    local output_dir="$1"

    if [[ -z "$output_dir" ]]; then
        log_error "compare_all_answers: No output directory specified"
        return 1
    fi

    if [[ ! -d "$output_dir" ]]; then
        log_error "compare_all_answers: Output directory not found: $output_dir"
        return 1
    fi

    # Initialize tracking
    init_validation_tracking

    # Process each language
    local languages=("rust" "gleam" "carbon" "bosque")

    for language in "${languages[@]}"; do
        local stdout_file="${output_dir}/${language}_stdout.txt"
        local stderr_file="${output_dir}/${language}_stderr.txt"
        local exit_code_file="${output_dir}/${language}_exit_code.txt"

        # Read exit code
        local exit_code=1
        if [[ -f "$exit_code_file" ]]; then
            exit_code=$(cat "$exit_code_file" 2>/dev/null || echo "1")
        fi

        # Check if test failed
        if [[ "$exit_code" -ne 0 ]]; then
            local error_msg="not implemented"

            if [[ "$exit_code" -eq 124 ]]; then
                error_msg="timeout"
            elif [[ -f "$stderr_file" ]]; then
                local stderr_content
                stderr_content=$(head -n 5 "$stderr_file" 2>/dev/null || echo "")
                if [[ -n "$stderr_content" ]]; then
                    error_msg="error: $stderr_content"
                fi
            fi

            store_validation_result "$language" "ERROR" "ERROR" "$exit_code" "$error_msg"
            continue
        fi

        # Read stdout JSON
        if [[ ! -f "$stdout_file" ]]; then
            store_validation_result "$language" "ERROR" "ERROR" "$exit_code" "no output file"
            continue
        fi

        local json_output
        json_output=$(cat "$stdout_file" 2>/dev/null || echo "")

        if [[ -z "$json_output" ]]; then
            store_validation_result "$language" "ERROR" "ERROR" "$exit_code" "empty output"
            continue
        fi

        # Validate JSON format
        if ! validate_json_format "$json_output" 2>/dev/null; then
            store_validation_result "$language" "ERROR" "ERROR" "$exit_code" "malformed JSON"
            continue
        fi

        # Parse part1 and part2
        local part1_value
        local part2_value

        set +e
        part1_value=$(parse_json_answer "$json_output" "part1" 2>/dev/null)
        local part1_exit=$?
        part2_value=$(parse_json_answer "$json_output" "part2" 2>/dev/null)
        local part2_exit=$?
        set -e

        if [[ $part1_exit -ne 0 ]]; then
            part1_value="ERROR"
        fi

        if [[ $part2_exit -ne 0 ]]; then
            part2_value="ERROR"
        fi

        store_validation_result "$language" "$part1_value" "$part2_value" "$exit_code" ""
    done

    return 0
}

# Check which languages agree on a specific part
# Usage: check_part_agreement <part_number>
# Returns: 0 if at least 2 languages agree, 1 otherwise
# Prints: Comma-separated list of agreeing languages and their value
check_part_agreement() {
    local part_number="$1"

    if [[ -z "$part_number" ]]; then
        log_error "check_part_agreement: No part number specified"
        return 1
    fi

    if [[ "$part_number" != "part1" && "$part_number" != "part2" ]]; then
        log_error "check_part_agreement: Invalid part number '$part_number'"
        return 1
    fi

    # Select the appropriate values array
    local -a values_array
    if [[ "$part_number" == "part1" ]]; then
        values_array=("${VALIDATION_PART1_VALUES[@]}")
    else
        values_array=("${VALIDATION_PART2_VALUES[@]}")
    fi

    # Build a map of value -> languages (using string concatenation for bash 3.2)
    # We'll use a simple approach: collect all non-error, non-null values
    local -a unique_values=()
    local -a value_languages=()

    for i in "${!VALIDATION_LANGUAGES[@]}"; do
        local language="${VALIDATION_LANGUAGES[$i]}"
        local value="${values_array[$i]}"

        # Skip errors and null values
        if [[ "$value" == "ERROR" ]] || [[ "$value" == "null" ]]; then
            continue
        fi

        # Check if this value already exists in unique_values
        local found=0
        local found_index=0
        for j in "${!unique_values[@]}"; do
            if [[ "${unique_values[$j]}" == "$value" ]]; then
                found=1
                found_index=$j
                break
            fi
        done

        if [[ $found -eq 1 ]]; then
            # Append language to existing value
            value_languages[$found_index]="${value_languages[$found_index]},$language"
        else
            # Add new unique value
            unique_values+=("$value")
            value_languages+=("$language")
        fi
    done

    # Find agreements (2+ languages with same value)
    local found_agreement=0
    for i in "${!unique_values[@]}"; do
        local langs="${value_languages[$i]}"
        local lang_count
        lang_count=$(echo "$langs" | tr ',' '\n' | wc -l | tr -d ' ')

        if [[ $lang_count -ge 2 ]]; then
            echo "${unique_values[$i]}:${langs}"
            found_agreement=1
        fi
    done

    if [[ $found_agreement -eq 0 ]]; then
        return 1
    fi

    return 0
}

# Find divergences in answers for a specific part
# Usage: find_divergences <part_number>
# Returns: 0 if divergences found, 1 if all agree or no valid answers
# Prints: List of "language:value" pairs that diverge
find_divergences() {
    local part_number="$1"

    if [[ -z "$part_number" ]]; then
        log_error "find_divergences: No part number specified"
        return 1
    fi

    if [[ "$part_number" != "part1" && "$part_number" != "part2" ]]; then
        log_error "find_divergences: Invalid part number '$part_number'"
        return 1
    fi

    # Select the appropriate values array
    local -a values_array
    if [[ "$part_number" == "part1" ]]; then
        values_array=("${VALIDATION_PART1_VALUES[@]}")
    else
        values_array=("${VALIDATION_PART2_VALUES[@]}")
    fi

    # Collect all non-error, non-null values
    local -a all_values=()
    local -a all_languages=()

    for i in "${!VALIDATION_LANGUAGES[@]}"; do
        local language="${VALIDATION_LANGUAGES[$i]}"
        local value="${values_array[$i]}"

        # Skip errors and null values
        if [[ "$value" == "ERROR" ]] || [[ "$value" == "null" ]]; then
            continue
        fi

        all_values+=("$value")
        all_languages+=("$language")
    done

    # If fewer than 2 valid answers, no divergence analysis possible
    if [[ ${#all_values[@]} -lt 2 ]]; then
        return 1
    fi

    # Check if all values are the same
    local first_value="${all_values[0]}"
    local has_divergence=0

    for value in "${all_values[@]}"; do
        if [[ "$value" != "$first_value" ]]; then
            has_divergence=1
            break
        fi
    done

    if [[ $has_divergence -eq 0 ]]; then
        return 1  # No divergence, all agree
    fi

    # Print divergent values
    for i in "${!all_languages[@]}"; do
        echo "${all_languages[$i]}:${all_values[$i]}"
    done

    return 0
}

# Handle null values in validation
# Usage: handle_null_values <part_number>
# Returns: 0 if any null values found, 1 otherwise
# Prints: List of languages with null values (not yet implemented)
handle_null_values() {
    local part_number="$1"

    if [[ -z "$part_number" ]]; then
        log_error "handle_null_values: No part number specified"
        return 1
    fi

    if [[ "$part_number" != "part1" && "$part_number" != "part2" ]]; then
        log_error "handle_null_values: Invalid part number '$part_number'"
        return 1
    fi

    # Select the appropriate values array
    local -a values_array
    if [[ "$part_number" == "part1" ]]; then
        values_array=("${VALIDATION_PART1_VALUES[@]}")
    else
        values_array=("${VALIDATION_PART2_VALUES[@]}")
    fi

    # Find languages with null values
    local found_null=0
    for i in "${!VALIDATION_LANGUAGES[@]}"; do
        local language="${VALIDATION_LANGUAGES[$i]}"
        local value="${values_array[$i]}"

        if [[ "$value" == "null" ]]; then
            echo "$language"
            found_null=1
        fi
    done

    if [[ $found_null -eq 0 ]]; then
        return 1
    fi

    return 0
}

# Get languages that failed to run
# Usage: get_failed_languages
# Returns: 0 if any failures found, 1 otherwise
# Prints: List of "language:error_message" pairs
get_failed_languages() {
    local found_failures=0

    for i in "${!VALIDATION_LANGUAGES[@]}"; do
        local language="${VALIDATION_LANGUAGES[$i]}"
        local exit_code="${VALIDATION_EXIT_CODES[$i]}"
        local error_msg="${VALIDATION_ERRORS[$i]}"

        if [[ "$exit_code" -ne 0 ]]; then
            echo "${language}:${error_msg}"
            found_failures=1
        fi
    done

    if [[ $found_failures -eq 0 ]]; then
        return 1
    fi

    return 0
}

# Get count of languages with valid answers for a part
# Usage: get_valid_answer_count <part_number>
# Prints: Count of languages with non-error, non-null answers
get_valid_answer_count() {
    local part_number="$1"

    if [[ -z "$part_number" ]]; then
        log_error "get_valid_answer_count: No part number specified"
        return 1
    fi

    # Select the appropriate values array
    local -a values_array
    if [[ "$part_number" == "part1" ]]; then
        values_array=("${VALIDATION_PART1_VALUES[@]}")
    else
        values_array=("${VALIDATION_PART2_VALUES[@]}")
    fi

    local count=0
    for value in "${values_array[@]}"; do
        if [[ "$value" != "ERROR" ]] && [[ "$value" != "null" ]]; then
            count=$((count + 1))
        fi
    done

    echo "$count"
    return 0
}

# Check if all valid answers agree
# Usage: all_answers_agree <part_number>
# Returns: 0 if all valid answers are identical OR all are null, 1 otherwise
all_answers_agree() {
    local part_number="$1"

    if [[ -z "$part_number" ]]; then
        log_error "all_answers_agree: No part number specified"
        return 1
    fi

    # Select the appropriate values array
    local -a values_array
    if [[ "$part_number" == "part1" ]]; then
        values_array=("${VALIDATION_PART1_VALUES[@]}")
    else
        values_array=("${VALIDATION_PART2_VALUES[@]}")
    fi

    # Collect valid values (non-error, non-null)
    local -a valid_values=()
    # Also track null and error counts
    local null_count=0
    local error_count=0

    for value in "${values_array[@]}"; do
        if [[ "$value" == "ERROR" ]]; then
            error_count=$((error_count + 1))
        elif [[ "$value" == "null" ]]; then
            null_count=$((null_count + 1))
        else
            valid_values+=("$value")
        fi
    done

    # If all values are null (and no errors), that's agreement (not implemented)
    if [[ ${#valid_values[@]} -eq 0 ]] && [[ $null_count -gt 0 ]] && [[ $error_count -eq 0 ]]; then
        return 0
    fi

    # Need at least one valid value if not all null
    if [[ ${#valid_values[@]} -eq 0 ]]; then
        return 1
    fi

    # Check if all valid values are the same
    local first_value="${valid_values[0]}"
    for value in "${valid_values[@]}"; do
        if [[ "$value" != "$first_value" ]]; then
            return 1
        fi
    done

    return 0
}
