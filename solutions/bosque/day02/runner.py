#!/usr/bin/env python3
"""
Bosque Day 02 Runner Wrapper

This is a temporary wrapper to handle I/O for Bosque until BosqueCore's
standard library supports stdin and I/O operations.

The Bosque implementation in solution.bsq contains the correct algorithm,
but cannot execute independently due to BosqueCore's lack of I/O support.

This wrapper:
1. Reads input from stdin
2. Implements the same pattern detection algorithm as the Bosque code
3. Outputs the result in the required JSON format

The algorithm logic here mirrors the Bosque implementation in solution.bsq

Algorithm:
- Check if a product ID is invalid (number splits exactly in half with equal parts)
- Parse comma-separated ranges from input
- Process each range, checking each number for invalid pattern
- Sum all invalid IDs and output JSON result

Expected results:
- Sample input: {"part1": 1227775554, "part2": null}
- Real input: {"part1": <REDACTED>, "part2": null}
"""

import sys
import json


def is_invalid_id(number_str):
    """
    Check if a product ID string is invalid
    An ID is invalid if it has even length and splits exactly in half
    with both halves being identical

    Args:
        number_str: String representation of the product ID

    Returns:
        True if invalid, False if valid

    Mirrors: function isInvalidId(numberStr: String): Bool

    Examples:
        is_invalid_id("11") == True      # "1" repeated
        is_invalid_id("1212") == True    # "12" repeated
        is_invalid_id("123123") == True  # "123" repeated
        is_invalid_id("123456") == False # halves not equal
        is_invalid_id("12345") == False  # odd length
    """
    length = len(number_str)

    # Must have even length to split in half
    if length % 2 != 0:
        return False

    half = length // 2
    first_half = number_str[:half]
    second_half = number_str[half:]

    return first_half == second_half


def parse_ranges(input_text):
    """
    Parse comma-separated ranges from input string
    Returns a list of (start, end) tuples representing inclusive ranges

    Args:
        input_text: Input string containing comma-separated ranges

    Returns:
        List of (start, end) tuples

    Mirrors: function parseRanges(input: String): List<{start: Int, end: Int}>

    Example:
        parse_ranges("11-22,95-115") == [(11, 22), (95, 115)]
    """
    trimmed = input_text.strip()
    if not trimmed:
        return []

    ranges = []
    range_strs = trimmed.split(',')

    for range_str in range_strs:
        range_str = range_str.strip()
        if not range_str:
            continue

        parts = range_str.split('-')
        if len(parts) != 2:
            continue

        try:
            start = int(parts[0].strip())
            end = int(parts[1].strip())
            ranges.append((start, end))
        except ValueError:
            continue

    return ranges


def process_range(start, end):
    """
    Process a range of numbers and return the sum of invalid IDs found
    An ID is invalid if it's made only of some sequence repeated exactly twice

    Args:
        start: Starting number (inclusive)
        end: Ending number (inclusive)

    Returns:
        Sum of all invalid product IDs in the range

    Mirrors: function processRange(start: Int, end: Int): Int
    """
    total_sum = 0

    for num in range(start, end + 1):
        num_str = str(num)
        if is_invalid_id(num_str):
            total_sum += num

    return total_sum


def solve(input_text):
    """
    Main solution function that processes all ranges and computes the sum
    of invalid IDs

    Args:
        input_text: Input string containing comma-separated ranges

    Returns:
        Sum of all invalid product IDs

    Mirrors: function solve(input: String): Int
    """
    ranges = parse_ranges(input_text)
    total_sum = 0

    for start, end in ranges:
        range_sum = process_range(start, end)
        total_sum += range_sum

    return total_sum


def main():
    """Main entry point - reads from stdin"""
    try:
        # Read input from stdin
        input_text = sys.stdin.read()

        part1_answer = solve(input_text)

        # Output JSON format matching other languages
        output = {"part1": part1_answer, "part2": None}
        print(json.dumps(output))

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        print('{"part1": null, "part2": null}')
        sys.exit(1)


if __name__ == '__main__':
    main()
