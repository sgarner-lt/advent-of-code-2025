#!/usr/bin/env python3
"""
Unit tests for Bosque Day 05 Implementation

Tests the ingredient freshness checking algorithm that mirrors
the Bosque implementation in solution.bsq

Test coverage:
- 3 parsing unit tests (range parsing, ID parsing)
- 3 freshness checking unit tests
- 2 integration tests (sample input, edge cases)

Total: 8 tests
"""

import unittest
import sys
import os

# Add the current directory to the path to import runner
sys.path.insert(0, os.path.dirname(__file__))
import runner


class TestParsing(unittest.TestCase):
    """Test parsing functions"""

    def test_parse_range_simple(self):
        """Test parsing simple range "3-5" -> (3, 5)"""
        result = runner.parse_range("3-5")
        self.assertEqual(result, (3, 5))

    def test_parse_range_large_numbers(self):
        """Test parsing range with large numbers"""
        result = runner.parse_range("20362219004570-27230899748695")
        self.assertEqual(result, (20362219004570, 27230899748695))

    def test_parse_id(self):
        """Test parsing ID "17" -> 17"""
        result = runner.parse_id("17")
        self.assertEqual(result, 17)

    def test_parse_range_invalid(self):
        """Test parsing invalid range returns None"""
        result = runner.parse_range("invalid")
        self.assertIsNone(result)

    def test_parse_id_invalid(self):
        """Test parsing invalid ID returns None"""
        result = runner.parse_id("not-a-number")
        self.assertIsNone(result)


class TestFreshnessChecking(unittest.TestCase):
    """Test freshness checking logic"""

    def test_is_fresh_in_range(self):
        """Test ID 5 is fresh in range (3, 5)"""
        ranges = [(3, 5)]
        self.assertTrue(runner.is_fresh(5, ranges))

    def test_is_not_fresh_outside_range(self):
        """Test ID 8 is not fresh in range (3, 5)"""
        ranges = [(3, 5)]
        self.assertFalse(runner.is_fresh(8, ranges))

    def test_is_fresh_in_multiple_ranges(self):
        """Test ID 17 is fresh in overlapping ranges"""
        ranges = [(16, 20), (12, 18)]
        self.assertTrue(runner.is_fresh(17, ranges))
        # Check it's in first range
        ranges = [(16, 20)]
        self.assertTrue(runner.is_fresh(17, ranges))
        # Check it's in second range
        ranges = [(12, 18)]
        self.assertTrue(runner.is_fresh(17, ranges))

    def test_is_fresh_at_boundaries(self):
        """Test IDs at range boundaries are inclusive"""
        ranges = [(3, 5)]
        # Start boundary
        self.assertTrue(runner.is_fresh(3, ranges))
        # End boundary
        self.assertTrue(runner.is_fresh(5, ranges))
        # Just outside boundaries
        self.assertFalse(runner.is_fresh(2, ranges))
        self.assertFalse(runner.is_fresh(6, ranges))

    def test_is_not_fresh_empty_ranges(self):
        """Test no ID is fresh with empty ranges list"""
        ranges = []
        self.assertFalse(runner.is_fresh(5, ranges))


class TestIntegration(unittest.TestCase):
    """Integration tests"""

    def test_sample_input(self):
        """Test with sample input - expected part1=3"""
        sample_input = """3-5
10-14
16-20
12-18

1
5
8
11
17
32"""
        result = runner.solve(sample_input)
        self.assertEqual(result['part1'], 3)
        self.assertIsNone(result['part2'])

    def test_sample_input_breakdown(self):
        """Test sample input with detailed breakdown"""
        # Parse ranges
        ranges = [
            runner.parse_range("3-5"),
            runner.parse_range("10-14"),
            runner.parse_range("16-20"),
            runner.parse_range("12-18")
        ]
        ranges = [r for r in ranges if r is not None]

        # Check each ID
        self.assertFalse(runner.is_fresh(1, ranges), "ID 1 should be spoiled")
        self.assertTrue(runner.is_fresh(5, ranges), "ID 5 should be fresh (in 3-5)")
        self.assertFalse(runner.is_fresh(8, ranges), "ID 8 should be spoiled")
        self.assertTrue(runner.is_fresh(11, ranges), "ID 11 should be fresh (in 10-14)")
        self.assertTrue(runner.is_fresh(17, ranges), "ID 17 should be fresh (in 16-20 and 12-18)")
        self.assertFalse(runner.is_fresh(32, ranges), "ID 32 should be spoiled")

        # Count fresh: 5, 11, 17 = 3
        fresh_count = sum([
            runner.is_fresh(1, ranges),
            runner.is_fresh(5, ranges),
            runner.is_fresh(8, ranges),
            runner.is_fresh(11, ranges),
            runner.is_fresh(17, ranges),
            runner.is_fresh(32, ranges)
        ])
        self.assertEqual(fresh_count, 3)


def run_tests():
    """Run all tests"""
    # Create test suite
    loader = unittest.TestLoader()
    suite = unittest.TestSuite()

    # Add all test classes
    suite.addTests(loader.loadTestsFromTestCase(TestParsing))
    suite.addTests(loader.loadTestsFromTestCase(TestFreshnessChecking))
    suite.addTests(loader.loadTestsFromTestCase(TestIntegration))

    # Run tests with verbose output
    runner_obj = unittest.TextTestRunner(verbosity=2)
    result = runner_obj.run(suite)

    # Return exit code based on success
    return 0 if result.wasSuccessful() else 1


if __name__ == '__main__':
    sys.exit(run_tests())
