#!/usr/bin/env python3
"""
Unit tests for Bosque Day 03 - Maximum Battery Pair Selection

This test file validates the Python runner wrapper that mirrors
the Bosque implementation in solution.bsq.

Test Coverage:
- Extract pairs from various digit strings (all combinations)
- Find maximum value in lists
- Process individual lines
- Complete solve function with sample input

Expected Results:
- Sample input: {"part1": 357, "part2": null}
- Real input: {"part1": <REDACTED>, "part2": null}
"""

import unittest
import sys
import os

# Add the solution directory to the path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

# Import the runner module
import runner


class TestBosqueDay03(unittest.TestCase):
    """Unit tests for Day 03 solution"""

    # ========== Extract Pairs Tests ==========

    def test_extract_pairs_simple(self):
        """Test extracting all pairs from '987' -> [98, 97, 87]"""
        pairs = runner.extract_pairs("987")
        self.assertEqual(len(pairs), 3)
        self.assertIn(98, pairs)  # positions (0,1)
        self.assertIn(97, pairs)  # positions (0,2)
        self.assertIn(87, pairs)  # positions (1,2)

    def test_extract_pairs_two_chars(self):
        """Test extracting pairs from '11' -> [11]"""
        pairs = runner.extract_pairs("11")
        self.assertEqual(len(pairs), 1)
        self.assertEqual(pairs[0], 11)

    def test_extract_pairs_too_short(self):
        """Test extracting pairs from single character: '1' -> []"""
        pairs = runner.extract_pairs("1")
        self.assertEqual(len(pairs), 0)

    # ========== Find Maximum Tests ==========

    def test_find_maximum_simple(self):
        """Test finding maximum in simple list: [98, 87, 76] -> 98"""
        pairs = [98, 87, 76]
        max_value = runner.find_maximum(pairs)
        self.assertEqual(max_value, 98)

    def test_find_maximum_empty(self):
        """Test finding maximum in empty list: [] -> None"""
        pairs = []
        max_value = runner.find_maximum(pairs)
        self.assertIsNone(max_value)

    # ========== Process Line Tests ==========

    def test_process_line_sample1(self):
        """Test processing line from sample input (line 1): '987654321111111' -> max 98"""
        line_max = runner.process_line("987654321111111")
        self.assertEqual(line_max, 98)

    def test_process_line_sample2(self):
        """Test processing line from sample input (line 2): '811111111111119' -> max 89

        The maximum is formed by selecting positions (0, 14): '8' and '9' = 89
        """
        line_max = runner.process_line("811111111111119")
        self.assertEqual(line_max, 89)

    def test_process_line_sample3(self):
        """Test processing line from sample input (line 3): '234234234234278' -> max 78"""
        line_max = runner.process_line("234234234234278")
        self.assertEqual(line_max, 78)

    def test_process_line_sample4(self):
        """Test processing line from sample input (line 4): '818181911112111' -> max 92

        The maximum is formed by selecting positions with '9' and '2' = 92
        """
        line_max = runner.process_line("818181911112111")
        self.assertEqual(line_max, 92)

    def test_process_line_empty(self):
        """Test processing empty line: '' -> 0"""
        line_max = runner.process_line("")
        self.assertEqual(line_max, 0)

    # ========== Complete Solve Tests ==========

    def test_sample_input_complete(self):
        """Test complete sample input expecting part1=357"""
        sample = "987654321111111\n811111111111119\n234234234234278\n818181911112111"
        result = runner.solve(sample)
        self.assertEqual(result["part1"], 357)
        self.assertIsNone(result["part2"])

    def test_sample_input_with_trailing_newline(self):
        """Test sample input with trailing newline"""
        sample = "987654321111111\n811111111111119\n234234234234278\n818181911112111\n"
        result = runner.solve(sample)
        self.assertEqual(result["part1"], 357)
        self.assertIsNone(result["part2"])


def main():
    """Run all unit tests"""
    unittest.main()


if __name__ == '__main__':
    main()
