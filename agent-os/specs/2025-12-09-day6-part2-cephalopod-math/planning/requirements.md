# Spec Requirements: Day 6 Part 2 - Cephalopod Math (Right-to-Left Column Reading)

## Initial Description

Implement a solution for Advent of Code Day 6 Part 2. This involves:
- Reading math problems arranged in columns (right-to-left)
- Each number is in its own column with most significant digit at top, least significant at bottom
- Problems are separated by columns of spaces
- The operator (*, +) is at the bottom of each problem column
- Calculate each problem's result and sum them for the grand total

Example:
```
123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +
```

Reading right-to-left by columns:
- Rightmost: 4 + 431 + 623 = 1058
- Second: 175 * 581 * 32 = 3253600
- Third: 8 + 248 + 369 = 625
- Leftmost: 356 * 24 * 1 = 8544
- Grand total: 3263827

## Requirements Discussion

### First Round Questions

**Q1:** When parsing the columns for Part 2, how should we handle numbers that aren't the same height (like "6" vs "123")? Should we treat them as right-aligned in the column representation (so "6" is just "6", not "600")?

**Answer:** Each digit left to right in the column - if the number isn't wide enough then it doesn't contribute and should be skipped.

**Q2:** The example shows reading right-to-left for Part 2. Is this a fundamental change in parsing, or just a different way to describe the same problem separation logic as Part 1?

**Answer:** The input hasn't changed for part 2. It's just how you interpret the numbers in the column that changes - it's not a direct math on the column values but a transformation from column values to new numbers and then math on them.

**Q3:** For the output in Part 2, should we display intermediate results (each column's calculation) or just the final grand total?

**Answer:** Display both the intermediate column calculations (for debugging/verification) and the final grand total.

**Q4:** Should we leverage existing parsing logic from Part 1, or does Part 2's column interpretation require a completely separate implementation?

**Answer:** We can probably reuse all the parsing and storing in arrays and just have functions that operate on the 2d array differently for part 2. If it's easier to just create all new functions in the same file and label part2 or something feel free. Up to the implementer to choose the best option here.

**Q5:** Are there any edge cases we should be aware of? For example:
- Single-digit numbers in columns
- Empty columns (consecutive spaces)
- Operators other than * and +
- Invalid input formats

**Answer:** Focus on the standard case with * and + operators. Single-digit numbers should work as expected (each digit contributes to one column position). Empty columns/consecutive spaces indicate problem boundaries.

**Q6:** What should happen if a number "isn't wide enough" (as mentioned)? Should that position just not contribute to that particular column's number formation?

**Answer:** Correct - if a number isn't wide enough to have a digit at a particular column position, it simply doesn't contribute to that column's number. Skip it and move to the next number that has a digit at that position.

### Existing Code to Reference

**Similar Features Identified:**
- Feature: Day 6 Part 1 solution - Path: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day06/`
- Components to potentially reuse: Input parsing, 2D array storage, file reading logic
- Backend logic to reference: Array traversal patterns, operator evaluation

### Follow-up Questions

**Follow-up 1:** When you said "each digit left to right in the column" - to clarify: in the example with columns containing "123", "45", "6" - for the leftmost column position (column index 0), we read top-to-bottom to form "146" (digit 1 from "123", digit 4 from "45", digit 6 from "6")? And for column index 1, we get "25" (digit 2 from "123", digit 5 from "45", skipping "6" since it has no digit at that position)?

**Answer:** (Implied by previous answer about number formation in Part 2): Each digit left to right in the column - if the number isn't wide enough then it doesn't contribute and should be skipped.

**Follow-up 2:** For problem separation in Part 2 - are problems still separated by rows/columns of spaces in the input, or does the "right-to-left column reading" change how we identify problem boundaries?

**Answer:** The input hasn't changed for part 2. It's just how you interpret the numbers in the column that changes - it's not a direct math on the column values but a transformation from column values to new numbers and then math on them.

**Follow-up 3:** Regarding code reuse strategy - would you prefer we extend the existing Day 6 Part 1 solution file with Part 2 functions, or create a separate solution file? And should we keep the existing Part 1 output intact?

**Answer:** We can probably reuse all the parsing and storing in arrays and just have functions that operate on the 2d array differently for part 2. If it's easier to just create all new functions in the same file and label part2 or something feel free. Up to the implementer to choose the best option here.

## Visual Assets

### Files Provided:
No visual assets provided.

### Visual Insights:
Not applicable - no visual files were provided.

## Requirements Summary

### Functional Requirements

**Core Functionality:**
- Read input file containing math problems arranged in a 2D grid
- Parse the grid into a 2D array structure (reusing Part 1 parsing logic)
- Transform the 2D array using column-based digit extraction (Part 2 specific logic)
- For each column position (left to right):
  - Extract digits from each number at that column position
  - Skip numbers that don't have a digit at that position
  - Form new numbers by concatenating digits top-to-bottom
  - Read these new numbers right-to-left as a math problem
  - The operator is at the bottom of the column
- Calculate each column's math problem result
- Sum all column results to get the grand total

**Number Formation Logic:**
- Process columns left-to-right (column index 0, 1, 2, etc.)
- For each column position:
  - Extract the digit at that position from each number (if it exists)
  - If a number is too short to have a digit at this position, skip it
  - Concatenate digits top-to-bottom to form new numbers
- Example: Numbers "123", "45", "6" in a column:
  - Position 0: "1", "4", "6" → forms numbers 1, 4, 6
  - Position 1: "2", "5", (skip) → forms numbers 2, 5
  - Position 2: "3", (skip), (skip) → forms number 3

**Problem Interpretation:**
- Once new numbers are formed from column extraction, read them right-to-left
- Apply the operator at the bottom to calculate the result
- This is a transformation from the original grid structure to new math problems

**Output Requirements:**
- Display intermediate results for each column's calculation (for debugging/verification)
- Display the final grand total
- Format should be clear and easy to verify against expected output

### Reusability Opportunities

**From Day 6 Part 1:**
- Input file reading logic
- Grid parsing into 2D array
- Data structure for storing the grid
- File path handling
- Error handling patterns

**New Part 2 Specific Logic:**
- Column-based digit extraction function
- Number formation from digit arrays
- Right-to-left problem interpretation
- Column-wise calculation and aggregation

**Implementation Approach:**
- Extend existing Day 6 solution file with Part 2 functions
- Label functions clearly (e.g., `solvePart2`, `extractColumnDigits`, `formNumbersFromColumn`)
- Reuse parsing and storage from Part 1
- Keep Part 1 output/functionality intact
- Allow implementer flexibility in choosing best code organization

### Scope Boundaries

**In Scope:**
- Reading and parsing input file into 2D array (reusing Part 1 logic)
- Implementing column-based digit extraction logic
- Forming new numbers from extracted digits
- Right-to-left problem interpretation
- Calculating individual column results
- Summing column results for grand total
- Displaying intermediate and final results
- Supporting * and + operators
- Handling numbers of varying widths
- Skipping positions where numbers don't have digits

**Out of Scope:**
- Support for operators other than * and +
- Extensive error handling for malformed input (focus on standard case)
- Input validation beyond basic checks
- Alternative interpretations of column reading
- GUI or interactive components
- Performance optimization for very large inputs
- Unit testing (unless specified by project standards)

### Technical Considerations

**Integration Points:**
- Must work with existing Day 6 Part 1 code
- Should read from the same input file structure
- Output format should be consistent with other day solutions

**Implementation Strategy:**
- Reuse existing parsing and 2D array storage from Part 1
- Create new functions for Part 2 logic that operate on the stored array
- Implementer can choose between:
  - Adding Part 2 functions to existing file
  - Creating separate Part 2 file with shared utilities
  - Any other organization that maintains code clarity

**Edge Cases to Handle:**
- Single-digit numbers (contribute to only one column position)
- Numbers of varying lengths in the same problem
- Empty columns indicating problem boundaries (consecutive spaces)
- Column positions beyond the shortest number's length

**Data Flow:**
1. Read input file → 2D array (Part 1 logic)
2. For each column position (left to right):
   - Extract digits from all numbers at that position
   - Skip numbers without digit at that position
   - Form new numbers from extracted digits
3. Interpret new numbers right-to-left as math problems
4. Calculate each column's result
5. Sum all results for grand total
6. Output intermediate and final results

**Testing Strategy:**
- Test with provided example (expected grand total: 3263827)
- Verify intermediate column calculations match expected values
- Test with actual Day 6 input file
- Compare against expected output from problem statement
- Verify handling of numbers with different widths
- Confirm correct skipping of positions without digits

### Constraints

**Must Follow:**
- Digit extraction proceeds left-to-right by column position
- Number formation is top-to-bottom within each column
- Problem interpretation is right-to-left
- Only * and + operators are supported
- Input structure remains unchanged from Part 1
- Output must include both intermediate and final results
