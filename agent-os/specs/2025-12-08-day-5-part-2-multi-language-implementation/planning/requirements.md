# Spec Requirements: Day 5 Part 2 Multi-Language Implementation

## Initial Description

Day 5 Part 2 — Implement Part 2 solution in all 4 languages with cross-language validation

This is part of an Advent of Code 2025 challenge project. The user is implementing solutions in 4 languages: Rust, Gleam, Carbon, and Bosque.

The Day 5 Part 2 problem is about processing ingredient ID ranges to determine how many ingredient IDs are considered "fresh". The problem statement involves:
- Reading fresh ingredient ID ranges from a database file
- Finding all unique ingredient IDs that fall within ANY of these ranges
- Counting the total number of fresh ingredient IDs

This builds on Day 5 Part 1 (which is already completed). The implementation needs to:
1. Parse input containing ingredient ID ranges (format: X-Y where X and Y are integers)
2. Generate all IDs covered by all ranges
3. Handle overlapping ranges correctly (avoid double-counting)
4. Implement the solution in all 4 languages (Rust, Gleam, Carbon, Bosque)
5. Validate that all 4 implementations produce identical results

## Requirements Discussion

### First Round Questions

**Q1:** Should we add Part 2 as a separate function, or integrate it into the existing Part 1 solution to return both results?
**Answer:** Add onto Part 1. Should return both part 1 result unchanged and additionally part 2 result.

**Q2:** For Part 2, we need to count unique ingredient IDs across all ranges. I'm assuming we should use sets to handle overlapping ranges efficiently. Is that the right approach, or would you prefer a different algorithm (like merging intervals)?
**Answer:** Sets seem fine for handling overlapping ranges.

**Q3:** Looking at the input, the ingredient IDs are very large numbers (e.g., 20362219004570-27230899748695). I assume we need to use 64-bit integers (i64/Int64/long). Should I verify the data type by checking the actual values in inputs.txt?
**Answer:** Check the inputs.txt values and use the proper type for the data.

**Q4:** For Part 2, do we need to handle arbitrary range sizes, or is there a practical limit based on the input? Should I count how many ranges are in the real input.txt to determine the maximum?
**Answer:** The input.txt has them all, count them and that's the max.

**Q5:** Should the solution follow the same input/output patterns as Part 1 (reading from stdin, outputting JSON format {"part1": X, "part2": Y})?
**Answer:** Yes, same patterns (stdin, JSON output, existing test framework).

**Q6:** For the Part 2 implementation, should we reuse the existing range parsing and validation logic from Part 1, or build fresh code?
**Answer:** Just don't use the available IDs for part 2.

**Q7:** What data structures should we use for representing ranges? Would you prefer simple tuples/structs, or should we create dedicated Range types with helper methods?
**Answer:** Doesn't seem like you need something powerful to represent ranges. Could be classes with begin and end and merge function.

**Q8:** Are there any features we should explicitly exclude from this implementation (like performance optimizations, visualization, or additional metrics beyond the count)?
**Answer:** All this is out of scope, stick to solving tech problem.

### Existing Code to Reference

**Similar Features Identified:**
- Feature: Day 5 Part 1 implementations - Paths:
  - `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/rust/day05/src/main.rs`
  - `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/gleam/day05/src/day05.gleam`
  - `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/carbon/day05/day05_simple.carbon`
  - `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/bosque/day05/day05.bsq`
  - `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/bosque/day05/solution.bsq`

- Components to potentially reuse: Range parsing logic, input reading, JSON output formatting, error handling patterns

- Language-specific patterns documented in:
  - `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/docs/languages/rust.md`
  - `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/docs/languages/gleam.md`
  - `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/docs/languages/carbon.md`
  - `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/docs/languages/bosque.md`

### Follow-up Questions

No follow-up questions were needed. User provided clear, comprehensive answers to all initial questions.

## Visual Assets

### Files Provided:
No visual assets provided.

### Visual Insights:
Not applicable - this is an algorithmic problem that doesn't require visual design.

## Requirements Summary

### Functional Requirements

**Part 2 Core Functionality:**
- Count the total number of unique ingredient IDs that fall within ANY of the fresh ingredient ID ranges
- Part 2 should ignore the second section of the input (the available ingredient IDs list)
- Ranges are inclusive: range 3-5 means IDs 3, 4, and 5 are all fresh
- Overlapping ranges must be handled correctly (no double-counting)
- Example: Ranges 3-5, 10-14, 16-20, 12-18 should produce count of 14 unique IDs

**Integration with Part 1:**
- Extend existing Part 1 solutions rather than creating separate implementations
- Return both Part 1 and Part 2 results in a single execution
- Maintain Part 1 logic unchanged
- Output format: `{"part1": <count>, "part2": <count>}`

**Input Processing:**
- Read from stdin (standard input)
- Parse ingredient ID ranges from first section (before blank line)
- Ignore second section for Part 2 (available IDs list)
- Handle large 64-bit integer values (verified from input.txt)
- Input contains 185 ranges in the real puzzle input
- Range format: `START-END` where START and END are integers

**Data Types:**
- Use 64-bit integers (i64 in Rust, Int in Gleam, Int64 in Carbon/Bosque)
- Verified necessary due to very large numbers like 20362219004570-27230899748695

**Algorithm Approach:**
- Use sets to collect unique ingredient IDs across all ranges
- Simple range representation (tuples or basic structs with start/end fields)
- Optional: implement merge function for ranges if helpful
- No need for complex range data structures

**Output Requirements:**
- JSON format: `{"part1": X, "part2": Y}`
- Output to stdout
- Handle errors gracefully with null values in JSON output
- Exit with appropriate status codes on failure

**Cross-Language Validation:**
- All 4 language implementations must produce identical results
- Sample input expected output: `{"part1": 3, "part2": 14}`
- Success criteria: Pass integration tests with `./scripts/test_integration.sh 5 --timeout 300`

**Critical Constraint:**
- Solutions MUST be implemented in the target language (Rust, Gleam, Carbon, Bosque)
- NOT in Python or any other language
- Follow language-specific idioms and patterns as documented in `docs/languages/<language>.md`

### Reusability Opportunities

**Components from Part 1 to Reuse:**
- Range parsing logic (`parse_range` function)
- Input reading and splitting into sections
- Error handling patterns
- JSON output formatting
- Test structure and assertions

**Language-Specific Patterns:**
- Each language has documented patterns in `docs/languages/` directory
- Rust: Use `HashSet` for unique ID collection, maintain existing error handling with `Result` types
- Gleam: Follow functional patterns with proper type safety
- Carbon: Use appropriate collections for set operations
- Bosque: Leverage algebraic operations where applicable

**Existing Code Structure:**
- Main function reads stdin and calls solve function
- Solve function returns tuple of (part1_result, part2_result)
- Part 1 already has comprehensive test coverage to maintain

### Scope Boundaries

**In Scope:**
- Implement Part 2 logic to count unique IDs across all ranges
- Extend all 4 existing language implementations (Rust, Gleam, Carbon, Bosque)
- Handle overlapping ranges correctly using sets
- Return both Part 1 and Part 2 results in single execution
- Validate against sample input (expected: part2 = 14)
- Pass integration tests with real input

**Out of Scope:**
- Performance optimizations beyond basic algorithm
- Visualization of ranges or IDs
- Additional metrics or statistics
- Interval merging optimizations (unless needed for correctness)
- Analysis or comparison of approaches across languages
- Benchmarking or performance measurement
- Creating new test files or modifying test framework
- Changing existing Part 1 functionality
- Using Python or any language other than the 4 target languages

### Technical Considerations

**Input Characteristics:**
- 185 ranges in the real puzzle input
- Very large integer values requiring 64-bit representation
- Ranges can overlap (e.g., 12-18 and 16-20)
- Single blank line separates ranges from available IDs
- Available IDs section is ignored for Part 2

**Integration Points:**
- Existing Part 1 solve function needs to be extended
- Maintain same stdin input reading mechanism
- Keep same JSON output format
- Preserve existing error handling patterns

**Language-Specific Considerations:**
- Follow patterns documented in `docs/languages/<language>.md` files
- Use native collection types appropriate for each language
- Maintain idiomatic code style for each language
- Respect each language's type system and constraints

**Testing Requirements:**
- Validate against sample input: part2 should return 14
- Run full integration test suite: `./scripts/test_integration.sh 5 --timeout 300`
- Ensure cross-language consistency (all 4 languages return same answers)
- Maintain existing Part 1 test coverage

**Performance Targets:**
- Solutions should complete within integration test timeout (300 seconds)
- No specific optimization requirements beyond correctness
- Set-based approach should be sufficient for input size (185 ranges)

**Edge Cases to Handle:**
- Empty ranges section
- Single-point ranges (e.g., 253462588002459-253462588002459)
- Very large ranges (e.g., 20362219004570-27230899748695)
- Overlapping ranges of varying degrees
- Adjacent but non-overlapping ranges

**Constraints:**
- Must use target languages (Rust, Gleam, Carbon, Bosque) exclusively
- Cannot use Python or other scripting languages for implementation
- Must follow existing code structure and patterns
- Must maintain backward compatibility with Part 1
