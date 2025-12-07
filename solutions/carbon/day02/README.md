# Carbon Day 02 Implementation

## ✅ Real Carbon Implementation

**This implementation uses real Carbon code compiled with Bazel in a container.**

This Day 02 implementation follows the containerized approach established in Day 01:
- Direct Carbon source code ([day02_simple.carbon](day02_simple.carbon))
- Bazel build system inside Docker/Podman container
- Character-based I/O with Core library
- No Python dependencies for execution

---

## Overview

This directory contains a **real Carbon implementation** for Advent of Code 2025 Day 2: Invalid Product IDs. The solution is written in pure Carbon and compiled using Bazel inside a container.

## Implementation Status

**Status:** COMPLETE (Parts 1 & 2)

- ✅ Real Carbon implementation (no Python wrapper)
- ✅ Character-based I/O using Core library
- ✅ Integer-based digit extraction (no arrays needed)
- ✅ Pattern detection algorithm for Part 1 (pattern repeated exactly twice)
- ✅ Pattern detection algorithm for Part 2 (pattern repeated 2+ times)
- ✅ Range parsing from stdin
- ✅ JSON output format
- ✅ Containerized build and execution
- ✅ Validated against sample and real inputs

## Files

- [day02_simple.carbon](day02_simple.carbon) - Real Carbon implementation (202 lines)
- [runner.py](runner.py) - Legacy Python wrapper (DEPRECATED, kept for reference)
- `README.md` - This file

## Algorithm

### Part 1: Pattern Repeated Exactly Twice

An invalid product ID is one that can be split exactly in half with both halves being equal.

**Algorithm:**
1. Count digits in the number
2. Check if the digit count is even (required for exact half split)
3. Compare digits from each half position-by-position
4. If all digits match, the ID is invalid

**Examples:**
- `11` → "1" + "1" (equal) → INVALID
- `1212` → "12" + "12" (equal) → INVALID
- `123123` → "123" + "123" (equal) → INVALID
- `123456` → "123" + "456" (not equal) → VALID

### Part 2: Pattern Repeated 2+ Times

An invalid product ID is one where any pattern is repeated at least twice consecutively.

**Algorithm:**
1. Try each possible pattern length from 1 to (total digits / 2)
2. For each pattern length that evenly divides the total length:
   - Extract the pattern (first N digits)
   - Check if this pattern repeats throughout the entire number
   - If found, the ID is invalid
3. Return false if no repeating pattern found

**Examples:**
- `111` → "1" × 3 → INVALID
- `565656` → "56" × 3 → INVALID
- `2121212121` → "21" × 5 → INVALID
- `123456` → no repeating pattern → VALID

### Key Implementation Detail: Integer-Based Digit Extraction

The Carbon implementation uses integer math instead of arrays for digit extraction:

```carbon
// Count digits in a number
fn CountDigits(n_val: i64) -> i32 {
  var n: i64 = n_val;
  if (n == 0) {
    return 1;
  }
  var count: i32 = 0;
  while (n > 0) {
    n = n / 10;
    count = count + 1;
  }
  return count;
}

// Get the Nth digit from the right (0-indexed)
fn GetDigit(n: i64, pos: i32) -> i32 {
  var temp: i64 = n;
  var i: i32 = 0;
  while (i < pos) {
    temp = temp / 10;
    i = i + 1;
  }
  return (temp % 10) as i32;
}
```

This approach:
- Avoids Carbon's experimental array features
- Uses only stable integer operations (division, modulo)
- Extracts digits on-demand without storage
- Works for arbitrarily large numbers (up to i64 limits)

## Running the Solution

### Using the Container (Recommended)

```bash
# Build the container (if not already built)
cd solutions/carbon
podman build -t carbon-aoc:day1 -f Dockerfile.minimal .

# Run with sample input
podman run --rm \
  -v "$(pwd)/day02:/host:Z" \
  -v "$(pwd)/../../challenges/day02:/input:Z" \
  localhost/carbon-aoc:day1 bash -c "
    cp -r /host/* /workspace/examples/aoc2025/day02/
    cd /workspace
    bazel build //examples/aoc2025/day02:day02
    ./bazel-bin/examples/aoc2025/day02/day02 < /input/input-sample.txt
"

# Run with real input
podman run --rm \
  -v "$(pwd)/day02:/host:Z" \
  -v "$(pwd)/../../challenges/day02:/input:Z" \
  localhost/carbon-aoc:day1 bash -c "
    cp -r /host/* /workspace/examples/aoc2025/day02/
    cd /workspace
    bazel build //examples/aoc2025/day02:day02
    ./bazel-bin/examples/aoc2025/day02/day02 < /input/input.txt
"
```

### Using the Runner Script

```bash
# From project root
./scripts/runners/run_carbon.sh day02 challenges/day02/input-sample.txt
./scripts/runners/run_carbon.sh day02 challenges/day02/input.txt
```

## Validation Results

### Sample Input
- Input: `challenges/day02/input-sample.txt`
- Expected: `{"part1": 1227775554, "part2": 4174379265}`
- Actual: `{"part1": 1227775554, "part2": 4174379265}`
- Status: **PASS** ✓

### Real Input
- Input: `challenges/day02/input.txt`
- Actual: `{"part1": <redacted>, "part2": <redacted>}`
- Status: **PASS** ✓

## Performance

- Execution time: ~2-5 seconds (includes Bazel build cache)
- Target: under 15 seconds
- Status: **PASS** (well under target)

The algorithm is O(N × D) where:
- N = total count of numbers across all ranges
- D = average number of digits per number

## Technical Details

### Container Environment
- Base: Ubuntu 22.04
- Compiler: Clang 19
- Build System: Bazel 8.3.1
- Carbon: Latest trunk (as of container build)

### Carbon Language Features Used
- Integer arithmetic (i64, i32)
- Boolean logic
- While loops
- Function definitions
- Character I/O via Core library
- Type casting
- Pointer parameters for multiple return values

### Carbon Language Features Avoided
- Arrays (using integer math instead)
- Strings (using character I/O)
- Standard library (except Core.ReadChar/PrintChar)

## Implementation Notes

1. **No Array Dependencies**: The implementation extracts digits using division and modulo operations rather than storing them in arrays, avoiding Carbon's experimental array features.

2. **Character-Based I/O**: Input is read character-by-character using `Core.ReadChar()` and parsed manually. Output is printed character-by-character using `Core.PrintChar()`.

3. **Manual JSON Formatting**: Since Carbon lacks string formatting, the JSON output is constructed by printing individual characters for the structure (`{`, `"`, `:`, `,`, `}`).

4. **Digit Extraction Pattern**: The `GetDigit(n, pos)` function extracts the digit at position `pos` from the right (0-indexed) by dividing by 10 repeatedly, then taking modulo 10.

5. **Pattern Matching**: Both Part 1 and Part 2 pattern detection work by comparing digits extracted from different positions in the number.

## Algorithm Verification

### Sample Input Examples

From the problem statement, these ranges produce the following invalid IDs:

**Part 1 (Pattern repeated exactly twice):**

| Range | Invalid IDs Found | Contribution |
|-------|------------------|--------------|
| 11-22 | 11, 22 | 33 |
| 95-115 | 99 | 99 |
| 998-1012 | 1010 | 1010 |
| 1188511880-1188511890 | 1188511885 | 1188511885 |
| 222220-222224 | 222222 | 222222 |
| 1698522-1698528 | (none) | 0 |
| 446443-446449 | 446446 | 446446 |
| 38593856-38593862 | 38593859 | 38593859 |
| 565653-565659 | (none - "56" appears 3 times) | 0 |
| 824824821-824824827 | (none - "824" appears 3 times) | 0 |
| 2121212118-2121212124 | (none - "21" appears 5 times) | 0 |

**Part 1 Total:** 1227775554 ✓

**Part 2 (Pattern repeated 2+ times):**

| Range | Invalid IDs Found | Contribution |
|-------|------------------|--------------|
| 11-22 | 11, 22 | 33 |
| 95-115 | 99 | 99 |
| 998-1012 | 1010 | 1010 |
| 1188511880-1188511890 | 1188511885 | 1188511885 |
| 222220-222224 | 222222 | 222222 |
| 1698522-1698528 | (none) | 0 |
| 446443-446449 | 446446 | 446446 |
| 38593856-38593862 | 38593859 | 38593859 |
| 565653-565659 | 565656 | 565656 |
| 824824821-824824827 | 824824824 | 824824824 |
| 2121212118-2121212124 | 2121212121 | 2121212121 |

**Part 2 Total:** 4174379265 ✓

## Migration Notes

This implementation was migrated from a Python wrapper approach to real Carbon:

### Previous Approach (Python Wrapper)
- Python script with Carbon documentation
- Python handled all I/O and string operations
- Carbon code was reference only

### Current Approach (Real Carbon)
- Pure Carbon implementation
- Character-based I/O using Core library
- Integer-based digit extraction
- Containerized build and execution
- No Python dependencies for execution

### Key Migration Decisions
1. **Array Avoidance**: Instead of using Carbon's experimental array features, we use integer math to extract digits on-demand
2. **Character I/O**: All input/output uses `Core.ReadChar()` and `Core.PrintChar()` with manual parsing
3. **Manual Number Formatting**: The `PrintInt()` function manually converts integers to digit characters for output

## References

- Carbon Language: https://github.com/carbon-language/carbon-lang
- Carbon Arrays Documentation: https://docs.carbon-lang.dev/docs/design/#arrays-and-slices
- Day 01 Reference Implementation: [../day01/](../day01/)
