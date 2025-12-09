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
"""

import sys
import json


def parse_input(input_text):
    """
    Parse input into a 2D list of strings (rows and columns).
    Each line is split on whitespace.
    """
    lines = input_text.strip().split('\n')
    rows = []

    for line in lines:
        parts = line.split()
        row = [part.strip() for part in parts if part.strip()]
        if row:
            rows.append(row)

    return rows


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


def solve(input_text):
    """
    Solve the puzzle: parse input, identify problems, calculate each, and sum results.
    Returns (part1, part2) tuple.
    """
    # Parse input into rows
    rows = parse_input(input_text)

    if not rows:
        return (0, None)

    # Identify vertical problems (transpose to columns)
    problems = identify_problems(rows)

    if not problems:
        return (0, None)

    # Calculate each problem and sum results
    grand_total = 0

    for problem in problems:
        operation = extract_operation(problem)
        if operation:
            result = calculate_problem(problem, operation)
            if result is not None:
                grand_total += result

    return (grand_total, None)


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
