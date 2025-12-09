#!/usr/bin/env python3
"""
Test suite for Bosque Day 06 - Trash Compactor Math Worksheet

Tests the Python runner implementation which follows the Bosque algorithm
defined in solution.bsq. These tests validate parsing, calculation, and
cross-language consistency.
"""

import unittest
import sys
import os

# Add the current directory to the path to import runner
sys.path.insert(0, os.path.dirname(__file__))

from runner import (
    parse_input,
    identify_problems,
    extract_operation,
    calculate_problem,
    solve
)


class TestDay06(unittest.TestCase):
    """Test cases for Day 06 Trash Compactor Math Worksheet"""

    def test_parse_input_simple(self):
        """Test parsing simple input with 2 problems"""
        input_text = "123 328\n45 64\n* +"
        rows = parse_input(input_text)

        self.assertEqual(len(rows), 3)
        self.assertEqual(rows[0], ["123", "328"])
        self.assertEqual(rows[1], ["45", "64"])
        self.assertEqual(rows[2], ["*", "+"])

    def test_identify_problems_sample(self):
        """Test identifying problems from sample data"""
        rows = [
            ["123", "328"],
            ["45", "64"],
            ["*", "+"]
        ]

        problems = identify_problems(rows)

        self.assertEqual(len(problems), 2)
        self.assertEqual(problems[0], ["123", "45", "*"])
        self.assertEqual(problems[1], ["328", "64", "+"])

    def test_extract_operation_multiply(self):
        """Test extracting multiplication operation"""
        problem = ["123", "45", "*"]
        op = extract_operation(problem)

        self.assertEqual(op, "*")

    def test_extract_operation_add(self):
        """Test extracting addition operation"""
        problem = ["328", "64", "+"]
        op = extract_operation(problem)

        self.assertEqual(op, "+")

    def test_calculate_problem_multiply(self):
        """Test calculating multiplication problem: 123 * 45 * 6 = 33210"""
        problem = ["123", "45", "6", "*"]
        result = calculate_problem(problem, "*")

        self.assertEqual(result, 33210)

    def test_calculate_problem_add(self):
        """Test calculating addition problem: 328 + 64 + 98 = 490"""
        problem = ["328", "64", "98", "+"]
        result = calculate_problem(problem, "+")

        self.assertEqual(result, 490)

    def test_solve_sample_input(self):
        """Test sample input produces expected result: 4277556"""
        input_text = """123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +  """

        part1, part2 = solve(input_text)

        self.assertEqual(part1, 4277556)
        self.assertIsNone(part2)

    def test_solve_small_example(self):
        """Test small example: (10 * 5) + (20 + 10) = 50 + 30 = 80"""
        input_text = "10 20\n5 10\n* +"

        part1, part2 = solve(input_text)

        self.assertEqual(part1, 80)
        self.assertIsNone(part2)


if __name__ == "__main__":
    # Run tests with verbose output
    unittest.main(verbosity=2)
