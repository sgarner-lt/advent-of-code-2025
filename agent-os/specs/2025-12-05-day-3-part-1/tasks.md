# Task Breakdown: Day 3 Part 1 - Maximum Consecutive 2-Digit Pairs

## Overview
Total Tasks: ~32 sub-tasks across 5 major task groups
Estimated Completion: 2-3 hours for all 4 languages

## Algorithm Summary
Parse lines of digit strings from stdin, extract all consecutive 2-digit pairs from each line (e.g., "987" yields "98" and "87"), find the maximum value per line, sum all maximums, and output JSON: `{"part1": <answer>, "part2": null}`.

**Sample Input Validation:**
- File: `challenges/day03/input-sample.txt` (4 lines)
- Line 1: "987654321111111" → max pair: 98
- Line 2: "811111111111119" → max pair: 89
- Line 3: "234234234234278" → max pair: 78
- Line 4: "818181911112111" → max pair: 92
- Expected sum: 357

## Task List

### Task Group 1: Setup and Input Preparation
**Dependencies:** None
**Parallel Execution:** All sub-tasks can be done independently

This group ensures all input files and directory structures are ready before implementation begins.

- [x] 1.0 Verify setup and input files
  - [x] 1.1 Verify challenge input files exist
    - Confirm `challenges/day03/input-sample.txt` exists with 4 lines
    - Confirm `challenges/day03/input.txt` exists with 200 lines
    - No creation needed - files should already exist from challenge setup
  - [x] 1.2 Verify execution scripts are in place
    - Confirm `scripts/runners/run_rust.sh` exists
    - Confirm `scripts/runners/run_gleam.sh` exists
    - Confirm `scripts/runners/run_carbon.sh` exists
    - Confirm `scripts/runners/run_bosque.sh` exists
    - Confirm `scripts/test_integration.sh` exists
  - [x] 1.3 Verify solution directory structure
    - Confirm `solutions/rust/day03/` exists with Cargo.toml
    - Confirm `solutions/gleam/day03/` exists
    - Confirm `solutions/carbon/day03/` exists
    - Confirm `solutions/bosque/day03/` exists

**Acceptance Criteria:**
- All input files are accessible and contain expected line counts
- All execution scripts are present and executable
- All language-specific directories exist

---

### Task Group 2: Rust Implementation
**Dependencies:** Task Group 1 (COMPLETED)
**Parallel Execution:** Can be done in parallel with other language implementations (Groups 3-5)

Implement solution in Rust using idiomatic string slicing and iteration patterns.

- [x] 2.0 Implement Rust solution
  - [x] 2.1 Write 2-8 focused unit tests in inline test module
    - Test consecutive pair extraction (e.g., "987" yields [98, 87, 76])
    - Test finding maximum from a list of pairs
    - Test sample input line (e.g., "987654321111111" yields max 98)
    - Test complete sample input expecting sum of 357
    - Use `#[cfg(test)]` module and `#[test]` attributes
    - Focus on critical behaviors only - not exhaustive edge cases
  - [x] 2.2 Create main function with stdin reading
    - Read from stdin using `io::stdin().read_to_string(&mut input)`
    - Call solve function and destructure result tuple
    - Output JSON format: `println!("{{\"part1\": {}, \"part2\": null}}")`
    - Follow pattern from Day 1 and Day 2 implementations
  - [x] 2.3 Implement solve function
    - Function signature: `fn solve(input: &str) -> i32`
    - Parse input line by line using `.lines()`
    - For each non-empty trimmed line, extract consecutive pairs
    - Find maximum pair per line and accumulate sum
    - Return final sum
  - [x] 2.4 Implement helper functions
    - `fn extract_pairs(line: &str) -> Vec<i32>` using string slicing
    - Use windowing or manual iteration with `line[i..i+2]` slicing
    - Parse each 2-character substring to integer
    - Handle empty lines gracefully
  - [x] 2.5 Run Rust unit tests only
    - Execute: `cd solutions/rust/day03 && cargo test`
    - Verify ONLY the 2-8 tests written in 2.1 pass
    - Do NOT run integration tests yet
  - [x] 2.6 Test with sample input via runner script
    - Execute: `./scripts/runners/run_rust.sh 3 input-sample`
    - Verify output: `{"part1": 357, "part2": null}`
    - Confirm JSON is valid and parseable
  - [x] 2.7 Test with real input via runner script
    - Execute: `./scripts/runners/run_rust.sh 3`
    - Verify output is valid JSON format
    - Record answer for cross-validation later

**Acceptance Criteria:**
- 2-8 unit tests pass
- Sample input produces correct answer (357)
- Real input produces valid JSON output
- Code follows Rust idioms (ownership, error handling, iterators)

---

### Task Group 3: Gleam Implementation
**Dependencies:** Task Group 1
**Parallel Execution:** Can be done in parallel with other language implementations (Groups 2, 4, 5)

Implement solution in Gleam using functional patterns and immutable data structures.

- [x] 3.0 Implement Gleam solution
  - [x] 3.1 Write 2-8 focused unit tests in separate test file
    - Create `solutions/gleam/test/day03_test.gleam`
    - Test parse_line function for extracting pairs
    - Test find_max function with list of integers
    - Test process_line for single line returning maximum
    - Test complete solve function with sample input
    - Use Gleam's test framework and assertions
    - Limit to critical behaviors only
  - [x] 3.2 Create main function in day03.gleam
    - Read from stdin (following Day 1 pattern with simplifile reading /dev/stdin)
    - Call solve function and handle Result type
    - Build JSON output using helper function
    - Print to stdout with `io.println(json)`
  - [x] 3.3 Implement solve function
    - Function signature: `pub fn solve(input: String) -> Result(Int, String)`
    - Split input by newlines using `string.split(input, "\n")`
    - Filter empty lines with `list.filter`
    - Map each line to extract pairs and find max
    - Use `list.fold` to sum maximums
    - Return Result type for error handling
  - [x] 3.4 Implement helper functions
    - `pub fn extract_pairs(line: String) -> List(Int)` using string.to_graphemes
    - Use recursive helper with pattern matching
    - `pub fn find_max(pairs: List(Int)) -> Result(Int, String)` using recursive pattern
    - `fn build_json(part1: Int) -> String` for JSON formatting
  - [x] 3.5 Run Gleam unit tests only
    - Execute: `cd solutions/gleam && gleam test`
    - Verify ONLY the 8 tests written in 3.1 pass
    - Do NOT run integration tests yet
  - [x] 3.6 Test with sample input via runner script
    - Execute: `./scripts/runners/run_gleam.sh 3 challenges/day03/input-sample.txt`
    - Verify output: `{"part1": 357, "part2": null}`
    - Confirm JSON matches expected format
  - [x] 3.7 Test with real input via runner script
    - Execute: `./scripts/runners/run_gleam.sh 3 challenges/day03/input.txt`
    - Verify output is valid JSON format
    - Record answer for cross-validation: <REDACTED>

**Acceptance Criteria:**
- 8 unit tests pass
- Sample input produces correct answer (357)
- Real input produces valid JSON output (<REDACTED>)
- Code uses idiomatic Gleam patterns (pattern matching, pipelines, Result types)

---

### Task Group 4: Carbon Implementation
**Dependencies:** Task Group 1 (COMPLETED)
**Parallel Execution:** Can be done in parallel with other language implementations (Groups 2, 3, 5)

Implement solution in Carbon with Python runner wrapper following project patterns.

- [x] 4.0 Implement Carbon solution
  - [x] 4.1 Write 2-8 focused unit tests in separate Python test file
    - Create `solutions/carbon/day03/test_carbon_day03.py`
    - Test pair extraction logic
    - Test maximum finding for single line
    - Test complete solution with sample input
    - Use Python's unittest or pytest framework
    - Follow Day 1 Carbon test patterns
  - [x] 4.2 Create Carbon source file
    - Create `solutions/carbon/day03/day03.carbon`
    - Implement main function that reads stdin
    - Process input line by line
    - Output JSON to stdout
    - Follow Carbon syntax and conventions from Day 1
  - [x] 4.3 Implement core algorithm in Carbon
    - Define function to extract consecutive 2-digit pairs
    - Use Carbon's string manipulation capabilities
    - Implement maximum finding logic
    - Sum maximums across all lines
  - [x] 4.4 Create Python runner wrapper
    - Create `solutions/carbon/day03/runner.py`
    - Follow Day 1 runner pattern exactly
    - Accept stdin and pass to Carbon executable
    - Capture stdout and return JSON output
    - Handle execution errors gracefully
  - [x] 4.5 Run Carbon unit tests only
    - Execute: `cd solutions/carbon/day03 && python3 test_carbon_day03.py`
    - Verify ONLY the 11 tests written in 4.1 pass
    - Do NOT run integration tests yet
  - [x] 4.6 Test with sample input via runner script
    - Execute: `./scripts/runners/run_carbon.sh 3 challenges/day03/input-sample.txt`
    - Verify output: `{"part1": 357, "part2": null}`
    - Ensure runner.py correctly bridges Carbon and shell script
  - [x] 4.7 Test with real input via runner script
    - Execute: `./scripts/runners/run_carbon.sh 3 challenges/day03/input.txt`
    - Verify output is valid JSON format
    - Record answer for cross-validation: <REDACTED>

**Acceptance Criteria:**
- 11 unit tests pass
- Sample input produces correct answer (357)
- Real input produces valid JSON output (<REDACTED>)
- Python runner correctly wraps Carbon execution
- Code follows Carbon language conventions

---

### Task Group 5: Bosque Implementation
**Dependencies:** Task Group 1
**Parallel Execution:** Can be done in parallel with other language implementations (Groups 2, 3, 4)

Implement solution in Bosque with Python runner, considering Bosque's limitations documented in LIMITATIONS.md.

- [x] 5.0 Implement Bosque solution
  - [x] 5.1 Write 2-8 focused unit tests (if Bosque supports testing)
    - Research Bosque's testing capabilities from Day 1 LIMITATIONS.md
    - If native testing unavailable, create Python test file
    - Test core algorithm logic through runner.py
    - Test sample input expecting 357
    - Follow Day 1 Bosque testing approach
  - [x] 5.2 Create Bosque source file
    - Create `solutions/bosque/day03/solution.bsq`
    - Implement entry point that reads stdin
    - Process input line by line
    - Output JSON to stdout
    - Follow Bosque syntax from Day 1 implementation
  - [x] 5.3 Implement core algorithm in Bosque
    - Define function to extract consecutive 2-digit pairs
    - Use Bosque's string operations (check LIMITATIONS.md for constraints)
    - Implement maximum finding using available Bosque primitives
    - Sum maximums across all lines
    - Work within Bosque's type system and limitations
  - [x] 5.4 Create Python runner wrapper
    - Create or update `solutions/bosque/day03/runner.py`
    - Follow Day 1 runner pattern exactly
    - Accept stdin and pass to Bosque interpreter
    - Capture stdout and return JSON output
    - Handle Bosque-specific execution quirks
  - [x] 5.5 Run Bosque tests
    - Execute tests as defined in 5.1 (may be runner-based)
    - Verify core logic produces expected results
    - Do NOT run integration tests yet
  - [x] 5.6 Test with sample input via runner script
    - Execute: `./scripts/runners/run_bosque.sh 3 input-sample`
    - Verify output: `{"part1": 357, "part2": null}`
    - Ensure runner.py correctly bridges Bosque and shell script
  - [x] 5.7 Test with real input via runner script
    - Execute: `./scripts/runners/run_bosque.sh 3`
    - Verify output is valid JSON format
    - Record answer for cross-validation

**Acceptance Criteria:**
- Tests pass (following Bosque's testing approach)
- Sample input produces correct answer (357)
- Real input produces valid JSON output
- Python runner correctly wraps Bosque execution
- Code respects Bosque limitations from LIMITATIONS.md

---

### Task Group 6: Cross-Language Validation and Integration
**Dependencies:** Task Groups 2, 3, 4, 5 (all language implementations)
**Sequential Execution:** Must complete after all languages are implemented

Validate that all implementations produce identical results and meet integration requirements.

- [x] 6.0 Validate cross-language consistency
  - [x] 6.1 Run integration test with sample input
    - Execute: `./scripts/test_integration.sh 3 --sample`
    - Verify all 4 languages produce identical output: 357
    - Check that test script confirms "all languages agree"
    - Review generated markdown report at `test_results.md`
  - [x] 6.2 Run integration test with real input
    - Execute: `./scripts/test_integration.sh 3`
    - Verify all 4 languages produce identical JSON output
    - Confirm answers match across Rust, Gleam, Carbon, and Bosque
    - Check test script exit code is 0 (success)
  - [x] 6.3 Review and verify output consistency
    - Compare recorded answers from each language (from tasks 2.7, 3.7, 4.7, 5.7)
    - Ensure JSON format is identical across all implementations
    - Verify part2 field is null (not a number or missing)
    - Confirm no language-specific formatting differences
  - [x] 6.4 Verify execution script compatibility
    - Test each runner script independently with both input types
    - Confirm scripts correctly pipe input from challenge directory
    - Verify timeout handling and error reporting
    - Check that scripts work from any directory (use absolute paths)
  - [x] 6.5 Documentation spot-check
    - Verify each language directory has necessary files
    - Rust: Cargo.toml, src/main.rs with inline tests
    - Gleam: src/day03.gleam, test/day03_test.gleam
    - Carbon: day03.carbon, runner.py, test file
    - Bosque: solution.bsq, runner.py, LIMITATIONS.md reference
  - [x] 6.6 Final validation run
    - Execute: `./scripts/test_integration.sh 3 --verbose`
    - Review verbose output for any warnings or anomalies
    - Confirm all languages complete within timeout (default 60s)
    - Verify final report shows all green/passing status

**Acceptance Criteria:**
- Integration test passes with exit code 0
- All 4 languages produce identical answers for both sample and real input
- JSON output format is consistent across all implementations
- Generated test report shows 100% agreement between languages
- No errors or warnings in verbose test output

---

## Execution Strategy

### Parallel Implementation Phase
**Groups 2, 3, 4, 5 can be executed in parallel** since each language implementation is independent. This allows for efficient use of resources:
- Assign different engineers to different languages
- Or implement one language completely, then move to next
- All must complete before Group 6

### Sequential Validation Phase
**Group 6 must execute sequentially** after all implementations are complete:
1. First validate sample input (known answer: 357)
2. Then validate real input (unknown answer, but must match across languages)
3. Finally perform comprehensive cross-validation

### Testing Philosophy
- Each language group writes **only 2-8 focused tests** during implementation
- Tests cover critical behaviors: pair extraction, max finding, complete sample
- No exhaustive edge case testing during development
- Integration tests in Group 6 provide final validation
- Focus on getting correct answer, not comprehensive coverage

### Recommended Order (if not parallelizing)
1. **Setup** (Group 1) - 15 minutes
2. **Rust** (Group 2) - 45 minutes (most mature tooling)
3. **Gleam** (Group 3) - 45 minutes (functional approach)
4. **Carbon** (Group 4) - 60 minutes (may require Python bridge debugging)
5. **Bosque** (Group 5) - 60 minutes (experimental language, may have limitations)
6. **Validation** (Group 6) - 30 minutes

Total estimated time: 3-4 hours

---

## Language-Specific Patterns to Follow

### Rust Patterns (from Day 1 & Day 2)
- Use `io::stdin().read_to_string(&mut input)` for input
- Implement `fn solve(input: &str) -> i32` as core logic
- Use `.lines()` iterator for line-by-line processing
- String slicing: `&line[i..i+2]` for consecutive pairs
- Inline tests with `#[cfg(test)]` and `#[test]` attributes
- JSON output: `println!("{{\"part1\": {}, \"part2\": null}}", result)`

### Gleam Patterns (from Day 1)
- Use `simplifile.read("/dev/stdin")` for input from stdin
- Implement `pub fn solve(input: String) -> Result(Int, String)`
- Use `string.split()` and `list.filter()` for parsing
- String processing: `string.to_graphemes()` for character lists
- Pattern matching with `case` expressions
- Separate test file in `test/` directory
- JSON builder: `fn build_json(part1: Int) -> String`
- Run with `gleam run -m day03` to specify module

### Carbon Patterns (from Day 1)
- Implement main logic in `.carbon` file
- Create `runner.py` to bridge Carbon and shell scripts
- Python runner reads stdin, passes to Carbon executable
- Separate Python test file: `test_carbon_day03.py`
- Follow Carbon syntax for string operations
- Return JSON string from Carbon program

### Bosque Patterns (from Day 1)
- Implement logic in `solution.bsq`
- Create `runner.py` wrapper following Day 1 pattern
- Check LIMITATIONS.md for string operation constraints
- May have limited standard library - work within constraints
- Python runner handles stdin/stdout bridge
- Testing may be done through runner rather than natively

---

## Critical Success Factors

1. **Code Isolation**: Each day's code is self-contained - duplicate patterns from Day 1/2, don't link
2. **Idiomatic Code**: Use each language's strengths for string processing
3. **Identical Output**: All languages must produce exact same JSON format and answers
4. **Sample First**: Always validate with sample input (357) before running real input
5. **Minimal Tests**: Write only 2-8 tests per language during implementation
6. **JSON Format**: Must be `{"part1": <number>, "part2": null}` - note null, not a number
7. **Runner Scripts**: Always use `./scripts/runners/run_<language>.sh` for execution
8. **Integration Last**: Only run cross-language validation after all implementations complete

---

## Notes

- Real input answer is <REDACTED> (verified by Rust, Gleam, Carbon, and Bosque implementations)
- Each language's string processing approach will differ - embrace idiomatic patterns
- Carbon and Bosque may require more time due to less mature tooling
- Integration test script provides authoritative validation
- Generated test report will highlight any discrepancies between languages
