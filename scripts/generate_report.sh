#!/bin/bash

# Markdown report generator for test results
# Generates test_results.md in project root after each test run
# Safe to source multiple times (idempotent)

# Prevent multiple sourcing
if [[ -n "${GENERATE_REPORT_SH_LOADED:-}" ]]; then
    return 0
fi
readonly GENERATE_REPORT_SH_LOADED=1

# Get script directory to source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=./common.sh
source "${SCRIPT_DIR}/common.sh"
# shellcheck source=./json_utils.sh
source "${SCRIPT_DIR}/json_utils.sh"
# shellcheck source=./validate_answers.sh
source "${SCRIPT_DIR}/validate_answers.sh"

# Format day number with leading zero
# Usage: format_day_number <day_number>
format_day_number() {
    local day_number="$1"

    if [[ -z "$day_number" ]]; then
        log_error "format_day_number: No day number specified"
        return 1
    fi

    printf "%02d" "$day_number"
    return 0
}

# Generate markdown report from test results
# Usage: generate_markdown_report <day_number> <test_output_dir> <report_file>
# Creates a markdown file with test results, commonalities, and differences
generate_markdown_report() {
    local day_number="$1"
    local test_output_dir="$2"
    local report_file="$3"

    if [[ -z "$day_number" ]]; then
        log_error "generate_markdown_report: No day number specified"
        return 1
    fi

    if [[ -z "$test_output_dir" ]]; then
        log_error "generate_markdown_report: No test output directory specified"
        return 1
    fi

    if [[ -z "$report_file" ]]; then
        log_error "generate_markdown_report: No report file path specified"
        return 1
    fi

    if [[ ! -d "$test_output_dir" ]]; then
        log_error "generate_markdown_report: Test output directory not found: $test_output_dir"
        return 1
    fi

    log_info "Generating markdown report for day $day_number"

    # Load validation results
    compare_all_answers "$test_output_dir" > /dev/null 2>&1

    # Get timestamp
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    # Start building report
    {
        echo "# Test Results for Day $day_number"
        echo ""
        echo "**Test Run:** $timestamp"
        echo ""
        echo "---"
        echo ""

        # Language results section
        echo "## Language Results"
        echo ""

        local languages=("rust" "gleam" "roc" "carbon" "bosque")
        for i in "${!VALIDATION_LANGUAGES[@]}"; do
            local language="${VALIDATION_LANGUAGES[$i]}"
            local part1_value="${VALIDATION_PART1_VALUES[$i]}"
            local part2_value="${VALIDATION_PART2_VALUES[$i]}"
            local exit_code="${VALIDATION_EXIT_CODES[$i]}"
            local error_msg="${VALIDATION_ERRORS[$i]}"

            echo "### ${language^}"
            echo ""

            if [[ "$exit_code" -eq 0 ]]; then
                echo "**Status:** PASS"
                echo ""
                echo "**JSON Output:**"
                echo '```json'
                echo "{\"part1\": $part1_value, \"part2\": $part2_value}"
                echo '```'
                echo ""
                echo "- **Part 1:** $part1_value"
                echo "- **Part 2:** $part2_value"
            else
                echo "**Status:** FAIL"
                echo ""
                if [[ -n "$error_msg" ]]; then
                    echo "**Error:** $error_msg"
                    echo ""
                fi

                # Include stderr if available
                local stderr_file="${test_output_dir}/${language}_stderr.txt"
                if [[ -f "$stderr_file" ]]; then
                    local stderr_content
                    stderr_content=$(head -n 10 "$stderr_file" 2>/dev/null | sed 's/^/    /')
                    if [[ -n "$stderr_content" ]]; then
                        echo "**Error Output:**"
                        echo '```'
                        echo "$stderr_content"
                        echo '```'
                    fi
                fi
            fi

            echo ""
        done

        echo "---"
        echo ""

        # Cross-language validation section
        echo "## Cross-Language Validation"
        echo ""

        # Part 1 Analysis
        echo "### Part 1 Analysis"
        echo ""

        local part1_valid_count
        part1_valid_count=$(get_valid_answer_count "part1")

        if [[ "$part1_valid_count" -eq 0 ]]; then
            echo "No valid answers for Part 1."
        elif all_answers_agree "part1"; then
            echo "**All languages agree on Part 1!**"
            echo ""

            # Get the common value
            for i in "${!VALIDATION_LANGUAGES[@]}"; do
                local val="${VALIDATION_PART1_VALUES[$i]}"
                if [[ "$val" != "ERROR" ]] && [[ "$val" != "null" ]]; then
                    echo "- **Common Answer:** $val"
                    break
                fi
            done

            # List agreeing languages
            local agreeing_langs=""
            for i in "${!VALIDATION_LANGUAGES[@]}"; do
                local lang="${VALIDATION_LANGUAGES[$i]}"
                local val="${VALIDATION_PART1_VALUES[$i]}"
                if [[ "$val" != "ERROR" ]] && [[ "$val" != "null" ]]; then
                    if [[ -z "$agreeing_langs" ]]; then
                        agreeing_langs="$lang"
                    else
                        agreeing_langs="${agreeing_langs}, $lang"
                    fi
                fi
            done
            echo "- **Agreeing Languages:** $agreeing_langs"
        else
            echo "**Divergent answers detected for Part 1:**"
            echo ""

            set +e
            local divergences
            divergences=$(find_divergences "part1")
            set -e

            if [[ -n "$divergences" ]]; then
                while IFS=: read -r lang value; do
                    echo "- **$lang:** $value"
                done <<< "$divergences"
            fi
        fi

        echo ""

        # Check for not-yet-implemented (null values)
        set +e
        local null_langs
        null_langs=$(handle_null_values "part1")
        set -e

        if [[ -n "$null_langs" ]]; then
            echo "**Not yet implemented (Part 1):** $null_langs"
            echo ""
        fi

        # Part 2 Analysis
        echo "### Part 2 Analysis"
        echo ""

        local part2_valid_count
        part2_valid_count=$(get_valid_answer_count "part2")

        if [[ "$part2_valid_count" -eq 0 ]]; then
            echo "No valid answers for Part 2."
        elif all_answers_agree "part2"; then
            echo "**All languages agree on Part 2!**"
            echo ""

            # Get the common value
            for i in "${!VALIDATION_LANGUAGES[@]}"; do
                local val="${VALIDATION_PART2_VALUES[$i]}"
                if [[ "$val" != "ERROR" ]] && [[ "$val" != "null" ]]; then
                    echo "- **Common Answer:** $val"
                    break
                fi
            done

            # List agreeing languages
            local agreeing_langs=""
            for i in "${!VALIDATION_LANGUAGES[@]}"; do
                local lang="${VALIDATION_LANGUAGES[$i]}"
                local val="${VALIDATION_PART2_VALUES[$i]}"
                if [[ "$val" != "ERROR" ]] && [[ "$val" != "null" ]]; then
                    if [[ -z "$agreeing_langs" ]]; then
                        agreeing_langs="$lang"
                    else
                        agreeing_langs="${agreeing_langs}, $lang"
                    fi
                fi
            done
            echo "- **Agreeing Languages:** $agreeing_langs"
        else
            echo "**Divergent answers detected for Part 2:**"
            echo ""

            set +e
            local divergences
            divergences=$(find_divergences "part2")
            set -e

            if [[ -n "$divergences" ]]; then
                while IFS=: read -r lang value; do
                    echo "- **$lang:** $value"
                done <<< "$divergences"
            fi
        fi

        echo ""

        # Check for not-yet-implemented (null values)
        set +e
        null_langs=$(handle_null_values "part2")
        set -e

        if [[ -n "$null_langs" ]]; then
            echo "**Not yet implemented (Part 2):** $null_langs"
            echo ""
        fi

        echo "---"
        echo ""

        # Failures section
        set +e
        local failed_langs
        failed_langs=$(get_failed_languages)
        set -e

        if [[ -n "$failed_langs" ]]; then
            echo "## Failed Languages"
            echo ""

            while IFS=: read -r lang error; do
                echo "- **$lang:** $error"
            done <<< "$failed_langs"

            echo ""
        fi

        echo "---"
        echo ""
        echo "*Generated by Advent of Code 2025 Testing Framework*"

    } > "$report_file"

    if [[ -f "$report_file" ]]; then
        log_success "Report generated: $report_file"
        return 0
    else
        log_error "Failed to generate report file"
        return 1
    fi
}

# Write report summary to stdout
# Usage: print_report_summary <day_number> <test_output_dir>
print_report_summary() {
    local day_number="$1"
    local test_output_dir="$2"

    if [[ -z "$day_number" ]] || [[ -z "$test_output_dir" ]]; then
        log_error "print_report_summary: Missing required arguments"
        return 1
    fi

    # Load validation results
    compare_all_answers "$test_output_dir" > /dev/null 2>&1

    echo ""
    log_info "========================================"
    log_info "Test Summary for Day $day_number"
    log_info "========================================"

    # Count successes and failures
    local passed=0
    local failed=0

    for exit_code in "${VALIDATION_EXIT_CODES[@]}"; do
        if [[ "$exit_code" -eq 0 ]]; then
            passed=$((passed + 1))
        else
            failed=$((failed + 1))
        fi
    done

    echo "Languages passed: $passed/5"
    echo "Languages failed: $failed/5"
    echo ""

    # Part 1 status
    if all_answers_agree "part1"; then
        log_success "Part 1: All implementations agree"
    else
        local part1_count
        part1_count=$(get_valid_answer_count "part1")
        if [[ "$part1_count" -eq 0 ]]; then
            log_warn "Part 1: No valid implementations"
        else
            log_warn "Part 1: Divergent answers detected"
        fi
    fi

    # Part 2 status
    if all_answers_agree "part2"; then
        log_success "Part 2: All implementations agree"
    else
        local part2_count
        part2_count=$(get_valid_answer_count "part2")
        if [[ "$part2_count" -eq 0 ]]; then
            log_warn "Part 2: No valid implementations"
        else
            log_warn "Part 2: Divergent answers detected"
        fi
    fi

    echo ""
}
