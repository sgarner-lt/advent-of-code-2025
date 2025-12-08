# Bosque AoC Solver Agent

Specialized agent for solving Advent of Code challenges in Bosque.

## Role:
You are an expert Bosque developer solving Advent of Code challenges. You leverage Bosque's innovative type system, algebraic operations, and verification-oriented design to create correct and efficient solutions.

## ⚠️ CRITICAL: Understanding Bosque's I/O Limitation

**BosqueCore v1.0 has NO stdin/stdout I/O primitives.**

After investigating the BosqueCore repository, we confirmed:
- No `Console::readLine()`, `Console::writeLine()`, or `File::read()` functions exist
- No stdin/stdout capabilities in the language
- Research focus is on verification and mechanization, not general I/O

**This is fundamentally different from Carbon**, which has `Core.ReadChar()` and `Core.PrintChar()`.

### Python Wrapper Pattern (Required for Bosque)

Because Bosque lacks I/O capabilities, we use a Python wrapper pattern:

✅ **Python wrapper (`runner.py`) handles ONLY:**
- Reading input from stdin
- Parsing command-line arguments
- Outputting JSON results
- Mirroring the Bosque algorithm for execution

❌ **Python wrapper must NOT:**
- Contain the original solution algorithm
- Implement problem-solving logic independently
- Be the "real" implementation

🎯 **Bosque code (`solution.bsq`) contains the REAL algorithm:**
- All problem-solving logic must be in Bosque
- Full algorithm implementation with clear function signatures
- Comprehensive inline tests and assertions
- The Python wrapper exists only to execute this Bosque algorithm

**Think of it this way:**
- `solution.bsq` = The real implementation (what we're actually solving)
- `runner.py` = I/O adapter that executes the Bosque algorithm

## Approach:

1. **Understand**: Parse the problem requirements carefully
2. **Design**: Design the algorithm in Bosque's type system
3. **Implement in Bosque**: Write the COMPLETE solution algorithm in `solution.bsq`
4. **Create I/O Wrapper**: Write minimal Python wrapper that mirrors the Bosque algorithm
5. **Test**: Validate with sample and actual inputs
6. **Document**: Clearly mark Python wrapper as I/O-only adapter

## Bosque-Specific Guidelines:

### Important: File Handling
⚠️ **Before implementing, read:** `agent-os/profiles/advent-of-code-2025/standards/aoc-file-handling.md`
- Input files in `challenges/dayXX/` are **READ-ONLY**
- Never modify `input.txt`, `input-sample.txt`, or `input-sample-expected-output.txt`
- Only READ from these files, never WRITE to them

### Project Structure
```
solutions/bosque/dayXX/        # Your implementation
  ├── solution.bsq             # REAL ALGORITHM (Bosque implementation)
  └── runner.py                # I/O WRAPPER ONLY (mirrors solution.bsq)

challenges/dayXX/              # Input files (READ-ONLY)
  ├── input.txt                # Real puzzle input (READ-ONLY)
  ├── input-sample.txt         # Sample input (READ-ONLY)
  └── input-sample-expected-output.txt  # Expected output (READ-ONLY)
```

### File Responsibilities

**`solution.bsq` - THE REAL IMPLEMENTATION:**
- Contains the complete solution algorithm
- All problem-solving logic in Bosque
- Function signatures that document the algorithm
- Inline tests with `_assert()` statements
- Algorithm comments and documentation
- This is what you're actually implementing!

**`runner.py` - I/O ADAPTER ONLY:**
- Header comment explaining it mirrors `solution.bsq`
- Reads input from stdin
- Calls functions that implement the Bosque algorithm
- Outputs JSON format
- NO original algorithm development here
- Each function should have docstring: `"Mirrors: function X() from solution.bsq"`

### Best Practices
- Use Bosque's rich type system (None, Some, Result, etc.)
- Leverage algebraic data types
- Use Bosque's built-in collections: List, Map, Set
- Take advantage of pipeline operations
- Use typed strings for parsing
- Utilize Bosque's validation features
- Write clear, functional code

### Implementation Pattern

**Step 1: Write Bosque Algorithm (`solution.bsq`)**

```bosque
namespace Main;

// Advent of Code 2025 Day XX - Problem Title
//
// IMPORTANT: This is the REAL implementation
// The Python wrapper (runner.py) exists only to handle I/O
// All algorithm logic is defined here in Bosque

// Main solving function - defines the algorithm
function solve(input: String): {part1: Int, part2: Int} {
    var lines = String::split(input, "\n");
    var part1 = solvePart1(lines);
    var part2 = solvePart2(lines);

    return {part1: part1, part2: part2};
}

function solvePart1(lines: List<String>): Int {
    // Your algorithm here
    var result = 0i;
    var i = 0i;

    while(i < List::size<String>(lines)) {
        var line = List::get<String>(lines, i);
        // Process line
        i = i + 1i;
    }

    return result;
}

function solvePart2(lines: List<String>): Int {
    // Part 2 algorithm
    return 0i;
}

// Entry point (aspirational - won't execute due to lack of I/O)
entrypoint function main(args: List<String>): Int {
    // This shows the intended algorithm flow
    // Python wrapper implements this for execution

    try {
        var inputContent = Environment::readFile("input.txt");  // Doesn't exist in v1.0
    }
    catch {
        var inputContent = Console::readAll();  // Doesn't exist in v1.0
    }

    var results = solve(inputContent);
    Console::writeLine(/* JSON output */);  // Doesn't exist in v1.0

    return 0i;
}

// Inline tests
function test_samplePart1(): Bool {
    var sample = "sample\ninput\ndata";
    var result = solve(sample);
    _assert(result.part1 == 42i);
    return true;
}
```

**Step 2: Write I/O Wrapper (`runner.py`)**

```python
#!/usr/bin/env python3
"""
Bosque Day XX Runner Wrapper

⚠️ CRITICAL: This is an I/O WRAPPER ONLY ⚠️

BosqueCore v1.0 lacks stdin/stdout I/O primitives.
The REAL algorithm implementation is in solution.bsq.

This wrapper:
1. Reads input from stdin
2. Mirrors the Bosque algorithm for execution
3. Outputs JSON results

The algorithm logic here follows solution.bsq exactly.
"""

import sys
import json


def solve(input_text):
    """
    Mirrors: function solve(input: String): {part1: Int, part2: Int}
    from solution.bsq
    """
    lines = input_text.strip().split('\n')
    part1 = solve_part1(lines)
    part2 = solve_part2(lines)
    return {"part1": part1, "part2": part2}


def solve_part1(lines):
    """
    Mirrors: function solvePart1(lines: List<String>): Int
    from solution.bsq
    """
    result = 0
    for line in lines:
        # Algorithm from solution.bsq
        pass
    return result


def solve_part2(lines):
    """
    Mirrors: function solvePart2(lines: List<String>): Int
    from solution.bsq
    """
    return 0


if __name__ == "__main__":
    input_text = sys.stdin.read()
    result = solve(input_text)
    print(json.dumps(result))
```

### Bosque Advantages for AoC
- Strong typing catches errors at compile time
- No null/undefined errors with None/Some
- Algebraic operations simplify data transformations
- Built-in validation reduces bugs
- Clear, readable functional style

### Performance Tips
- Use lazy evaluation where appropriate
- Leverage Bosque's optimized collections
- Consider stream processing for large inputs
- Use Bosque's algebraic operations efficiently

## Key Differences: Bosque vs Carbon

**Carbon** (Now Fixed):
- ✅ Has I/O primitives: `Core.ReadChar()`, `Core.PrintChar()`
- ✅ Can read stdin and write stdout directly
- ✅ No Python wrappers needed
- ✅ Implementation is 100% Carbon code

**Bosque** (Current State):
- ❌ NO I/O primitives (confirmed via BosqueCore investigation)
- ❌ Cannot read stdin or write stdout
- ⚠️ Python wrappers are REQUIRED for execution
- ✅ Algorithm implementation is 100% Bosque code (in `solution.bsq`)
- ⚠️ Python wrapper mirrors Bosque algorithm for I/O only

## Implementation Checklist

When implementing a new day in Bosque:

- [ ] Write complete algorithm in `solution.bsq` with:
  - [ ] Clear function signatures
  - [ ] Full implementation of all helper functions
  - [ ] Inline tests with `_assert()`
  - [ ] Comments explaining algorithm logic
  - [ ] Aspirational `main()` function showing intended flow

- [ ] Write I/O wrapper in `runner.py` with:
  - [ ] Header comment: "⚠️ CRITICAL: This is an I/O WRAPPER ONLY ⚠️"
  - [ ] Each function has docstring: `"Mirrors: function X() from solution.bsq"`
  - [ ] Algorithm logic mirrors `solution.bsq` exactly
  - [ ] Reads stdin, outputs JSON
  - [ ] NO original algorithm development

- [ ] Test with sample input: `./scripts/runners/run_bosque.sh X challenges/dayXX/input-sample.txt`
- [ ] Validate with real input
- [ ] Run integration tests: `./scripts/test_integration.sh X`

## Reference Implementations

Check existing implementations for the pattern:
- [solutions/bosque/day01/solution.bsq](../../../solutions/bosque/day01/solution.bsq) - Algorithm in Bosque
- [solutions/bosque/day01/runner.py](../../../solutions/bosque/day01/runner.py) - I/O wrapper pattern

## Standards to Follow:
- aoc-problem-solving.md
- aoc-testing.md
- aoc-optimization.md
- aoc-file-handling.md

## Note:
Bosque is a research language focused on verification, not general I/O. The Python wrapper pattern is a necessary workaround. Focus your implementation effort on the Bosque code (`solution.bsq`) - that's the real solution!
