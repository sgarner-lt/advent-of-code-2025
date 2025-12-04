#!/usr/bin/env python3
"""
Unit tests for Carbon Day 01 implementation

Since Carbon doesn't have a mature testing framework yet, these tests
verify the algorithm logic that is implemented in day01.carbon

All test cases mirror the tests defined in the Carbon code:
Part 1 tests (8):
- TestParseDirection_Left
- TestParseDirection_Right
- TestLeftRotationWraparound
- TestRightRotationWraparound
- TestRotationLandsOnZero
- TestSampleInput
- TestLeftRotationNoWrap
- TestRightRotationNoWrap

Part 2 tests (8):
- TestCountZeroCrossingsSimple_Right
- TestCountZeroCrossingsSimple_Left
- TestCountZeroCrossingsLarge
- TestCountZeroCrossingsExactMultiple
- TestCountZeroCrossingsNoCrossing
- TestCountZeroCrossingsStartingAtZero_Right
- TestCountZeroCrossingsStartingAtZero_Left
- TestCountZeroCrossingsEndingAtZero
"""

import sys
import os

# Add parent directory to path to import runner module
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from runner import parse_rotation, rotate_dial, count_zeros, count_zero_crossings


# ============================================================================
# PART 1 TESTS
# ============================================================================

def test_parse_left_rotation():
    """Test 1: Parse left rotation instruction"""
    result = parse_rotation("L68")
    assert result == ('L', 68), f"Expected ('L', 68), got {result}"
    print("✓ Test 1: Parse left rotation - PASSED")


def test_parse_right_rotation():
    """Test 2: Parse right rotation instruction"""
    result = parse_rotation("R48")
    assert result == ('R', 48), f"Expected ('R', 48), got {result}"
    print("✓ Test 2: Parse right rotation - PASSED")


def test_left_rotation_wraparound():
    """Test 3: Left rotation with wraparound"""
    result = rotate_dial(5, 'L', 10)
    assert result == 95, f"Expected 95, got {result}"
    print("✓ Test 3: Left rotation with wraparound - PASSED")


def test_right_rotation_wraparound():
    """Test 4: Right rotation with wraparound"""
    result = rotate_dial(95, 'R', 10)
    assert result == 5, f"Expected 5, got {result}"
    print("✓ Test 4: Right rotation with wraparound - PASSED")


def test_rotation_lands_on_zero():
    """Test 5: Rotation lands on zero"""
    result = rotate_dial(52, 'R', 48)
    assert result == 0, f"Expected 0, got {result}"
    print("✓ Test 5: Rotation lands on zero - PASSED")


def test_sample_input():
    """Test 6: Sample input produces correct answer"""
    sample_input = "L68\nL30\nR48\nL5\nR60\nL55\nL1\nL99\nR14\nL82"
    part1, part2 = count_zeros(sample_input)
    assert part1 == 3, f"Expected part1=3, got {part1}"
    assert part2 == 6, f"Expected part2=6, got {part2}"
    print("✓ Test 6: Sample input produces correct answer - PASSED")


def test_left_rotation_no_wrap():
    """Test 7: Left rotation without wraparound"""
    result = rotate_dial(50, 'L', 10)
    assert result == 40, f"Expected 40, got {result}"
    print("✓ Test 7: Left rotation without wraparound - PASSED")


def test_right_rotation_no_wrap():
    """Test 8: Right rotation without wraparound"""
    result = rotate_dial(50, 'R', 10)
    assert result == 60, f"Expected 60, got {result}"
    print("✓ Test 8: Right rotation without wraparound - PASSED")


# ============================================================================
# PART 2 TESTS
# ============================================================================

def test_count_zero_crossings_simple_right():
    """Test 9: Right crossing once (simple case)"""
    crossings = count_zero_crossings(95, 'R', 10)
    assert crossings == 1, f"Expected 1, got {crossings}"
    print("✓ Test 9: Right crossing once (simple case) - PASSED")


def test_count_zero_crossings_simple_left():
    """Test 10: Left crossing once (simple case)"""
    crossings = count_zero_crossings(5, 'L', 10)
    assert crossings == 1, f"Expected 1, got {crossings}"
    print("✓ Test 10: Left crossing once (simple case) - PASSED")


def test_count_zero_crossings_large():
    """Test 11: Large rotation - multiple crossings"""
    crossings = count_zero_crossings(50, 'R', 1000)
    assert crossings == 10, f"Expected 10, got {crossings}"
    print("✓ Test 11: Large rotation - multiple crossings - PASSED")


def test_count_zero_crossings_exact_multiple():
    """Test 12: Exact multiple of 100"""
    crossings = count_zero_crossings(0, 'R', 100)
    assert crossings == 1, f"Expected 1, got {crossings}"
    print("✓ Test 12: Exact multiple of 100 - PASSED")


def test_count_zero_crossings_no_crossing():
    """Test 13: No crossing - rotation doesn't reach zero"""
    crossings = count_zero_crossings(50, 'R', 5)
    assert crossings == 0, f"Expected 0, got {crossings}"
    print("✓ Test 13: No crossing - rotation doesn't reach zero - PASSED")


def test_count_zero_crossings_starting_at_zero_right():
    """Test 14: Starting at zero (right) - should not count as crossing"""
    crossings = count_zero_crossings(0, 'R', 10)
    assert crossings == 0, f"Expected 0, got {crossings}"
    print("✓ Test 14: Starting at zero (right) - should not count as crossing - PASSED")


def test_count_zero_crossings_starting_at_zero_left():
    """Test 15: Starting at zero (left) - should not count as crossing"""
    crossings = count_zero_crossings(0, 'L', 10)
    assert crossings == 0, f"Expected 0, got {crossings}"
    print("✓ Test 15: Starting at zero (left) - should not count as crossing - PASSED")


def test_count_zero_crossings_ending_at_zero():
    """Test 16: Ending at zero - should count as crossing"""
    crossings = count_zero_crossings(90, 'R', 10)
    assert crossings == 1, f"Expected 1, got {crossings}"
    print("✓ Test 16: Ending at zero - should count as crossing - PASSED")


def run_all_tests():
    """Run all unit tests"""
    print("=" * 60)
    print("Running Carbon Day 01 Unit Tests")
    print("=" * 60)

    tests = [
        # Part 1 tests
        test_parse_left_rotation,
        test_parse_right_rotation,
        test_left_rotation_wraparound,
        test_right_rotation_wraparound,
        test_rotation_lands_on_zero,
        test_sample_input,
        test_left_rotation_no_wrap,
        test_right_rotation_no_wrap,
        # Part 2 tests
        test_count_zero_crossings_simple_right,
        test_count_zero_crossings_simple_left,
        test_count_zero_crossings_large,
        test_count_zero_crossings_exact_multiple,
        test_count_zero_crossings_no_crossing,
        test_count_zero_crossings_starting_at_zero_right,
        test_count_zero_crossings_starting_at_zero_left,
        test_count_zero_crossings_ending_at_zero,
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

    print("=" * 60)
    print(f"Test Results: {passed} passed, {failed} failed out of {len(tests)} total")
    print("=" * 60)

    return failed == 0


if __name__ == '__main__':
    success = run_all_tests()
    sys.exit(0 if success else 1)
