#!/usr/bin/env python3
"""
Unit tests for Carbon Day 03 implementation

Since Carbon doesn't have a mature testing framework yet, these tests
verify the algorithm logic that is implemented in day03.carbon

Test Coverage:
- Part 1: Pair extraction and maximum finding
- Part 2: Greedy algorithm for maximum k-digit extraction
- Integration tests for dual-output solve function
"""

import sys
import os

# Add parent directory to path to import runner module
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from runner import extract_pairs, extract_max_k_digits, find_max, solve


# ============================================================================
# PART 1 TESTS (Existing)
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


def test_find_max_from_list():
    """Test 2: Find maximum from list of pairs"""
    pairs = [98, 87, 76, 65, 54, 43, 32, 21, 11]
    max_value = find_max(pairs)
    assert max_value == 98, f"Expected 98, got {max_value}"
    print("✓ Test 2: Find maximum from list - PASSED")


def test_sample_line1_part1():
    """Test 3: Sample line 1 Part 1 - '987654321111111' should have max 98"""
    line = "987654321111111"
    pairs = extract_pairs(line)
    max_value = find_max(pairs)
    assert max_value == 98, f"Expected 98, got {max_value}"
    print("✓ Test 3: Sample line 1 Part 1 (max 98) - PASSED")


def test_sample_line2_part1():
    """Test 4: Sample line 2 Part 1 - '811111111111119' should have max 89"""
    line = "811111111111119"
    pairs = extract_pairs(line)
    max_value = find_max(pairs)
    assert max_value == 89, f"Expected 89, got {max_value}"
    print("✓ Test 4: Sample line 2 Part 1 (max 89) - PASSED")


# ============================================================================
# PART 2 TESTS (New)
# ============================================================================

def test_extract_max_k_digits_line1():
    """Test 5: Extract max 12-digit from line 1: '987654321111111' yields 987654321111"""
    line = "987654321111111"
    result = extract_max_k_digits(line, 12)
    expected = 987654321111
    assert result == expected, f"Expected {expected}, got {result}"
    print("✓ Test 5: Extract max 12-digit from line 1 - PASSED")


def test_extract_max_k_digits_line2():
    """Test 6: Extract max 12-digit from line 2: '811111111111119' yields 811111111119"""
    line = "811111111111119"
    result = extract_max_k_digits(line, 12)
    expected = 811111111119
    assert result == expected, f"Expected {expected}, got {result}"
    print("✓ Test 6: Extract max 12-digit from line 2 - PASSED")


def test_extract_max_k_digits_line3():
    """Test 7: Extract max 12-digit from line 3: '234234234234278' yields 434234234278"""
    line = "234234234234278"
    result = extract_max_k_digits(line, 12)
    expected = 434234234278
    assert result == expected, f"Expected {expected}, got {result}"
    print("✓ Test 7: Extract max 12-digit from line 3 - PASSED")


def test_extract_max_k_digits_line4():
    """Test 8: Extract max 12-digit from line 4: '818181911112111' yields 888911112111"""
    line = "818181911112111"
    result = extract_max_k_digits(line, 12)
    expected = 888911112111
    assert result == expected, f"Expected {expected}, got {result}"
    print("✓ Test 8: Extract max 12-digit from line 4 - PASSED")


# ============================================================================
# INTEGRATION TESTS
# ============================================================================

def test_solve_dual_output():
    """Test 9: Complete sample input should return (357, 3121910778619)"""
    sample_input = """987654321111111
811111111111119
234234234234278
818181911112111"""
    part1, part2 = solve(sample_input)
    assert part1 == 357, f"Expected part1=357, got {part1}"
    assert part2 == 3121910778619, f"Expected part2=3121910778619, got {part2}"
    print("✓ Test 9: Complete sample input dual output - PASSED")


def test_part1_unchanged():
    """Test 10: Verify Part 1 result remains unchanged"""
    sample_input = """987654321111111
811111111111119
234234234234278
818181911112111"""
    part1, _ = solve(sample_input)
    assert part1 == 357, f"Expected part1=357, got {part1}"
    print("✓ Test 10: Part 1 unchanged - PASSED")


def test_part2_correct_sum():
    """Test 11: Verify Part 2 produces correct sum"""
    sample_input = """987654321111111
811111111111119
234234234234278
818181911112111"""
    _, part2 = solve(sample_input)
    expected = 3121910778619
    assert part2 == expected, f"Expected part2={expected}, got {part2}"
    print("✓ Test 11: Part 2 correct sum - PASSED")


def run_all_tests():
    """Run all unit tests"""
    print("=" * 70)
    print("Running Carbon Day 03 Unit Tests (Part 1 + Part 2)")
    print("=" * 70)

    tests = [
        # Part 1 tests (4)
        test_extract_pairs_simple,
        test_find_max_from_list,
        test_sample_line1_part1,
        test_sample_line2_part1,
        # Part 2 tests (4)
        test_extract_max_k_digits_line1,
        test_extract_max_k_digits_line2,
        test_extract_max_k_digits_line3,
        test_extract_max_k_digits_line4,
        # Integration tests (3)
        test_solve_dual_output,
        test_part1_unchanged,
        test_part2_correct_sum,
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
