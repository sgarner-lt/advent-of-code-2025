#!/usr/bin/env python3
"""
Unit tests for Carbon Day 02 implementation

Since Carbon doesn't have a mature testing framework yet, these tests
verify the algorithm logic that is implemented in day02.carbon

All test cases mirror the tests from the Rust and Gleam implementations:

Pattern Detection Tests (8):
- TestSingleRepeatedDigit (11 → invalid)
- TestTwoDigitRepeatedPattern (1212 → invalid)
- TestLongerRepeatedPattern (123123 → invalid)
- TestValidNoRepetition (123456 → valid)
- TestSingleDigitValid (1 → valid)
- TestMidLengthPattern (12345656 → valid)
- TestPartialMatch (123412 → valid)
- TestMultiplePatterns (121212 → valid)

Range Processing Tests (8):
- TestRange11To22 (should find 11 and 22)
- TestRange95To115 (should find 99)
- TestRange998To1012 (should find 1010)
- TestRange1188511880To1188511890 (should find 1188511885)
- TestRange222220To222224 (should find 222222)
- TestRange1698522To1698528 (should find none)
- TestRange446443To446449 (should find 446446)
- TestRange38593856To38593862 (should find 38593859)

Part 2 Pattern Detection Tests (8):
- TestPart2SingleCharThreeReps (111 → invalid)
- TestPart2MultiCharThreeReps (565656 → invalid)
- TestPart2ManyReps (2121212121 → invalid)
- TestPart2EdgeCases (11, 123456)
- TestPart2IncludesPart1 (all Part 1 invalid IDs remain invalid)
- TestPart2Range95To115 ([99, 111])
- TestPart2Range998To1012 ([999, 1010])
- TestPart2Range565653To565659 ([565656])
"""

import sys
import os

# Add parent directory to path to import runner module
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from runner import is_invalid_id, is_invalid_id_part2, parse_ranges, process_range, process_range_part2, solve


# ============================================================================
# PATTERN DETECTION TESTS (PART 1)
# ============================================================================

def test_single_repeated_digit():
    """Test 1: Single repeated digit (11) should be invalid"""
    result = is_invalid_id("11")
    assert result == True, f"Expected True (invalid), got {result}"
    # Also test 22
    result = is_invalid_id("22")
    assert result == True, f"Expected True (invalid), got {result}"
    print("✓ Test 1: Single repeated digit - PASSED")


def test_two_digit_repeated_pattern():
    """Test 2: Two digit repeated pattern (1212) should be invalid"""
    result = is_invalid_id("1212")
    assert result == True, f"Expected True (invalid), got {result}"
    print("✓ Test 2: Two digit repeated pattern - PASSED")


def test_longer_repeated_pattern():
    """Test 3: Longer repeated pattern (123123) should be invalid"""
    result = is_invalid_id("123123")
    assert result == True, f"Expected True (invalid), got {result}"
    print("✓ Test 3: Longer repeated pattern - PASSED")


def test_valid_no_repetition():
    """Test 4: Valid number (123456) should not be invalid"""
    result = is_invalid_id("123456")
    assert result == False, f"Expected False (valid), got {result}"
    print("✓ Test 4: Valid number with no repetition - PASSED")


def test_single_digit_valid():
    """Test 5: Single digit (1, 5) should be valid (odd length)"""
    result = is_invalid_id("1")
    assert result == False, f"Expected False (valid), got {result}"
    result = is_invalid_id("5")
    assert result == False, f"Expected False (valid), got {result}"
    print("✓ Test 5: Single digit valid - PASSED")


def test_mid_length_pattern():
    """Test 6: Mid-length pattern (12345656) should be valid"""
    # "12345656" splits to "1234" + "5656" (not equal) → valid
    result = is_invalid_id("12345656")
    assert result == False, f"Expected False (valid), got {result}"
    print("✓ Test 6: Mid-length pattern - PASSED")


def test_partial_match():
    """Test 7: Partial match (123412) should be valid"""
    # "123412" splits to "123" + "412" (not equal) → valid
    result = is_invalid_id("123412")
    assert result == False, f"Expected False (valid), got {result}"
    print("✓ Test 7: Partial match - PASSED")


def test_multiple_patterns():
    """Test 8: Multiple patterns (121212) should be valid"""
    # "121212" splits to "121" + "212" (not equal) → valid
    # Even though "12" repeats 3 times, the halves don't match
    result = is_invalid_id("121212")
    assert result == False, f"Expected False (valid), got {result}"
    print("✓ Test 8: Multiple patterns - PASSED")


# ============================================================================
# PART 2 PATTERN DETECTION TESTS
# ============================================================================

def test_part2_single_char_three_reps():
    """Test 9: Single char three repetitions (111, 999) should be invalid"""
    result = is_invalid_id_part2("111")
    assert result == True, f"Expected True (invalid), got {result}"
    result = is_invalid_id_part2("999")
    assert result == True, f"Expected True (invalid), got {result}"
    print("✓ Test 9: Part 2 single char three reps - PASSED")


def test_part2_multi_char_three_reps():
    """Test 10: Multi-char three repetitions (565656, 824824824) should be invalid"""
    result = is_invalid_id_part2("565656")
    assert result == True, f"Expected True (invalid), got {result}"
    result = is_invalid_id_part2("824824824")
    assert result == True, f"Expected True (invalid), got {result}"
    print("✓ Test 10: Part 2 multi-char three reps - PASSED")


def test_part2_many_repetitions():
    """Test 11: Many repetitions (2121212121) should be invalid"""
    result = is_invalid_id_part2("2121212121")
    assert result == True, f"Expected True (invalid), got {result}"
    print("✓ Test 11: Part 2 many repetitions - PASSED")


def test_part2_edge_cases():
    """Test 12: Edge cases - 11 still invalid, 123456 still valid"""
    result = is_invalid_id_part2("11")
    assert result == True, f"Expected True (invalid), got {result}"
    result = is_invalid_id_part2("123456")
    assert result == False, f"Expected False (valid), got {result}"
    print("✓ Test 12: Part 2 edge cases - PASSED")


def test_part2_includes_part1_invalid():
    """Test 13: All Part 1 invalid IDs remain invalid in Part 2"""
    assert is_invalid_id_part2("11") == True
    assert is_invalid_id_part2("1212") == True
    assert is_invalid_id_part2("123123") == True
    assert is_invalid_id_part2("99") == True
    assert is_invalid_id_part2("1010") == True
    print("✓ Test 13: Part 2 includes Part 1 invalid IDs - PASSED")


# ============================================================================
# RANGE PROCESSING TESTS (PART 1)
# ============================================================================

def test_range_11_to_22():
    """Test 14: Range 11-22 should find [11, 22]"""
    result = process_range(11, 22)
    expected = 11 + 22  # 33
    assert result == expected, f"Expected {expected}, got {result}"
    print("✓ Test 14: Range 11-22 - PASSED")


def test_range_95_to_115():
    """Test 15: Range 95-115 should find [99]"""
    result = process_range(95, 115)
    expected = 99
    assert result == expected, f"Expected {expected}, got {result}"
    print("✓ Test 15: Range 95-115 - PASSED")


def test_range_998_to_1012():
    """Test 16: Range 998-1012 should find [1010]"""
    result = process_range(998, 1012)
    expected = 1010
    assert result == expected, f"Expected {expected}, got {result}"
    print("✓ Test 16: Range 998-1012 - PASSED")


def test_range_1188511880_to_1188511890():
    """Test 17: Range 1188511880-1188511890 should find [1188511885]"""
    result = process_range(1188511880, 1188511890)
    expected = 1188511885
    assert result == expected, f"Expected {expected}, got {result}"
    print("✓ Test 17: Range 1188511880-1188511890 - PASSED")


def test_range_222220_to_222224():
    """Test 18: Range 222220-222224 should find [222222]"""
    result = process_range(222220, 222224)
    expected = 222222
    assert result == expected, f"Expected {expected}, got {result}"
    print("✓ Test 18: Range 222220-222224 - PASSED")


def test_range_1698522_to_1698528_no_invalid():
    """Test 19: Range 1698522-1698528 should find none"""
    result = process_range(1698522, 1698528)
    expected = 0
    assert result == expected, f"Expected {expected}, got {result}"
    print("✓ Test 19: Range 1698522-1698528 (no invalid) - PASSED")


def test_range_446443_to_446449():
    """Test 20: Range 446443-446449 should find [446446]"""
    result = process_range(446443, 446449)
    expected = 446446
    assert result == expected, f"Expected {expected}, got {result}"
    print("✓ Test 20: Range 446443-446449 - PASSED")


def test_range_38593856_to_38593862():
    """Test 21: Range 38593856-38593862 should find [38593859]"""
    result = process_range(38593856, 38593862)
    expected = 38593859
    assert result == expected, f"Expected {expected}, got {result}"
    print("✓ Test 21: Range 38593856-38593862 - PASSED")


# ============================================================================
# PART 2 RANGE PROCESSING TESTS
# ============================================================================

def test_part2_range_95_to_115():
    """Test 22: Part 2 Range 95-115 should find [99, 111]"""
    result = process_range_part2(95, 115)
    expected = 99 + 111  # 210
    assert result == expected, f"Expected {expected}, got {result}"
    print("✓ Test 22: Part 2 Range 95-115 - PASSED")


def test_part2_range_998_to_1012():
    """Test 23: Part 2 Range 998-1012 should find [999, 1010]"""
    result = process_range_part2(998, 1012)
    expected = 999 + 1010  # 2009
    assert result == expected, f"Expected {expected}, got {result}"
    print("✓ Test 23: Part 2 Range 998-1012 - PASSED")


def test_part2_range_565653_to_565659():
    """Test 24: Part 2 Range 565653-565659 should find [565656]"""
    result = process_range_part2(565653, 565659)
    expected = 565656
    assert result == expected, f"Expected {expected}, got {result}"
    print("✓ Test 24: Part 2 Range 565653-565659 - PASSED")


# ============================================================================
# HELPER FUNCTION TESTS
# ============================================================================

def test_parse_single_range():
    """Test 25: Parse single range"""
    ranges = parse_ranges("11-22")
    assert ranges == [(11, 22)], f"Expected [(11, 22)], got {ranges}"
    print("✓ Test 25: Parse single range - PASSED")


def test_parse_multiple_ranges():
    """Test 26: Parse multiple ranges"""
    ranges = parse_ranges("11-22,95-115")
    assert ranges == [(11, 22), (95, 115)], f"Expected [(11, 22), (95, 115)], got {ranges}"
    print("✓ Test 26: Parse multiple ranges - PASSED")


def test_parse_with_whitespace():
    """Test 27: Parse ranges with whitespace"""
    ranges = parse_ranges(" 11-22 , 95-115 ")
    assert ranges == [(11, 22), (95, 115)], f"Expected [(11, 22), (95, 115)], got {ranges}"
    print("✓ Test 27: Parse ranges with whitespace - PASSED")


def test_solve_simple_example():
    """Test 28: Solve simple example (11-22)"""
    part1_result, part2_result = solve("11-22")
    expected_part1 = 33  # 11 + 22
    expected_part2 = 33  # 11 + 22 (same for this range)
    assert part1_result == expected_part1, f"Expected Part 1 {expected_part1}, got {part1_result}"
    assert part2_result == expected_part2, f"Expected Part 2 {expected_part2}, got {part2_result}"
    print("✓ Test 28: Solve simple example - PASSED")


# ============================================================================
# INTEGRATION TESTS
# ============================================================================

def test_integration_sample_input():
    """Test 29: Integration test with sample input"""
    sample_input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
    part1_result, _ = solve(sample_input)
    expected = 1227775554
    assert part1_result == expected, f"Expected {expected}, got {part1_result}"
    print("✓ Test 29: Integration test with sample input (Part 1) - PASSED")


def test_integration_sample_input_part2():
    """Test 30: Integration test with sample input (Part 2)"""
    sample_input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
    part1_result, part2_result = solve(sample_input)
    expected_part1 = 1227775554
    expected_part2 = 4174379265
    assert part1_result == expected_part1, f"Expected Part 1 {expected_part1}, got {part1_result}"
    assert part2_result == expected_part2, f"Expected Part 2 {expected_part2}, got {part2_result}"
    print("✓ Test 30: Integration test with sample input (Part 2) - PASSED")


def test_integration_range_with_no_invalid_ids():
    """Test 31: Integration test with range that has no invalid IDs"""
    part1_result, _ = solve("1698522-1698528")
    expected = 0
    assert part1_result == expected, f"Expected {expected}, got {part1_result}"
    print("✓ Test 31: Integration test (no invalid IDs) - PASSED")


def test_integration_multiple_ranges_sum():
    """Test 32: Integration test with multiple ranges"""
    part1_result, _ = solve("11-22,95-115")
    expected = 132  # 11 + 22 + 99
    assert part1_result == expected, f"Expected {expected}, got {part1_result}"
    print("✓ Test 32: Integration test (multiple ranges sum) - PASSED")


# ============================================================================
# VERIFICATION TESTS (Specific Invalid IDs)
# ============================================================================

def test_specific_invalid_ids():
    """Test 33: Verify specific invalid IDs from problem statement"""
    # From problem: 55, 6464, 123123 should be invalid
    assert is_invalid_id("55") == True, "55 should be invalid"
    assert is_invalid_id("6464") == True, "6464 should be invalid"
    assert is_invalid_id("123123") == True, "123123 should be invalid"

    # From ranges: these should be invalid
    assert is_invalid_id("99") == True, "99 should be invalid"
    assert is_invalid_id("1010") == True, "1010 should be invalid"
    assert is_invalid_id("222222") == True, "222222 should be invalid"
    assert is_invalid_id("446446") == True, "446446 should be invalid"

    print("✓ Test 33: Specific invalid IDs verification - PASSED")


def run_all_tests():
    """Run all unit tests"""
    print("=" * 70)
    print("Running Carbon Day 02 Unit Tests (Part 1 & Part 2)")
    print("=" * 70)

    tests = [
        # Pattern detection tests (8)
        test_single_repeated_digit,
        test_two_digit_repeated_pattern,
        test_longer_repeated_pattern,
        test_valid_no_repetition,
        test_single_digit_valid,
        test_mid_length_pattern,
        test_partial_match,
        test_multiple_patterns,
        # Part 2 pattern detection tests (5)
        test_part2_single_char_three_reps,
        test_part2_multi_char_three_reps,
        test_part2_many_repetitions,
        test_part2_edge_cases,
        test_part2_includes_part1_invalid,
        # Range processing tests (8)
        test_range_11_to_22,
        test_range_95_to_115,
        test_range_998_to_1012,
        test_range_1188511880_to_1188511890,
        test_range_222220_to_222224,
        test_range_1698522_to_1698528_no_invalid,
        test_range_446443_to_446449,
        test_range_38593856_to_38593862,
        # Part 2 range processing tests (3)
        test_part2_range_95_to_115,
        test_part2_range_998_to_1012,
        test_part2_range_565653_to_565659,
        # Helper function tests (4)
        test_parse_single_range,
        test_parse_multiple_ranges,
        test_parse_with_whitespace,
        test_solve_simple_example,
        # Integration tests (5)
        test_integration_sample_input,
        test_integration_sample_input_part2,
        test_integration_range_with_no_invalid_ids,
        test_integration_multiple_ranges_sum,
        # Verification test (1)
        test_specific_invalid_ids,
    ]

    passed = 0
    failed = 0

    for test in tests:
        try:
            test()
            passed += 1
        except AssertionError as e:
            print(f"✗ {test.__doc__} - FAILED: {e}")
            failed += 1
        except Exception as e:
            print(f"✗ {test.__doc__} - ERROR: {e}")
            failed += 1

    print("=" * 70)
    print(f"Test Results: {passed} passed, {failed} failed out of {len(tests)} total")
    print("=" * 70)

    return failed == 0


if __name__ == '__main__':
    success = run_all_tests()
    sys.exit(0 if success else 1)
