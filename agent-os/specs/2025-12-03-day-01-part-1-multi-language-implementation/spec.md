# Specification: Day 01 Part 1 Multi-Language Implementation

## Goal
Implement the Advent of Code 2025 Day 1 Part 1 solution in all 5 languages (Rust, Gleam, Roc, Carbon, Bosque) with cross-language validation to ensure all implementations produce identical results.

## User Stories
- As a developer, I want to solve Part 1 of Day 1 in all 5 languages so that I can compare implementation approaches across different programming paradigms
- As a tester, I want cross-language validation to confirm all implementations produce the same answer so that I can trust the correctness of the solutions

## Specific Requirements

**Dial Rotation Simulation Logic**
- Start dial position at 50 on a circular dial numbered 0-99
- Parse rotation instructions from input file in format "L68" or "R48" (direction + distance)
- Process left rotations by subtracting distance from current position with modulo 100 wraparound
- Process right rotations by adding distance to current position with modulo 100 wraparound
- Count increments each time position equals 0 after processing a rotation
- Return final count as Part 1 answer

**Input File Handling**
- Read rotation instructions from `challenges/day01/input.txt` for actual puzzle input
- Read from `challenges/day01/input-sample.txt` for sample validation (expected answer: 3)
- Each line contains one rotation instruction (e.g., "L68", "R30", "R48")
- Parse direction (L or R) and numeric distance from each line
- Handle wraparound: position 5 with L10 becomes 95, position 95 with R10 becomes 5

**JSON Output Format**
- All implementations must output to stdout in JSON format: `{"part1": <answer>, "part2": null}`
- Part 2 value must be null since only Part 1 is implemented in this spec
- JSON format enables cross-language validator to parse and compare results programmatically
- Rust implementation already demonstrates this pattern with println macro formatting JSON

**Unit Testing per Language**
- Write unit tests for rotation logic using each language's native test framework
- Test left rotation with wraparound (e.g., position 5 subtract 10 wraps to 95)
- Test right rotation with wraparound (e.g., position 95 add 10 wraps to 5)
- Test counting when dial lands on 0 after rotation
- Test parsing of rotation instructions (direction and distance extraction)
- Tests must pass before running sample or real input validation

**Sample Data Validation**
- Validate each implementation against `input-sample.txt` containing the example sequence from problem statement
- Expected output is 3 (dial lands on 0 three times during the sequence)
- Run sample validation only after unit tests pass
- Sample must produce correct answer before proceeding to real input

**Cross-Language Validation**
- Execute all 5 language implementations against same input file
- Parse JSON output from each implementation
- Compare part1 values to ensure all languages produce identical answer
- Report any discrepancies between language implementations
- Only proceed to puzzle submission after all languages agree

**Language-Specific File I/O**
- Rust: Use std::fs::read_to_string with error handling via expect or Result
- Gleam: Use simplifile.read returning Result type for file operations
- Roc: Use File.readUtf8! with Path.fromStr for file reading
- Carbon: Implement file reading when Carbon's standard library supports it (may need workarounds)
- Bosque: Implement file reading when Bosque's runtime supports it (may need workarounds)

**Modular Arithmetic Implementation**
- Use modulo operator (% in most languages) for circular wraparound
- Left rotation: `(current_position - distance) % 100`
- Right rotation: `(current_position + distance) % 100`
- Handle negative modulo results for left rotation (may need adjustment depending on language)
- Ensure position always remains in valid range 0-99

**Directory Structure Requirements**
- Place implementations in existing structure: `challenges/day01/{language}/`
- Rust: `rust/day01/src/main.rs` (already exists with JSON output pattern)
- Gleam: `gleam/day01/src/day01.gleam` (already exists with file I/O pattern)
- Roc: `roc/day01/day01.roc` (already exists with file I/O pattern)
- Carbon: `carbon/day01/day01.carbon` (exists but needs implementation)
- Bosque: `bosque/day01/day01.bsq` (exists but needs implementation)

**Algorithm Correctness Validation**
- Manually trace through sample input sequence to verify logic correctness
- Sample sequence: L68, L30, R48, L5, R60, L55, L1, L99, R14, L82
- Expected trace: 50 → 82 → 52 → 0 (count=1) → 95 → 55 → 0 (count=2) → 99 → 0 (count=3) → 14 → 32
- Final count should be 3 matching expected output

## Existing Code to Leverage

**Rust JSON Output Pattern**
- Rust implementation already uses JSON output format: `println!("{{\"part1\": {}, \"part2\": {}}}", part1_result, part2_result)`
- This pattern should be replicated in other languages for consistency
- Format ensures cross-language validator can parse results uniformly

**Gleam File I/O Pattern**
- Gleam uses simplifile.read returning Result type for error handling
- Pattern: `simplifile.read(path)` with case expression for Ok/Error handling
- Demonstrates functional approach to file I/O that can inform other implementations

**Roc File I/O Pattern**
- Roc uses effects with exclamation mark syntax: `File.readUtf8! path_obj`
- Path creation: `Path.fromStr path` before reading file
- Shows Roc's unique approach to side effects

**Rust Command-Line Argument Handling**
- Rust implementation accepts input file path as command-line argument
- Falls back to default path if no argument provided
- This pattern enables running against sample or real input files flexibly

**Existing Test Framework Integration**
- Rust demonstrates #[cfg(test)] module with #[test] attributes for unit tests
- Cross-language validation scripts already exist in scripts/ directory
- Test discovery and execution infrastructure from Phase 0 can be reused

## Out of Scope
- Part 2 implementation (will be addressed in separate spec after Part 1 validation)
- Performance optimization or benchmarking (separate analysis phase planned)
- Graphical visualization of dial rotations
- Alternative input formats beyond line-by-line rotation instructions
- Interactive dial simulation or real-time visualization
- Comparative performance analysis between languages
- Handling of malformed input or error cases beyond basic file reading failures
- Support for dial sizes other than 0-99
- Support for starting positions other than 50
- Optimization for very large input files
