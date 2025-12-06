# Bosque Language - Advent of Code 2025

Bosque is a research programming language developed by Microsoft Research. It is in an experimental state with limited tooling and documentation.

## Status

Bosque is an experimental research language and has:
- Working BosqueCore v1.0 compiler (runs in containerized environment)
- Limited standard library functionality (especially file I/O)
- **Solution:** Python wrapper pattern for file I/O and execution

## Running Solutions

Bosque solutions are executed via Python wrappers due to BosqueCore's limited file I/O capabilities:

```bash
# Run integration test for a specific day
./scripts/runners/run_bosque.sh 4 challenges/day04/input.txt

# Or via the integration test framework
./scripts/test_integration.sh 4
```

## File Naming Convention

**IMPORTANT:** Each implemented day must have the following file structure:

```
solutions/bosque/dayXX/
├── solution.bsq         # ✅ REQUIRED - Algorithm documentation in Bosque syntax
├── runner.py            # ✅ REQUIRED - Python wrapper for execution
└── test_runner.py       # ✅ REQUIRED - Unit tests for the wrapper
```

### Why This Structure?

1. **`solution.bsq`** - Documents the algorithm in Bosque syntax
   - Shows what the implementation would look like in pure Bosque
   - Includes comprehensive comments and unit tests
   - The test runner script (`scripts/runners/run_bosque.sh`) expects this filename
   - Serves as the "source of truth" for the algorithm

2. **`runner.py`** - Python wrapper that handles execution
   - Reads input from stdin
   - Implements the algorithm from `solution.bsq`
   - Outputs JSON results to stdout
   - Handles errors and edge cases

3. **`test_runner.py`** - Unit tests for the Python implementation
   - 8 focused tests covering core functionality
   - Tests grid parsing, algorithm logic, output formatting
   - Runs independently via `python3 test_runner.py`

### What NOT to Include

- ❌ **`dayXX.bsq`** - These are placeholder templates, delete them once `solution.bsq` is created
- ❌ Duplicate files with different names

### For Unimplemented Days

Days not yet implemented will have a placeholder `dayXX.bsq` file. When you implement a day:
1. Create the three required files listed above
2. Delete the placeholder `dayXX.bsq` file
3. Ensure the test runner can find `solution.bsq`

## Solution Structure

Each day's solution follows this pattern:

**solution.bsq:**
```bosque
namespace Main;

// Comprehensive documentation of algorithm
// Example: Day 4 - Paper Roll Accessibility

function solve(input: String): {part1: Int, part2: Int?, grid: String} {
    // Algorithm implementation in Bosque syntax
    // ...
}

entrypoint function main(args: List<String>): Int {
    // Entry point (requires Python wrapper for actual execution)
    // ...
}

// Unit tests (8 tests documenting behavior)
function test_example(): Bool {
    // ...
}
```

**runner.py:**
```python
#!/usr/bin/env python3
"""
Bosque wrapper for Day XX Part 1

This Python wrapper implements the algorithm documented in solution.bsq
because BosqueCore's file I/O capabilities are limited.
"""

import sys
import json

def solve(input_text):
    # Implementation matching solution.bsq algorithm
    pass

if __name__ == "__main__":
    # Read from stdin, execute, output JSON
    pass
```

## Why Python Wrappers?

BosqueCore v1.0 has limited file I/O support in its standard library. Until the language matures, we use Python wrappers that:
- Handle file reading from stdin
- Implement the algorithm documented in `solution.bsq`
- Provide consistent JSON output format
- Enable integration testing across all 4 languages

The Bosque `.bsq` files serve as **algorithm documentation and specification**, while Python handles the execution.

## Testing

```bash
# Run unit tests for a specific day's wrapper
cd solutions/bosque/day04
python3 test_runner.py

# Run integration test comparing all languages
./scripts/test_integration.sh 4
```

## References

- **Bosque Language Guide:** `docs/languages/bosque.md`
- **Runner Script:** `scripts/runners/run_bosque.sh`
- **BosqueCore Repository:** https://github.com/BosqueLanguage/BosqueCore
