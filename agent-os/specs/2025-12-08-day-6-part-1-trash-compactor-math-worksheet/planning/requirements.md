# Spec Requirements: Day 6 Part 1 - Trash Compactor Math Worksheet

## Initial Description

Implement Day 6 Part 1 of Advent of Code 2025 across all 4 languages (Rust, Gleam, Carbon, Bosque). The challenge involves solving cephalopod math worksheets where problems are arranged horizontally as vertical columns of numbers with operation symbols at the bottom.

The puzzle input consists of multiple rows where:
- Each problem's numbers are arranged vertically in columns
- The bottom row contains the operation symbol (* or +)
- Problems are separated by columns of spaces
- Numbers can have varying alignment (left/right) within columns

The solution must:
1. Parse the horizontal worksheet into vertical problems
2. Extract numbers and operation symbols for each problem
3. Apply the operation (multiplication or addition) to each problem's numbers
4. Sum all individual problem answers to get the grand total

Example from problem statement:
```
123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +
```

This represents four problems:
- 123 * 45 * 6 = 33210
- 328 + 64 + 98 = 490
- 51 * 387 * 215 = 4243455
- 64 + 23 + 314 = 401

Grand total: 33210 + 490 + 4243455 + 401 = 4277556

## Requirements Discussion

### First Round Questions

**Q1: Parsing Strategy** - I assume we should parse the input line-by-line and treat each line as an array of strings (splitting on whitespace), creating an array of arrays. Should we use this approach or parse character-by-character to preserve exact column positions?

**Answer:** Split each line by one or more whitespace and have each row be an array, so you'd have an array of arrays.

**Q2: Number Extraction** - I'm thinking we should use regex to split on one or more whitespace characters, which automatically handles varying alignment. Should we trim whitespace from extracted strings before parsing to integers, or rely solely on the regex split?

**Answer:** Either trim whitespace or split on a regex, just ignore alignment.

**Q3: Column Separator Detection** - For identifying problem boundaries, I assume we detect empty columns (where all rows have whitespace/empty string at that position). Should we trim numbers before parsing or handle empty strings differently?

**Answer:** Trim numbers before parsing.

**Q4: Operation Symbol Parsing** - I'm assuming the operation symbol is always in the last row and will be a single character (* or +) at the start of the problem's column. Should we validate that only these two operations exist, or handle errors gracefully if unexpected symbols appear?

**Answer:** Yeah, last row and starts with an operator.

**Q5: Integer Overflow Handling** - For multiplication of large numbers (like 51 * 387 * 215 = 4243455), should we use 64-bit integers (i64 in Rust, equivalent in other languages) or implement arbitrary precision arithmetic? Should we check for overflow conditions?

**Answer:** Check for overflow but assume we can use 64-bit numbers. Open to other ideas depending on what a language has.

**Q6: Cross-Language Validation** - Should we validate that all 4 language implementations produce identical results using the existing test_integration.sh script with --sample flag first, then with real input?

**Answer:** Use scripts/test_integration.sh to validate across languages - it has a sample flag already.

**Q7: Error Handling** - For invalid input formats (non-numeric values, missing operation symbols, malformed lines), should we return an error, skip invalid problems, or make assumptions about defaults? What edge cases should we handle?

**Answer:** We have challenges/day06/input.txt and challenges/day06/input-sample.txt so we only need to handle those cases.

**Q8: Testing Approach** - Should we write unit tests for parsing functions, integration tests for sample input (expected: 4277556), and then validate against real input? What's the expected JSON output format?

**Answer:** Yes, unit test based on problem statement, integration test sample, then integration test real input.

**Q9: Out of Scope** - I assume Part 2 of Day 6 will be a separate specification. Should this spec only focus on Part 1, outputting JSON in format: `{"part1": <answer>, "part2": null}`?

**Answer:** Part 2 is another spec.

**Q10: Existing Code Patterns** - Are there similar parsing problems from previous days (Day 1-5) that we should reference for input handling patterns, JSON output format, or error handling approaches?

**Answer:** See docs/languages/<language>.md for the respective language. Look for examples in other days and copy into this day's code.

**Q11: Visual Assets** - Do you have any design mockups, wireframes, or screenshots that could help guide the development?

**Answer:** None.

### Existing Code to Reference

**Similar Features Identified:**
- Feature: Previous day implementations (Days 1-5)
- Path: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/<language>/day01-day05/`
- Language-specific patterns documented in: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/docs/languages/rust.md`, `gleam.md`, `carbon.md`, `bosque.md`
- Input reading: All previous days read from stdin
- Output format: JSON with `{"part1": <value>, "part2": null}` format (reference: `solutions/rust/day05/src/main.rs`)
- Error handling: Return null values and exit code 1 on errors

**Reusable Patterns:**
- Stdin input reading (from all previous days)
- JSON output format (from all previous days)
- Error handling with eprintln! and process::exit(1) in Rust
- Line-by-line parsing patterns
- Cross-language validation via `scripts/test_integration.sh --sample` flag

### Follow-up Questions

No follow-up questions needed - all requirements are clear and comprehensive.

## Visual Assets

### Files Provided:
No visual files found.

### Visual Insights:
No visual assets provided.

## Requirements Summary

### Functional Requirements

**Input Processing:**
- Read puzzle input from stdin
- Parse input line-by-line, splitting on one or more whitespace characters
- Create array of arrays (rows) where each row contains strings/numbers
- Trim whitespace from numbers before parsing

**Problem Identification:**
- Identify vertical problems by detecting columns
- Each problem consists of vertically stacked numbers
- Problems are separated by empty columns (all whitespace)
- Last row contains operation symbols (* or +)

**Calculation Logic:**
- Extract numbers from each column (ignoring alignment)
- Identify operation symbol from last row of each column
- Apply operation to all numbers in the column:
  - Multiplication (*): multiply all numbers together
  - Addition (+): sum all numbers together
- Handle 64-bit integers (check for overflow but assume 64-bit is sufficient)
- Calculate grand total by summing all individual problem answers

**Output:**
- Return JSON format: `{"part1": <grand_total>, "part2": null}`
- Print to stdout
- On error: output `{"part1": null, "part2": null}` and exit with code 1
- Error messages go to stderr

**Cross-Language Implementation:**
- Implement identical logic in all 4 languages: Rust, Gleam, Carbon, Bosque
- All implementations must produce identical results
- Follow language-specific idioms and conventions per docs/languages/*.md

### Reusability Opportunities

**Components that exist already:**
- Stdin reading patterns (all previous days)
- JSON output formatting (all previous days)
- Line-based parsing (Days 1-5)
- Error handling with stderr and exit codes (Day 5 example)
- Testing framework integration (scripts/test_integration.sh)

**Backend patterns to investigate:**
- String splitting and parsing utilities
- Integer parsing with error handling
- Array/list manipulation for 2D data structures

**Similar features to model after:**
- Day 5: stdin reading, JSON output, error handling
- Days 1-4: parsing patterns and testing approaches
- All previous days: cross-language validation workflow

### Scope Boundaries

**In Scope:**
- Parse horizontal math worksheet into vertical problems
- Extract numbers and operation symbols from columnar format
- Handle left/right alignment variations by trimming
- Support multiplication (*) and addition (+) operations
- Calculate individual problem answers
- Sum all answers for grand total
- Output JSON format with part1 result
- Implement in all 4 languages (Rust, Gleam, Carbon, Bosque)
- Unit tests for parsing and calculation functions
- Integration tests with sample input (expected: 4277556)
- Integration tests with real puzzle input
- Cross-language validation via test_integration.sh

**Out of Scope:**
- Day 6 Part 2 implementation (separate spec)
- Arbitrary precision arithmetic (use 64-bit integers)
- Handling input files beyond challenges/day06/input.txt and input-sample.txt
- Additional operation symbols beyond * and +
- Interactive or GUI components
- Performance optimization beyond baseline correctness

### Technical Considerations

**Integration Points:**
- Input files: `challenges/day06/input.txt` and `challenges/day06/input-sample.txt`
- Expected output file: `challenges/day06/input-sample-expected-output.txt` (contains: `{"part1": 4277556, "part2": null}`)
- Testing script: `scripts/test_integration.sh` with `--sample` flag for sample input
- Output location: Solutions in `solutions/<language>/day06/` following existing directory patterns

**Existing System Constraints:**
- Must read from stdin (all solutions use this pattern)
- Must output JSON to stdout in format: `{"part1": <value>, "part2": null}`
- Must write errors to stderr
- Must exit with code 1 on errors, code 0 on success
- Must follow language-specific project structure conventions from tech-stack.md

**Technology Preferences:**
- Rust: Use std::io for stdin, std::process::exit for error codes
- Gleam: Use simplifile for I/O, gleam_stdlib for parsing
- Carbon: Follow experimental tooling patterns as available
- Bosque: Use built-in I/O and verification features as available
- All languages: Use native string splitting and integer parsing

**Similar Code Patterns to Follow:**
- Reference `solutions/rust/day05/src/main.rs` for stdin reading and JSON output
- Reference `docs/languages/rust.md`, `gleam.md`, `carbon.md`, `bosque.md` for language-specific patterns
- Copy input handling and error patterns from Days 1-5
- Use 64-bit integers: i64 (Rust), Int (Gleam), equivalent in Carbon/Bosque
- Follow existing testing patterns with unit tests + integration tests

**Testing Requirements:**
- Unit tests for parsing functions (splitting lines, extracting numbers, detecting columns)
- Unit tests for calculation logic (apply operation, sum results)
- Integration test with sample input validates expected output: 4277556
- Integration test with real input produces consistent answer across all 4 languages
- Use `scripts/test_integration.sh 6 --sample` for sample validation
- Use `scripts/test_integration.sh 6` for real input validation
