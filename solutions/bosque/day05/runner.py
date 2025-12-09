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
- Part 1: For each available ID, check if it falls within any fresh range
- Part 2: Count unique ingredient IDs across all ranges using interval merging
- Return both results in JSON format

Expected results:
- Sample input: {"part1": 3, "part2": 14}
- Real input: {"part1": <to be determined>, "part2": <to be determined>}
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


def count_unique_ids(ranges):
    """
    Count unique ingredient IDs across all ranges
    Handles overlapping ranges by merging intervals

    Algorithm:
    1. Sort ranges by start position
    2. Merge overlapping/adjacent ranges
    3. Sum the counts of IDs in each merged range

    Args:
        ranges: List of (start, end) tuples representing fresh ranges

    Returns:
        Total count of unique ingredient IDs across all ranges

    Mirrors: function countUniqueIds(ranges: List<{start: Int, end: Int}>): Int

    Example:
        Ranges: [(3, 5), (10, 14), (16, 20), (12, 18)]
        After sorting: [(3, 5), (10, 14), (12, 18), (16, 20)]
        After merging: [(3, 5), (10, 20)]
          - (10, 14) and (12, 18) merge to (10, 18)
          - (10, 18) and (16, 20) merge to (10, 20)
        Count: (5-3+1) + (20-10+1) = 3 + 11 = 14
    """
    # Handle empty ranges
    if not ranges:
        return 0

    # Sort ranges by start position
    sorted_ranges = sorted(ranges, key=lambda r: r[0])

    # Merge overlapping ranges
    merged = []
    current_start, current_end = sorted_ranges[0]

    for start, end in sorted_ranges[1:]:
        # Check if current range overlaps or is adjacent to the last merged range
        if start <= current_end + 1:
            # Merge by extending the end if needed
            current_end = max(current_end, end)
        else:
            # No overlap, save the current merged range and start a new one
            merged.append((current_start, current_end))
            current_start, current_end = start, end

    # Don't forget to add the last merged range
    merged.append((current_start, current_end))

    # Count total unique IDs across merged ranges
    total = 0
    for start, end in merged:
        count = end - start + 1
        total += count

    return total


def solve(input_text):
    """
    Main solution function that processes input and counts fresh ingredients

    Algorithm:
    1. Split input into two groups separated by blank line
    2. Parse Group 1 as ranges (format: "start-end")
    3. Parse Group 2 as available IDs (single numbers)
    4. Part 1: For each available ID, check if it's fresh using is_fresh()
    5. Part 2: Count unique IDs across all ranges using count_unique_ids()
    6. Return both results

    Args:
        input_text: Complete input string with two groups separated by blank line

    Returns:
        Dictionary with 'part1' (count of fresh ingredients) and 'part2' (count of unique IDs)

    Mirrors: function solve(input: String): {part1: Int, part2: Int}
    """
    # Split input into two groups by blank line
    groups = input_text.split('\n\n')

    if len(groups) != 2:
        # Invalid input format
        return {'part1': 0, 'part2': 0}

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

    # Part 1: Count fresh ingredients
    fresh_count = 0

    for ingredient_id in ids:
        if is_fresh(ingredient_id, ranges):
            fresh_count += 1

    # Part 2: Count unique ingredient IDs across all ranges
    unique_count = count_unique_ids(ranges)

    return {'part1': fresh_count, 'part2': unique_count}


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
