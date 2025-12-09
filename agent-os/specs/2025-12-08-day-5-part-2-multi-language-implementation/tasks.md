# Task Breakdown: Day 5 Part 2 Multi-Language Implementation

## Overview

**Goal:** Extend Day 5 Part 1 solutions across all 4 languages (Rust, Gleam, Carbon, Bosque) to calculate Part 2 result by counting unique ingredient IDs across all fresh ingredient ID ranges.

**Total Task Groups:** 5
**Expected Completion Order:** Rust → Carbon → Gleam → Bosque → Integration Validation

## Task List

### Rust Implementation

#### Task Group 1: Rust Part 2 Implementation
**Dependencies:** None (Part 1 already complete)

- [x] 1.0 Extend Rust solution to calculate Part 2
  - [x] 1.1 Write 2-8 focused tests for Part 2 functionality
    - Test unique ID counting across multiple ranges
    - Test overlapping ranges (e.g., 12-18 and 16-20)
    - Test sample input expecting part2 = 14
    - Limit to critical behaviors only
    - Run ONLY these new tests initially
  - [x] 1.2 Add HashSet<i64> import and implementation
    - Import `use std::collections::HashSet;` at top of file
    - Create HashSet to collect unique IDs from all ranges
    - Iterate through each range and insert all IDs (start to end, inclusive)
  - [x] 1.3 Update solve function signature
    - Change return type from `Result<(i64, String), String>` to `Result<(i64, i64), String>`
    - Return tuple with (part1_count, part2_count)
    - Maintain existing Part 1 logic unchanged
  - [x] 1.4 Update main function JSON output
    - Change `println!` to output both part1 and part2 as integers
    - Format: `{{"part1": {}, "part2": {}}}"`
    - Update error case to output `"part2": null` instead of string
  - [x] 1.5 Verify Rust tests pass
    - Run ONLY the tests written in 1.1
    - Verify sample input produces `{{"part1": 3, "part2": 14}}`
    - Do NOT run entire test suite at this stage

**Acceptance Criteria:**
- All new tests pass (2-8 tests from 1.1)
- Sample input produces correct output: `{{"part1": 3, "part2": 14}}`
- Part 1 logic remains unchanged
- Large 64-bit values handled correctly

### Carbon Implementation

#### Task Group 2: Carbon Part 2 Implementation
**Dependencies:** Task Group 1 (reference for algorithm)

- [x] 2.0 Extend Carbon solution to calculate Part 2
  - [x] 2.1 Write 2-8 focused tests for Part 2 functionality
    - Test unique ID counting logic
    - Test with sample input expecting part2 = 14
    - Focus on critical path only
    - Create simple test harness if needed
  - [x] 2.2 Add global array for tracking unique IDs
    - Option A: Boolean array indexed by normalized ID ranges
    - Option B: Sorted array for collecting unique IDs with deduplication
    - Use global storage pattern (no dynamic allocation)
    - Declare arrays at top with existing globals
  - [x] 2.3 Implement Part 2 calculation function
    - Create `fn CountUniqueIds() -> i64` function
    - Iterate through all ranges using existing `range_starts`, `range_ends`, `num_ranges`
    - For each range, track unique IDs using chosen approach from 2.2
    - Return count of unique IDs
  - [x] 2.4 Update JSON output in Run function
    - Call `CountUniqueIds()` to get part2 result
    - Update JSON output to print part2 value instead of "null"
    - Use `PrintInt64NoNewline()` for part2 value
    - Maintain character-by-character output pattern
  - [x] 2.5 Verify Carbon solution
    - Run tests from 2.1
    - Test with sample input via container
    - Expected output: `{{"part1": 3, "part2": 14}}`

**Acceptance Criteria:**
- Tests pass (2-8 tests from 2.1)
- Sample input produces correct output
- Follows Carbon constraints (no dynamic allocation, global arrays)
- Character-by-character I/O pattern maintained
- Compiles successfully in container with Bazel

### Gleam Implementation

#### Task Group 3: Gleam Part 2 Implementation
**Dependencies:** Task Group 1 (reference for algorithm)

- [x] 3.0 Complete Gleam solution with Part 1 and Part 2
  - [x] 3.1 Write 2-8 focused tests for core functionality
    - Test range parsing logic
    - Test unique ID calculation
    - Test sample input expecting part1=3, part2=14
    - Limit to critical behaviors only
  - [x] 3.2 Implement parse_range function
    - Parse "START-END" format into tuple
    - Handle validation (start <= end)
    - Return Result type for error handling
    - Reuse pattern from Rust implementation
  - [x] 3.3 Implement is_fresh function
    - Check if ID falls within any range (Part 1)
    - Take ID and list of range tuples
    - Return Bool (True if fresh, False otherwise)
  - [x] 3.4 Implement count_unique_ids function (Part 2)
    - Import `gleam/set` module for Set operations
    - Create empty Set<Int>
    - Iterate through ranges and insert all IDs (start to end, inclusive)
    - Return set.size() as unique count
  - [x] 3.5 Implement solve function
    - Split input by "\n\n" into two sections
    - Parse first section as ranges
    - Parse second section as available IDs
    - Calculate part1: count available IDs that are fresh
    - Calculate part2: count unique IDs from count_unique_ids
    - Return Result<#(Int, Int), String>
  - [x] 3.6 Update main function for stdin input
    - Change from file reading to stdin reading
    - Use appropriate Gleam I/O functions for stdin
    - Call solve function
    - Output JSON format: `{{"part1": X, "part2": Y}}`
    - Handle errors with `{{"part1": null, "part2": null}}`
  - [x] 3.7 Verify Gleam solution
    - Run tests from 3.1
    - Test with sample input
    - Expected output: `{{"part1": 3, "part2": 14}}`

**Acceptance Criteria:**
- Tests pass (2-8 tests from 3.1)
- Reads from stdin (not file path)
- Sample input produces correct output
- Follows Gleam functional patterns (immutable data, pipe operator)
- Proper Result type error handling

### Bosque Implementation

#### Task Group 4: Bosque Part 2 Implementation
**Dependencies:** Task Group 1 (reference for algorithm)

- [x] 4.0 Extend Bosque solution to calculate Part 2
  - [x] 4.1 Write 2-8 focused tests for Part 2 functionality
    - Add tests to `test_bosque_day05.py`
    - Test unique ID counting logic
    - Test sample input expecting part2 = 14
    - Limit to critical behaviors
  - [x] 4.2 Update solution.bsq algorithm documentation
    - Extend solve function signature to return part2 in tuple
    - Document Part 2 algorithm using set operations
    - Add comments explaining unique ID counting logic
    - Update function documentation for count_unique_ids
    - Algorithm serves as canonical specification
  - [x] 4.3 Update Python runner.py implementation
    - Mirror the Bosque algorithm from solution.bsq
    - Implement count_unique_ids function using interval merging
    - Sort ranges and merge overlapping intervals
    - Update solve function to return both part1 and part2
    - Maintain stdin reading and JSON output format
  - [x] 4.4 Verify Bosque solution
    - Run unit tests in test_bosque_day05.py
    - Test via runner script: `./scripts/runners/run_bosque.sh 5 challenges/day05/input-sample.txt`
    - Expected output: `{{"part1": 3, "part2": 14}}` for sample
    - Verify Python implementation matches solution.bsq algorithm

**Acceptance Criteria:**
- Tests pass (3 tests from 4.1)
- solution.bsq contains canonical algorithm documentation
- Python runner mirrors Bosque algorithm exactly
- Sample input produces correct output
- Follows Bosque wrapper pattern (I/O only in Python)

**File Locations:**
- /Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/bosque/day05/solution.bsq
- /Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/bosque/day05/runner.py
- /Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/bosque/day05/test_bosque_day05.py

**Reference Implementations:**
- Rust: /Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/rust/day05/src/main.rs
- Carbon: /Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/carbon/day05/day05_simple.carbon
- Gleam: /Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/gleam/src/day05.gleam

**Expected Results:**
- Sample input: `{{"part1": 3, "part2": 14}}`
- Real input: `{{"part1": <redacted>, "part2": <redacted>}}`

### Integration Testing & Validation

#### Task Group 5: Cross-Language Validation
**Dependencies:** Task Groups 1-4 (all language implementations)

- [x] 5.0 Validate all implementations produce identical results
  - [x] 5.1 Review test coverage across all languages
    - Review Rust tests (1.1): 20 tests
    - Review Carbon tests (2.1): 5 tests
    - Review Gleam tests (3.1): 17 tests
    - Review Bosque tests (4.1): 15 tests
    - Total tests: 57 across all languages
  - [x] 5.2 Test all languages with sample input
    - Rust: Run manually with sample input - PASS: `{"part1": 3, "part2": 14}`
    - Gleam: Run manually with sample input - PASS: `{"part1": 3, "part2": 14}`
    - Carbon: Run via container with sample input - PASS: `{"part1": 3, "part2": 14}`
    - Bosque: Run via wrapper with sample input - PASS: `{"part1": 3, "part2": 14}`
    - Verified all produce: `{{"part1": 3, "part2": 14}}`
  - [x] 5.3 Test all languages with real input
    - Run each language implementation with challenges/day05/input.txt
    - Capture part1 and part2 results from each language
    - Verify all 4 languages produce identical results
    - Documented the expected results: `{"part1": <redacted>, "part2": <redacted>}`
  - [x] 5.4 Run integration test suite
    - Execute: `./scripts/test_integration.sh 5 --timeout 300`
    - Verify all 4 languages pass - PASS
    - Check that execution completes within 300 second timeout - PASS
    - Resolve any cross-language inconsistencies - None found, all agree
  - [x] 5.5 Write up to 5 additional integration tests if needed
    - Assessed test coverage across all languages
    - No critical gaps identified in cross-language validation
    - Existing coverage is comprehensive (57 tests total)
    - All edge cases covered (parsing, freshness, overlapping ranges, boundaries)
    - No additional tests needed

**Acceptance Criteria:**
- All 4 languages produce identical results for sample input - COMPLETE
- All 4 languages produce identical results for real input - COMPLETE
- Integration test passes: `./scripts/test_integration.sh 5 --timeout 300` - COMPLETE
- Cross-language consistency verified - COMPLETE
- No more than 5 additional tests added if gaps identified - N/A (no gaps found)

**Test Results Summary:**
- Sample input: All 4 languages produce `{"part1": 3, "part2": 14}`
- Real input: All 4 languages produce `{"part1": <redacted>, "part2": <redacted>}`
- Integration test: PASS (all 4 languages agree)
- Total test count: 57 tests across all languages
- Cross-language consistency: 100% agreement

## Execution Order

Recommended implementation sequence:

1. **Rust Implementation** (Task Group 1) - Simplest, well-established patterns
2. **Carbon Implementation** (Task Group 2) - Similar systems approach to Rust
3. **Gleam Implementation** (Task Group 3) - Functional approach, requires full implementation
4. **Bosque Implementation** (Task Group 4) - Requires algorithm documentation + Python wrapper
5. **Integration Testing** (Task Group 5) - Validates all implementations together

## Important Constraints

- **Maintain Part 1 functionality**: All changes must preserve existing Part 1 logic unchanged
- **Use target languages**: Implement in Rust, Gleam, Carbon, Bosque (NOT Python except for Bosque I/O wrapper)
- **Handle 64-bit integers**: Use i64/Int/Int64 for all ingredient IDs
- **Focused testing**: 2-8 tests per language during development, maximum 5 additional tests if critical gaps found
- **JSON output format**: `{{"part1": X, "part2": Y}}` for all languages
- **Stdin input**: All languages read from stdin, not file paths (except via wrapper scripts)
- **Cross-language consistency**: All implementations must produce identical results

## Language-Specific Notes

### Rust
- Use `HashSet<i64>` from `std::collections`
- Strong error handling with `Result` types
- Maintain existing test coverage
- File: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/rust/day05/src/main.rs`

### Carbon
- No dynamic allocation - use global arrays
- Character-by-character I/O pattern
- Compiles in Docker container with Bazel
- Entry point: `fn Run()`
- Import `Core library "range"` for loops
- File: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/carbon/day05/day05_simple.carbon`

### Gleam
- Functional patterns with immutable data
- Use `gleam/set` module for Set operations
- Reads from stdin (not file path)
- Pipe operator for clarity
- Result type for error handling
- File: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/gleam/src/day05.gleam`

### Bosque
- Algorithm documented in `solution.bsq` (canonical implementation)
- Python `runner.py` mirrors Bosque algorithm for I/O
- Python wrapper handles stdin/stdout only
- Unit tests in `test_bosque_day05.py`
- Files:
  - `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/bosque/day05/solution.bsq`
  - `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/bosque/day05/runner.py`
  - `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/bosque/day05/test_bosque_day05.py`

## Success Criteria

- Sample input produces: `{{"part1": 3, "part2": 14}}` across all 4 languages - COMPLETE
- Real input produces identical results across all 4 languages - COMPLETE: `{"part1": <redacted>, "part2": <redacted>}`
- Integration test passes: `./scripts/test_integration.sh 5 --timeout 300` - COMPLETE
- All language-specific tests pass (approximately 8-32 tests total) - COMPLETE: 57 tests total
- Part 1 functionality remains unchanged - COMPLETE
- Code follows language-specific patterns and conventions - COMPLETE
