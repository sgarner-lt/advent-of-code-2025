#!/bin/bash
# Test harness for Carbon Day 06 Part 2 implementation

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
RUNNER_SCRIPT="$PROJECT_ROOT/scripts/runners/run_carbon.sh"
SAMPLE_INPUT="$PROJECT_ROOT/challenges/day06/input-sample.txt"

echo "======================================"
echo "Carbon Day 06 Part 2 Test Suite"
echo "======================================"
echo ""

# Test 1: Sample input produces expected output
echo "Test 1: Sample input validation"
echo "Expected: {\"part1\": 4277556, \"part2\": 3263827}"
RESULT=$(bash "$RUNNER_SCRIPT" 6 "$SAMPLE_INPUT" 2>&1)
# Extract just the JSON line (last line with curly braces)
JSON_LINE=$(echo "$RESULT" | grep -E '^\{.*\}$')
echo "Actual:   $JSON_LINE"
if echo "$JSON_LINE" | grep -q '"part1": 4277556' && echo "$JSON_LINE" | grep -q '"part2": 3263827'; then
  echo "✓ PASS: Sample input produces correct output"
else
  echo "✗ FAIL: Sample input output mismatch"
  exit 1
fi
echo ""

# Test 2: Part 1 still works (regression test)
echo "Test 2: Part 1 regression test"
if echo "$JSON_LINE" | grep -q '"part1": 4277556'; then
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

# Test 5: Part 2 specific value check
echo "Test 5: Part 2 exact value verification"
if echo "$JSON_LINE" | grep -q '"part2": 3263827'; then
  echo "✓ PASS: Part 2 produces expected value (3263827)"
else
  echo "✗ FAIL: Part 2 value incorrect"
  exit 1
fi
echo ""

echo "======================================"
echo "All tests passed!"
echo "======================================"
echo ""
echo "Algorithm verification:"
echo "- Column 0 (*): 123,45,6 -> extract right: 356,24,1 -> 356*24*1 = 8544"
echo "- Column 1 (+): 328,64,98 -> extract left: 369,248,8 -> reverse: 8+248+369 = 625"
echo "- Column 2 (*): 51,387,215 -> extract right: 175,581,32 -> 175*581*32 = 3253600"
echo "- Column 3 (+): 64,23,314 -> extract left: 623,431,4 -> reverse: 4+431+623 = 1058"
echo "- Grand total: 8544 + 625 + 3253600 + 1058 = 3263827 ✓"
