# Task Breakdown: Day 5 Part 1 Multi-Language AOC Solution

## Overview
Implement Day 5 Part 1 solution across all 4 languages (Rust, Gleam, Carbon, Bosque) following established patterns from Days 1-4. The problem involves parsing ingredient database files to determine which available ingredient IDs fall within fresh ingredient ID ranges.

**Total Tasks:** 21 tasks across 5 task groups
**Estimated Total Time:** 6-8 hours

## Task List

### Task Group 1: Rust Implementation
**Dependencies:** None
**Size Estimate:** 1.5-2 hours
**Assigned Role:** Backend Engineer (Rust specialist)

- [x] 1.0 Complete Rust day05 implementation
  - [x] 1.1 Write 4-6 focused unit tests for Rust implementation
    - Test range parsing: "3-5" should parse to start=3, end=5
    - Test ID parsing: "17" should parse to id=17
    - Test range checking: ID 5 is in range 3-5, ID 8 is not in range 3-5
    - Test overlapping ranges: ID 17 is fresh if in range 16-20 OR 12-18
    - Test sample input: Expected output part1=3
    - Test edge cases: IDs at range boundaries (optional but recommended)
  - [x] 1.2 Create main.rs with stdin reading pattern
    - Location: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/rust/day05/src/main.rs`
    - Reuse stdin reading from day01: `io::stdin().read_to_string(&mut input)`
    - Split input into two groups separated by blank line
    - Use i64 for all integer types (handles large IDs in billions)
  - [x] 1.3 Implement range parsing function
    - Parse "start-end" format by splitting on hyphen
    - Return Option<(i64, i64)> for start and end values
    - Validate that start <= end
    - Handle parse errors gracefully
  - [x] 1.4 Implement ID freshness checking function
    - Function signature: `fn is_fresh(id: i64, ranges: &[(i64, i64)]) -> bool`
    - Check if id falls within ANY range (range_start <= id <= range_end)
    - Use simple nested loop approach (don't optimize yet for Part 2)
    - Ranges are inclusive on both ends
  - [x] 1.5 Implement solve() function
    - Parse both groups: ranges and available IDs
    - For each available ID, check if it's fresh using is_fresh()
    - Count fresh ingredients and return count
    - Return (count, None) tuple for part1 and part2
  - [x] 1.6 Add JSON output with println!()
    - Format: `{"part1": <count>, "part2": null}`
    - Reuse pattern from day01: `println!("{{\"part1\": {}, \"part2\": null}}", count)`
  - [x] 1.7 Add error handling for invalid input
    - Output `{"part1": null, "part2": null}` on parse errors
    - Log specific errors to stderr
    - Exit with code 1 on failure
  - [x] 1.8 Run Rust unit tests to verify implementation
    - Command: `cd solutions/rust/day05 && cargo test`
    - Verify all 4-6 tests pass
    - Fix any failing tests before proceeding

**Acceptance Criteria:**
- All 4-6 unit tests pass
- Parses sample input correctly
- Outputs expected JSON format
- Handles large i64 integers for IDs
- Graceful error handling with stderr logging

---

### Task Group 2: Gleam Implementation
**Dependencies:** None (can run in parallel with Task Group 1)
**Size Estimate:** 1.5-2 hours
**Assigned Role:** Backend Engineer (Gleam specialist)

- [x] 2.0 Complete Gleam day05 implementation
  - [x] 2.1 Write 4-6 focused unit tests for Gleam implementation
    - Test range parsing: "3-5" should parse to #(3, 5)
    - Test ID parsing: "17" should parse to 17
    - Test range checking: ID 5 is in range #(3, 5), ID 8 is not
    - Test overlapping ranges: ID 17 is fresh if in multiple ranges
    - Test sample input: Expected output part1=3
    - Test edge cases: IDs at range boundaries (optional but recommended)
  - [x] 2.2 Create day05.gleam with file reading pattern
    - Location: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/gleam/day05/src/day05.gleam`
    - Note: Gleam reads from file path passed as argument (not stdin)
    - Reuse file reading from day01: `simplifile.read(path)`
    - Use Result type with case expressions for Ok/Error handling
  - [x] 2.3 Implement parse_range function
    - Parse "start-end" format using string.split()
    - Return Result(#(Int, Int), String) for tuple of start and end
    - Use int.parse() for string to Int conversion
    - Handle parse errors with descriptive error messages
  - [x] 2.4 Implement is_fresh function
    - Function signature: `pub fn is_fresh(id: Int, ranges: List(#(Int, Int))) -> Bool`
    - Use list.any() to check if id falls within any range
    - Ranges are inclusive: start <= id <= end
    - Use pattern matching for clean range checking
  - [x] 2.5 Implement solve function
    - Parse input into two groups using string.split("\n\n")
    - Parse ranges list and available IDs list
    - Use list.filter() with is_fresh to find fresh IDs
    - Return count using list.length()
  - [x] 2.6 Create build_json function
    - Format: `{"part1": <count>, "part2": null}`
    - Reuse pattern from day01 with string concatenation
    - Use int.to_string() for count conversion
  - [x] 2.7 Add error handling in main
    - Handle file read errors with case expressions
    - Handle parse errors with descriptive messages
    - Output error JSON on failures
  - [x] 2.8 Create test file and run Gleam tests
    - Location: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/gleam/day05/test/day05_test.gleam`
    - Import day05 module functions
    - Add all unit tests from 2.1
    - Command: `cd solutions/gleam && gleam test`
    - Verify all tests pass

**Acceptance Criteria:**
- All 4-6 unit tests pass
- Reads from file path argument (not stdin)
- Parses sample input correctly
- Outputs expected JSON format
- Proper Result type error handling
- Idiomatic Gleam code with pattern matching

---

### Task Group 3: Carbon Implementation
**Dependencies:** None (can run in parallel with Task Groups 1-2)
**Size Estimate:** 1.5-2 hours
**Assigned Role:** Backend Engineer (Carbon/Python specialist)

- [x] 3.0 Complete Carbon day05 implementation
  - [x] 3.1 Write 4-6 focused unit tests in Python
    - Location: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/carbon/day05/test_carbon_day05.py`
    - Test parse_range: "3-5" should return (3, 5)
    - Test parse_id: "17" should return 17
    - Test is_fresh: ID 5 is fresh in ranges [(3,5)], ID 8 is not
    - Test overlapping ranges: ID 17 is fresh in multiple ranges
    - Test sample input: Expected output part1=3
    - Follow pattern from day01 test file with run_all_tests() function
  - [x] 3.2 Create day05_simple.carbon file
    - Location: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/carbon/day05/day05_simple.carbon`
    - Define Carbon functions for algorithm logic
    - Follow structure from day04_simple.carbon
    - Use Int type (64-bit) for IDs
    - Document expected behavior in comments
  - [x] 3.3 Create runner.py wrapper for I/O
    - Location: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/carbon/day05/runner.py`
    - Read input from stdin: `sys.stdin.read()`
    - Implement parse_range() mirroring Carbon logic
    - Implement is_fresh() mirroring Carbon logic
    - Document which Carbon functions are mirrored in comments
  - [x] 3.4 Implement solve() function in runner.py
    - Split input into two groups by blank line
    - Parse ranges: list of (start, end) tuples
    - Parse available IDs: list of integers
    - For each ID, check if fresh using is_fresh()
    - Count and return fresh ingredients
  - [x] 3.5 Add JSON output in main()
    - Format: `{"part1": <count>, "part2": null}`
    - Use json.dumps() for formatting
    - Reuse pattern from day01 runner
  - [x] 3.6 Add error handling
    - Try/except block around all logic
    - Output `{"part1": null, "part2": null}` on errors
    - Log errors to stderr with print(..., file=sys.stderr)
    - Exit with code 1 on failure
  - [x] 3.7 Run Python unit tests
    - Command: `cd solutions/carbon/day05 && python3 test_carbon_day05.py`
    - Verify all 4-6 tests pass
    - Ensure test output shows pass/fail counts
  - [x] 3.8 Create README.md documenting implementation
    - Follow pattern from day01/day04 Carbon READMEs
    - Explain Python wrapper approach
    - Document test results
    - Include sample input/output

**Acceptance Criteria:**
- All 4-6 Python tests pass
- Carbon file documents algorithm logic
- Python runner mirrors Carbon functions
- Reads from stdin correctly
- Outputs expected JSON format
- Comprehensive error handling
- README documents approach

---

### Task Group 4: Bosque Implementation
**Dependencies:** None (can run in parallel with Task Groups 1-3)
**Size Estimate:** 1.5-2 hours
**Assigned Role:** Backend Engineer (Bosque/Python specialist)

- [x] 4.0 Complete Bosque day05 implementation
  - [x] 4.1 Write 4-6 focused unit tests in Python
    - Location: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/bosque/day05/test_bosque_day05.py`
    - Test parse_range: "3-5" should return (3, 5)
    - Test parse_id: "17" should return 17
    - Test is_fresh: ID 5 is fresh in ranges [(3,5)], ID 8 is not
    - Test overlapping ranges: ID 17 is fresh in multiple ranges
    - Test sample input: Expected output part1=3
    - Follow pattern from day01/day02 test files
  - [x] 4.2 Create solution.bsq with Bosque types
    - Location: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/bosque/day05/solution.bsq`
    - Define Bosque type signatures for all functions
    - Document algorithm in Bosque syntax
    - Use Int type for IDs (Bosque supports 64-bit integers)
    - Follow structure from day01/day02 solution.bsq files
  - [x] 4.3 Create runner.py wrapper
    - Location: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/bosque/day05/runner.py`
    - Read input from stdin: `sys.stdin.read()`
    - Mirror Bosque functions with docstring comments
    - Example: `Mirrors: function parseRange(line: String): {start: Int, end: Int}?`
  - [x] 4.4 Implement parse_range() mirroring Bosque
    - Parse "start-end" format
    - Return tuple (start, end) or None on error
    - Document Bosque function signature in comment
  - [x] 4.5 Implement is_fresh() mirroring Bosque
    - Check if ID falls within any range
    - Return boolean
    - Document Bosque function signature in comment
  - [x] 4.6 Implement solve() function
    - Process input and parse both groups
    - Count fresh ingredients
    - Return part1 count
    - Mirror Bosque solve signature
  - [x] 4.7 Add JSON output and error handling
    - Format: `{"part1": <count>, "part2": null}`
    - Use json.dumps() for output
    - Try/except with stderr logging
    - Exit with code 1 on errors
  - [x] 4.8 Run Python unit tests and create documentation
    - Command: `cd solutions/bosque/day05 && python3 test_bosque_day05.py`
    - Verify all 4-6 tests pass
    - Create README.md explaining Bosque algorithm
    - Optional: Create LIMITATIONS.md if Bosque has constraints

**Acceptance Criteria:**
- All 4-6 Python tests pass
- Bosque file documents algorithm with type signatures
- Python runner mirrors all Bosque functions
- Reads from stdin correctly
- Outputs expected JSON format
- Clear docstring comments showing Bosque mirrors
- README documents approach

---

### Task Group 5: Integration Testing & Validation
**Dependencies:** Task Groups 1, 2, 3, 4 (all language implementations must be complete)
**Size Estimate:** 1-1.5 hours
**Assigned Role:** QA Engineer / Integration Tester

- [x] 5.0 Complete integration testing across all languages
  - [x] 5.1 Create sample integration test script
    - Location: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/scripts/test_day05_sample.sh`
    - Test all 4 languages with sample input
    - Sample input: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day05/input-sample.txt`
    - Expected output: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day05/input-sample-expected-output.txt`
    - Compare actual output to expected output byte-for-byte
    - Report pass/fail for each language
  - [x] 5.2 Run sample integration tests for Rust
    - Command: `bash scripts/runners/run_rust.sh day05 challenges/day05/input-sample.txt`
    - Verify output: `{"part1": 3, "part2": null}`
    - Check exit code is 0
    - Verify execution time < 60 seconds
  - [x] 5.3 Run sample integration tests for Gleam
    - Command: `bash scripts/runners/run_gleam.sh day05 challenges/day05/input-sample.txt`
    - Verify output: `{"part1": 3, "part2": null}`
    - Check exit code is 0
    - Verify execution time < 60 seconds
  - [x] 5.4 Run sample integration tests for Carbon
    - Command: `bash scripts/runners/run_carbon.sh day05 challenges/day05/input-sample.txt`
    - Verify output: `{"part1": 3, "part2": null}`
    - Check exit code is 0
    - Verify execution time < 60 seconds
  - [x] 5.5 Run sample integration tests for Bosque
    - Command: `bash scripts/runners/run_bosque.sh day05 challenges/day05/input-sample.txt`
    - Verify output: `{"part1": 3, "part2": null}`
    - Check exit code is 0
    - Verify execution time < 60 seconds
  - [x] 5.6 Run full integration test with real input
    - Use existing test framework: `bash scripts/test_execution.sh`
    - Real input: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day05/input.txt`
    - Verify all 4 languages complete successfully
    - Check all exit codes are 0
    - Verify all outputs are valid JSON
    - Ensure all execute within 60 second timeout
  - [x] 5.7 Verify output consistency across languages
    - Compare part1 results from all 4 languages
    - All languages should produce identical part1 count
    - All languages should output `"part2": null`
    - Document any discrepancies if found
  - [x] 5.8 Create test summary report
    - Document all test results (unit + integration)
    - List any issues or failures encountered
    - Verify all acceptance criteria met
    - Confirm ready for Part 2 implementation

**Acceptance Criteria:**
- Sample integration tests pass for all 4 languages
- Full integration test passes for all 4 languages
- All languages produce identical results
- All languages execute within 60 second timeout
- Exit codes are 0 for all successful runs
- JSON output is valid and matches expected format
- Test summary report documents all results

---

## Execution Order

**Recommended implementation sequence:**

**Phase 1: Parallel Language Implementation (Tasks 1-4)**
- All 4 language implementations can be developed in parallel
- Each task group is independent and has no cross-dependencies
- Estimated time: 1.5-2 hours per language (can be parallelized)

**Phase 2: Integration Testing (Task 5)**
- Must wait for all 4 language implementations to complete
- Run sample tests first, then full integration
- Estimated time: 1-1.5 hours

**Total Sequential Time:** 3-3.5 hours (if parallelized)
**Total Serial Time:** 7.5-9.5 hours (if done sequentially)

---

## Testing Strategy

**Unit Testing (per language):**
- Write 4-6 focused tests covering core functionality
- Test parsing (ranges and IDs)
- Test range checking logic
- Test sample input with known expected output
- Run language-specific test command to verify

**Sample Integration Testing:**
- Test each language independently with sample input
- Verify output matches expected: `{"part1": 3, "part2": null}`
- Check exit codes and execution time

**Full Integration Testing:**
- Use existing test framework (`scripts/test_execution.sh`)
- Test with real input file
- Verify consistency across all 4 languages
- Ensure all pass within timeout constraints

**Test Progression:** Unit → Sample Integration → Full Integration

---

## Size Estimates

- **Task Group 1 (Rust):** 1.5-2 hours
- **Task Group 2 (Gleam):** 1.5-2 hours
- **Task Group 3 (Carbon):** 1.5-2 hours (COMPLETED)
- **Task Group 4 (Bosque):** 1.5-2 hours
- **Task Group 5 (Integration):** 1-1.5 hours

**Total:** 7.5-9.5 hours (serial) or 3-3.5 hours (parallel)

---

## Key Implementation Notes

**Input Format:**
- Two groups separated by blank line
- Group 1: Fresh ingredient ID ranges (format: "start-end")
- Group 2: Available ingredient IDs (single numbers, one per line)

**Algorithm Approach:**
- Parse ranges into list of (start, end) tuples
- Parse available IDs into list of integers
- For each ID, check if it falls within ANY range
- Use simple nested loop (don't optimize for Part 2)
- Ranges are inclusive on both ends

**Language-Specific Notes:**
- **Rust:** Use i64 for large IDs, stdin reading
- **Gleam:** Read from file path (not stdin), use Result types
- **Carbon:** Python wrapper with algorithm mirroring Carbon code
- **Bosque:** Python wrapper with Bosque type signatures documented

**Error Handling:**
- Output `{"part1": null, "part2": null}` on any errors
- Log specific errors to stderr
- Exit with non-zero code on failure

**Expected Results:**
- Sample input: `{"part1": 3, "part2": null}`
- Real input: Will be validated during integration testing
