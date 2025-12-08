# Carbon Day 04 Implementation

## ✅ Real Carbon Implementation

**This implementation uses real Carbon code compiled with Bazel in a container.**

This Day 04 implementation follows the containerized approach established in Days 01-03:
- Direct Carbon source code ([day04_simple.carbon](day04_simple.carbon))
- Bazel build system inside Docker/Podman container
- Character-based I/O with Core library
- No Python dependencies for execution

---

## Overview

This directory contains a **real Carbon implementation** for Advent of Code 2025 Day 4: Paper Roll Accessibility. The solution is written in pure Carbon and compiled using Bazel inside a container.

## Implementation Status

**Status:** COMPLETE (Parts 1 & 2)

- ✅ Real Carbon implementation (no Python wrapper)
- ✅ Character-based I/O using Core library
- ✅ Grid-based processing with global arrays
- ✅ 8-directional adjacency checking
- ✅ Iterative roll removal algorithm
- ✅ JSON output format
- ✅ Containerized build and execution
- ✅ Validated against sample and real inputs

## Files

- [day04_simple.carbon](day04_simple.carbon) - Real Carbon implementation (207 lines)
- `README.md` - This file

**Deprecated files removed:**
- `runner.py` - Legacy Python wrapper (DELETED)
- `day04.carbon` - Legacy Carbon stub (DELETED)
- `test_runner.py` - Legacy test file (DELETED)

## Problem Description

### Part 1: Count Accessible Rolls

Count paper rolls that have **fewer than 4 adjacent rolls** (in any of 8 directions).

**Algorithm:**
1. Parse grid from input (rows × cols, max 150×150)
2. For each cell containing '@' (paper roll):
   - Count adjacent rolls in all 8 directions (N, S, E, W, NE, NW, SE, SW)
   - If count < 4, the roll is "accessible"
3. Return total count of accessible rolls

**Example:**
```
..@@.@@@@.
@@@.@.@.@@
```
- Roll at (0,2) has 3 adjacent rolls → accessible
- Roll at (1,0) has 2 adjacent rolls → accessible
- Roll at (1,1) has 4 adjacent rolls → NOT accessible

### Part 2: Iterative Roll Removal

Remove accessible rolls iteratively until no more can be removed. Count total removed.

**Algorithm:**
1. Find all accessible rolls (< 4 adjacent) in current grid
2. Mark them for removal (batch processing)
3. Remove all marked rolls simultaneously
4. Repeat until no accessible rolls remain
5. Return total count of removed rolls

**Key Detail:** Rolls are removed in batches, not one at a time. This ensures that removing one roll doesn't immediately affect the accessibility of neighboring rolls in the same iteration.

## Key Implementation Details

### Discovery: Carbon Trailing Comment Restriction

During implementation, we discovered that **Carbon does NOT allow trailing comments**:

```carbon
// INCORRECT - Compilation error:
grid[r][c] = 0x40;  // '@'
if (count < 4) {  // accessible

// CORRECT - Comments on separate lines:
grid[r][c] = 0x40;
if (count < 4) {
```

**Error message:** `error: trailing comments are not permitted`

This is a strict Carbon syntax rule that applies to ALL statements.

### Global Variables for Large Arrays

Carbon has difficulty passing large nested arrays as function parameters:

```carbon
// INCORRECT - Parameter error:
fn ParseGrid(grid: array(array(i32, 150), 150)*) { ... }

// CORRECT - Use global variables:
var grid: array(array(i32, 150), 150);
var rows: i32 = 0;
var cols: i32 = 0;

fn ParseGrid() {
  // Access globals directly
  grid[r][c] = ch;
}
```

**Why:** Carbon's type system has limitations with large nested array parameters. Using module-level globals is the recommended workaround.

### 8-Directional Adjacency Checking

Initially attempted to use direction arrays, but explicit if statements proved more reliable:

```carbon
fn CountAdjacent(r: i32, c: i32) -> i32 {
  var count: i32 = 0;

  // Check all 8 directions explicitly
  if (r > 0 and grid[r - 1][c] == 0x40) { count = count + 1; }  // N
  if (r < rows - 1 and grid[r + 1][c] == 0x40) { count = count + 1; }  // S
  if (c < cols - 1 and grid[r][c + 1] == 0x40) { count = count + 1; }  // E
  if (c > 0 and grid[r][c - 1] == 0x40) { count = count + 1; }  // W
  // ... diagonal directions ...

  return count;
}
```

### Batch Removal with Marking Array

Part 2 requires a separate marking array to track which rolls to remove:

```carbon
fn RemoveAccessible() -> i32 {
  var total_removed: i32 = 0;
  var to_remove: array(array(i32, 150), 150);

  while (true) {
    // Phase 1: Mark accessible rolls
    var found_any: bool = false;
    for each position:
      if accessible:
        to_remove[r][c] = 1;
        found_any = true;

    if (not found_any) {
      break;  // No more accessible rolls
    }

    // Phase 2: Remove marked rolls
    for each marked position:
      grid[r][c] = 0x2E;  // '.'
      total_removed = total_removed + 1;
  }

  return total_removed;
}
```

## Running the Solution

### Using the Container (Recommended)

```bash
# Build the container (if not already built)
cd solutions/carbon
podman build -t carbon-aoc:day1 -f Dockerfile.minimal .

# Run with sample input
podman run --rm \
  -v "$(pwd)/day04:/host:Z" \
  -v "$(pwd)/../../challenges/day04:/input:Z" \
  localhost/carbon-aoc:day1 bash -c "
    cd /opt/carbon-lang
    mkdir -p examples/aoc2025/day04
    cp /host/day04_simple.carbon examples/aoc2025/day04/
    cd examples/aoc2025/day04
    echo 'load(\"//bazel/carbon_rules:defs.bzl\", \"carbon_binary\")

carbon_binary(
    name = \"day04\",
    srcs = [\"day04_simple.carbon\"],
)' > BUILD
    cd /opt/carbon-lang
    ./scripts/run_bazelisk.py build //examples/aoc2025/day04:day04
    ./bazel-bin/examples/aoc2025/day04/day04 < /input/input-sample.txt
"
```

### Using the Runner Script

```bash
# From project root
./scripts/runners/run_carbon.sh 4 challenges/day04/input-sample.txt
./scripts/runners/run_carbon.sh 4 challenges/day04/input.txt
```

## Validation Results

### Sample Input
- Input: `challenges/day04/input-sample.txt` (10×10 grid)
- Expected: `{"part1": 13, "part2": 43}`
- Actual: `{"part1": 13, "part2": 43}`
- Status: **PASS** ✓

### Real Input
- Input: `challenges/day04/input.txt` (135×137 grid)
- Result: `{"part1": <redacted>, "part2": <redacted>}`
- Status: **PASS** ✓

### Cross-Language Validation
All 4 languages (Rust, Gleam, Carbon, Bosque) agree:
- Part 1: **<redacted>**
- Part 2: **<redacted>**

## Performance

- Execution time: ~2-3 seconds (includes Bazel build cache)
- Target: under 15 seconds
- Status: **PASS** (well under target)

The algorithm complexity:
- Part 1: O(R × C × 8) = O(R × C) for grid traversal with 8-direction checks
- Part 2: O(I × R × C) where I = number of iterations until no accessible rolls remain

## Technical Details

### Container Environment
- Base: Ubuntu 22.04
- Compiler: Clang 19
- Build System: Bazel 8.3.1
- Carbon: Latest trunk (commit d5bddcb, December 6, 2025)

### Carbon Language Features Used
- Global variables for large arrays
- Arrays: `array(array(type, size), size)` for 2D grids
- Integer arithmetic (i64, i32)
- Boolean logic
- While loops with break
- Function definitions
- Character I/O via Core library
- Type casting
- Boundary checking

### Carbon Language Features Avoided
- Trailing comments (syntax error)
- Direction arrays (replaced with explicit checks)
- Nested array parameters (use globals instead)
- Strings (using character I/O)
- Complex standard library (limited availability)

## Implementation Notes

1. **Trailing Comment Discovery**: The migration initially had compilation errors due to trailing comments like `grid[r][c] = 0x40;  // '@'`. Carbon requires all comments to be on separate lines, which is now documented as a critical syntax rule.

2. **Global Array Approach**: After attempting to pass nested arrays as parameters resulted in errors, we switched to using global variables for the grid. This is a known Carbon limitation with large nested arrays.

3. **Character-Based I/O**: Input is read character-by-character using `Core.ReadChar()` and parsed manually. Output is printed character-by-character using `Core.PrintChar()`.

4. **Grid Initialization**: The 150×150 grid is initialized with '.' (0x2E) at the start to ensure all cells have valid values.

5. **Batch Removal Logic**: Part 2 requires careful implementation to mark all accessible rolls before removing them, ensuring simultaneous removal rather than sequential removal.

6. **Manual JSON Formatting**: Since Carbon lacks string formatting, JSON output is constructed by printing individual characters.

## Migration Notes

This implementation was migrated from a Python wrapper approach to real Carbon:

### Previous Approach (Python Wrapper)
- Python script with Carbon documentation
- Python handled all I/O and grid operations
- Carbon code was reference only

### Current Approach (Real Carbon)
- Pure Carbon implementation
- Character-based I/O using Core library
- Global arrays for grid storage
- Containerized build and execution
- No Python dependencies for execution

### Key Migration Challenges
1. **Trailing Comments**: Discovered that Carbon doesn't allow `// comment` after code on same line
2. **Nested Array Parameters**: Cannot pass large nested arrays as parameters; must use globals
3. **Direction Iteration**: Attempted array-based iteration but explicit if statements proved more reliable
4. **Compilation Time**: ~2-3 minutes with cached dependencies

## Algorithm Verification

### Sample Input Walkthrough (10×10 grid)

**Initial Grid:**
```
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
```

**Part 1 Analysis:**
Accessible rolls (< 4 adjacent) = 13 rolls
- Corner rolls typically have fewer neighbors
- Edge rolls near gaps have fewer neighbors
- Interior rolls surrounded by other rolls are NOT accessible

**Part 2 Analysis:**
Iteration process removes accessible rolls in waves:
1. First iteration: Remove 13 accessible rolls
2. Second iteration: Some previously inaccessible rolls become accessible
3. Continue until no accessible rolls remain
4. Total removed: 43 rolls

## References

- Carbon Language: https://github.com/carbon-language/carbon-lang
- Carbon Examples: `/opt/carbon-lang/examples/advent2024/` (in container)
- Day 01 Reference Implementation: [../day01/](../day01/)
- Day 02 Reference Implementation: [../day02/](../day02/)
- Day 03 Reference Implementation: [../day03/](../day03/)
- Carbon Documentation: [../../docs/languages/carbon.md](../../docs/languages/carbon.md)
