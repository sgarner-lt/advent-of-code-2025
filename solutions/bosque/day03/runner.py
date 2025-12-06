#!/usr/bin/env python3
"""
Bosque Day 03 Runner Wrapper

This is a temporary wrapper to handle I/O for Bosque until BosqueCore's
standard library supports stdin and I/O operations.

The Bosque implementation in solution.bsq contains the correct algorithm,
but cannot execute independently due to BosqueCore's lack of I/O support.

This wrapper:
1. Reads input from stdin
2. Implements the same battery pair selection algorithm as the Bosque code
3. Outputs the result in the required JSON format

The algorithm logic here mirrors the Bosque implementation in solution.bsq

Algorithm:
- Part 1: For each line of digit strings (battery banks):
  1. Extract all possible 2-digit pairs by selecting any two positions (maintaining order)
  2. Find the maximum value among those pairs
  3. Sum all maximums across all lines
- Part 2: Not implemented (null)

Example:
- Input line: "987654321111111"
- Battery selection (maintaining order):
  - Positions (0,1): '9','8' = 98
  - Positions (0,2): '9','7' = 97
  - Positions (1,2): '8','7' = 87
  - ... and so on for all pairs where i < j
- Maximum: 98

Expected results:
- Sample input: {"part1": 357, "part2": null}
- Real input: {"part1": <REDACTED>, "part2": null}
"""

import sys
import json


def extract_pairs(line):
    """
    Extract all possible 2-digit pairs from a line by picking any two positions
    For each pair of positions (i, j) where i < j, creates a 2-digit number
    from digits at those positions

    Args:
        line: String containing digits

    Returns:
        List of integers representing all possible 2-digit combinations

    Mirrors: function extractPairs(line: String): List<Int>

    Examples:
        extract_pairs("987") == [98, 97, 87]
        extract_pairs("11") == [11]
        extract_pairs("1") == []
    """
    pairs = []
    length = len(line)

    # Need at least 2 characters to make a pair
    if length < 2:
        return pairs

    # Nested loops to generate all pairs (i, j) where i < j
    for i in range(length):
        for j in range(i + 1, length):
            # Extract characters at positions i and j
            first_digit = line[i]
            second_digit = line[j]

            # Check that both are digits
            if first_digit.isdigit() and second_digit.isdigit():
                # Concatenate to form 2-digit number
                pair_str = first_digit + second_digit
                try:
                    pair_value = int(pair_str)
                    pairs.append(pair_value)
                except ValueError:
                    # Skip if not a valid integer
                    continue

    return pairs


def find_maximum(pairs):
    """
    Find the maximum value in a list of integers
    Returns the maximum value, or None if list is empty

    Args:
        pairs: List of integers

    Returns:
        Maximum integer value or None if empty

    Mirrors: function findMaximum(pairs: List<Int>): Int?
    """
    if not pairs:
        return None

    return max(pairs)


def process_line(line):
    """
    Process a single line: extract pairs and find maximum
    Returns the maximum pair value from the line, or 0 if no pairs found

    Args:
        line: String containing digits

    Returns:
        Maximum pair value as integer

    Mirrors: function processLine(line: String): Int
    """
    trimmed = line.strip()

    # Skip empty lines
    if not trimmed:
        return 0

    pairs = extract_pairs(trimmed)
    max_value = find_maximum(pairs)

    if max_value is None:
        return 0

    return max_value


def solve(input_text):
    """
    Main solve function that processes all lines and returns the sum
    of maximum values from each line

    Args:
        input_text: Multi-line string containing digit strings

    Returns:
        Dictionary with 'part1' answer and None for 'part2'

    Mirrors: function solve(input: String): {part1: Int, part2: Int?}
    """
    lines = input_text.split('\n')
    total_sum = 0

    for line in lines:
        line_max = process_line(line)
        total_sum += line_max

    return {"part1": total_sum, "part2": None}


def main():
    """Main entry point - reads from stdin"""
    try:
        # Read input from stdin
        input_text = sys.stdin.read()

        result = solve(input_text)

        # Output JSON format matching other languages
        print(json.dumps(result))

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        print('{"part1": null, "part2": null}')
        sys.exit(1)


if __name__ == '__main__':
    main()
