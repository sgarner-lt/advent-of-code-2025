#!/bin/bash
# Simple test harness for Carbon Day 05 Part 2 implementation

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
RUNNER_SCRIPT="$PROJECT_ROOT/scripts/runners/run_carbon.sh"
SAMPLE_INPUT="$PROJECT_ROOT/challenges/day05/input-sample.txt"

echo "======================================"
echo "Carbon Day 05 Part 2 Test Suite"
echo "======================================"
echo ""

# Test 1: Sample input produces expected output
echo "Test 1: Sample input validation"
echo "Expected: {\"part1\": 3, \"part2\": 14}"
RESULT=$(bash "$RUNNER_SCRIPT" 5 "$SAMPLE_INPUT" 2>&1)
# Extract just the JSON line (last line with curly braces)
JSON_LINE=$(echo "$RESULT" | grep -E '^\{.*\}$')
echo "Actual:   $JSON_LINE"
if echo "$JSON_LINE" | grep -q '"part1": 3' && echo "$JSON_LINE" | grep -q '"part2": 14'; then
  echo "✓ PASS: Sample input produces correct output"
else
  echo "✗ FAIL: Sample input output mismatch"
  exit 1
fi
echo ""

# Test 2: Part 1 still works (regression test)
echo "Test 2: Part 1 regression test"
if echo "$JSON_LINE" | grep -q '"part1": 3'; then
  echo "✓ PASS: Part 1 still produces correct output"
else
  echo "✗ FAIL: Part 1 output incorrect"
  exit 1
fi
echo ""

# Test 3: Part 2 is not null
echo "Test 3: Part 2 returns a valid number"
if echo "$JSON_LINE" | grep -q '"part2": [0-9]'; then
  echo "✓ PASS: Part 2 returns a numeric value (not null)"
else
  echo "✗ FAIL: Part 2 returns null or invalid value"
  exit 1
fi
echo ""

# Test 4: Valid JSON format
echo "Test 4: JSON format validation"
if echo "$JSON_LINE" | python3 -m json.tool > /dev/null 2>&1; then
  echo "✓ PASS: Output is valid JSON"
else
  echo "✗ FAIL: Output is not valid JSON"
  exit 1
fi
echo ""

# Test 5: Unique ID counting logic (overlapping ranges)
echo "Test 5: Overlapping ranges handled correctly"
echo "Ranges: 3-5, 10-14, 16-20, 12-18"
echo "Expected unique IDs: 3,4,5,10,11,12,13,14,15,16,17,18,19,20 (14 total)"
if echo "$JSON_LINE" | grep -q '"part2": 14'; then
  echo "✓ PASS: Correctly counts 14 unique IDs across overlapping ranges"
else
  echo "✗ FAIL: Incorrect unique ID count"
  exit 1
fi
echo ""

echo "======================================"
echo "All tests passed!"
echo "======================================"
