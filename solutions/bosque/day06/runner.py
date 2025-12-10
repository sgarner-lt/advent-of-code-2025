#!/usr/bin/env python3
"""
Python runner for Bosque Day 06 - Trash Compactor Math Worksheet

This script implements the logic described in solution.bsq since Bosque's
standard library and tooling are still in development. It reads from stdin,
processes the input according to the Bosque algorithm, and outputs JSON.

The implementation follows the exact algorithm specified in solution.bsq:
1. Parse vertical math problems from horizontal row input
2. Split on whitespace, trim numbers before parsing
3. Identify columns as separate problems
4. Apply operations (* or +) to each problem's numbers
5. Sum all problem results for grand total

Part 2 extends this with column-based digit extraction:
- Extract digits at each column position from original numbers
- For multiplication (*): extract from RIGHT (position 0 = rightmost)
- For addition (+): extract from LEFT (position 0 = leftmost), then REVERSE
- Form new numbers and calculate results for each position
"""

import sys
import json


def parse_input(input_text):
    """
    Parse input into a 2D list of strings (rows and columns).
    Each line is split on whitespace.

    NOTE: This function is used for Part 1 only. Part 2 uses parse_input_raw()
    to preserve whitespace alignment.
    """
    lines = input_text.strip().split('\n')
    rows = []

    for line in lines:
        parts = line.split()
        row = [part.strip() for part in parts if part.strip()]
        if row:
            rows.append(row)

    return rows


def parse_input_raw(input_text):
    """
    Parse input preserving whitespace for proper column alignment.
    Returns raw lines without modification.

    Part 2 requires preserving whitespace because numbers are read
    vertically by CHARACTER POSITION, not by string position.
    """
    lines = input_text.rstrip('\n').split('\n')
    return lines


def find_column_boundaries(rows):
    """
    Find column boundaries where all rows have whitespace.
    Returns the start positions of each column.

    This is critical for Part 2 because numbers are right-aligned
    in fixed-width columns. For example, "593" might be " 593" and
    "4" might be "   4" in a 4-character column.
    """
    if not rows:
        return []

    max_len = max(len(row) for row in rows)
    boundaries = [0]  # First column always starts at 0

    in_whitespace = False

    for pos in range(max_len):
        # Check if all rows have whitespace or are beyond their length at this position
        all_whitespace = all(
            pos >= len(row) or row[pos].isspace()
            for row in rows
        )

        if all_whitespace and not in_whitespace:
            in_whitespace = True
        elif not all_whitespace and in_whitespace:
            boundaries.append(pos)
            in_whitespace = False

    return boundaries


def extract_columns(rows, boundaries):
    """
    Extract fixed-width columns from rows based on boundaries.
    Returns list of columns, where each column is a list of strings (one per row).

    Each column preserves internal spaces, which is critical for reading
    digits by character position in Part 2.
    """
    columns = []

    for i in range(len(boundaries)):
        start = boundaries[i]
        end = boundaries[i + 1] if i + 1 < len(boundaries) else max(len(row) for row in rows)

        column = []
        for row in rows:
            if start < len(row):
                col_str = row[start:end] if end <= len(row) else row[start:]
                column.append(col_str)
            else:
                column.append("")

        columns.append(column)

    return columns


def identify_problems(rows):
    """
    Identify vertical problems by transposing rows into columns.
    Returns a list of problems where each problem is a list of values from that column.
    """
    if not rows:
        return []

    # Find max columns
    max_cols = max(len(row) for row in rows)

    # Transpose rows into columns
    problems = []
    for col in range(max_cols):
        column = []
        for row in rows:
            if col < len(row):
                column.append(row[col])
        if column:
            problems.append(column)

    return problems


def extract_operation(problem):
    """
    Extract operation symbol from the last element of a problem column.
    Returns the first character which should be * or +.
    """
    if not problem:
        return None

    last = problem[-1]
    if not last:
        return None

    first_char = last[0]
    if first_char in ['*', '+']:
        return first_char

    return None


def calculate_problem(problem, operation):
    """
    Calculate the result of a problem by applying the operation to all numbers.
    Numbers are all elements except the last one (which contains the operation).
    """
    if len(problem) < 2:
        return None

    # Parse all numbers (all elements except the last one)
    numbers = []
    for i in range(len(problem) - 1):
        try:
            num = int(problem[i].strip())
            numbers.append(num)
        except ValueError:
            continue

    if not numbers:
        return None

    # Apply the operation
    if operation == '*':
        result = numbers[0]
        for num in numbers[1:]:
            result *= num
        return result
    elif operation == '+':
        result = numbers[0]
        for num in numbers[1:]:
            result += num
        return result

    return None


def solve_part1(input_text):
    """
    Solve Part 1: parse input, identify problems, calculate each, and sum results.
    Returns the grand total for Part 1.
    """
    # Parse input into rows
    rows = parse_input(input_text)

    if not rows:
        return 0

    # Identify vertical problems (transpose to columns)
    problems = identify_problems(rows)

    if not problems:
        return 0

    # Calculate each problem and sum results
    grand_total = 0

    for problem in problems:
        operation = extract_operation(problem)
        if operation:
            result = calculate_problem(problem, operation)
            if result is not None:
                grand_total += result

    return grand_total


def find_max_width(problems):
    """
    Find the maximum width (number of digits) among all numbers in problems.
    Excludes the operator (last element of each problem).

    This determines how many digit positions we need to process for Part 2.
    Example: numbers [123, 45, 6] have max width 3 (from "123")

    Args:
        problems: List of problem columns, each containing numbers and an operator

    Returns:
        Maximum digit count among all numbers
    """
    max_width = 0

    for problem in problems:
        # Iterate through all elements except the last one (operator)
        for i in range(len(problem) - 1):
            width = len(problem[i])
            if width > max_width:
                max_width = width

    return max_width


def extract_column_digits(problem, column_position, operation):
    """
    Extract digits at a specific column position from a problem column.

    Part 2 uses operator-dependent digit extraction patterns:
    - Multiplication (*): Extract from RIGHT (position 0 = rightmost digit)
      Example: For numbers [123, 45, 6] at position 0: "3", "5", "6" -> "356"
    - Addition (+): Extract from LEFT (position 0 = leftmost digit)
      Example: For numbers [328, 64, 98] at position 0: "3", "6", "9" -> "369"

    The extracted digits are concatenated to form new numbers that are then
    evaluated according to the original operator (with reversal for addition).

    Args:
        problem: List of number strings and operator (last element)
        column_position: Index position to extract (0-based)
        operation: '*' for multiplication or '+' for addition

    Returns:
        String of concatenated digits from all numbers at that position
    """
    digits = ""
    num_rows = len(problem) - 1  # Exclude operator

    for row_idx in range(num_rows):
        number = problem[row_idx]
        num_len = len(number)

        if operation == '*':
            # Multiplication: extract from right
            # Position 0 gets rightmost, position 1 gets second from right, etc.
            if column_position < num_len:
                char_index = num_len - 1 - column_position
                digits += number[char_index]
        else:
            # Addition: extract from left
            # Position 0 gets leftmost, position 1 gets second from left, etc.
            if column_position < num_len:
                digits += number[column_position]

    return digits


def solve_part2(input_text):
    """
    Solve Part 2: Column-based digit extraction with whitespace preservation.

    Part 2 requires preserving whitespace alignment because numbers are read
    vertically by CHARACTER POSITION, not by string position.

    Algorithm:
    1. Parse input preserving raw lines (no split on whitespace)
    2. Find column boundaries (where ALL rows have whitespace)
    3. Extract fixed-width columns (preserving internal spaces)
    4. For each column:
       - The last row contains the operator
       - Read vertically by character position (left to right)
       - For each character position, extract non-whitespace digits top-to-bottom
       - Form numbers from extracted digits
       - These numbers are then read right-to-left and combined with operator
    5. Sum all column results for grand total

    Example with column ["123", " 45", "  6", "*"]:
      Character position 0: "1" → number 1
      Character position 1: "24" → number 24
      Character position 2: "356" → number 356
      Reading right-to-left: 356 * 24 * 1 = 8544

    Returns:
        Grand total for Part 2
    """
    # Parse input preserving whitespace
    raw_lines = parse_input_raw(input_text)

    if not raw_lines:
        return 0

    # Find column boundaries
    boundaries = find_column_boundaries(raw_lines)

    if not boundaries:
        return 0

    # Extract fixed-width columns
    columns = extract_columns(raw_lines, boundaries)

    if not columns:
        return 0

    grand_total = 0

    # Process each column
    for col_idx, column in enumerate(columns):
        if not column:
            continue

        # Last row should contain the operator
        last_row = column[-1]
        operation = last_row.strip()[0] if last_row.strip() else None

        if operation not in ['*', '+']:
            # Skip columns without valid operators
            continue

        # Number rows are all except the last
        number_rows = column[:-1]

        if not number_rows:
            continue

        # Find max width among number rows
        max_width = max(len(s) for s in number_rows)

        if max_width == 0:
            continue

        # Extract numbers by reading vertically at each character position
        numbers_right_to_left = []

        for char_pos in range(max_width):
            digits = ""

            # Read vertically top-to-bottom at this character position
            for row in number_rows:
                if char_pos < len(row):
                    ch = row[char_pos]
                    if not ch.isspace() and ch.isdigit():
                        digits += ch

            # If we extracted any digits, form a number
            if digits:
                numbers_right_to_left.append(digits)

        # Numbers are naturally in left-to-right order (character pos 0 is leftmost)
        # So reverse to get right-to-left reading order
        numbers_right_to_left.reverse()

        # Calculate this column's result
        if numbers_right_to_left:
            problem_with_op = numbers_right_to_left + [operation]
            result = calculate_problem(problem_with_op, operation)

            if result is not None:
                # Debug output to stderr (not stdout, to preserve JSON output)
                print(f"Column {col_idx}: {numbers_right_to_left} {operation} = {result}",
                      file=sys.stderr)
                grand_total += result

    return grand_total


def solve(input_text):
    """
    Solve the puzzle: parse input, identify problems, calculate each, and sum results.
    Returns (part1, part2) tuple.
    """
    part1 = solve_part1(input_text)
    part2 = solve_part2(input_text)

    return (part1, part2)


def main():
    """
    Main entry point.
    Reads from stdin, processes input, and outputs JSON.
    """
    try:
        # Read input from stdin
        input_text = sys.stdin.read()

        # Solve the puzzle
        part1, part2 = solve(input_text)

        # Output JSON format for cross-language validation
        result = {
            "part1": part1,
            "part2": part2
        }
        print(json.dumps(result))

        return 0

    except Exception as e:
        # Error handling: output null results
        print(json.dumps({"part1": None, "part2": None}), file=sys.stderr)
        print(f"Error: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
