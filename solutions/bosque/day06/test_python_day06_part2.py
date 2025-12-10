#!/usr/bin/env python3
"""
Test suite for Day 06 Part 2 - Cephalopod Math Right-to-Left Column Reading

This test file contains 2-6 focused tests for Part 2 functionality:
- find_max_width() with sample grid
- extract_column_digits() for position 0
- extract_column_digits() for position 2 (numbers too short case)
- solve_part2() with full sample input (expected: 3263827)
"""

import sys
import os

# Add parent directory to path to import runner
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from runner import (
    parse_input,
    identify_problems,
    find_max_width,
    extract_column_digits,
    solve_part2,
    solve
)


def test_find_max_width():
    """
    Test find_max_width() with sample grid.
    Expected: 3 (for numbers "123", "387", "215", "314")
    """
    problems = [
        ["123", "45", "6", "*"],
        ["328", "64", "98", "+"],
        ["51", "387", "215", "*"],
        ["64", "23", "314", "+"]
    ]

    max_width = find_max_width(problems)
    assert max_width == 3, f"Expected max_width=3, got {max_width}"
    print("PASS: test_find_max_width")


def test_extract_column_digits_multiply_position_0():
    """
    Test extract_column_digits() for multiplication at position 0 (rightmost).
    Problem: ["123", "45", "6", "*"]
    Position 0 (rightmost): "3" from 123, "5" from 45, "6" from 6 → "356"
    """
    problem = ["123", "45", "6", "*"]

    result = extract_column_digits(problem, 0, '*')
    assert result == "356", f"Expected '356', got '{result}'"
    print("PASS: test_extract_column_digits_multiply_position_0")


def test_extract_column_digits_multiply_position_2():
    """
    Test extract_column_digits() for multiplication at position 2.
    Problem: ["123", "45", "6", "*"]
    Position 2 (leftmost): only "123" has 3 digits → "1"
    """
    problem = ["123", "45", "6", "*"]

    result = extract_column_digits(problem, 2, '*')
    assert result == "1", f"Expected '1', got '{result}'"
    print("PASS: test_extract_column_digits_multiply_position_2")


def test_extract_column_digits_addition_position_0():
    """
    Test extract_column_digits() for addition at position 0 (leftmost).
    Problem: ["328", "64", "98", "+"]
    Position 0 (leftmost): "3" from 328, "6" from 64, "9" from 98 → "369"
    """
    problem = ["328", "64", "98", "+"]

    result = extract_column_digits(problem, 0, '+')
    assert result == "369", f"Expected '369', got '{result}'"
    print("PASS: test_extract_column_digits_addition_position_0")


def test_extract_column_digits_addition_position_2():
    """
    Test extract_column_digits() for addition at position 2.
    Problem: ["64", "23", "314", "+"]
    Position 2 (third digit): only "314" has 3 digits → "4"
    """
    problem = ["64", "23", "314", "+"]

    result = extract_column_digits(problem, 2, '+')
    assert result == "4", f"Expected '4', got '{result}'"
    print("PASS: test_extract_column_digits_addition_position_2")


def test_solve_part2_sample():
    """
    Test solve_part2() with full sample input.
    Expected: 3263827
    """
    input_text = """123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   + """

    result = solve_part2(input_text)
    assert result == 3263827, f"Expected 3263827, got {result}"
    print("PASS: test_solve_part2_sample")


def test_solve_returns_both_parts():
    """
    Test solve() returns tuple with both part1 and part2.
    Expected: (4277556, 3263827)
    """
    input_text = """123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   + """

    part1, part2 = solve(input_text)
    assert part1 == 4277556, f"Expected part1=4277556, got {part1}"
    assert part2 == 3263827, f"Expected part2=3263827, got {part2}"
    print("PASS: test_solve_returns_both_parts")


if __name__ == "__main__":
    # Run all tests
    test_find_max_width()
    test_extract_column_digits_multiply_position_0()
    test_extract_column_digits_multiply_position_2()
    test_extract_column_digits_addition_position_0()
    test_extract_column_digits_addition_position_2()
    test_solve_part2_sample()
    test_solve_returns_both_parts()

    print("\nAll Part 2 tests passed!")
