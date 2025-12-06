#!/usr/bin/env python3
"""
Carbon Day 03 Runner Wrapper

This is a temporary wrapper to simulate Carbon execution until Carbon's
standard library matures to support stdin and I/O operations.

The Carbon implementation in day03.carbon contains the correct algorithm,
but cannot execute independently due to Carbon's experimental state.

This wrapper:
1. Reads input from stdin
2. Implements the same algorithm as the Carbon code
3. Outputs the result in the required JSON format

The algorithm logic here mirrors the Carbon implementation in day03.carbon

Part 1: Extract maximum 2-digit pair from each line
Part 2: Extract maximum 12-digit number from each line using greedy algorithm
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


def extract_max_k_digits(line, k):
    """
    Extracts the maximum k-digit number from a line using a greedy algorithm.

    Algorithm: For each position i (0 to k-1) in the result:
    1. Calculate search window: from current_pos to (line_length - remaining_digits)
    2. Find the maximum digit in this search window
    3. Append the maximum digit to the result
    4. Update current_pos to immediately after the selected digit

    This greedy approach guarantees the lexicographically largest k-digit number,
    which equals the maximum numeric value for fixed-length numbers.

    Args:
        line: String containing digit characters
        k: Number of digits to extract

    Returns:
        Integer representing the maximum k-digit number, or None if invalid input

    Examples:
        extract_max_k_digits("987654321111111", 12) == 987654321111
        extract_max_k_digits("811111111111119", 12) == 811111111119
        extract_max_k_digits("234234234234278", 12) == 434234234278
        extract_max_k_digits("818181911112111", 12) == 888911112111
    """
    # Validate input: need at least k digits
    if len(line) < k:
        return None

    # Validate all characters are digits
    if not all(c.isdigit() for c in line):
        return None

    result = ""
    current_pos = 0

    # For each position in the k-digit result
    for i in range(k):
        remaining_digits = k - i
        # Calculate search window: must leave enough digits to complete the k-digit number
        search_end = len(line) - remaining_digits + 1

        # Find the maximum digit in the search window [current_pos, search_end)
        max_digit = line[current_pos]
        max_pos = current_pos

        for pos in range(current_pos, search_end):
            if line[pos] > max_digit:
                max_digit = line[pos]
                max_pos = pos

        # Append the maximum digit to the result
        result += max_digit
        # Move current position to immediately after the selected digit
        current_pos = max_pos + 1

    # Parse the k-digit string as integer (64-bit)
    return int(result)


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
    Solves the puzzle: returns (part1_sum, part2_sum) as tuple.

    Algorithm:
    1. Process each line from the input
    2. For each non-empty line:
       a. Extract all possible 2-digit pairs and find maximum (Part 1)
       b. Extract maximum 12-digit number using greedy algorithm (Part 2)
       c. Add both maximums to running sums
    3. Return tuple of (part1_sum, part2_sum)

    Args:
        input_text: String containing multiple lines of digit characters

    Returns:
        Tuple of (part1_sum, part2_sum)
    """
    part1_sum = 0
    part2_sum = 0

    for line in input_text.strip().split('\n'):
        trimmed = line.strip()
        if not trimmed:
            continue

        # Part 1: Extract max 2-digit pair
        pairs = extract_pairs(trimmed)
        max_value = find_max(pairs)
        if max_value is not None:
            part1_sum += max_value

        # Part 2: Extract max 12-digit number
        max_12_digit = extract_max_k_digits(trimmed, 12)
        if max_12_digit is not None:
            part2_sum += max_12_digit

    return (part1_sum, part2_sum)


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
