# Spec Requirements: Day 1 Part 2 - Cross-Language Implementation

## Initial Description
Implement Part 2 solution in all 5 languages with cross-language validation.

This feature involves implementing the solution for Day 1 Part 2 of Advent of Code across all 5 languages (Bosque, Carbon, Gleam, Roc, Rust) and ensuring cross-language validation to confirm all implementations produce consistent results.

## Problem Context

### Part 1 Summary
Part 1 required counting how many times the dial points at 0 **after completing** each rotation in a sequence. The dial has numbers 0-99 and starts at position 50.

### Part 2 Requirements
Part 2 (Password Method 0x434C49434B) requires counting how many times the dial **crosses through** position 0 **during** rotations, in addition to counting when it lands on 0 at the end of a rotation.

**Key Examples from Problem Statement:**
- Starting at 50, rotation R1000 would cross 0 ten times (multiple complete circles)
- Starting at 82, rotation L68 crosses 0 once during the rotation
- Starting at 55, rotation R60 crosses 0 once during the rotation
- Starting at 32, rotation L82 crosses 0 once during the rotation

## Requirements Discussion

### Updated Implementation Approach

**Core Implementation Decision:**
Instead of passing start and end positions to `count_zero_crossings`, the function should:
- Take the **original position** and the **rotation instruction** (direction + amount)
- Calculate how many times zero is crossed by using the effective rotation size (not the wrapped final position)
- Leave the original `rotate_dial` function completely alone
- Use division by 100 approach for large rotations

**Function Signature:**
```
count_zero_crossings(current_position, direction, amount) -> number of zero crossings
```

### Key Design Constraints

1. **Preserve Part 1 Code**: Do not modify existing `rotate_dial` or other Part 1 functions
2. **JSON Output Structure**: Maintain the existing JSON format with both `part1` and `part2` results
3. **Reuse Existing Infrastructure**: Use all existing .sh files and build upon Part 1 structure
4. **Zero Crossing Algorithm**: Calculate crossings using the effective rotation size before position wrapping occurs

### Algorithm Approach for Large Rotations

For rotations larger than 100, use division to calculate complete circles:
- Amount 1000 = 10 complete circles
- Each complete circle crosses 0 exactly once in each direction
- Remaining amount after division handles the partial rotation

### Testing Requirements

1. **Unit Tests**: Test `count_zero_crossings` function with various scenarios:
   - Simple rotations that don't cross zero
   - Rotations that cross zero once
   - Large rotations that cross multiple times
   - Edge cases (starting at 0, ending at 0, etc.)

2. **Integration Tests**:
   - Validate against sample input (expected answer: 6)
   - Validate against real puzzle input
   - Confirm Part 1 answer remains unchanged

3. **Cross-Language Validation**:
   - All 5 languages must produce identical Part 2 answers
   - Part 1 answers must remain unchanged across all languages

### Workflow

**Test Sequence:**
1. Run unit tests for `count_zero_crossings` in each language
2. Test with sample input (expected: part1=3, part2=6)
3. Test with real puzzle input
4. Validate cross-language consistency

**Output Format:**
```json
{
  "part1": <number>,
  "part2": <number>
}
```

### Existing Code to Reference

**Similar Features Identified:**
- Feature: Day 1 Part 1 implementation - Path: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day01/`
- Components to potentially reuse:
  - Input parsing logic
  - `rotate_dial` function (use as-is, don't modify)
  - Test infrastructure
  - JSON output formatting
  - run-*.sh script patterns

**Existing Project Structure:**
```
challenges/day01/
├── bosque/
├── carbon/
├── gleam/
├── roc/
├── rust/
├── input.txt (shared)
├── sample.txt (shared)
├── run-bosque.sh
├── run-carbon.sh
├── run-gleam.sh
├── run-roc.sh
└── run-rust.sh
```

## Visual Assets

### Files Provided:
No visual assets provided.

### Visual Insights:
No visual assets provided.

## Requirements Summary

### Functional Requirements

1. **New Function**: Create `count_zero_crossings(current_position, direction, amount)` function
   - Takes current dial position (0-99)
   - Takes rotation direction ('L' or 'R')
   - Takes rotation amount (any positive integer)
   - Returns count of times dial crosses through position 0 during rotation
   - Handles large rotations (> 100) efficiently using division

2. **Main Logic Update**: Modify each language's main solving logic to:
   - Calculate Part 1 answer (count final positions at 0) - **unchanged from existing code**
   - Calculate Part 2 answer (count crossings through 0 during rotations)
   - Output both answers in JSON format: `{"part1": X, "part2": Y}`

3. **Preserve Existing Functions**: Do not modify:
   - `rotate_dial` function
   - Input parsing logic
   - Any other Part 1 helper functions

4. **Cross-Language Consistency**: All 5 implementations must:
   - Use the same algorithm approach
   - Produce identical numerical results
   - Follow language-specific idioms while maintaining logical equivalence

### Reusability Opportunities

- **Input Parsing**: Reuse existing parsing logic from Part 1
- **Dial Rotation**: Use existing `rotate_dial` function without modification
- **Test Infrastructure**: Extend existing test suites with Part 2 test cases
- **Build Scripts**: Use existing run-*.sh files (may need minor updates for Part 2)
- **JSON Output**: Follow existing output format pattern from Part 1

### Scope Boundaries

**In Scope:**
- Implement `count_zero_crossings` function in all 5 languages
- Update main logic to calculate both Part 1 and Part 2 answers
- Add unit tests for zero crossing calculation
- Update integration tests to validate Part 2
- Ensure JSON output includes both part1 and part2 results
- Cross-language validation of results
- Document interesting findings about language differences

**Out of Scope:**
- Performance optimization beyond basic efficiency (division approach is sufficient)
- Visualization of dial rotations
- Alternative algorithm implementations for comparison (though comparisons are okay to document)
- Modifying Part 1 code structure or algorithms
- Creating new build scripts (reuse existing ones)

### Technical Considerations

**Algorithm Logic:**
The zero crossing calculation must account for:
1. **Direction Matters**: Left vs. Right rotations cross zero differently
2. **Effective Distance**: Use the actual rotation amount, not the wrapped position
3. **Multiple Crossings**: Large rotations (e.g., 1000 clicks) cross zero many times
4. **Edge Cases**:
   - Starting at 0 (may or may not count as a crossing)
   - Ending at 0 (don't double-count)
   - Exact multiples of 100

**Integration Points:**
- Each language already has input parsing working
- Each language already has `rotate_dial` function working
- Each language already outputs to stdout
- Test scripts already exist and can be extended

**Existing System Constraints:**
- Must maintain JSON output format for consistency
- Must not break Part 1 functionality
- Must follow each language's native idioms and conventions
- Must work with existing build and test infrastructure

**Technology Preferences:**
- **Rust**: Use standard library, avoid unnecessary dependencies
- **Gleam**: Use stdlib and gleeunit for testing
- **Roc**: Use expect statements for testing
- **Carbon**: Use available standard library features
- **Bosque**: Use built-in assertions

**Similar Code Patterns to Follow:**
- Follow existing Part 1 code structure in each language
- Maintain consistent function naming conventions within each language
- Use native testing frameworks already established in Part 1
- Follow existing error handling patterns

## Implementation Notes

### Expected Sample Answer
For the sample input provided in the problem statement:
- Part 1: 3 (dial lands on 0 three times)
- Part 2: 6 (dial crosses through 0 six times total)

### Key Algorithm Insight
The difference between Part 1 and Part 2 is:
- **Part 1**: Count only when position equals 0 after rotation completes
- **Part 2**: Count every time the dial passes through 0, including during rotation

### Cross-Language Validation Strategy
1. Run all 5 languages against sample input first
2. Verify all produce `{"part1": 3, "part2": 6}`
3. Then run all 5 languages against real puzzle input
4. Verify all produce identical results
5. Submit the answer only after cross-language validation passes

### Documentation Requirements
After implementation, document:
- How each language handled the zero crossing logic
- Any language-specific challenges encountered
- Performance comparisons (informal observations)
- Code readability and maintainability observations
- Lessons learned about each language's strengths/weaknesses for this problem
