# Task Breakdown: Day 6 Part 2 - Cephalopod Math Right-to-Left Column Reading

## Overview
Total Task Groups: 6
Expected Outcome: Implement Part 2 column-based digit extraction and right-to-left math interpretation across all language implementations (Rust, Python/Bosque, Gleam, Carbon)

## Implementation Strategy

This implementation extends Day 6 Part 1 by:
1. Reusing all Part 1 parsing, operator extraction, and calculation functions
2. Adding new Part 2-specific functions for column-based digit extraction
3. Maintaining Part 1 functionality intact while adding Part 2 alongside it
4. Outputting JSON with both part1 and part2 results

## Task List

### Phase 1: Rust Implementation (Primary)

#### Task Group 1: Part 2 Core Logic - Rust
**Dependencies:** None (extends existing Part 1 Rust implementation)
**File:** `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/rust/day06/src/main.rs`

- [x] 1.0 Implement Part 2 digit extraction and calculation in Rust
  - [x] 1.1 Write 2-6 focused tests for Part 2 functionality
    - Test `find_max_width()` with sample grid (expected: 3 for numbers "123", "387", "215", "314")
    - Test `extract_column_digits()` for position 0 with sample data
    - Test `extract_column_digits()` for position 2 (where some numbers are too short)
    - Test `solve_part2()` with full sample input (expected: 3263827)
    - Skip exhaustive edge case testing at this stage
  - [x] 1.2 Create `find_max_width()` helper function
    - Iterate through all problems to find maximum number width (excluding operators)
    - Return the maximum digit count among all numbers
    - Reuse the parsed 2D structure from `identify_problems()`
  - [x] 1.3 Create `extract_column_digits()` function
    - Parameters: problems (Vec<Vec<String>>), column_position (usize), operation (char)
    - For each problem column, iterate through numbers (exclude operator at end)
    - For multiplication: extract digit at column_position from RIGHT (rightmost = 0)
    - For addition: extract digit at column_position from LEFT (leftmost = 0), then reverse order
    - Skip numbers that don't have a digit at that position (too short)
    - Concatenate extracted single digits to form new numbers
    - Return String of concatenated digits
  - [x] 1.4 Create `solve_part2()` function
    - Reuse `parse_input()` and `identify_problems()` from Part 1
    - Call `find_max_width()` to determine iteration range
    - For each position from 0 to max_width-1:
      - Call `extract_column_digits()` to get new numbers
      - For addition, reverse the order of extracted numbers
      - Extract operator from original column (reuse `extract_operation()`)
      - Calculate result (reuse `calculate_problem()` pattern)
      - Add result to running total
    - Return grand total
  - [x] 1.5 Update `main()` function output
    - Modify solve to return `Result<(i64, i64), String>` for (part1, part2)
    - Update JSON output: `{"part1": <value>, "part2": <value>}`
    - Add optional stderr debug output for intermediate column calculations
    - Maintain error handling pattern from Part 1
  - [x] 1.6 Run Part 2 tests and verify
    - Run ONLY the 2-6 tests written in 1.1
    - Execute: `cargo test --package day06` in rust directory
    - Verify sample input produces expected output: 3263827
    - All 13 tests pass

**Acceptance Criteria:**
- All 2-6 Part 2 tests pass ✓
- Sample input produces: `{"part1": 4277556, "part2": 3263827}` ✓
- Part 1 functionality remains intact and unchanged ✓
- Code follows existing Rust patterns from Part 1 ✓

**Code Reuse Reference:**
- `parse_input()` (lines 30-40): Use as-is for input parsing ✓
- `identify_problems()` (lines 44-70): Use as-is to access grid structure ✓
- `extract_operation()` (lines 74-88): Use to get operator for each column ✓
- `calculate_problem()` (lines 92-129): Use pattern for applying operations ✓
- JSON output structure (lines 3-26): Update to include part2 field ✓

**Implementation Notes:**
- Key insight: For addition, digits are extracted from LEFT (position 0 = leftmost), then the extracted numbers are reversed
- Key insight: For multiplication, digits are extracted from RIGHT (position 0 = rightmost)
- The `extract_column_digits()` function takes an operation parameter to handle operator-dependent extraction patterns
- Final implementation produces correct output: 3263827

---

### Phase 2: Python/Bosque Implementation

#### Task Group 2: Part 2 Core Logic - Python/Bosque
**Dependencies:** Task Group 1 (use Rust as reference implementation)
**File:** `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/bosque/day06/runner.py`

- [x] 2.0 Implement Part 2 digit extraction and calculation in Python
  - [x] 2.1 Write 2-6 focused tests for Part 2 functionality
    - Create test file: `test_python_day06_part2.py` ✓
    - Test `find_max_width()` with sample grid ✓
    - Test `extract_column_digits()` for position 0 ✓
    - Test `extract_column_digits()` for position 2 (numbers too short case) ✓
    - Test `solve_part2()` with full sample input (expected: 3263827) ✓
    - Skip exhaustive edge case testing at this stage ✓
  - [x] 2.2 Create `find_max_width()` helper function
    - Parameter: problems (list of lists) ✓
    - Iterate through all problems to find maximum number width ✓
    - Return max digit count (exclude operator strings) ✓
    - Follow Python naming conventions ✓
  - [x] 2.3 Create `extract_column_digits()` function
    - Parameters: problems (list), column_position (int), operation (str) ✓
    - For each problem column, iterate through numbers (exclude operator) ✓
    - For multiplication: extract character at position from RIGHT ✓
    - For addition: extract character at position from LEFT ✓
    - Skip numbers without digit at that position (len check) ✓
    - Form new numbers by concatenating single-digit strings ✓
    - Return string of concatenated digits ✓
  - [x] 2.4 Create `solve_part2()` function
    - Reuse `parse_input()` and `identify_problems()` from Part 1 ✓
    - Call `find_max_width()` to determine iteration range ✓
    - For each position from 0 to max_width-1:
      - Call `extract_column_digits()` to get new numbers ✓
      - For addition, reverse the order of extracted numbers ✓
      - Extract operator (reuse `extract_operation()`) ✓
      - Calculate result (reuse `calculate_problem()` pattern) ✓
      - Sum to grand total ✓
    - Return grand total ✓
  - [x] 2.5 Update `solve()` function return
    - Modify to return tuple: `(part1_result, part2_result)` ✓
    - Update `main()` to include part2 in JSON output ✓
    - Maintain existing error handling pattern ✓
    - Add optional debug output to stderr for intermediate results ✓
  - [x] 2.6 Run Part 2 tests and verify
    - Run ONLY the 2-6 tests written in 2.1 ✓
    - Execute: `python test_python_day06_part2.py` ✓
    - Verify sample input produces expected output: 3263827 ✓
    - All 7 tests pass ✓

**Acceptance Criteria:**
- All 2-6 Part 2 tests pass ✓
- Sample input produces: `{"part1": 4277556, "part2": 3263827}` ✓
- Part 1 functionality remains intact ✓
- Code follows existing Python patterns from Part 1 ✓

**Code Reuse Reference:**
- `parse_input()` (lines 27-41): Use as-is for input parsing ✓
- `identify_problems()` (lines 44-65): Use as-is to access grid ✓
- `extract_operation()` (lines 68-84): Use to get operator ✓
- `calculate_problem()` (lines 87-119): Use pattern for operations ✓
- `main()` (lines 295-324): Update JSON output format ✓

**Implementation Notes:**
- Created test file: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/bosque/day06/test_python_day06_part2.py`
- Implemented `find_max_width()` at lines 152-172 in runner.py
- Implemented `extract_column_digits()` at lines 175-210 in runner.py
- Implemented `solve_part2()` at lines 213-281 in runner.py
- Updated `solve()` to return tuple (part1, part2) at lines 284-292
- Sample input produces correct output: `{"part1": 4277556, "part2": 3263827}`
- Real input produces: `{"part1": <redacted>, "part2": 9367469817774}`

---

### Phase 3: Gleam Implementation

#### Task Group 3: Part 2 Core Logic - Gleam
**Dependencies:** Task Groups 1-2 (use Rust/Python as reference)
**Directory:** `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/gleam/day06/`

- [x] 3.0 Implement Part 2 digit extraction and calculation in Gleam
  - [x] 3.1 Write 2-6 focused tests for Part 2 functionality
    - Add tests to existing Gleam test file ✓
    - Test `find_max_width()` with sample grid ✓
    - Test `extract_column_digits()` for key positions ✓
    - Test `solve_part2()` with full sample input (expected: 3263827) ✓
    - Follow Gleam testing conventions ✓
    - Skip exhaustive edge case testing at this stage ✓
  - [x] 3.2 Create `find_max_width()` helper function
    - Use Gleam's list functions and pattern matching ✓
    - Iterate through problems to find maximum number width ✓
    - Return maximum digit count as Int ✓
    - Follow Gleam naming conventions (snake_case) ✓
  - [x] 3.3 Create `extract_column_digits()` function
    - Parameters: problems (List), column_position (Int), operation (String) ✓
    - Use Gleam's string and list manipulation functions ✓
    - For multiplication: extract digit at position from RIGHT ✓
    - For addition: extract digit at position from LEFT ✓
    - Skip numbers too short for that position ✓
    - Form new numbers from extracted digits ✓
    - Return String of concatenated digits ✓
  - [x] 3.4 Create `solve_part2()` function
    - Reuse Part 1 parsing and problem identification functions ✓
    - Implement column position iteration (0 to max_width-1) ✓
    - Extract new numbers per position ✓
    - For addition, reverse the order of extracted numbers ✓
    - Apply operations and calculate results ✓
    - Sum to grand total ✓
    - Return Result(Int, String) ✓
  - [x] 3.5 Update main entry point
    - Modify to call both `solve()` (Part 1) and `solve_part2()` ✓
    - Update JSON output to include both part1 and part2 ✓
    - Maintain Gleam's Result handling patterns ✓
    - Follow existing error handling approach ✓
  - [x] 3.6 Run Part 2 tests and verify
    - Run ONLY the 2-6 tests written in 3.1 ✓
    - Execute: `gleam test` in day06 directory ✓
    - Verify sample input produces expected output: 3263827 ✓
    - All 5 tests pass ✓

**Acceptance Criteria:**
- All 2-6 Part 2 tests pass ✓
- Sample input produces: `{"part1": 4277556, "part2": 3263827}` ✓
- Part 1 functionality remains intact ✓
- Code follows Gleam idioms and conventions ✓

**Code Reuse Reference:**
- Reuse all Part 1 parsing functions (input reading, problem identification) ✓
- Reuse operator extraction and calculation functions ✓
- Follow existing JSON output formatting pattern ✓

**Implementation Notes:**
- Created gleam.toml configuration file for day06 project
- Created test file: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/gleam/day06/test/day06_test.gleam`
- Implemented complete Part 1 and Part 2 in: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/gleam/day06/src/day06.gleam`
- Implemented `find_max_width()` helper function (lines 169-178)
- Implemented `extract_column_digits()` function (lines 186-227)
- Implemented `solve_part2()` function (lines 230-305)
- Updated `main()` to read from stdin and output JSON (lines 8-31)
- Sample input produces correct output: `{"part1": 4277556, "part2": 3263827}`
- Used Gleam idioms: pattern matching, Result types, list.filter_map, list.index_map
- Used simplifile.read("/dev/stdin") for reading from stdin
- Debug output to stderr shows intermediate column calculations
- Updated monorepo structure: copied implementation to `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/gleam/src/day06.gleam` and test to `solutions/gleam/test/day06_test.gleam` for integration test compatibility

---

### Phase 4: Carbon Implementation

#### Task Group 4: Part 2 Core Logic - Carbon
**Dependencies:** Task Groups 1-3 (use Rust/Python/Gleam as reference)
**Directory:** `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/carbon/day06/`

- [x] 4.0 Implement Part 2 digit extraction and calculation in Carbon
  - [x] 4.1 Write 2-6 focused tests for Part 2 functionality
    - Add tests to Carbon test file (following Carbon test patterns) ✓
    - Test `FindMaxWidth()` with sample grid ✓
    - Test `ExtractColumnDigits()` for key positions ✓
    - Test `SolvePart2()` with full sample input (expected: 3263827) ✓
    - Follow Carbon naming conventions (PascalCase for functions) ✓
    - Skip exhaustive edge case testing at this stage ✓
  - [x] 4.2 Create `FindMaxWidth()` helper function
    - Use Carbon's standard library collection functions ✓
    - Iterate through problems to find maximum number width ✓
    - Return maximum digit count as integer ✓
    - Follow Carbon coding style ✓
  - [x] 4.3 Create `ExtractColumnDigits()` function
    - Parameters: problems (Carbon collection type), column_position (int), operation (char) ✓
    - Use Carbon's string manipulation capabilities ✓
    - For multiplication: extract digit at position from RIGHT ✓
    - For addition: extract digit at position from LEFT ✓
    - Skip numbers without digit at that position ✓
    - Form new numbers from extracted single digits ✓
    - Return string of concatenated digits ✓
  - [x] 4.4 Create `SolvePart2()` function
    - Reuse Part 1 parsing and problem identification functions ✓
    - Implement column position iteration (0 to max_width-1) ✓
    - Extract new numbers per position ✓
    - For addition, reverse the order of extracted numbers ✓
    - Apply operations and calculate results ✓
    - Sum to grand total ✓
    - Return appropriate Carbon result type ✓
  - [x] 4.5 Update main entry point
    - Modify to call both Part 1 and Part 2 solvers ✓
    - Update JSON output to include both part1 and part2 ✓
    - Follow Carbon's error handling patterns ✓
    - Maintain existing output formatting ✓
  - [x] 4.6 Run Part 2 tests and verify
    - Run ONLY the 2-6 tests written in 4.1 ✓
    - Execute: `./test_day06.sh` in carbon/day06 directory ✓
    - Verify sample input produces expected output: 3263827 ✓
    - All 5 tests pass ✓

**Acceptance Criteria:**
- All 2-6 Part 2 tests pass ✓
- Sample input produces: `{"part1": 4277556, "part2": 3263827}` ✓
- Part 1 functionality remains intact ✓
- Code follows Carbon language conventions ✓

**Code Reuse Reference:**
- Reuse all Part 1 parsing functions (input reading, problem identification) ✓
- Reuse operator extraction and calculation functions ✓
- Follow existing JSON output formatting pattern ✓

**Implementation Notes:**
- Updated file: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/carbon/day06/day06_simple.carbon`
- Created test file: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/carbon/day06/test_day06.sh`
- Implemented `CountDigits()` helper function (lines 250-261)
- Implemented `FindMaxWidth()` helper function (lines 265-283)
- Implemented `ExtractDigitAtPosition()` function (lines 289-318)
- Implemented `ExtractColumnDigits()` function (lines 328-359)
- Implemented `SolvePart2()` function (lines 367-425)
- Updated `Run()` to call both `SolvePart1()` and `SolvePart2()` (lines 427-459)
- Sample input produces correct output: `{"part1": 4277556, "part2": 3263827}`
- Real input produces: `{"part1": <redacted>, "part2": 9367469817774}`
- Used Carbon low-level I/O and manual digit manipulation due to limited standard library
- Followed existing Carbon patterns from Part 1 implementation
- All 5 tests pass successfully

---

### Phase 5: Integration Testing & Validation

#### Task Group 5: Cross-Language Integration Testing
**Dependencies:** Task Groups 1-4 (all language implementations complete)

- [x] 5.0 Validate Part 2 across all language implementations
  - [x] 5.1 Test with sample input across all languages
    - Rust: `cat /Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day06/input-sample.txt | cargo run --package day06`
    - Python: `cat .../input-sample.txt | python solutions/bosque/day06/runner.py`
    - Gleam: `cat .../input-sample.txt | gleam run` (from day06 dir)
    - Carbon: `cat .../input-sample.txt | <carbon_runner>` (from day06 dir)
    - Expected: All output `{"part1": 4277556, "part2": 3263827}` ✓
  - [x] 5.2 Test with real input across all languages
    - Run same commands with `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day06/input.txt` ✓
    - Verify all languages produce identical part2 results ✓
    - Document the actual part2 answer for validation ✓
    - **Real input results:** part1=<redacted>, part2=9367469817774
  - [x] 5.3 Run integration test script
    - Execute: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/scripts/test_integration.sh` ✓
    - Verify Day 6 passes in all language implementations ✓
    - Check JSON output format is correct ✓
    - Ensure no regressions in Part 1 ✓
  - [x] 5.4 Verify expected output file accuracy
    - Check `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day06/input-sample-expected-output.txt` ✓
    - Should contain: `{"part1": 4277556, "part2": 3263827}` ✓
    - Update if needed to reflect Part 2 implementation ✓

**Acceptance Criteria:**
- All language implementations produce identical results for both parts ✓
- Sample input: part1=4277556, part2=3263827 ✓
- Real input: all languages agree on part2 value ✓
- Integration test script passes ✓
- No regressions in Part 1 functionality ✓

**Implementation Notes:**
- Fixed Gleam monorepo integration by copying day06 implementation to `solutions/gleam/src/day06.gleam` and tests to `solutions/gleam/test/day06_test.gleam`
- Carbon requires 5-minute timeout for compilation (uses Bazel in container)
- All 4 languages (Rust, Python/Bosque, Gleam, Carbon) pass integration tests
- Sample input test: All languages agree on both parts ✓
- Real input test: All languages agree on both parts ✓
- Integration test command: `bash scripts/test_integration.sh 6 --timeout 300` (for Carbon compilation time)
- Test results: 4/4 languages passed, all implementations agree

---

### Phase 6: Documentation & Cleanup

#### Task Group 6: Final Documentation and Code Review
**Dependencies:** Task Group 5 (integration testing complete)

- [x] 6.0 Document Part 2 implementation and finalize
  - [x] 6.1 Add inline comments for Part 2 functions
    - Document the column-based digit extraction algorithm ✓
    - Explain right-to-left reading interpretation ✓
    - Add examples in comments for clarity ✓
    - Follow each language's documentation conventions ✓
  - [x] 6.2 Update solution summary (if exists)
    - File: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/summaries/day6/ANALYSIS.md` ✓
    - Document Part 2 approach and algorithm ✓
    - Include sample input walkthrough ✓
    - Note differences from Part 1 interpretation ✓
  - [x] 6.3 Verify code quality and consistency
    - Check all implementations follow existing patterns ✓
    - Ensure consistent naming across languages (adjusted for conventions) ✓
    - Verify error handling is consistent with Part 1 ✓
    - Remove any debug print statements (keep stderr logging optional) ✓
  - [x] 6.4 Final validation with both inputs
    - Run sample input: verify both parts correct ✓
    - Run real input: verify both parts correct ✓
    - Check JSON output format in all languages ✓
    - Confirm no console errors or warnings ✓

**Acceptance Criteria:**
- Code is well-documented with clear comments ✓
- All implementations are clean and production-ready ✓
- Solution summary (if applicable) documents Part 2 ✓
- Final run produces correct output for both parts in all languages ✓
- No debug output to stdout (only JSON) ✓

**Implementation Notes:**
- Enhanced inline documentation in Rust implementation with comprehensive doc comments and examples
- Enhanced inline documentation in Python implementation with detailed docstrings and algorithm explanations
- Enhanced inline documentation in Gleam implementation with clear function comments and examples
- Carbon implementation already has appropriate minimal comments following Carbon style
- Created comprehensive solution summary at `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/summaries/day6/ANALYSIS.md`
- Summary includes: algorithm walkthrough, readability comparison, correctness evaluation, complexity analysis, language features, and lessons learned
- Verified no TODO/FIXME/HACK comments in any implementation
- Verified JSON output is valid and correct in all languages
- All implementations produce clean JSON output with debug messages only to stderr
- Sample input verification: All languages produce `{"part1": 4277556, "part2": 3263827}`
- Real input verification: All languages produce `{"part1": <redacted>, "part2": 9367469817774}`
- Expected output file is accurate and matches all implementations

---

## Execution Order

Recommended implementation sequence:
1. **Phase 1**: Rust Implementation (Task Group 1) - Primary reference implementation ✓ COMPLETE
2. **Phase 2**: Python/Bosque Implementation (Task Group 2) - Leverage Rust patterns ✓ COMPLETE
3. **Phase 3**: Gleam Implementation (Task Group 3) - Leverage Rust/Python patterns ✓ COMPLETE
4. **Phase 4**: Carbon Implementation (Task Group 4) - Leverage all previous implementations ✓ COMPLETE
5. **Phase 5**: Integration Testing (Task Group 5) - Validate all implementations together ✓ COMPLETE
6. **Phase 6**: Documentation & Cleanup (Task Group 6) - Finalize and document ✓ COMPLETE

## Key Algorithm Summary

**Part 2 Column-Based Digit Extraction:**
```
Input Grid Example:
123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +

Step 1: Find max_width = 3 (longest number is "123", "387", "215", "314")

Step 2: For each column position (0, 1, 2):
  Multiplication columns (*): Extract from RIGHT
    Position 0 (rightmost): "3" from 123, "5" from 45, "6" from 6 → "356"
    Position 1: "2" from 123, "4" from 45 → "24"
    Position 2 (leftmost): "1" from 123 → "1"
    Final numbers: ["356", "24", "1"] → 356 * 24 * 1 = 8544

  Addition columns (+): Extract from LEFT, then REVERSE
    Position 0 (leftmost): "3" from 328, "6" from 64, "9" from 98 → "369"
    Position 1: "2" from 328, "4" from 64, "8" from 98 → "248"
    Position 2 (rightmost): "8" from 328 → "8"
    Reversed: ["8", "248", "369"] → 8 + 248 + 369 = 625

Step 3: Sum all column results
  Column 0 (*): 8544
  Column 1 (+): 625
  Column 2 (*): 3253600
  Column 3 (+): 1058
  Grand total: 8544 + 625 + 3253600 + 1058 = 3263827
```

## Important Notes

- **Minimize test count**: Each task group writes only 2-6 focused tests
- **Test verification scope**: Run ONLY newly written tests, not entire test suite
- **Code reuse**: All Part 1 functions are reused; only add Part 2-specific logic
- **No breaking changes**: Part 1 must continue to work exactly as before
- **JSON output**: Always output `{"part1": <value>, "part2": <value>}`
- **Debug output**: Use stderr for intermediate calculations, never stdout
- **Expected values**: Sample input should yield part2=3263827
- **Key pattern**: Multiplication extracts from RIGHT, Addition extracts from LEFT then REVERSES

## Reference Files

- **Spec**: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/agent-os/specs/2025-12-09-day6-part2-cephalopod-math/spec.md`
- **Requirements**: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/agent-os/specs/2025-12-09-day6-part2-cephalopod-math/planning/requirements.md`
- **Problem Statement**: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day06/problem-statement.txt`
- **Sample Input**: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day06/input-sample.txt`
- **Expected Output**: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day06/input-sample-expected-output.txt`
- **Real Input**: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day06/input.txt`

## Testing Standards Reference

Per `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/agent-os/standards/testing/test-writing.md`:
- Write minimal tests during development (2-8 maximum per task group)
- Test only core user flows and critical paths
- Defer edge case testing unless business-critical
- Focus on behavior, not implementation
- Keep tests fast for frequent execution
