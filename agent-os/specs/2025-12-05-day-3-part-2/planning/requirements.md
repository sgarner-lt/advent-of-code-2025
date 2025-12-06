# Spec Requirements: Day 3 Part 2 - Maximum 12-Digit Number Extraction

## Initial Description

Day 3 Part 2 - implementing the Part 2 solution for Advent of Code 2025 Day 3 in all 4 languages with cross-language validation.

This is for an Advent of Code 2025 project where solutions are implemented in multiple languages (Rust, Gleam, Roc, Bosque) with validation across all implementations.

## Requirements Discussion

### Algorithm Selection

**Question:** There are three main algorithmic approaches for finding the maximum 12-digit number from a sequence:

- **Option A - Brute Force**: Try all possible combinations of removing digits (O(n!) time complexity)
- **Option B - Dynamic Programming**: Track maximum values at each position with state (O(n*k) time and space where k is 12)
- **Option C - Mathematical/Greedy**: Greedily select the largest available digit at each position from left to right, ensuring enough remaining digits to complete the 12-digit number (O(n) time complexity, optimal solution)

Which approach would you like to implement?

**Answer:** **Option C - Mathematical/Greedy Approach**

The maximum 12-digit number from a sequence is formed by greedily selecting the largest available digit at each position from left to right, ensuring we leave enough remaining digits to complete the 12-digit number. This is the "remove minimum digits to maximize remaining value" problem with O(n) time complexity.

### Implementation Scope

**Question:** Should we extend the existing Part 1 implementations or create entirely separate executables for Part 2?

**Answer:** Extend Part 1 implementations and reuse existing code where possible. The solutions should be in the same executable for all 4 languages.

### Output Format

**Question:** Should the output be JSON with both part1 and part2 keys, or should we have separate outputs?

**Answer:** Output JSON with both part1 and part2 keys. Don't break existing Part 1 implementations.

### Testing Requirements

**Question:** What are the expected test inputs and outputs for validation?

**Answer:**
- Test against `input-sample.txt` with expected output: `3121910778619`
- Use `./scripts/test_integration.sh 3` for validation across all 4 languages
- Must validate that all implementations produce identical answers

### Language Coverage

**Question:** Should this be implemented in all 4 languages (Rust, Gleam, Roc, Bosque)?

**Answer:** Yes, implement in same executable for all 4 languages (Rust, Gleam, Roc, Bosque).

### Performance Considerations

**Question:** Are there any performance constraints or expectations given the input size (100 digits)?

**Answer:** Factor in performance considerations for long input lines (100 digits). The greedy algorithm with O(n) time complexity should handle this efficiently.

### Code Reuse

**Question:** Should we build off existing Part 1 implementations?

**Answer:** Yes, build off existing Part 1 implementations and reuse parsing, file I/O, and output formatting logic.

### Existing Code to Reference

**Similar Features Identified:**

Based on the product context, this spec should reference:

- **Day 1 Part 2 implementation**: Similar pattern of extending Part 1 in the same executable with dual JSON output
- **Day 2 Part 2 implementation**: Another example of extending Part 1 with additional problem logic
- **Cross-language validation framework**: Testing infrastructure at `./scripts/test_integration.sh`

**File Paths:**
- `challenges/day01/rust/`, `challenges/day01/gleam/`, `challenges/day01/roc/`, `challenges/day01/bosque/` - Part 1 + Part 2 dual implementation pattern
- `challenges/day02/rust/`, `challenges/day02/gleam/`, `challenges/day02/roc/`, `challenges/day02/bosque/` - Another dual implementation example
- `challenges/day03/rust/`, `challenges/day03/gleam/`, `challenges/day03/roc/`, `challenges/day03/bosque/` - Existing Part 1 implementations to extend
- `scripts/test_integration.sh` - Cross-language validation script

### Follow-up Questions

None required - all decisions have been made.

## Visual Assets

### Files Provided:
No visual assets provided.

### Visual Insights:
N/A - This is an algorithmic problem with no UI/visual design requirements.

## Requirements Summary

### Functional Requirements

**Core Functionality:**
- Given a sequence of digits (potentially 100 digits long), find the maximum possible 12-digit number that can be formed by removing the minimum number of digits
- Implement greedy algorithm: at each position (0-11), select the largest available digit from the remaining sequence, ensuring enough digits remain to complete the 12-digit number
- Parse input lines from `input.txt` and `input-sample.txt`
- Calculate both Part 1 (sum of max 2-digit numbers per line) and Part 2 (sum of max 12-digit numbers per line)
- Output JSON with both `part1` and `part2` keys

**Algorithm Details:**
- For position i in the result (0-11):
  - Search window: from current position in sequence up to `sequence_length - (12 - i)`
  - Select the largest digit found in this window
  - Move current position to just after the selected digit
  - Repeat for next position

**User Actions Enabled:**
- Run the same executable for Day 3 to get both Part 1 and Part 2 answers
- Validate implementation correctness using `./scripts/test_integration.sh 3`
- Compare performance across all 4 language implementations

**Data to be Managed:**
- Input: Text file with lines of digit sequences (up to 100 digits per line)
- Intermediate: Tracking current position in sequence while building 12-digit number
- Output: JSON with integer keys for `part1` and `part2`

### Reusability Opportunities

**Components that already exist:**
- File I/O and input parsing from Part 1 implementations
- JSON output formatting with `part1` key
- Test infrastructure via `./scripts/test_integration.sh`
- Cross-language validation workflow

**Backend patterns to investigate:**
- How Day 1 and Day 2 structured their Part 1 + Part 2 dual implementations
- String/digit parsing utilities from Part 1
- Iterator/collection manipulation patterns used in Part 1

**Similar features to model after:**
- Day 1 Part 2: Extended Part 1 with additional logic in same executable
- Day 2 Part 2: Similar dual-output JSON structure
- Part 1 of Day 3: Max 2-digit number extraction (conceptually similar, but with k=2)

### Scope Boundaries

**In Scope:**
- Implement greedy algorithm for maximum 12-digit number extraction
- Extend existing Part 1 implementations to include Part 2 logic
- Output JSON with both `part1` and `part2` keys
- Test against sample input with expected output `3121910778619`
- Implement in all 4 languages: Rust, Gleam, Roc, Bosque
- Validate cross-language consistency using test integration script
- Handle input lines up to 100 digits efficiently

**Out of Scope:**
- Alternative algorithms (brute force, dynamic programming)
- UI or visualization of the greedy selection process
- Performance benchmarking beyond basic validation
- Detailed analysis documentation (saved for separate Day 3 Analysis phase)
- Breaking or modifying existing Part 1 functionality

### Technical Considerations

**Integration Points:**
- Must integrate with existing Part 1 implementations without breaking them
- Must work with existing test framework (`./scripts/test_integration.sh 3`)
- Must output JSON format compatible with validation script

**Existing System Constraints:**
- Follow language-specific project structures (Cargo.toml for Rust, gleam.toml for Gleam, etc.)
- Maintain consistency with Day 1 and Day 2 dual-implementation patterns
- Use native testing frameworks for each language (cargo test, gleeunit, roc expect, etc.)
- Input files: `challenges/day03/input.txt` and `challenges/day03/input-sample.txt`

**Technology Preferences:**
- **Rust**: Use itertools, standard library string/digit parsing
- **Gleam**: Use gleam_stdlib, gleam_list for collection manipulation
- **Roc**: Use built-in List and Str modules
- **Bosque**: Use standard library as available in research builds

**Performance Considerations:**
- O(n) time complexity greedy algorithm is optimal for this problem
- Input lines can be up to 100 digits, so efficiency matters
- Each line requires one pass through the sequence (at most 12 iterations with decreasing search windows)
- Expected total runtime: < 1 second for typical inputs across all languages

**Similar Code Patterns to Follow:**
- Dual JSON output structure from Day 1 and Day 2
- File I/O patterns from existing Part 1 implementations
- Iterator/collection processing patterns from Part 1's max 2-digit extraction
- Test structure with sample validation before real input
