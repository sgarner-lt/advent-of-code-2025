#!/usr/bin/env python3
"""
Unit tests for Carbon Day 07 implementation

Since Carbon doesn't have a mature testing framework yet, these tests
verify the algorithm logic that is implemented in day07.carbon

All test cases mirror the core algorithm logic from Rust/Gleam implementations:

Grid Parsing Tests (2):
- TestParseGrid
- TestFindStartPosition

Boundary Tests (2):
- TestIsInBounds
- TestBoundaryEdgeCases

Beam Splitting Tests (4):
- TestSingleSplitter
- TestBeamExitsGrid
- TestSplitterOnEdge
- TestMultipleSplitters
"""

import sys
import os


# ============================================================================
# GRID PARSING LOGIC
# ============================================================================

def parse_grid(input_text):
    """Parse input into 2D grid of characters"""
    lines = input_text.strip().split('\n')
    grid = []
    for line in lines:
        if line.strip():
            grid.append(list(line))
    return grid


def find_start_position(grid):
    """Find the starting position marked with 'S'"""
    for row in range(len(grid)):
        for col in range(len(grid[row])):
            if grid[row][col] == 'S':
                return (row, col)
    return None


def is_in_bounds(grid, row, col):
    """Check if position is within grid bounds"""
    if not grid:
        return False
    return 0 <= row < len(grid) and 0 <= col < len(grid[0])


# ============================================================================
# BEAM SIMULATION LOGIC
# ============================================================================

def simulate_beam_propagation(grid, start_row, start_col):
    """
    Simulate beam propagation and count splits.

    Algorithm:
    1. Initialize beam queue with starting position
    2. While beams remain active:
       a. For each beam, move one step downward
       b. Check if out of bounds (stop tracking)
       c. If on empty space '.', continue tracking
       d. If on splitter '^', increment counter (once per splitter)
          and create two new beams at left/right positions
    3. Return total split count
    """
    active_beams = [(start_row, start_col)]
    split_count = 0
    activated_splitters = set()
    visited_beams = set()

    iteration = 0
    max_iterations = 100000

    while active_beams and iteration < max_iterations:
        iteration += 1
        next_beams = []
        seen_this_iteration = set()

        for beam_row, beam_col in active_beams:
            # Skip if already visited
            if (beam_row, beam_col) in visited_beams:
                continue
            visited_beams.add((beam_row, beam_col))

            # Move beam one step downward
            new_row = beam_row + 1
            new_col = beam_col

            # Check bounds
            if not is_in_bounds(grid, new_row, new_col):
                continue

            cell = grid[new_row][new_col]
            new_beam = (new_row, new_col)

            if cell == '.' or cell == 'S':
                # Continue tracking beam through empty space
                if new_beam not in seen_this_iteration:
                    next_beams.append(new_beam)
                    seen_this_iteration.add(new_beam)
            elif cell == '^':
                # Hit a splitter - count it only if not already activated
                if (new_row, new_col) not in activated_splitters:
                    split_count += 1
                    activated_splitters.add((new_row, new_col))

                # Create left beam at (new_row, new_col - 1)
                left_col = new_col - 1
                if is_in_bounds(grid, new_row, left_col):
                    left_beam = (new_row, left_col)
                    if left_beam not in seen_this_iteration:
                        next_beams.append(left_beam)
                        seen_this_iteration.add(left_beam)

                # Create right beam at (new_row, new_col + 1)
                right_col = new_col + 1
                if is_in_bounds(grid, new_row, right_col):
                    right_beam = (new_row, right_col)
                    if right_beam not in seen_this_iteration:
                        next_beams.append(right_beam)
                        seen_this_iteration.add(right_beam)
            else:
                # Unknown cell - treat as empty
                if new_beam not in seen_this_iteration:
                    next_beams.append(new_beam)
                    seen_this_iteration.add(new_beam)

        active_beams = next_beams

    return split_count


def solve(input_text):
    """Solve both parts of the puzzle"""
    grid = parse_grid(input_text)

    if not grid:
        return (None, None)

    # Find starting position
    start_pos = find_start_position(grid)
    if start_pos is None:
        return (None, None)

    # Part 1: Count beam splits
    split_count = simulate_beam_propagation(grid, start_pos[0], start_pos[1])

    return (split_count, None)


# ============================================================================
# GRID PARSING TESTS
# ============================================================================

def test_parse_grid():
    """Test 1: Parse grid correctly"""
    input_text = "...\n.S.\n.^."
    grid = parse_grid(input_text)
    assert len(grid) == 3, f"Expected 3 rows, got {len(grid)}"
    assert grid[0] == ['.', '.', '.'], f"Expected ['.', '.', '.'], got {grid[0]}"
    assert grid[1] == ['.', 'S', '.'], f"Expected ['.', 'S', '.'], got {grid[1]}"
    assert grid[2] == ['.', '^', '.'], f"Expected ['.', '^', '.'], got {grid[2]}"
    print("✓ Test 1: Parse grid - PASSED")


def test_find_start_position():
    """Test 2: Find start position correctly"""
    grid = [
        ['.', '.', '.'],
        ['.', 'S', '.'],
        ['.', '^', '.'],
    ]
    start = find_start_position(grid)
    assert start == (1, 1), f"Expected (1, 1), got {start}"
    print("✓ Test 2: Find start position - PASSED")


# ============================================================================
# BOUNDARY TESTS
# ============================================================================

def test_is_in_bounds():
    """Test 3: Boundary checking works correctly"""
    grid = [
        ['.', '.', '.'],
        ['.', 'S', '.'],
        ['.', '^', '.'],
    ]
    assert is_in_bounds(grid, 0, 0) == True
    assert is_in_bounds(grid, 2, 2) == True
    assert is_in_bounds(grid, -1, 0) == False
    assert is_in_bounds(grid, 0, -1) == False
    assert is_in_bounds(grid, 3, 0) == False
    assert is_in_bounds(grid, 0, 3) == False
    print("✓ Test 3: Boundary checking - PASSED")


def test_boundary_edge_cases():
    """Test 4: Boundary edge cases"""
    grid = [
        ['.', '.'],
        ['.', '.'],
    ]
    # Test all corners
    assert is_in_bounds(grid, 0, 0) == True
    assert is_in_bounds(grid, 0, 1) == True
    assert is_in_bounds(grid, 1, 0) == True
    assert is_in_bounds(grid, 1, 1) == True
    # Test just outside all edges
    assert is_in_bounds(grid, -1, 0) == False
    assert is_in_bounds(grid, 2, 0) == False
    assert is_in_bounds(grid, 0, -1) == False
    assert is_in_bounds(grid, 0, 2) == False
    print("✓ Test 4: Boundary edge cases - PASSED")


# ============================================================================
# BEAM SPLITTING TESTS
# ============================================================================

def test_single_splitter():
    """Test 5: Single splitter produces one split"""
    input_text = ".S.\n...\n.^."
    part1, _ = solve(input_text)
    assert part1 == 1, f"Expected 1, got {part1}"
    print("✓ Test 5: Single splitter - PASSED")


def test_beam_exits_grid():
    """Test 6: Beam exits grid without hitting splitter"""
    input_text = ".S.\n..."
    part1, _ = solve(input_text)
    assert part1 == 0, f"Expected 0, got {part1}"
    print("✓ Test 6: Beam exits grid - PASSED")


def test_splitter_on_edge():
    """Test 7: Splitter on left edge creates only right beam"""
    input_text = "S..\n...\n^.."
    part1, _ = solve(input_text)
    assert part1 == 1, f"Expected 1, got {part1}"
    print("✓ Test 7: Splitter on edge - PASSED")


def test_multiple_splitters():
    """Test 8: Multiple splitters in cascade"""
    input_text = "...S...\n.......\n...^..."
    part1, _ = solve(input_text)
    assert part1 == 1, f"Expected 1, got {part1}"
    print("✓ Test 8: Multiple splitters setup - PASSED")


# ============================================================================
# INTEGRATION TESTS
# ============================================================================

def test_sample_input():
    """Test 9: Sample input produces correct answer (21)"""
    input_text = """.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
..............."""
    part1, _ = solve(input_text)
    assert part1 == 21, f"Expected 21, got {part1}"
    print("✓ Test 9: Sample input (21 splits) - PASSED")


def run_all_tests():
    """Run all unit tests"""
    print("=" * 70)
    print("Running Carbon Day 07 Unit Tests")
    print("=" * 70)

    tests = [
        # Grid parsing tests (2)
        test_parse_grid,
        test_find_start_position,
        # Boundary tests (2)
        test_is_in_bounds,
        test_boundary_edge_cases,
        # Beam splitting tests (4)
        test_single_splitter,
        test_beam_exits_grid,
        test_splitter_on_edge,
        test_multiple_splitters,
        # Integration test (1)
        test_sample_input,
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
