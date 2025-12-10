#!/usr/bin/env python3
"""
Test suite for Bosque Day 07 - Tachyon Manifold Beam Splitter Simulation

Tests the Python runner implementation which follows the Bosque algorithm
defined in solution.bsq. These tests validate grid parsing, beam propagation,
split counting, and cross-language consistency.

Expected results:
- Sample input: {"part1": 21, "part2": null}
- Real input: {"part1": <redacted>, "part2": null}
"""

import unittest
import sys
import os

# Add the current directory to the path to import runner
sys.path.insert(0, os.path.dirname(__file__))

from runner import (
    Beam,
    parse_grid,
    find_start_position,
    is_in_bounds,
    get_cell,
    simulate_beam_propagation,
    solve
)


class TestDay07(unittest.TestCase):
    """Test cases for Day 07 Tachyon Manifold Beam Splitter"""

    def test_parse_grid(self):
        """Test parsing grid with 3 rows"""
        input_text = "...\n.S.\n.^."
        grid = parse_grid(input_text)

        self.assertEqual(len(grid), 3)
        self.assertEqual(grid[0], ['.', '.', '.'])
        self.assertEqual(grid[1], ['.', 'S', '.'])
        self.assertEqual(grid[2], ['.', '^', '.'])

    def test_find_start_position(self):
        """Test finding start position at (1, 1)"""
        grid = [
            ['.', '.', '.'],
            ['.', 'S', '.'],
            ['.', '^', '.']
        ]
        start = find_start_position(grid)

        self.assertIsNotNone(start)
        self.assertEqual(start, (1, 1))

    def test_is_in_bounds(self):
        """Test boundary checking"""
        grid = [
            ['.', '.', '.'],
            ['.', 'S', '.'],
            ['.', '^', '.']
        ]

        self.assertTrue(is_in_bounds(grid, 0, 0))
        self.assertTrue(is_in_bounds(grid, 2, 2))
        self.assertFalse(is_in_bounds(grid, -1, 0))
        self.assertFalse(is_in_bounds(grid, 0, -1))
        self.assertFalse(is_in_bounds(grid, 3, 0))
        self.assertFalse(is_in_bounds(grid, 0, 3))

    def test_single_splitter(self):
        """Test single splitter produces count of 1"""
        input_text = ".S.\n...\n.^."
        part1, part2 = solve(input_text)

        self.assertEqual(part1, 1)
        self.assertIsNone(part2)

    def test_beam_exits_grid(self):
        """Test beam exits grid without hitting splitter"""
        input_text = ".S.\n..."
        part1, part2 = solve(input_text)

        self.assertEqual(part1, 0)
        self.assertIsNone(part2)

    def test_splitter_on_edge(self):
        """Test splitter on left edge only creates right beam"""
        input_text = "S..\n...\n^.."
        part1, part2 = solve(input_text)

        self.assertEqual(part1, 1)
        self.assertIsNone(part2)

    def test_sample_input(self):
        """Test sample input produces 21 splits"""
        sample = """.......S.......
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

        part1, part2 = solve(sample)

        self.assertEqual(part1, 21)
        self.assertIsNone(part2)

    def test_get_cell(self):
        """Test getting cell at valid position"""
        grid = [
            ['.', '.', '.'],
            ['.', 'S', '.'],
            ['.', '^', '.']
        ]
        cell = get_cell(grid, 1, 1)

        self.assertEqual(cell, 'S')


if __name__ == "__main__":
    # Run tests with verbose output
    unittest.main(verbosity=2)
