# Spec Requirements: Day 2 Part 2

## Initial Description
Implement Part 2 solution in all 4 languages with cross-language validation

## Product Context

### Product Mission Alignment
This feature is part of the Advent of Code 2025 Multi-Language Learning Project, which helps developers master five distinct programming languages (Rust, Roc, Gleam, Carbon, and Bosque) by solving 10 days of coding challenges in parallel. Day 2 Part 2 continues the learning journey by introducing a more complex pattern detection algorithm, building on the skills developed in Part 1.

### Roadmap Position
This is Feature #8 from Phase 2 of the roadmap: "Day 2 Part 2 — Implement Part 2 solution in all 4 languages with cross-language validation"

Phase 2 Learning Goals:
- Practice iteration, conditionals, and collection manipulation patterns
- Build confidence with each language's standard library

### Project Structure
Each language solution follows the established convention:
- Rust: `/solutions/rust/day02/src/main.rs`
- Gleam: `/solutions/gleam/src/day02.gleam`
- Carbon: `/solutions/carbon/day02/day02.carbon`
- Bosque: `/solutions/bosque/day02/solution.bsq`
- Shared input: `/challenges/day02/input.txt` and `/challenges/day02/input-sample.txt`

## Requirements Discussion

### Problem Statement Summary

**Part 1 Rule:** An ID is invalid if it is made only of some sequence of digits repeated exactly twice (the entire number must be splittable in half with equal halves).

**Part 2 Rule (Expanded):** An ID is now invalid if it is made only of some sequence of digits repeated at least twice (2 or more times). The pattern can be any length from 1 character up to half the total length.

**Examples:**
- "12341234" = "1234" repeated 2 times (INVALID)
- "123123123" = "123" repeated 3 times (INVALID)
- "1212121212" = "12" repeated 5 times (INVALID)
- "1111111" = "1" repeated 7 times (INVALID)
- "565656" = "56" repeated 3 times (INVALID)
- "824824824" = "824" repeated 3 times (INVALID)
- "2121212121" = "21" repeated 5 times (INVALID)

### Algorithm Confirmation

**Q1:** To clarify the Part 2 algorithm: For each number, we need to check if it can be split into ANY equal-length repeated pattern (2+ times). The approach should be:
1. For each possible pattern length (1 to length/2)
2. Check if the entire number consists of that pattern repeated 2+ times
3. If any pattern length works, the ID is invalid

Is this the correct approach?

**Answer:** The algorithm approach is confirmed correct:
- `is_invalid_id_part2` function should check if a number can be split into ANY equal-length repeated pattern (2+ times)
- For each possible pattern length (1 to length/2), check if the entire number consists of that pattern repeated 2+ times
- Examples: "565656" = "56" repeated 3 times (INVALID), "1111" = "1" repeated 4 times (INVALID), "121212" = "12" repeated 3 times (INVALID), "12341234" = "1234" repeated 2 times (INVALID)

### Existing Code to Reference

**Similar Features Identified:**

The project has existing Day 2 Part 1 solutions in all 4 languages that should be referenced and extended:

**Rust Implementation:** `/solutions/rust/day02/src/main.rs`
- Existing `is_invalid_id()` function that checks for pattern repeated exactly twice (split in half)
- Existing `parse_ranges()` function for parsing comma-separated ranges
- Existing `process_range()` function for iterating through a range
- Existing `solve()` function structure that returns `(part1_sum, Option<part2_sum>)`
- Currently returns `None` for Part 2 - needs to be updated to return the Part 2 sum

**Gleam Implementation:** `/solutions/gleam/src/day02.gleam`
- Similar structure to Rust solution
- Should follow Gleam idioms and patterns

**Carbon Implementation:** `/solutions/carbon/day02/day02.carbon`
- Similar structure to Rust solution
- Should follow Carbon idioms and patterns

**Bosque Implementation:** `/solutions/bosque/day02/solution.bsq`
- Similar structure to Rust solution
- Should follow Bosque idioms and patterns

**Components to Reuse:**
- Input parsing logic (`parse_ranges()`)
- Range iteration logic (`process_range()`)
- Main solution structure (`solve()` function)
- Test structure and sample data validation

**New Logic Required:**
- New `is_invalid_id_part2()` function that checks for patterns repeated 2+ times (not just exactly twice)
- Update `solve()` to compute both Part 1 and Part 2 sums
- Update `process_range()` or create `process_range_part2()` to use the new validation function

### Follow-up Questions
No follow-up questions were needed.

## Visual Assets

### Files Provided:
No visual assets provided.

### Visual Insights:
No visual insights (this is an algorithmic problem with no UI components).

## Requirements Summary

### Functional Requirements

**Core Functionality:**
1. Extend existing Day 2 Part 1 solution to include Part 2 logic
2. Implement new pattern detection algorithm: `is_invalid_id_part2()`
3. Check if a number can be split into ANY equal-length pattern repeated 2+ times
4. Return both Part 1 and Part 2 sums in the JSON output format

**Algorithm Details:**
- For each number in the ranges, convert to string
- For each possible pattern length (1 to length/2):
  - Extract the pattern (first N characters)
  - Check if the entire number equals that pattern repeated length/N times
  - If number length is evenly divisible by pattern length AND all repetitions match, it's invalid
- Pattern lengths to check: 1, 2, 3, ..., up to floor(length/2)

**Input/Output:**
- Input: Comma-separated ranges from stdin (same as Part 1)
- Output: JSON format `{"part1": <sum>, "part2": <sum>}`

**Testing Requirements:**
1. Validate against sample input first
2. Expected Part 2 sample output: 4174379265
3. Cross-language validation: all 4 languages must produce identical answers
4. Unit tests for pattern detection edge cases
5. Integration tests for the full sample input

### Reusability Opportunities

**Existing Functions to Reuse:**
- `parse_ranges()` - no changes needed
- `process_range()` - can be extended or duplicated for Part 2
- `solve()` - update to compute both parts
- Test structure and assertions

**Code Patterns to Follow:**
- Consistent function naming across languages
- String manipulation for pattern detection
- Iterative approach over ranges
- Same JSON output format

**Similar Logic:**
- Part 1's `is_invalid_id()` checks pattern repeated exactly twice (split in half)
- Part 2's `is_invalid_id_part2()` generalizes this to check patterns repeated 2+ times

### Scope Boundaries

**In Scope:**
- Implement `is_invalid_id_part2()` function in all 4 languages
- Update `solve()` to return Part 2 sum (not None)
- Add unit tests for Part 2 pattern detection
- Add integration test for Part 2 sample input validation
- Ensure cross-language answer consistency
- Maintain existing Part 1 functionality

**Out of Scope:**
- Performance optimization (unless execution exceeds 15 seconds)
- Refactoring of Part 1 code (unless needed for Part 2)
- Day 2 Analysis document (separate feature #9)
- UI or visualization of results
- Alternative algorithm implementations (stick to the confirmed approach)

**Future Enhancements (Day 2 Analysis):**
- Language comparison notes
- Performance benchmarking across languages
- Lessons learned documentation

### Technical Considerations

**Integration Points:**
- Must read from stdin (same as Part 1)
- Must output JSON format for testing framework
- Must work with existing test harness

**Existing System Constraints:**
- Solutions must be self-contained in language-specific directories
- All languages share the same input files
- Testing framework expects specific JSON output format
- Cross-language validation is mandatory before proceeding to Day 3

**Technology Stack:**
- Rust 1.83.0+ with cargo test
- Gleam 1.13.0+ with gleeunit
- Carbon (experimental)
- Bosque (research/experimental)

**Testing Strategy:**
1. Sample data validation first (expected: 4174379265 for Part 2)
2. Cross-language consistency check
3. Real input validation
4. Unit tests for edge cases (single digit patterns, multi-char patterns, non-repeating numbers)

**Similar Code Patterns:**
- Follow the same structure as Day 1 solutions
- Use idiomatic patterns for each language
- Maintain readability and clear documentation
- Use native testing frameworks for each language

### Expected Test Cases

**Part 2 Sample Ranges (from problem statement):**
- 11-22: invalid IDs = [11, 22] (same as Part 1)
- 95-115: invalid IDs = [99, 111] (added 111 which is "1" repeated 3 times)
- 998-1012: invalid IDs = [999, 1010] (added 999 which is "9" repeated 3 times)
- 1188511880-1188511890: invalid IDs = [1188511885] (same as Part 1)
- 222220-222224: invalid IDs = [222222] (same as Part 1)
- 1698522-1698528: invalid IDs = [] (none, same as Part 1)
- 446443-446449: invalid IDs = [446446] (same as Part 1)
- 38593856-38593862: invalid IDs = [38593859] (same as Part 1)
- 565653-565659: invalid IDs = [565656] ("56" repeated 3 times - NEW in Part 2)
- 824824821-824824827: invalid IDs = [824824824] ("824" repeated 3 times - NEW in Part 2)
- 2121212118-2121212124: invalid IDs = [2121212121] ("21" repeated 5 times - NEW in Part 2)

**Expected Part 2 Sum:** 4174379265
