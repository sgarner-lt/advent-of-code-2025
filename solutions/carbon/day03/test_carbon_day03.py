#!/usr/bin/env python3
"""
Unit tests for Carbon Day 03 implementation

Since Carbon doesn't have a mature testing framework yet, these tests
verify the algorithm logic that is implemented in day03.carbon

Test Coverage:
- Pair extraction from simple strings
- Maximum finding from list of pairs
- Individual sample input lines
- Complete sample input
- Edge cases (empty strings, single characters)
"""

import sys
import os

# Add parent directory to path to import runner module
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from runner import extract_pairs, find_max, solve


# ============================================================================
# PAIR EXTRACTION TESTS
# ============================================================================

def test_extract_pairs_simple():
    """Test 1: Extract pairs from simple string '987'"""
    pairs = extract_pairs("987")
    # Should contain 98 (pos 0,1), 97 (pos 0,2), 87 (pos 1,2)
    assert 98 in pairs, f"Expected 98 in pairs, got {pairs}"
    assert 97 in pairs, f"Expected 97 in pairs, got {pairs}"
    assert 87 in pairs, f"Expected 87 in pairs, got {pairs}"
    assert len(pairs) == 3, f"Expected 3 pairs, got {len(pairs)}"
    print("✓ Test 1: Extract pairs from '987' - PASSED")


def test_extract_pairs_two_digits():
    """Test 2: Extract pairs from two-digit string '12'"""
    pairs = extract_pairs("12")
    assert pairs == [12], f"Expected [12], got {pairs}"
    print("✓ Test 2: Extract pairs from '12' - PASSED")


def test_extract_pairs_single_digit():
    """Test 3: Extract pairs from single digit '9' (should be empty)"""
    pairs = extract_pairs("9")
    assert pairs == [], f"Expected empty list, got {pairs}"
    print("✓ Test 3: Extract pairs from single digit - PASSED")


def test_extract_pairs_count():
    """Test 4: Verify pairs count formula n*(n-1)/2"""
    line = "12345"  # 5 digits
    pairs = extract_pairs(line)
    expected_count = 5 * 4 // 2  # 10 pairs
    assert len(pairs) == expected_count, f"Expected {expected_count} pairs, got {len(pairs)}"
    print("✓ Test 4: Verify pairs count formula - PASSED")


# ============================================================================
# MAXIMUM FINDING TESTS
# ============================================================================

def test_find_max_from_list():
    """Test 5: Find maximum from list of pairs"""
    pairs = [98, 87, 76, 65, 54, 43, 32, 21, 11]
    max_value = find_max(pairs)
    assert max_value == 98, f"Expected 98, got {max_value}"
    print("✓ Test 5: Find maximum from list - PASSED")


def test_find_max_empty_list():
    """Test 6: Find maximum from empty list (should be None)"""
    pairs = []
    max_value = find_max(pairs)
    assert max_value is None, f"Expected None, got {max_value}"
    print("✓ Test 6: Find maximum from empty list - PASSED")


# ============================================================================
# SAMPLE INPUT LINE TESTS
# ============================================================================

def test_sample_line1():
    """Test 7: Sample line 1 - '987654321111111' should have max 98"""
    line = "987654321111111"
    pairs = extract_pairs(line)
    max_value = find_max(pairs)
    assert max_value == 98, f"Expected 98, got {max_value}"
    print("✓ Test 7: Sample line 1 (max 98) - PASSED")


def test_sample_line2():
    """Test 8: Sample line 2 - '811111111111119' should have max 89"""
    # Max is 89 from positions 0 and 14: '8' and '9'
    line = "811111111111119"
    pairs = extract_pairs(line)
    max_value = find_max(pairs)
    assert max_value == 89, f"Expected 89, got {max_value}"
    print("✓ Test 8: Sample line 2 (max 89) - PASSED")


def test_sample_line3():
    """Test 9: Sample line 3 - '234234234234278' should have max 78"""
    line = "234234234234278"
    pairs = extract_pairs(line)
    max_value = find_max(pairs)
    assert max_value == 78, f"Expected 78, got {max_value}"
    print("✓ Test 9: Sample line 3 (max 78) - PASSED")


def test_sample_line4():
    """Test 10: Sample line 4 - '818181911112111' should have max 92"""
    # Max is 92 from positions with '9' and '2'
    line = "818181911112111"
    pairs = extract_pairs(line)
    max_value = find_max(pairs)
    assert max_value == 92, f"Expected 92, got {max_value}"
    print("✓ Test 10: Sample line 4 (max 92) - PASSED")


# ============================================================================
# COMPLETE SAMPLE INPUT TEST
# ============================================================================

def test_complete_sample_input():
    """Test 11: Complete sample input should sum to 357"""
    sample_input = """987654321111111
811111111111119
234234234234278
818181911112111"""
    result = solve(sample_input)
    expected = 357  # 98 + 89 + 78 + 92
    assert result == expected, f"Expected {expected}, got {result}"
    print("✓ Test 11: Complete sample input (sum 357) - PASSED")


def run_all_tests():
    """Run all unit tests"""
    print("=" * 70)
    print("Running Carbon Day 03 Unit Tests")
    print("=" * 70)

    tests = [
        # Pair extraction tests (4)
        test_extract_pairs_simple,
        test_extract_pairs_two_digits,
        test_extract_pairs_single_digit,
        test_extract_pairs_count,
        # Maximum finding tests (2)
        test_find_max_from_list,
        test_find_max_empty_list,
        # Sample input line tests (4)
        test_sample_line1,
        test_sample_line2,
        test_sample_line3,
        test_sample_line4,
        # Complete sample test (1)
        test_complete_sample_input,
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
