# Specification: Day 6 Part 2 - Cephalopod Math Right-to-Left Column Reading

## Goal
Implement Part 2 of the Advent of Code Day 6 challenge by transforming the parsed grid data using column-based digit extraction to form new numbers, then evaluating math problems right-to-left to calculate a grand total.

## User Stories
- As a developer, I want to reuse the existing Part 1 parsing logic so that I don't duplicate input handling code
- As a user, I want to see both intermediate column calculations and the final grand total so that I can verify the solution is working correctly

## Specific Requirements

**Column-Based Digit Extraction**
- Process the 2D array by column position (left to right, starting at position 0)
- For each column position, extract the digit at that position from each number in the original grid
- Skip numbers that are too short to have a digit at the current position
- Extract digits from all rows top-to-bottom to form new numbers for that column
- Each column position produces a set of new numbers that become a new math problem

**Number Formation from Digits**
- When extracting digits at position N from numbers like "123", "45", "6", handle varying widths correctly
- Position 0 extracts leftmost digits: "1" from "123", "4" from "45", "6" from "6" → forms 1, 4, 6
- Position 1 extracts second digits: "2" from "123", "5" from "45", skip "6" → forms 2, 5
- Position 2 extracts third digits: "3" from "123", skip others → forms 3
- Concatenate extracted digits top-to-bottom to form complete numbers for each column

**Right-to-Left Problem Interpretation**
- After forming new numbers from each column position, interpret them as math problems
- Read the new numbers from each column position right-to-left
- Apply the operator found at the bottom of the original column to these new numbers
- Calculate the result for each column's transformed problem

**Column Width Calculation**
- Determine the maximum width among all numbers in the original grid (excluding operators)
- Iterate through column positions from 0 to max_width - 1
- Each position generates a separate math problem from the extracted digits

**Operator Handling**
- Reuse the operator extraction logic from Part 1
- The operator at the bottom of each original problem column applies to the new numbers formed from that column
- Support multiplication and addition operators only

**Result Aggregation**
- Calculate the result for each column position's math problem
- Sum all column results to produce the grand total
- Display intermediate results for each column calculation for debugging and verification
- Display the final grand total as the answer

**Code Organization**
- Extend the existing Day 6 Part 1 solution file with Part 2 functions
- Label new functions clearly (e.g., solve_part2, extract_column_digits, form_numbers_from_column)
- Reuse parse_input and identify_problems functions from Part 1
- Maintain Part 1 functionality intact - both parts should coexist in the solution

**Multi-Language Implementation**
- Implement Part 2 logic in all supported languages (Python/Bosque, Rust, Gleam, Carbon)
- Follow the same patterns established in Part 1 for each language
- Maintain consistent JSON output format with part1 and part2 fields
- Update the solve function to return both part1 and part2 results

**Output Format**
- JSON output with structure: {"part1": <value>, "part2": <value>}
- For debugging purposes, optionally log intermediate column calculations to stderr
- Include clear labels showing which column position produced which result
- Final stdout output must be valid JSON for testing framework compatibility

**Edge Cases**
- Handle single-digit numbers that only contribute to position 0
- Handle problems where the rightmost number is wider than others
- Skip positions correctly when numbers don't extend that far
- Maintain correct operator association when forming new problems

## Visual Design
No visual mockups provided for this specification.

## Existing Code to Leverage

**parse_input function from Part 1**
- Already handles reading input and splitting on whitespace
- Returns 2D array structure with rows of trimmed strings
- Can be reused without modification for Part 2
- Handles empty lines and whitespace correctly
- Available in Python (runner.py lines 21-35) and Rust (main.rs lines 30-40)

**identify_problems function from Part 1**
- Transposes rows into columns to identify separate math problems
- Returns list of columns where each column is a problem
- Can be reused to access the original grid structure for Part 2 transformation
- Handles variable column lengths correctly
- Available in Python (runner.py lines 38-59) and Rust (main.rs lines 44-70)

**extract_operation function from Part 1**
- Extracts operator symbol (* or +) from last element of column
- Validates operator is one of the two supported types
- Can be reused for Part 2 to get the operator for transformed problems
- Available in Python (runner.py lines 62-78) and Rust (main.rs lines 74-88)

**calculate_problem function from Part 1**
- Applies operation (multiplication or addition) to a list of numbers
- Handles operator evaluation with proper error handling
- Can be reused for Part 2 after new numbers are formed from digit extraction
- Includes overflow checking in Rust implementation
- Available in Python (runner.py lines 81-113) and Rust (main.rs lines 92-129)

**JSON output structure from Part 1**
- Already established pattern of returning {"part1": value, "part2": value}
- Part 1 currently returns null for part2
- Update the solve function to populate part2 with the new calculation
- Maintain stderr error handling for invalid inputs
- Available in both Python main() and Rust main() functions

## Out of Scope
- Support for operators other than multiplication and addition
- Extensive input validation beyond what Part 1 already provides
- GUI or interactive visualization of the transformation process
- Performance optimization for grids larger than typical Advent of Code inputs
- Alternative interpretations of "right-to-left" reading beyond column position extraction
- Backward compatibility with non-standard input formats
- Unit tests for every intermediate function (focus on integration testing with sample input)
- Creating separate files for Part 2 - extend existing solution files instead
- Modifying or breaking existing Part 1 functionality
- Handling operators in positions other than the bottom of columns
