# Specification: Day 3 Part 1 - Maximum Consecutive 2-Digit Pairs

## Goal
Implement a solution in Rust, Gleam, Carbon, and Bosque that parses lines of digit strings, extracts all consecutive 2-digit pairs, finds the maximum value from each line, and returns the sum of all maximums.

## User Stories
- As a developer, I want to implement idiomatic string processing in each language to demonstrate language-specific strengths in pattern matching and string manipulation
- As a developer, I want all four language implementations to produce identical results for cross-language validation

## Specific Requirements

**Parse Input Files**
- Read input from stdin (via run scripts piping file contents)
- Process line-by-line, trimming whitespace
- Handle sample input (4 lines) and real input (200 lines)
- Ignore empty lines if present

**Extract Consecutive 2-Digit Pairs**
- For each line, iterate through characters to extract all consecutive 2-digit substrings
- Example: "987654321111111" yields pairs: 98, 87, 76, 65, 54, 43, 32, 21, 11, 11, 11, 11, 11, 11
- Convert each 2-character substring to an integer
- Use idiomatic string slicing/iteration for each language

**Find Maximum Per Line**
- From all extracted pairs in a line, find the maximum value
- Line 1: "987654321111111" → max = 98
- Line 2: "811111111111119" → max = 89
- Line 3: "234234234234278" → max = 78
- Line 4: "818181911112111" → max = 92

**Calculate Sum Across All Lines**
- Sum the maximum values from all lines
- Sample input expected sum: 98 + 89 + 78 + 92 = 357
- Return result in JSON format: `{"part1": 357, "part2": null}`

**Rust Implementation**
- Create `solutions/rust/day03/src/main.rs` following Day 1/Day 2 structure
- Read from stdin using `std::io::stdin().read_to_string()`
- Use string slicing with windows or manual iteration for consecutive pairs
- Include inline `#[cfg(test)]` module with unit tests
- Output JSON format to stdout

**Gleam Implementation**
- Create `solutions/gleam/day03/src/day03.gleam` following Day 1 structure
- Use `string.to_graphemes()` or `string.slice()` for pair extraction
- Create separate test file `solutions/gleam/day03/test/day03_test.gleam`
- Use pattern matching and list operations idiomatically
- Output JSON format to stdout

**Carbon Implementation**
- Create `solutions/carbon/day03/day03.carbon` following Day 1 structure
- Use Carbon's string manipulation capabilities for pair extraction
- Include `runner.py` for execution wrapper
- Create separate Python test file following Day 1 pattern
- Output JSON format to stdout

**Bosque Implementation**
- Create `solutions/bosque/day03/solution.bsq` following Day 1 structure
- Use Bosque's string operations for parsing and extraction
- Include `runner.py` for execution wrapper
- Follow Bosque limitations as documented in Day 1 LIMITATIONS.md
- Output JSON format to stdout

**JSON Output Format**
- All implementations must output exactly: `{"part1": <number>, "part2": null}`
- Part 2 value must be null (not a placeholder number)
- Output must be valid JSON parseable by integration test script

**Use Execution Scripts**
- Rust: Execute via `./scripts/runners/run_rust.sh 3 input-sample`
- Gleam: Execute via `./scripts/runners/run_gleam.sh 3 input-sample`
- Carbon: Execute via `./scripts/runners/run_carbon.sh 3 input-sample`
- Bosque: Execute via `./scripts/runners/run_bosque.sh 3 input-sample`
- Scripts handle path resolution and input piping

## Visual Design

No visual assets provided.

## Existing Code to Leverage

**Day 1 and Day 2 Rust Implementations**
- Pattern for reading stdin: `io::stdin().read_to_string(&mut input)`
- Pattern for solve function returning tuple: `fn solve(input: &str) -> (i32, i32)`
- Pattern for JSON output: `println!("{{\"part1\": {}, \"part2\": {}}}", part1, part2)`
- Pattern for inline unit tests with `#[cfg(test)]` module and `#[test]` attributes
- Parse line-by-line using `.lines()` iterator

**Day 1 Gleam Implementation**
- Pattern for reading input and error handling with Result types
- Pattern for building JSON output: `build_json(part1: Int, part2: result) -> String`
- Pattern for separate test files in `test/` directory
- Use of `string.split()`, `string.trim()`, and list operations
- Idiomatic pattern matching with case expressions

**Day 1 Carbon and Bosque Structures**
- Python runner wrapper pattern for execution
- Separate Python test file pattern for Carbon
- File organization with README.md and LIMITATIONS.md for context
- Standard output format for JSON results

**Integration Test Script Pattern**
- Script at `./scripts/test_integration.sh` validates all languages produce same result
- Execute with day number: `./scripts/test_integration.sh 3`
- Compares JSON output from all four language implementations

**Code Isolation Requirement**
- Each day's code must be self-contained in its own directory
- Duplicate shared patterns from previous days rather than creating dependencies
- No imports or references between day directories

## Out of Scope
- Part 2 solution or future-proofing for Part 2
- Performance benchmarking or optimization beyond idiomatic code
- Theoretical edge cases not present in sample or real input files (e.g., single-character lines, non-numeric input)
- Direct code reuse or linking between day directories (must duplicate)
- Handling inputs with non-digit characters
- Processing files with more than 200 lines
- Creating shared libraries or utilities across days
- Input validation beyond basic empty line handling
- Error recovery strategies for malformed input
- Command-line argument parsing (use stdin only)
- Alternative output formats besides JSON
