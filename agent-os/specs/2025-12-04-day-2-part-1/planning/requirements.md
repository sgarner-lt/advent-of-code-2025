# Spec Requirements: Day 2 Part 1 - Gift Shop Invalid Product IDs

## Initial Description
Implement the solution for Advent of Code 2025 Day 2 Part 1 in all required languages (Rust, Gleam, Carbon, Bosque). The problem involves identifying invalid product IDs within given ranges, where an invalid ID is one that contains any substring pattern repeated consecutively.

## Requirements Discussion

### First Round Questions

**Q1: Algorithm Understanding**
**Question:** The problem states "made only of some sequence of digits repeated twice" - but your clarification shows this means detecting ANY consecutively repeated substring pattern anywhere in the number, not just splitting in half. Is this correct?
**Answer:** YES - Confirmed. The algorithm must check for ANY substring pattern that appears twice consecutively. Examples:
- 12341234 is invalid (contains "1234" repeated, plus "12", "123", "23", "234", "34" all repeated)
- 123412 is invalid (contains "12" repeated)
- 121212 is invalid (contains "12" repeated three times, "21" repeated twice)
- 12345656 is invalid (contains "56" repeated)
- 123456 is VALID (no consecutive repeated patterns)

**Q2: Algorithm Implementation Approach**
**Question:** Should we iterate through all possible substring lengths (1 to N/2) and check for consecutive repetition at each position?
**Answer:** YES - The user confirmed: "You'll never have a sequence duplicated which is longer than half the length of the whole sequence." This means we check substring lengths from 1 up to floor(N/2), and for each length, slide through the string checking if any substring of that length appears twice consecutively.

**Q3: Testing Strategy**
**Question:** Should we create unit tests using the problem examples, and then validate with the full input.txt as an integration test?
**Answer:** YES - User explicitly recommended: "If you take the examples and write unit tests and then use the larger main statement in the input-statement.txt through via integration test as well should be able to figure out the edge cases."

**Q4: Edge Cases to Handle**
**Question:** What edge cases should we explicitly test?
**Answer:** Based on user's examples:
- Single digit numbers (e.g., "1", "5") - should be VALID (too short for patterns)
- Two digit same (e.g., "11", "22") - should be INVALID (digit repeated)
- Two digit different (e.g., "12", "34") - should be VALID (no repetition)
- Short patterns repeated multiple times (e.g., "121212")
- Long patterns (e.g., "12341234")
- Mid-length patterns (e.g., "12345656" with "56" repeated)

**Q5: Input Format and Output**
**Question:** The problem gives ranges like "11-22,95-115" - we need to parse these ranges, generate all numbers in each range, check each for validity, and sum all invalid IDs. Is this correct?
**Answer:** YES - Based on the problem statement:
- Input is comma-separated ranges on a single line
- Each range is "start-end" (inclusive)
- Check each number in each range
- Sum all invalid IDs found
- Example answer from problem statement: 1227775554

**Q6: Language Implementation**
**Question:** This should be implemented in Rust, Gleam, Carbon, and Bosque following the project structure in solutions/{language}/day02/, correct?
**Answer:** YES - Following the established project structure with:
- solutions/rust/day02/
- solutions/gleam/day02/
- solutions/carbon/day02/
- solutions/bosque/day02/
- Input file at challenges/day02/input.txt (shared)

**Q7: Performance Considerations**
**Question:** Some ranges are very large (e.g., 9957459726-9957683116 has over 200,000 numbers). Should we optimize for performance or focus on correctness first?
**Answer:** Per tech stack guidelines: "Correctness First: Get the right answer in all languages. Profile Second: Identify bottlenecks only if solution is too slow." Target execution time is < 15 seconds.

**Q8: Scope Boundaries**
**Question:** This spec is ONLY for Part 1, correct? Part 2 will be a separate spec after Part 1 is complete?
**Answer:** YES - This is explicitly Day 2 Part 1. Part 2 will follow as a separate implementation phase once Part 1 is validated.

### Existing Code to Reference

**Similar Features Identified:**
- Feature: Day 1 solutions - Path: `solutions/{rust,gleam,carbon,bosque}/day01/`
- Components to potentially reuse:
  - File I/O patterns for reading from challenges/day02/input.txt
  - String parsing and number conversion patterns
  - Testing framework setup and structure
  - Cross-language validation approach
- Backend logic to reference:
  - Input parsing (comma-separated, dash-separated ranges)
  - Number iteration over ranges
  - Validation functions with unit tests

### Follow-up Questions

None needed - all requirements are clear based on the detailed algorithm clarification provided by the user.

## Visual Assets

### Files Provided:
No visual assets provided.

### Visual Insights:
N/A - This is an algorithmic problem without UI/visual components.

## Requirements Summary

### Functional Requirements

**Core Algorithm:**
1. Parse input line containing comma-separated number ranges (e.g., "11-22,95-115")
2. For each range "start-end", generate all numbers from start to end (inclusive)
3. For each number, convert to string and check if it contains ANY consecutively repeated substring pattern
4. Pattern detection algorithm:
   - For substring lengths L from 1 to floor(string_length / 2)
   - Slide through string checking if any L-length substring appears twice consecutively
   - If found, number is INVALID
5. Sum all invalid IDs found across all ranges
6. Output the sum

**Input Handling:**
- Read from challenges/day02/input.txt
- Parse comma-separated ranges
- Handle ranges with very large numbers (up to 9+ digits)
- Handle ranges with many numbers (200k+ numbers in a range)

**Validation Logic:**
- A number is INVALID if it contains ANY substring pattern that appears twice consecutively
- A number is VALID if NO such pattern exists
- Maximum pattern length to check is half the total length of the number string

**Output:**
- Single integer: sum of all invalid product IDs

### Unit Test Cases

Based on problem statement examples:

1. **Test: "12341234"** → INVALID (expect to be counted as invalid)
   - Contains "1234" repeated consecutively
   - Also contains shorter patterns: "12", "123", "23", "234", "34" all repeated

2. **Test: "123412"** → INVALID (expect to be counted as invalid)
   - Contains "12" repeated consecutively at the beginning

3. **Test: "121212"** → INVALID (expect to be counted as invalid)
   - Contains "12" repeated three times consecutively
   - Also contains "21" repeated

4. **Test: "12345656"** → INVALID (expect to be counted as invalid)
   - Contains "56" repeated consecutively

5. **Test: "123456"** → VALID (expect to be counted as valid)
   - No consecutively repeated patterns found

6. **Test: Single digit "1"** → VALID
   - Too short to have patterns

7. **Test: Same digits "11"** → INVALID
   - Contains "1" repeated

8. **Test: Different digits "12"** → VALID
   - No repetition

9. **Test: Range "11-22"** → Should find 2 invalid IDs (11 and 22)

10. **Test: Range "95-115"** → Should find 1 invalid ID (99)

11. **Test: Range "998-1012"** → Should find 1 invalid ID (1010)

12. **Integration Test:** Full input from challenges/day02/input.txt
    - Expected sum from example: 1227775554 (for example input)
    - Actual answer will differ for real puzzle input

### Reusability Opportunities

**From Day 1 Solutions:**
- File reading patterns (reading from challenges/ directory)
- String parsing utilities
- Testing framework structure
- Cross-language validation workflow

**Common Patterns to Implement:**
- Range parsing function: parse_range("11-22") → (11, 22)
- Number iteration: generate all numbers in range
- String pattern detection: is_invalid(number_string) → bool
- Summation of invalid IDs

### Scope Boundaries

**In Scope:**
- Parse input ranges from challenges/day02/input.txt
- Implement substring pattern detection algorithm
- Identify all invalid product IDs in given ranges
- Sum invalid IDs and output total
- Unit tests with problem examples
- Integration test with full input
- Implementation in Rust, Gleam, Carbon, and Bosque
- Cross-language validation (all must produce same answer)

**Out of Scope:**
- Day 2 Part 2 (separate spec after Part 1 completion)
- Optimization beyond 15-second execution target
- Leading zero handling (problem states "None of the numbers have leading zeroes")
- UI or visualization of results
- Performance benchmarking (done after correctness validated)
- Language comparison analysis (done after both parts complete)

**Future Enhancements (Day 2 Part 2):**
- Part 2 requirements TBD after Part 1 completion
- Additional algorithm variations or problem extensions

### Technical Considerations

**Performance:**
- Some ranges contain 200k+ numbers (e.g., 9957459726-9957683116)
- Target execution time: < 15 seconds per language
- Algorithm complexity: O(N * L^2) where N is total numbers checked, L is average string length
- May need optimization if initial implementation is too slow

**Integration Points:**
- Input file: challenges/day02/input.txt (shared across all languages)
- Output: Console output with final sum
- Testing: Each language uses native test framework

**Language-Specific Constraints:**
- Rust: Use itertools, rustc-hash as needed from tech stack
- Gleam: Use simplifile for file I/O, gleeunit for tests
- Carbon: Experimental tooling - may have limitations
- Bosque: Research language - may lack features

**Technology Stack:**
- Rust 1.83.0+ with cargo test
- Gleam 1.13.0+ with gleeunit
- Carbon experimental build
- Bosque research build
- All solutions must read from same shared input file

**Similar Code Patterns to Follow:**
- Day 1 file I/O structure
- Day 1 testing approach
- Day 1 project organization within solutions/ directory

**Cross-Language Validation Requirements:**
- All 4 languages must produce identical sums
- Unit tests must pass in all languages before integration testing
- Integration test must pass in all languages before considering complete
- Validate against problem example sum: 1227775554 (for example input)
