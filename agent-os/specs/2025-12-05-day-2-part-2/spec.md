# Specification: Day 2 Part 2 - Extended Pattern Detection

## Goal
Extend Day 2 Part 1 solution to detect invalid product IDs with patterns repeated 2 or more times (not just exactly twice), implementing this enhanced detection across all four languages (Rust, Gleam, Carbon, Bosque) with cross-language validation.

## User Stories
- As a developer learning multiple languages, I want to implement a generalized pattern detection algorithm so that I can understand how each language handles iteration and string manipulation
- As a project maintainer, I want all four language implementations to produce identical results so that I can verify correctness through cross-language validation

## Specific Requirements

**Implement is_invalid_id_part2() function**
- Check if a number string can be split into ANY equal-length pattern repeated 2 or more times
- Iterate through all possible pattern lengths from 1 to floor(length/2)
- For each pattern length, verify the entire string consists of that pattern repeated
- Return true if any valid repeating pattern is found, false otherwise
- Examples: "565656" = "56" repeated 3 times (invalid), "111" = "1" repeated 3 times (invalid), "123456" = no repeating pattern (valid)

**Update solve() function to return Part 2 result**
- Compute both Part 1 sum (patterns repeated exactly twice) and Part 2 sum (patterns repeated 2+ times)
- Return tuple/pair of (part1_sum, Some(part2_sum)) instead of (part1_sum, None)
- Maintain existing Part 1 logic without modification
- Process the same input ranges for both parts
- Output JSON format: {"part1": <number>, "part2": <number>}

**Create process_range_part2() or extend existing logic**
- Iterate through each number in the given range (start to end, inclusive)
- Convert each number to string representation
- Call is_invalid_id_part2() to check for repeating patterns
- Sum all invalid IDs found in the range
- Return the sum for that range

**Add unit tests for Part 2 pattern detection**
- Test single character patterns: "111" (3 repetitions), "999" (3 repetitions)
- Test multi-character patterns: "565656" (3 repetitions of "56"), "824824824" (3 repetitions of "824")
- Test many repetitions: "2121212121" (5 repetitions of "21")
- Test edge cases: "11" (still invalid in Part 2), "123456" (still valid in Part 2)
- Verify that all Part 1 invalid IDs remain invalid in Part 2

**Add integration tests with sample data**
- Test with full sample input ranges from problem statement
- Expected Part 2 sum: 4174379265
- Verify ranges produce correct invalid ID counts: 95-115 has [99, 111], 998-1012 has [999, 1010], 565653-565659 has [565656]
- Compare Part 1 vs Part 2 results to ensure Part 2 is superset of Part 1

**Cross-language implementation consistency**
- Implement identical algorithm logic in Rust, Gleam, Carbon, and Bosque
- Use language-idiomatic patterns (for loops in Rust, tail recursion in Gleam, while loops in Carbon/Bosque)
- Ensure all four implementations produce identical Part 2 sum for sample input
- Use Python wrappers for Carbon and Bosque where language limitations require
- Follow existing code structure and naming conventions from Part 1

**Maintain backward compatibility with Part 1**
- Do not modify is_invalid_id() function logic
- Keep existing Part 1 tests unchanged and passing
- Ensure Part 1 sum remains 1227775554 for sample input
- JSON output must include both part1 and part2 fields

## Expected Algorithm Details

**Pattern Detection Logic**
- For a number string of length N, check pattern lengths from 1 to N/2
- For each candidate pattern length P, extract first P characters as the pattern
- Verify that N is evenly divisible by P (length % pattern_length == 0)
- Check if repeating the pattern (N/P) times equals the original string
- Return true on first matching pattern found (short-circuit optimization allowed)
- Example walkthrough for "565656": try length 1 ("5" != "565656"), try length 2 ("56" * 3 = "565656" MATCH)

**Sample Input Expected Results**
- Range 11-22: invalid IDs [11, 22] (sum 33)
- Range 95-115: invalid IDs [99, 111] (sum 210) - NEW: 111 added in Part 2
- Range 998-1012: invalid IDs [999, 1010] (sum 2009) - NEW: 999 added in Part 2
- Range 565653-565659: invalid IDs [565656] (sum 565656) - NEW: entire range added in Part 2
- Range 824824821-824824827: invalid IDs [824824824] (sum 824824824) - NEW: entire range added in Part 2
- Range 2121212118-2121212124: invalid IDs [2121212121] (sum 2121212121) - NEW: entire range added in Part 2
- Total Part 2 sum: 4174379265

## Existing Code to Leverage

**Rust implementation at /solutions/rust/day02/src/main.rs**
- Reuse parse_ranges() function for input parsing (lines 64-97)
- Reuse main() structure for stdin reading and JSON output (lines 3-21)
- Reference is_invalid_id() for Part 1 logic, implement similar is_invalid_id_part2() (lines 41-54)
- Duplicate or extend process_range() to create process_range_part2() (lines 108-119)
- Update solve() to compute both parts and return (part1, Some(part2)) (lines 128-145)

**Gleam implementation at /solutions/gleam/src/day02.gleam**
- Reuse parse_ranges() and parse_single_range() functions (lines 66-100)
- Reuse build_json() helper for output formatting (lines 151-158)
- Follow tail-recursive pattern from do_process_range() for Part 2 iteration (lines 116-128)
- Use Gleam's Result type and pattern matching for error handling
- Update solve() to call both Part 1 and Part 2 processing (lines 137-148)

**Carbon implementation at /solutions/carbon/day02/day02.carbon**
- Use Python wrapper pattern for string operations and I/O (entire file structure)
- Implement Part 2 algorithm logic in Python wrapper due to Carbon's limited string support
- Follow existing structure with IsInvalidId() conceptual function (lines 46-56)
- Add IsInvalidIdPart2() function skeleton and implement in Python runner
- Carbon code demonstrates algorithm structure while Python handles execution

**Bosque implementation at /solutions/bosque/day02/solution.bsq**
- Reuse parseRanges() structure for input handling (lines 55-85)
- Follow while-loop iteration pattern from processRange() (lines 95-108)
- Use Python wrapper for file I/O and execution (lines 134-163)
- Implement isInvalidIdPart2() following Bosque syntax and structure
- Update main() to output both part1 and part2 in JSON format

**Testing patterns from existing test suites**
- Follow Rust's #[cfg(test)] module structure with unit and integration tests (lines 147-347)
- Use descriptive test names like test_single_repeated_digit() and test_range_11_to_22()
- Validate specific invalid IDs from problem statement ranges
- Include full sample input integration test with expected sum assertion

## Out of Scope
- Performance optimization beyond basic algorithm implementation (unless execution exceeds 15 seconds)
- Refactoring or modifying existing Part 1 code beyond what's needed for Part 2 integration
- Creating Day 2 Analysis document comparing languages (separate feature)
- Implementing alternative algorithms or approaches not specified in requirements
- Adding visualization or UI for results beyond JSON output
- Supporting input formats other than comma-separated ranges from stdin
- Implementing Part 2 detection as a replacement for Part 1 (both must coexist)
- Writing exhaustive edge case tests beyond the specified sample input validation
- Adding command-line flags or configuration options for execution
- Creating shared libraries or code reuse across languages (each must be self-contained)
