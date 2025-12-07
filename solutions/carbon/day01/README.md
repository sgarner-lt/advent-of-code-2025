# Carbon Day 01 Implementation

## Overview

This directory contains a **real Carbon implementation** for Advent of Code 2025 Day 1 - Dial Rotation. This solution uses actual Carbon code compiled with Bazel inside a Docker/Podman container.

## Implementation Status

**Status:** COMPLETE (Real Carbon Implementation)

This is a fully native Carbon implementation:
- Character-based I/O using Core library
- Direct stdin/stdout without wrapper scripts
- Compiled with Bazel build system
- Executed inside container with Carbon toolchain

## Files

- `day01_simple.carbon` - Single-file Carbon implementation with all logic
- `day01.carbon` - Legacy file (deprecated, kept for reference)
- `runner.py` - **DEPRECATED** Python wrapper (no longer used)
- `test_carbon_day01.py` - **DEPRECATED** Unit tests (no longer used)

## Carbon Implementation

### Real Carbon Code

This solution uses **real Carbon code** without any Python wrappers. Key features:

- **Character-based I/O**: Uses `Core.ReadChar()` and `Core.PrintChar()` for all I/O
- **Manual parsing**: Parses rotations character-by-character from stdin
- **JSON output**: Prints JSON character-by-character to stdout
- **Container execution**: Compiled with Bazel inside carbon-aoc:day1 container

### Carbon Language Limitations

Carbon is an experimental language (December 2025) with these limitations:

1. **No string type**: Must use character-by-character I/O with hex codes
2. **No standard library**: Only Core library available (`Core.ReadChar()`, `Core.PrintChar()`, `Core.EOF()`)
3. **No dynamic allocation**: Fixed-size arrays only
4. **Immutable parameters**: Function parameters cannot be reassigned
5. **No library imports**: Must inline all utility functions

### Implementation Approach

The Carbon implementation:
1. Reads input character-by-character from stdin
2. Parses rotations (L/R followed by integer distance)
3. Simulates dial rotation with modulo arithmetic
4. Counts zero crossings for both parts
5. Outputs JSON by printing each character individually

## Running the Solution

### Prerequisites

- Docker or Podman installed
- 4GB+ RAM allocated to container runtime
- Carbon container image built: `carbon-aoc:day1`

To build the container:
```bash
cd solutions/carbon
podman build -t carbon-aoc:day1 -f Dockerfile.minimal .
```

**Note:** Initial container build takes ~5 hours but is cached afterward.

### Using the Runner Script

```bash
# From project root
./scripts/runners/run_carbon.sh 1 challenges/day01/input-sample.txt

# Expected output: {"part1": 3, "part2": 6}
```

The script automatically:
1. Copies Carbon source into the container
2. Creates Bazel BUILD file
3. Compiles with Bazel
4. Runs the compiled binary with provided input
5. Returns JSON output

### Direct Container Execution

```bash
# From project root
podman run --rm \
  -v $(pwd)/solutions/carbon/day01:/host:Z \
  -v $(pwd)/challenges/day01:/input:Z \
  carbon-aoc:day1 bash -c "
    mkdir -p /opt/carbon-lang/examples/aoc2025/day01 &&
    cp /host/day01_simple.carbon /opt/carbon-lang/examples/aoc2025/day01/ &&
    cd /opt/carbon-lang/examples/aoc2025/day01 &&
    echo 'load(\"//bazel/carbon_rules:defs.bzl\", \"carbon_binary\")

carbon_binary(
    name = \"day01\",
    srcs = [\"day01_simple.carbon\"],
)' > BUILD &&
    cd /opt/carbon-lang &&
    ./scripts/run_bazelisk.py build --jobs=2 --local_ram_resources=3500 //examples/aoc2025/day01:day01 &&
    ./bazel-bin/examples/aoc2025/day01/day01 < /input/input-sample.txt
"
```

## Validation Results

### Sample Input
- Input: `challenges/day01/input-sample.txt`
- Expected: `{"part1": 3, "part2": 6}`
- Actual: `{"part1": 3, "part2": 6}`
- Status: **PASS** ✓

### Real Input
- Input: `challenges/day01/input.txt`
- Expected: `{"part1": 1097, "part2": 7101}`
- Actual: `{"part1": 1097, "part2": 7101}`
- Status: **PASS** ✓

## Performance

- Compilation time: ~2-3 minutes (with cached Bazel dependencies)
- Execution time: < 1 second
- Memory usage: < 100MB runtime
- Container overhead: ~2GB disk space for image

## Algorithm Verification

The implementation correctly simulates the dial rotation:

```
Start: 50
L68 → 82
L30 → 52
R48 → 0 (count=1)
L5  → 95
R60 → 55
L55 → 0 (count=2)
L1  → 99
L99 → 0 (count=3)
R14 → 14
L82 → 32

Final count: 3
```

## Cross-Language Consistency

The Carbon implementation produces identical results to other languages:
- Rust: `{"part1": 1097, "part2": 7101}` ✓
- Gleam: `{"part1": 1097, "part2": 7101}` ✓
- Roc: `{"part1": 1097, "part2": 7101}` ✓
- Carbon: `{"part1": 1097, "part2": 7101}` ✓

All implementations agree on both parts!

## Container Architecture

The containerized approach provides:

**Benefits:**
- Consistent build environment across all platforms
- No manual Carbon installation required on host system
- Reproducible builds with cached dependencies
- Isolated toolchain (Clang 19, Bazel 8.3.1)

**Container Details:**
- Base: Ubuntu 22.04
- Compiler: Clang 19
- Build tool: Bazelisk → Bazel 8.3.1
- Carbon location: `/opt/carbon-lang/`
- Memory constraint: 3.5GB for Bazel builds

## Implementation Notes

### Character-Based I/O

Carbon has no string type, so all I/O uses character codes:
- `0x4C` = 'L' (left)
- `0x52` = 'R' (right)
- `0x30`-`0x39` = '0'-'9' (digits)
- `0x2D` = '-' (minus sign)

### Parsing Strategy

Input parsing uses a state machine:
1. Skip whitespace (spaces, tabs, newlines)
2. Read direction character (L or R)
3. Read integer distance digit-by-digit
4. Repeat until EOF

### Modulo Arithmetic

Dial positions use modulo-100 arithmetic:
- Left rotation: `(position - distance) % 100`
- Right rotation: `(position + distance) % 100`
- Handle negative results: add 100 if result < 0

## Future Improvements

Potential enhancements:
- Pre-built container image hosted on Docker Hub
- Carbon unit testing when test framework available
- String type support when Carbon adds it
- Direct execution without Bazel overhead (if Carbon adds REPL/interpreter)

## References

- [Carbon Language](https://github.com/carbon-language/carbon-lang)
- [Carbon Documentation](docs/languages/carbon.md)
- [Runner Script](scripts/runners/run_carbon.sh)
