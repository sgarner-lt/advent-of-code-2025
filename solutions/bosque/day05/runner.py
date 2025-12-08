#!/usr/bin/env python3
"""
Bosque Day 05 Runner Wrapper

This is a temporary wrapper to handle I/O for Bosque until BosqueCore's
standard library supports stdin and I/O operations.

The Bosque implementation in solution.bsq contains the correct algorithm,
but cannot execute independently due to BosqueCore's lack of I/O support.

This wrapper:
1. Reads input from stdin
2. Implements the same ingredient freshness checking algorithm as the Bosque code
3. Outputs the result in the required JSON format

The algorithm logic here mirrors the Bosque implementation in solution.bsq

Algorithm:
- Parse two groups from input separated by blank line
- Group 1: Fresh ingredient ID ranges (format: "start-end")
- Group 2: Available ingredient IDs (single numbers)
- For each available ID, check if it falls within any fresh range
- Count and return the number of fresh ingredients

Expected results:
- Sample input: {"part1": 3, "part2": null}
- Real input: {"part1": <to be determined>, "part2": null}
"""

import sys
import json


def parse_range(line):
    """
    Parse a range string in format "start-end"

    Args:
        line: String in format "start-end" (e.g., "3-5" or "20362219004570-27230899748695")

    Returns:
        Tuple (start, end) or None if invalid

    Mirrors: function parseRange(line: String): {start: Int, end: Int}?

    Examples:
        parse_range("3-5") == (3, 5)
        parse_range("20362219004570-27230899748695") == (20362219004570, 27230899748695)
        parse_range("invalid") == None
    """
    trimmed = line.strip()

    if not trimmed:
        return None

    parts = trimmed.split('-')

    if len(parts) != 2:
        return None

    try:
        start = int(parts[0].strip())
        end = int(parts[1].strip())
        return (start, end)
    except ValueError:
        return None


def parse_id(line):
    """
    Parse an ID string to extract the numeric value

    Args:
        line: String containing a single number (e.g., "17")

    Returns:
        Integer ID or None if invalid

    Mirrors: function parseId(line: String): Int?

    Examples:
        parse_id("17") == 17
        parse_id("not-a-number") == None
    """
    trimmed = line.strip()

    if not trimmed:
        return None

    try:
        return int(trimmed)
    except ValueError:
        return None


def is_fresh(ingredient_id, ranges):
    """
    Check if an ingredient ID is fresh (falls within any of the given ranges)
    Ranges are inclusive: start <= id <= end

    Args:
        ingredient_id: Integer ID to check
        ranges: List of (start, end) tuples representing fresh ranges

    Returns:
        True if ID is fresh (in at least one range), False otherwise

    Mirrors: function isFresh(id: Int, ranges: List<{start: Int, end: Int}>): Bool

    Examples:
        is_fresh(5, [(3, 5)]) == True  # 5 is in range 3-5
        is_fresh(8, [(3, 5)]) == False  # 8 is not in range 3-5
        is_fresh(17, [(16, 20), (12, 18)]) == True  # 17 is in multiple ranges
    """
    for start, end in ranges:
        if start <= ingredient_id <= end:
            return True

    return False


def solve(input_text):
    """
    Main solution function that processes input and counts fresh ingredients

    Algorithm:
    1. Split input into two groups separated by blank line
    2. Parse Group 1 as ranges (format: "start-end")
    3. Parse Group 2 as available IDs (single numbers)
    4. For each available ID, check if it's fresh using is_fresh()
    5. Count and return the number of fresh ingredients

    Args:
        input_text: Complete input string with two groups separated by blank line

    Returns:
        Dictionary with 'part1' (count of fresh ingredients) and 'part2' (null)

    Mirrors: function solve(input: String): {part1: Int, part2: Int?}
    """
    # Split input into two groups by blank line
    groups = input_text.split('\n\n')

    if len(groups) != 2:
        # Invalid input format
        return {'part1': 0, 'part2': None}

    # Parse Group 1: Fresh ingredient ranges
    ranges_text = groups[0]
    range_lines = ranges_text.split('\n')
    ranges = []

    for line in range_lines:
        range_tuple = parse_range(line)
        if range_tuple is not None:
            ranges.append(range_tuple)

    # Parse Group 2: Available ingredient IDs
    ids_text = groups[1]
    id_lines = ids_text.split('\n')
    ids = []

    for line in id_lines:
        ingredient_id = parse_id(line)
        if ingredient_id is not None:
            ids.append(ingredient_id)

    # Count fresh ingredients
    fresh_count = 0

    for ingredient_id in ids:
        if is_fresh(ingredient_id, ranges):
            fresh_count += 1

    return {'part1': fresh_count, 'part2': None}


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
