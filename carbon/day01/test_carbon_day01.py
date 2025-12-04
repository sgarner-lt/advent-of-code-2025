#!/usr/bin/env python3
"""
Unit tests for Carbon Day 01 implementation

Since Carbon doesn't have a mature testing framework yet, these tests
verify the algorithm logic that is implemented in day01.carbon

All test cases mirror the tests defined in the Carbon code:
- TestParseDirection_Left
- TestParseDirection_Right
- TestLeftRotationWraparound
- TestRightRotationWraparound
- TestRotationLandsOnZero
- TestSampleInput
- TestLeftRotationNoWrap
- TestRightRotationNoWrap
"""

import sys
import os

# Add parent directory to path to import runner module
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from runner import parse_rotation, rotate_dial, count_zeros


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
    result = count_zeros(sample_input)
    assert result == 3, f"Expected 3, got {result}"
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


def run_all_tests():
    """Run all unit tests"""
    print("=" * 60)
    print("Running Carbon Day 01 Unit Tests")
    print("=" * 60)

    tests = [
        test_parse_left_rotation,
        test_parse_right_rotation,
        test_left_rotation_wraparound,
        test_right_rotation_wraparound,
        test_rotation_lands_on_zero,
        test_sample_input,
        test_left_rotation_no_wrap,
        test_right_rotation_no_wrap,
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
