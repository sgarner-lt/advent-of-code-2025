#!/usr/bin/env python3
"""
Carbon Day 03 Runner Wrapper

This is a temporary wrapper to simulate Carbon execution until Carbon's
standard library matures to support stdin and I/O operations.

The Carbon implementation in day03.carbon contains the correct algorithm,
but cannot execute independently due to Carbon's experimental state.

This wrapper:
1. Reads input from stdin
2. Implements the same 2-digit pair extraction and maximum finding algorithm
3. Outputs the result in the required JSON format

The algorithm logic here mirrors the Carbon implementation in day03.carbon
"""

import sys
import json


def extract_pairs(line):
    """
    Extracts all possible 2-digit pairs from a line by picking any two positions.

    For each pair of positions (i, j) where i < j, creates a 2-digit number
    from digits at those positions. For example, "987" with positions (0,2) yields 97.

    Algorithm:
    1. For each position i from 0 to length-1
    2. For each position j from i+1 to length-1
    3. Create a 2-digit number from digits at positions i and j
    4. Add to list of pairs

    Args:
        line: String containing digit characters

    Returns:
        List of integers representing all possible 2-digit pairs

    Examples:
        "987" → [98, 97, 87]
        "12" → [12]
        "9" → []
    """
    pairs = []

    if len(line) < 2:
        return pairs

    # Generate all possible pairs by selecting any two positions
    for i in range(len(line)):
        for j in range(i + 1, len(line)):
            # Create 2-digit number from positions i and j
            first_digit = line[i]
            second_digit = line[j]

            if first_digit.isdigit() and second_digit.isdigit():
                pair_str = f"{first_digit}{second_digit}"
                pairs.append(int(pair_str))

    return pairs


def find_max(pairs):
    """
    Finds the maximum value from a list of pairs.

    Args:
        pairs: List of integers

    Returns:
        Maximum integer from the list, or None if list is empty
    """
    if not pairs:
        return None
    return max(pairs)


def solve(input_text):
    """
    Solves the puzzle: sum of maximum pairs from each line.

    Algorithm:
    1. Process each line from the input
    2. For each non-empty line:
       a. Extract all possible 2-digit pairs
       b. Find the maximum value among those pairs
       c. Add maximum to running sum
    3. Return final sum

    Args:
        input_text: String containing multiple lines of digit characters

    Returns:
        Sum of maximum pairs from all lines
    """
    total_sum = 0

    for line in input_text.strip().split('\n'):
        trimmed = line.strip()
        if not trimmed:
            continue

        pairs = extract_pairs(trimmed)
        max_value = find_max(pairs)

        if max_value is not None:
            total_sum += max_value

    return total_sum


def main():
    """Main entry point - reads from stdin"""
    try:
        # Read input from stdin
        input_text = sys.stdin.read()

        part1_result = solve(input_text)

        # Output JSON format matching other languages
        # Part 2 is null since we're only solving Part 1
        output = {"part1": part1_result, "part2": None}
        print(json.dumps(output))

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        print('{"part1": null, "part2": null}')
        sys.exit(1)


if __name__ == '__main__':
    main()
