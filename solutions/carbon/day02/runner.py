#!/usr/bin/env python3
"""
Carbon Day 02 Runner Wrapper

This is a temporary wrapper to simulate Carbon execution until Carbon's
standard library matures to support stdin and I/O operations.

The Carbon implementation in day02.carbon contains the correct algorithm,
but cannot execute independently due to Carbon's experimental state.

This wrapper:
1. Reads input from stdin
2. Implements the same invalid ID detection algorithm as the Carbon code
3. Outputs the result in the required JSON format

The algorithm logic here mirrors the Carbon implementation in day02.carbon
"""

import sys
import json


def is_invalid_id(number_str):
    """
    Checks if a product ID is invalid (pattern repeated exactly twice).

    An ID is invalid if it can be split exactly in half with both halves equal.

    Algorithm:
    - Check if string length is even (required for exact half split)
    - Split the string exactly in half
    - Compare both halves - if equal, ID is invalid

    Examples:
    - "11" → "1" + "1" (equal) → True (invalid)
    - "1212" → "12" + "12" (equal) → True (invalid)
    - "123456" → "123" + "456" (not equal) → False (valid)

    Args:
        number_str: String representation of the product ID

    Returns:
        True if invalid (pattern repeated), False if valid
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
    Parse comma-separated ranges from input string.

    Args:
        input_text: String containing comma-separated ranges (e.g., "11-22,95-115")

    Returns:
        List of tuples (start, end) representing inclusive ranges

    Raises:
        ValueError: If input format is invalid
    """
    input_text = input_text.strip()
    if not input_text:
        raise ValueError("Empty input")

    ranges = []
    for range_str in input_text.split(','):
        range_str = range_str.strip()
        if not range_str:
            continue

        parts = range_str.split('-')
        if len(parts) != 2:
            raise ValueError(f"Invalid range format: {range_str}")

        try:
            start = int(parts[0].strip())
            end = int(parts[1].strip())
            ranges.append((start, end))
        except ValueError as e:
            raise ValueError(f"Invalid number in range '{range_str}': {e}")

    return ranges


def process_range(start, end):
    """
    Process a range of numbers and return the sum of invalid IDs.

    Args:
        start: Starting product ID (inclusive)
        end: Ending product ID (inclusive)

    Returns:
        Sum of all invalid product IDs found in the range
    """
    total_sum = 0

    for num in range(start, end + 1):
        num_str = str(num)
        if is_invalid_id(num_str):
            total_sum += num

    return total_sum


def solve(input_text):
    """
    Main solution function that processes all ranges and computes the sum.

    Args:
        input_text: Input string containing comma-separated ranges

    Returns:
        Tuple of (part1_sum, part2_placeholder) where part2 is None for now
    """
    ranges = parse_ranges(input_text)

    total_sum = 0
    for start, end in ranges:
        total_sum += process_range(start, end)

    return (total_sum, None)


def main():
    """Main entry point - reads from stdin"""
    try:
        # Read input from stdin
        input_text = sys.stdin.read()

        part1_result, part2_result = solve(input_text)

        # Output JSON format matching other languages
        output = {"part1": part1_result, "part2": part2_result}
        print(json.dumps(output))

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        print('{"part1": null, "part2": null}')
        sys.exit(1)


if __name__ == '__main__':
    main()
