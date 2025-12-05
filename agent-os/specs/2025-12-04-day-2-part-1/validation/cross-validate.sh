#!/bin/bash

# Cross-Language Validation Script for Day 2 Part 1
# Tests all four implementations (Rust, Gleam, Carbon, Bosque) to ensure:
# 1. All produce identical output
# 2. Sample input produces expected result (1227775554)
# 3. Full input produces expected result (<REDACTED>)
# 4. All implementations meet performance target (<15 seconds)

# Base paths
BASE_DIR="/Users/sgarner/projects/sgarner-lt/advent-of-code-2025"
CHALLENGES_DIR="$BASE_DIR/challenges/day02"
SOLUTIONS_DIR="$BASE_DIR/solutions"
VALIDATION_DIR="$BASE_DIR/agent-os/specs/2025-12-04-day-2-part-1/validation"

# Expected results
EXPECTED_SAMPLE=1227775554
EXPECTED_FULL=<REDACTED>
MAX_TIME=15

# Results tracking
SAMPLE_INPUT="$CHALLENGES_DIR/input-sample.txt"
FULL_INPUT="$CHALLENGES_DIR/input.txt"
RESULTS_FILE="$VALIDATION_DIR/validation-results.txt"

echo "============================================="
echo "Cross-Language Validation: Day 2 Part 1"
echo "============================================="
echo ""

# Clear results file
rm -f "$RESULTS_FILE"
touch "$RESULTS_FILE"

# Function to extract part1 value from JSON output
extract_part1() {
    # Remove ANSI color codes, then extract part1 value
    echo "$1" | sed 's/\x1b\[[0-9;]*m//g' | grep -o '"part1":[^,}]*' | cut -d':' -f2 | tr -d ' '
}

# Function to test a language implementation
test_language() {
    local lang=$1
    local cmd=$2
    local input_file=$3
    local expected=$4

    echo "  Testing $lang with $(basename $input_file)..."

    # Time the execution
    local start=$(date +%s)
    local output=$(cd "$SOLUTIONS_DIR/$lang/day02" && eval "$cmd" < "$input_file" 2>&1)
    local exit_code=$?
    local end=$(date +%s)
    local elapsed=$((end - start))

    if [ $exit_code -ne 0 ]; then
        echo "    ERROR: Command failed (exit code $exit_code)"
        echo "    Output: $output"
        return 1
    fi

    local result=$(extract_part1 "$output")

    if [ -z "$result" ]; then
        echo "    ERROR: Could not extract result from output"
        echo "    Output: $output"
        return 1
    fi

    echo "    Result: $result"
    echo "    Time: ${elapsed}s"

    if [ "$result" = "$expected" ]; then
        echo "    PASS"
        echo "$lang:$(basename $input_file):$result:$elapsed:PASS" >> "$RESULTS_FILE"
        return 0
    else
        echo "    FAIL: Expected $expected, got $result"
        echo "$lang:$(basename $input_file):$result:$elapsed:FAIL" >> "$RESULTS_FILE"
        return 1
    fi
}

echo "============================================="
echo "Running All Implementations"
echo "============================================="
echo ""

all_passed=true

# Test each language
for lang in rust gleam carbon bosque; do
    echo "--- $lang Implementation ---"

    # Determine command based on language
    case $lang in
        rust)
            cmd="cargo run --release --quiet"
            ;;
        gleam)
            cmd="gleam run -m day02"
            ;;
        carbon|bosque)
            cmd="python3 runner.py"
            ;;
    esac

    # Test sample input
    if ! test_language "$lang" "$cmd" "$SAMPLE_INPUT" "$EXPECTED_SAMPLE"; then
        all_passed=false
    fi

    # Test full input
    if ! test_language "$lang" "$cmd" "$FULL_INPUT" "$EXPECTED_FULL"; then
        all_passed=false
    fi

    echo ""
done

# Summary report
echo "============================================="
echo "Validation Summary"
echo "============================================="
echo ""

echo "Test Status:"
for lang in rust gleam carbon bosque; do
    sample_status=$(grep "^$lang:input-sample.txt:" "$RESULTS_FILE" | cut -d':' -f5)
    full_status=$(grep "^$lang:input.txt:" "$RESULTS_FILE" | cut -d':' -f5)

    if [ "$sample_status" = "PASS" ] && [ "$full_status" = "PASS" ]; then
        echo "  $lang: PASSED"
    else
        echo "  $lang: FAILED"
    fi
done
echo ""

echo "Sample Input Results (expected: $EXPECTED_SAMPLE):"
for lang in rust gleam carbon bosque; do
    result=$(grep "^$lang:input-sample.txt:" "$RESULTS_FILE" | cut -d':' -f3)
    time=$(grep "^$lang:input-sample.txt:" "$RESULTS_FILE" | cut -d':' -f4)
    status=$(grep "^$lang:input-sample.txt:" "$RESULTS_FILE" | cut -d':' -f5)
    echo "  $lang: $result (${time}s) - $status"
done

# Check if all sample results match
sample_results=$(grep ":input-sample.txt:" "$RESULTS_FILE" | cut -d':' -f3 | sort -u | wc -l)
if [ $sample_results -eq 1 ]; then
    echo "  All implementations produce identical results!"
else
    echo "  WARNING: Results do not match!"
fi
echo ""

echo "Full Input Results (expected: $EXPECTED_FULL):"
for lang in rust gleam carbon bosque; do
    result=$(grep "^$lang:input.txt:" "$RESULTS_FILE" | cut -d':' -f3)
    time=$(grep "^$lang:input.txt:" "$RESULTS_FILE" | cut -d':' -f4)
    status=$(grep "^$lang:input.txt:" "$RESULTS_FILE" | cut -d':' -f5)
    echo "  $lang: $result (${time}s) - $status"
done

# Check if all full results match
full_results=$(grep ":input.txt:" "$RESULTS_FILE" | cut -d':' -f3 | sort -u | wc -l)
if [ $full_results -eq 1 ]; then
    echo "  All implementations produce identical results!"
else
    echo "  WARNING: Results do not match!"
fi
echo ""

echo "Performance Comparison (target: <${MAX_TIME}s):"
for lang in rust gleam carbon bosque; do
    time=$(grep "^$lang:input.txt:" "$RESULTS_FILE" | cut -d':' -f4)
    if [ $time -lt $MAX_TIME ]; then
        echo "  $lang: ${time}s (PASS)"
    else
        echo "  $lang: ${time}s (WARNING: over target)"
    fi
done
echo ""

# Final verdict
echo "============================================="
if $all_passed && [ $sample_results -eq 1 ] && [ $full_results -eq 1 ]; then
    echo "VALIDATION COMPLETE: All implementations PASSED!"
    echo "============================================="
    exit 0
else
    echo "VALIDATION FAILED: Some implementations did not pass!"
    echo "============================================="
    exit 1
fi
