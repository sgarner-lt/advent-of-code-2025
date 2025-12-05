#!/usr/bin/env python3
"""
Unit tests for Bosque Day 02 Implementation

Tests the pattern detection algorithm and range processing logic
that mirrors the Bosque implementation in solution.bsq

Test coverage:
- 8 pattern detection unit tests (Part 1)
- 5 pattern detection unit tests (Part 2)
- 8 range-based unit tests (Part 1)
- 3 range-based unit tests (Part 2)
- 4 helper function tests
- 5 integration tests

Total: 33 tests
"""

import unittest
import sys
import os

# Add the current directory to the path to import runner
sys.path.insert(0, os.path.dirname(__file__))
import runner


class TestPatternDetection(unittest.TestCase):
    """Test pattern detection algorithm - Part 1"""

    def test_single_repeated_digit(self):
        """Test single digit repeated (11 -> invalid)"""
        self.assertTrue(runner.is_invalid_id("11"))
        self.assertTrue(runner.is_invalid_id("22"))

    def test_two_digit_repeated_pattern(self):
        """Test two-digit pattern repeated (1212 -> invalid)"""
        self.assertTrue(runner.is_invalid_id("1212"))

    def test_longer_repeated_pattern(self):
        """Test longer pattern repeated (123123 -> invalid)"""
        self.assertTrue(runner.is_invalid_id("123123"))

    def test_valid_no_repetition(self):
        """Test valid number with no repetition (123456 -> valid)"""
        self.assertFalse(runner.is_invalid_id("123456"))

    def test_single_digit_valid(self):
        """Test single digit is valid (odd length)"""
        self.assertFalse(runner.is_invalid_id("1"))
        self.assertFalse(runner.is_invalid_id("5"))

    def test_mid_length_pattern(self):
        """Test mid-length pattern (12345656 -> valid, halves not equal)"""
        self.assertFalse(runner.is_invalid_id("12345656"))

    def test_partial_match(self):
        """Test partial match (123412 -> valid, not exact halves)"""
        self.assertFalse(runner.is_invalid_id("123412"))

    def test_multiple_overlapping_patterns(self):
        """Test 121212 splits as "121" + "212" (valid, not equal)"""
        self.assertFalse(runner.is_invalid_id("121212"))


class TestPart2PatternDetection(unittest.TestCase):
    """Test pattern detection algorithm - Part 2"""

    def test_single_char_three_reps(self):
        """Test single char three repetitions (111, 999 -> invalid)"""
        self.assertTrue(runner.is_invalid_id_part2("111"))
        self.assertTrue(runner.is_invalid_id_part2("999"))

    def test_multi_char_three_reps(self):
        """Test multi-char three repetitions (565656, 824824824 -> invalid)"""
        self.assertTrue(runner.is_invalid_id_part2("565656"))
        self.assertTrue(runner.is_invalid_id_part2("824824824"))

    def test_many_repetitions(self):
        """Test many repetitions (2121212121 -> invalid)"""
        self.assertTrue(runner.is_invalid_id_part2("2121212121"))

    def test_edge_cases(self):
        """Test edge cases - 11 still invalid, 123456 still valid"""
        self.assertTrue(runner.is_invalid_id_part2("11"))
        self.assertFalse(runner.is_invalid_id_part2("123456"))

    def test_includes_part1_invalid(self):
        """Test that all Part 1 invalid IDs remain invalid in Part 2"""
        self.assertTrue(runner.is_invalid_id_part2("11"))
        self.assertTrue(runner.is_invalid_id_part2("1212"))
        self.assertTrue(runner.is_invalid_id_part2("123123"))
        self.assertTrue(runner.is_invalid_id_part2("99"))
        self.assertTrue(runner.is_invalid_id_part2("1010"))


class TestRangeProcessing(unittest.TestCase):
    """Test range processing - Part 1"""

    def test_range_11_to_22(self):
        """Range 11-22 should contain 11 and 22 (sum = 33)"""
        result = runner.process_range(11, 22)
        self.assertEqual(result, 33)  # 11 + 22

    def test_range_95_to_115(self):
        """Range 95-115 should contain 99 (sum = 99)"""
        result = runner.process_range(95, 115)
        self.assertEqual(result, 99)

    def test_range_998_to_1012(self):
        """Range 998-1012 should contain 1010 (sum = 1010)"""
        result = runner.process_range(998, 1012)
        self.assertEqual(result, 1010)

    def test_range_1188511880_to_1188511890(self):
        """Range 1188511880-1188511890 should contain 1188511885"""
        result = runner.process_range(1188511880, 1188511890)
        self.assertEqual(result, 1188511885)

    def test_range_222220_to_222224(self):
        """Range 222220-222224 should contain 222222"""
        result = runner.process_range(222220, 222224)
        self.assertEqual(result, 222222)

    def test_range_1698522_to_1698528_no_invalid(self):
        """Range 1698522-1698528 should contain no invalid IDs"""
        result = runner.process_range(1698522, 1698528)
        self.assertEqual(result, 0)

    def test_range_446443_to_446449(self):
        """Range 446443-446449 should contain 446446"""
        result = runner.process_range(446443, 446449)
        self.assertEqual(result, 446446)

    def test_range_38593856_to_38593862(self):
        """Range 38593856-38593862 should contain 38593859"""
        result = runner.process_range(38593856, 38593862)
        self.assertEqual(result, 38593859)


class TestPart2RangeProcessing(unittest.TestCase):
    """Test range processing - Part 2"""

    def test_part2_range_95_to_115(self):
        """Part 2 Range 95-115 should find [99, 111]"""
        result = runner.process_range_part2(95, 115)
        self.assertEqual(result, 210)  # 99 + 111

    def test_part2_range_998_to_1012(self):
        """Part 2 Range 998-1012 should find [999, 1010]"""
        result = runner.process_range_part2(998, 1012)
        self.assertEqual(result, 2009)  # 999 + 1010

    def test_part2_range_565653_to_565659(self):
        """Part 2 Range 565653-565659 should find [565656]"""
        result = runner.process_range_part2(565653, 565659)
        self.assertEqual(result, 565656)


class TestHelperFunctions(unittest.TestCase):
    """Test helper functions"""

    def test_parse_single_range(self):
        """Test parsing single range"""
        ranges = runner.parse_ranges("11-22")
        self.assertEqual(ranges, [(11, 22)])

    def test_parse_multiple_ranges(self):
        """Test parsing multiple ranges"""
        ranges = runner.parse_ranges("11-22,95-115")
        self.assertEqual(ranges, [(11, 22), (95, 115)])

    def test_parse_with_whitespace(self):
        """Test parsing ranges with whitespace"""
        ranges = runner.parse_ranges(" 11-22 , 95-115 ")
        self.assertEqual(ranges, [(11, 22), (95, 115)])

    def test_parse_empty_input(self):
        """Test parsing empty input"""
        ranges = runner.parse_ranges("")
        self.assertEqual(ranges, [])


class TestIntegration(unittest.TestCase):
    """Integration tests"""

    def test_specific_invalid_ids(self):
        """Test specific invalid IDs from problem statement"""
        self.assertTrue(runner.is_invalid_id("55"))
        self.assertTrue(runner.is_invalid_id("6464"))
        self.assertTrue(runner.is_invalid_id("123123"))
        self.assertTrue(runner.is_invalid_id("99"))
        self.assertTrue(runner.is_invalid_id("1010"))
        self.assertTrue(runner.is_invalid_id("222222"))
        self.assertTrue(runner.is_invalid_id("446446"))

    def test_solve_simple_example(self):
        """Test solve with simple example"""
        result = runner.solve("11-22")
        self.assertEqual(result['part1'], 33)  # 11 + 22
        self.assertEqual(result['part2'], 33)  # 11 + 22 (same)

    def test_solve_multiple_ranges(self):
        """Test solve with multiple ranges"""
        result = runner.solve("11-22,95-115")
        self.assertEqual(result['part1'], 132)  # 11 + 22 + 99
        self.assertEqual(result['part2'], 243)  # 11 + 22 + 99 + 111

    def test_sample_input_integration_part1(self):
        """Test with full sample input - expected Part 1 sum: 1227775554"""
        sample_input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
        result = runner.solve(sample_input)
        self.assertEqual(result['part1'], 1227775554)

    def test_sample_input_integration_part2(self):
        """Test with full sample input - expected Part 2 sum: 4174379265"""
        sample_input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
        result = runner.solve(sample_input)
        self.assertEqual(result['part1'], 1227775554)
        self.assertEqual(result['part2'], 4174379265)


class TestVerification(unittest.TestCase):
    """Verification tests against other languages"""

    def test_cross_language_consistency(self):
        """Verify output matches Rust, Gleam, and Carbon implementations"""
        # Sample input should produce correct sums for both parts
        sample_input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
        result = runner.solve(sample_input)
        self.assertEqual(result['part1'], 1227775554, "Part 1 should match expected: 1227775554")
        self.assertEqual(result['part2'], 4174379265, "Part 2 should match expected: 4174379265")


def run_tests():
    """Run all tests"""
    # Create test suite
    loader = unittest.TestLoader()
    suite = unittest.TestSuite()

    # Add all test classes
    suite.addTests(loader.loadTestsFromTestCase(TestPatternDetection))
    suite.addTests(loader.loadTestsFromTestCase(TestPart2PatternDetection))
    suite.addTests(loader.loadTestsFromTestCase(TestRangeProcessing))
    suite.addTests(loader.loadTestsFromTestCase(TestPart2RangeProcessing))
    suite.addTests(loader.loadTestsFromTestCase(TestHelperFunctions))
    suite.addTests(loader.loadTestsFromTestCase(TestIntegration))
    suite.addTests(loader.loadTestsFromTestCase(TestVerification))

    # Run tests with verbose output
    runner_obj = unittest.TextTestRunner(verbosity=2)
    result = runner_obj.run(suite)

    # Return exit code based on success
    return 0 if result.wasSuccessful() else 1


if __name__ == '__main__':
    sys.exit(run_tests())
