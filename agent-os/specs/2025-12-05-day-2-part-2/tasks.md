# Task Breakdown: Day 2 Part 2 - Extended Pattern Detection

## Overview
**Feature:** Extend Day 2 Part 1 solution to detect invalid product IDs with patterns repeated 2+ times (not just exactly twice) across all four languages (Rust, Gleam, Carbon, Bosque).

**Total Task Groups:** 5
**Estimated Tests per Language:** 16-34 tests total (approximately 4-8 per task group)

## Task List

### Task Group 1: Rust Implementation

#### Dependencies: None

- [x] 1.0 Complete Rust Part 2 implementation
  - [x] 1.1 Write 2-8 focused tests for Part 2 pattern detection
    - Test single character patterns: "111" (3 repetitions), "999" (3 repetitions)
    - Test multi-character patterns: "565656" (3 repetitions of "56"), "824824824" (3 repetitions of "824")
    - Test many repetitions: "2121212121" (5 repetitions of "21")
    - Test edge cases: "11" (still invalid in Part 2), "123456" (still valid in Part 2)
    - Test that all Part 1 invalid IDs remain invalid in Part 2
    - Location: `/solutions/rust/day02/src/main.rs` in `#[cfg(test)] mod tests`
  - [x] 1.2 Implement `is_invalid_id_part2()` function
    - Iterate through pattern lengths from 1 to `length/2`
    - For each pattern length, check if `length % pattern_length == 0`
    - Extract first N characters as pattern
    - Verify entire string equals pattern repeated `length/N` times
    - Return true on first match (short-circuit optimization)
    - Location: Add after existing `is_invalid_id()` function (after line 54)
  - [x] 1.3 Create `process_range_part2()` function
    - Duplicate `process_range()` logic (lines 108-119)
    - Call `is_invalid_id_part2()` instead of `is_invalid_id()`
    - Return sum of invalid IDs for the range
    - Location: Add after existing `process_range()` function
  - [x] 1.4 Update `solve()` function to compute both parts
    - Process all ranges for Part 1 (existing logic)
    - Process all ranges for Part 2 using `process_range_part2()`
    - Return `(part1_sum, Some(part2_sum))` instead of `(part1_sum, None)`
    - Location: Modify existing `solve()` function (lines 128-145)
  - [x] 1.5 Add integration test for Part 2 sample data
    - Test with sample input ranges from spec
    - Assert Part 2 sum equals <redacted>
    - Verify Part 1 sum remains <redacted>
    - Verify Part 2 ranges: [99, 111] in 95-115, [999, 1010] in 998-1012, etc.
    - Location: Add to `#[cfg(test)] mod tests` after line 347
  - [x] 1.6 Ensure Rust Part 2 tests pass
    - Run ONLY the 2-8 tests written in 1.1 and the integration test from 1.5
    - Run: `cd /solutions/rust/day02 && cargo test`
    - Verify Part 2 sum: <redacted>
    - Do NOT run any additional test suites at this stage

**Acceptance Criteria:**
- All new tests pass (2-8 unit tests + 1 integration test)
- Part 1 sum remains <redacted> for sample input
- Part 2 sum equals <redacted> for sample input
- JSON output format: `{"part1": <redacted>, "part2": <redacted>}`
- Code follows Rust idioms and existing patterns

---

### Task Group 2: Gleam Implementation

#### Dependencies: Task Group 1

- [x] 2.0 Complete Gleam Part 2 implementation
  - [x] 2.1 Write 2-8 focused tests for Part 2 pattern detection
    - Mirror test cases from Rust implementation (Task 1.1)
    - Test single char patterns: "111", "999"
    - Test multi-char patterns: "565656", "824824824"
    - Test many repetitions: "2121212121"
    - Test edge cases: "11", "123456"
    - Location: `/solutions/gleam/test/day02_test.gleam` (create if needed)
  - [x] 2.2 Implement `is_invalid_id_part2()` function
    - Use tail recursion pattern for iteration (similar to `do_process_range` lines 116-128)
    - Create helper function `check_pattern_length()` to test each pattern length
    - Use Gleam's string slicing and comparison operations
    - Follow idiomatic Gleam patterns (pattern matching, recursion)
    - Location: Add after `is_invalid_id()` function (after line 57)
  - [x] 2.3 Create `process_range_part2()` function
    - Duplicate `process_range()` logic (lines 111-128)
    - Call `is_invalid_id_part2()` instead of `is_invalid_id()`
    - Use tail recursion pattern with helper function
    - Location: Add after existing `process_range()` function
  - [x] 2.4 Update `solve()` and `main()` functions
    - Modify `solve()` to return `Result(#(Int, Int), String)` for both parts
    - Update `main()` to call `build_json()` with Part 2 value
    - Pass `Some(part2_sum)` instead of `None` to `build_json()`
    - Location: Modify lines 137-148 and lines 9-23
  - [x] 2.5 Add integration test for Part 2 sample data
    - Test with sample input ranges
    - Assert Part 2 sum equals <redacted>
    - Verify Part 1 sum remains <redacted>
    - Location: Add to `/solutions/gleam/test/day02_test.gleam`
  - [x] 2.6 Ensure Gleam Part 2 tests pass
    - Run ONLY the 2-8 tests written in 2.1 and the integration test from 2.5
    - Run: `cd /solutions/gleam && gleam test`
    - Verify Part 2 sum: <redacted>
    - Do NOT run any additional test suites at this stage

**Acceptance Criteria:**
- All new tests pass (2-8 unit tests + 1 integration test)
- Part 1 sum remains <redacted> for sample input
- Part 2 sum equals <redacted> for sample input
- JSON output format: `{"part1": <redacted>, "part2": <redacted>}`
- Code follows Gleam idioms (tail recursion, pattern matching)
- Matches Rust implementation logic

---

### Task Group 3: Carbon Implementation (Python Wrapper)

#### Dependencies: Task Group 2

- [x] 3.0 Complete Carbon Part 2 implementation
  - [x] 3.1 Write 2-8 focused tests for Part 2 pattern detection
    - Tests implemented in Python wrapper (Carbon lacks testing framework)
    - Test single char patterns: "111", "999"
    - Test multi-char patterns: "565656", "824824824"
    - Test many repetitions: "2121212121"
    - Test edge cases: "11", "123456"
    - Location: Create or update `/solutions/carbon/day02/test_carbon_day02.py`
  - [x] 3.2 Add `IsInvalidIdPart2()` function skeleton in Carbon
    - Add function signature and documentation
    - Explain algorithm structure in comments
    - Note that actual implementation is in Python wrapper
    - Location: Add after `IsInvalidId()` function (after line 56)
  - [x] 3.3 Implement Part 2 logic in Python wrapper
    - Create `is_invalid_id_part2()` function in Python runner
    - Iterate through pattern lengths from 1 to length/2
    - Check if entire number consists of pattern repeated
    - Location: Update Python runner script for Carbon day02
  - [x] 3.4 Update Python wrapper to compute both parts
    - Process ranges for Part 1 (existing logic)
    - Process ranges for Part 2 using new function
    - Output JSON: `{"part1": <sum1>, "part2": <sum2>}`
    - Location: Update main execution in Python wrapper
  - [x] 3.5 Add integration test for Part 2 sample data
    - Test with sample input ranges
    - Assert Part 2 sum equals <redacted>
    - Verify Part 1 sum remains <redacted>
    - Location: Add to `/solutions/carbon/day02/test_carbon_day02.py`
  - [x] 3.6 Ensure Carbon Part 2 tests pass
    - Run ONLY the 2-8 tests written in 3.1 and the integration test from 3.5
    - Run Python wrapper tests: `cd /solutions/carbon/day02 && python test_carbon_day02.py`
    - Verify Part 2 sum: <redacted>
    - Do NOT run any additional test suites at this stage

**Acceptance Criteria:**
- All new tests pass (33 tests total: 8 Part 1 pattern + 5 Part 2 pattern + 8 Part 1 range + 3 Part 2 range + 4 helper + 5 integration)
- Part 1 sum remains <redacted> for sample input
- Part 2 sum equals <redacted> for sample input
- JSON output format: `{"part1": <redacted>, "part2": <redacted>}`
- Carbon code documents algorithm structure
- Python wrapper implements full logic
- Matches Rust and Gleam implementation behavior

---

### Task Group 4: Bosque Implementation (Python Wrapper)

#### Dependencies: Task Group 3

- [x] 4.0 Complete Bosque Part 2 implementation
  - [x] 4.1 Write 2-8 focused tests for Part 2 pattern detection
    - Mirror test structure from existing tests (lines 165-298)
    - Test single char patterns: "111", "999"
    - Test multi-char patterns: "565656", "824824824"
    - Test many repetitions: "2121212121"
    - Test edge cases: "11", "123456"
    - Location: Add after existing tests in `/solutions/bosque/day02/solution.bsq`
  - [x] 4.2 Implement `isInvalidIdPart2()` function
    - Use while-loop pattern (similar to `processRange` lines 95-108)
    - Iterate through pattern lengths from 1 to length/2
    - Use Bosque string operations: `String::substring()`, comparison
    - Check if entire string equals pattern repeated
    - Location: Add after `isInvalidId()` function (after line 46)
  - [x] 4.3 Create `processRangePart2()` function
    - Duplicate `processRange()` logic (lines 95-108)
    - Call `isInvalidIdPart2()` instead of `isInvalidId()`
    - Maintain while-loop iteration pattern
    - Location: Add after existing `processRange()` function
  - [x] 4.4 Update `solve()` and `main()` functions
    - Modify `solve()` to process ranges for both Part 1 and Part 2
    - Update `main()` to output both parts in JSON format
    - Output: `{"part1": <sum1>, "part2": <sum2>}`
    - Location: Modify lines 117-163
  - [x] 4.5 Update Python wrapper for Part 2
    - Ensure Python wrapper handles Part 2 JSON output
    - Verify file I/O and execution work correctly
    - Test with sample input via wrapper
    - Location: Update Python wrapper script for Bosque day02
  - [x] 4.6 Add integration test for Part 2 sample data
    - Test with sample input ranges
    - Assert Part 2 sum equals <redacted>
    - Verify Part 1 sum remains <redacted>
    - Location: Add to test functions (after line 297)
  - [x] 4.7 Ensure Bosque Part 2 tests pass
    - Run ONLY the 2-8 tests written in 4.1 and the integration test from 4.6
    - Run Python wrapper tests for Bosque
    - Verify Part 2 sum: <redacted>
    - Do NOT run any additional test suites at this stage

**Acceptance Criteria:**
- All new tests pass (34 tests total: 8 Part 1 pattern + 5 Part 2 pattern + 8 Part 1 range + 3 Part 2 range + 4 helper + 5 integration + 1 verification)
- Part 1 sum remains <redacted> for sample input
- Part 2 sum equals <redacted> for sample input
- JSON output format: `{"part1": <redacted>, "part2": <redacted>}`
- Code follows Bosque syntax and patterns
- Python wrapper handles execution correctly
- Matches behavior of all other language implementations

---

### Task Group 5: Cross-Language Validation & Testing

#### Dependencies: Task Groups 1-4

- [x] 5.0 Validate consistency across all languages and fill critical gaps
  - [x] 5.1 Review all language-specific tests
    - Review Rust tests from Task 1.1 (5 Part 2 tests written)
    - Review Gleam tests from Task 2.1 (8 Part 2 tests written)
    - Review Carbon tests from Task 3.1 (8 Part 2 tests written)
    - Review Bosque tests from Task 4.1 (8 Part 2 tests written)
    - Total existing tests: 29 Part 2 tests completed
  - [x] 5.2 Run cross-language validation on sample input
    - Run Rust solution: COMPLETED - outputs `{"part1": <redacted>, "part2": <redacted>}`
    - Run Gleam solution: COMPLETED - outputs `{"part1": <redacted>, "part2": <redacted>}`
    - Run Carbon solution via Python wrapper: COMPLETED - outputs `{"part1": <redacted>, "part2": <redacted>}`
    - Run Bosque solution via Python wrapper: COMPLETED - outputs `{"part1": <redacted>, "part2": <redacted>}`
    - All four languages produce identical results
  - [x] 5.3 Analyze test coverage gaps for Part 2 feature only
    - Identified critical Part 2 workflows covered by existing tests
    - All 4 languages have comprehensive pattern detection tests
    - All 4 languages have range processing tests for Part 2
    - All 4 languages have integration tests with sample data
    - No critical gaps found - coverage is adequate
  - [x] 5.4 Write up to 10 additional strategic tests (IF NEEDED)
    - Analysis complete: No additional tests needed
    - All critical scenarios covered across 4 languages
    - Total Part 2 tests: 29 focused tests across all languages
    - Cross-language consistency validated
  - [x] 5.5 Run full test suite for Part 2 feature only
    - Run Rust tests: COMPLETED - 33 tests passed
    - Run Gleam tests: COMPLETED - 56 tests passed
    - Run Carbon tests: COMPLETED - 33 tests passed (Python wrapper)
    - Run Bosque tests: COMPLETED - 34 tests passed (Python wrapper)
    - All Part 2-related tests pass in all languages
  - [x] 5.6 Validate with real input (if available)
    - Run Rust with real input: Part 1 = <REDACTED>, Part 2 = <REDACTED>
    - Run Gleam with real input: Part 1 = <REDACTED>, Part 2 = <REDACTED>
    - Run Carbon with real input: Part 1 = <REDACTED>, Part 2 = <REDACTED>
    - Run Bosque with real input: Part 1 = <REDACTED>, Part 2 = <REDACTED>
    - All languages produce identical results for real input
  - [x] 5.7 Update expected output file
    - Update `/challenges/day02/input-sample-expected-output.txt` with Part 2 result
    - Format: `{"part1": <redacted>, "part2": <redacted>}`
    - Ensure file matches JSON output format from all implementations

**Acceptance Criteria:**
- All four languages produce identical Part 1 sum: <redacted> (sample)
- All four languages produce identical Part 2 sum: <redacted> (sample)
- Cross-language validation passes for sample input
- Cross-language validation passes for real input
- All Part 2 feature tests pass (156 tests total across all languages)
- Expected output file updated
- No regression in Part 1 functionality

---

## Execution Order

**Recommended implementation sequence:**
1. **Task Group 1:** Rust Implementation (establish pattern and validate algorithm) - COMPLETED
2. **Task Group 2:** Gleam Implementation (extend to functional language) - COMPLETED
3. **Task Group 3:** Carbon Implementation (Python wrapper approach) - COMPLETED
4. **Task Group 4:** Bosque Implementation (complete all languages) - COMPLETED
5. **Task Group 5:** Cross-Language Validation & Testing (ensure consistency) - COMPLETED

## Key Technical Patterns

### Algorithm Implementation (All Languages)
```
function is_invalid_id_part2(number_str):
    length = len(number_str)

    for pattern_length in 1 to length/2:
        if length % pattern_length != 0:
            continue

        pattern = number_str[0:pattern_length]
        repetitions = length / pattern_length

        if pattern * repetitions == number_str:
            return true  // Invalid - pattern repeats

    return false  // Valid - no repeating pattern found
```

### Language-Specific Adaptations
- **Rust:** Use for loops, string slicing `&str[start..end]`, `.repeat(n)`
- **Gleam:** Use tail recursion, `string.slice()`, pattern matching
- **Carbon:** Document algorithm in Carbon, implement in Python wrapper
- **Bosque:** Use while loops, `String::substring()`, manual string building

### Testing Strategy
- Write 2-8 focused tests per language during implementation
- Focus on critical pattern detection cases
- Add integration test per language for sample data validation
- Cross-language validation in final task group
- No additional strategic tests needed (comprehensive coverage achieved)

## Important Constraints

- **Maintain Part 1 functionality:** Do NOT modify existing `is_invalid_id()` logic
- **Focused testing:** Each task group writes 2-8 tests maximum, not comprehensive suites
- **Algorithm consistency:** All languages must implement identical detection logic
- **Expected results:** Part 1 = <redacted>, Part 2 = <redacted> (sample input)
- **JSON output format:** `{"part1": <sum>, "part2": <sum>}` for all languages
- **Cross-language validation:** Mandatory before completion
- **Self-contained solutions:** Each language solution must work independently
- **Python wrappers:** Required for Carbon and Bosque due to language limitations

## References

**Spec Files:**
- Spec: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/agent-os/specs/2025-12-05-day-2-part-2/spec.md`
- Requirements: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/agent-os/specs/2025-12-05-day-2-part-2/planning/requirements.md`

**Existing Code:**
- Rust: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/rust/day02/src/main.rs`
- Gleam: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/gleam/src/day02.gleam`
- Carbon: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/carbon/day02/day02.carbon`
- Bosque: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/bosque/day02/solution.bsq`

**Input Files:**
- Sample: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day02/input-sample.txt`
- Real: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day02/input.txt`
- Expected: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day02/input-sample-expected-output.txt`

## Implementation Summary

### Completed Work

**Task Group 1: Rust Implementation**
- Implemented `is_invalid_id_part2()` function using for loops and string slicing
- Created `process_range_part2()` function to process ranges with Part 2 logic
- Updated `solve()` function to return both Part 1 and Part 2 results
- Added 5 focused unit tests for Part 2 pattern detection
- Added 3 integration tests including full sample input validation
- All 33 tests passing
- Verified output: `{"part1": <redacted>, "part2": <redacted>}`

**Task Group 2: Gleam Implementation**
- Implemented `is_invalid_id_part2()` function using tail recursion
- Created helper function `check_pattern_length()` for recursive pattern checking
- Created `process_range_part2()` and `do_process_range_part2()` helper functions
- Updated `main()` to use new `solve_both_parts()` function
- Added 8 focused unit tests for Part 2 pattern detection
- Added 3 Part 2-specific range tests
- Added 1 integration test for full sample input
- All 56 tests passing
- Verified output: `{"part1": <redacted>, "part2": <redacted>}`

**Task Group 3: Carbon Implementation**
- Added `IsInvalidIdPart2()` function skeleton in Carbon code with full documentation
- Implemented `is_invalid_id_part2()` function in Python wrapper
- Updated `process_range_part2()` function in Python wrapper
- Updated `solve()` function to return both Part 1 and Part 2 results
- Added 8 Part 2 pattern detection tests in Python test suite
- Added 3 Part 2 range processing tests in Python test suite
- Added 2 integration tests for Part 2 sample data
- All 33 tests passing
- Verified output: `{"part1": <redacted>, "part2": <redacted>}`

**Task Group 4: Bosque Implementation**
- Implemented `isInvalidIdPart2()` function using while loops and string operations
- Created `processRangePart2()` function following Bosque patterns
- Updated `solve()` function to return tuple with both Part 1 and Part 2 sums
- Updated `main()` to output both parts in JSON format
- Added 5 Part 2 pattern detection tests in Bosque code
- Added 3 Part 2 range processing tests in Bosque code
- Added 2 integration tests for Part 2 sample data
- Updated Python wrapper to implement Part 2 logic
- Added 5 Part 2 pattern detection tests in Python test suite
- Added 3 Part 2 range processing tests in Python test suite
- All 34 tests passing
- Verified output: `{"part1": <redacted>, "part2": <redacted>}`

**Task Group 5: Cross-Language Validation**
- Reviewed all language-specific tests (29 Part 2 tests total)
- Validated all 4 languages produce identical results for sample input
- Validated all 4 languages produce identical results for real input
- No critical test coverage gaps identified
- All 156 tests passing across all languages (33 Rust + 56 Gleam + 33 Carbon + 34 Bosque)
- Updated expected output file with Part 2 results

### Files Modified

1. `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/rust/day02/src/main.rs`
   - Added `is_invalid_id_part2()` function (lines 56-102)
   - Added `process_range_part2()` function (lines 178-189)
   - Updated `solve()` function to compute both parts (lines 198-220)
   - Added 8 Part 2-related tests (lines 295-503)

2. `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/gleam/src/day02.gleam`
   - Added `is_invalid_id_part2()` function (lines 59-82)
   - Added `check_pattern_length()` helper function (lines 85-110)
   - Added `process_range_part2()` and helper functions (lines 183-209)
   - Added `solve_both_parts()` function (lines 238-255)
   - Updated `main()` to use `solve_both_parts()` (lines 16-20)

3. `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/gleam/test/day02_test.gleam`
   - Added 8 Part 2 pattern detection tests (lines 71-122)
   - Added 3 Part 2 range tests (lines 174-192)
   - Added 1 Part 2 integration test (lines 270-284)

4. `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/carbon/day02/day02.carbon`
   - Added `IsInvalidIdPart2()` function skeleton with documentation
   - Updated comments to reflect Part 2 algorithm
   - Added Part 2 test function stubs

5. `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/carbon/day02/runner.py`
   - Added `is_invalid_id_part2()` function
   - Added `process_range_part2()` function
   - Updated `solve()` to return both parts

6. `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/carbon/day02/test_carbon_day02.py`
   - Added 8 Part 2 pattern detection tests
   - Added 3 Part 2 range processing tests
   - Added 2 Part 2 integration tests

7. `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/bosque/day02/solution.bsq`
   - Added `isInvalidIdPart2()` function with while-loop implementation
   - Added `processRangePart2()` function
   - Updated `solve()` to return tuple with both parts
   - Updated `main()` to output JSON with both parts
   - Added 5 Part 2 pattern detection test functions
   - Added 3 Part 2 range processing test functions
   - Added 1 Part 2 integration test function

8. `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/bosque/day02/runner.py`
   - Added `is_invalid_id_part2()` function
   - Added `process_range_part2()` function
   - Updated `solve()` to return dictionary with both parts

9. `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/bosque/day02/test_bosque_day02.py`
   - Added 5 Part 2 pattern detection test classes
   - Added 3 Part 2 range processing tests
   - Added 2 Part 2 integration tests

10. `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day02/input-sample-expected-output.txt`
    - Updated to include Part 2 result: `{"part1": <redacted>, "part2": <redacted>}`

11. `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/agent-os/specs/2025-12-05-day-2-part-2/tasks.md`
    - Marked all Task Groups 1-5 as completed
    - Updated implementation summary section

## Final Results

**Sample Input Validation:**
- All 4 languages: `{"part1": <redacted>, "part2": <redacted>}` ✓

**Real Input Validation:**
- All 4 languages: `{"part1": <REDACTED>, "part2": <REDACTED>}` ✓

**Test Results:**
- Rust: 33 tests passed ✓
- Gleam: 56 tests passed ✓
- Carbon (Python wrapper): 33 tests passed ✓
- Bosque (Python wrapper): 34 tests passed ✓
- Total: 156 tests passing ✓

**Implementation Complete:** All task groups finished successfully. All four languages produce identical results for both sample and real input. Cross-language validation confirmed.
