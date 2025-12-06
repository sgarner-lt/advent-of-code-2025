#!/usr/bin/env python3
"""
Tests for Carbon Day 04 Runner Wrapper
"""

import unittest
import sys
import os

# Add current directory to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from runner import parse_grid, count_adjacent_rolls, identify_accessible_rolls, create_visualization, solve


class TestDay04Carbon(unittest.TestCase):

    def test_parse_grid(self):
        """Test grid parsing from input"""
        input_text = "..@@\n@@@.\n"
        grid = parse_grid(input_text)
        self.assertEqual(len(grid), 2)
        self.assertEqual(grid[0], ['.', '.', '@', '@'])
        self.assertEqual(grid[1], ['@', '@', '@', '.'])

    def test_count_adjacent_corner_cell(self):
        """Test counting adjacent cells for corner position"""
        grid = [
            ['@', '@', '.'],
            ['@', '.', '.'],
            ['.', '.', '.'],
        ]
        count = count_adjacent_rolls(grid, 0, 0)
        # Corner cell (0,0) has 2 adjacent rolls: (0,1) and (1,0)
        self.assertEqual(count, 2)

    def test_count_adjacent_edge_cell(self):
        """Test counting adjacent cells for edge position"""
        grid = [
            ['@', '@', '@'],
            ['@', '@', '@'],
            ['.', '.', '.'],
        ]
        count = count_adjacent_rolls(grid, 0, 1)
        # Edge cell (0,1) has 5 adjacent rolls
        self.assertEqual(count, 5)

    def test_count_adjacent_interior_cell(self):
        """Test counting adjacent cells for interior position"""
        grid = [
            ['@', '@', '@'],
            ['@', '@', '@'],
            ['@', '@', '@'],
        ]
        count = count_adjacent_rolls(grid, 1, 1)
        # Interior cell (1,1) has all 8 neighbors
        self.assertEqual(count, 8)

    def test_accessibility_rule(self):
        """Test accessibility rule (adjacent_count < 4)"""
        grid = [
            ['@', '@', '.'],
            ['@', '@', '@'],
            ['.', '@', '.'],
        ]
        accessible = identify_accessible_rolls(grid)
        # Cell (0,0) has 3 adjacent -> accessible
        self.assertIn((0, 0), accessible)
        # Cell (1,1) has 5 adjacent -> not accessible
        self.assertNotIn((1, 1), accessible)

    def test_sample_input(self):
        """Test sample input produces 13 accessible rolls"""
        input_text = """..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@."""
        result = solve(input_text)
        self.assertEqual(result['part1'], 13)

    def test_visualization_format(self):
        """Test visualization contains expected characters"""
        input_text = "..@@\n@@@.\n"
        result = solve(input_text)
        viz = result['additional-info']['grid']
        # Visualization should contain 'x' or '@'
        self.assertTrue('x' in viz or '@' in viz)
        self.assertIn('\n', viz)

    def test_empty_grid(self):
        """Test empty grid handling"""
        input_text = ""
        result = solve(input_text)
        self.assertEqual(result['part1'], 0)
        self.assertEqual(result['additional-info']['grid'], "")


if __name__ == '__main__':
    unittest.main()
