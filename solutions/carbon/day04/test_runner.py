#!/usr/bin/env python3
"""
Tests for Carbon Day 04 Runner Wrapper
"""

import unittest
import sys
import os

# Add current directory to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from runner import parse_grid, count_adjacent_rolls, identify_accessible_rolls, create_visualization, remove_rolls, solve_part2, solve


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

    # Part 2 Tests

    def test_part2_sample_input(self):
        """Test Part 2 with sample input produces total of 43"""
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
        total = solve_part2(input_text)
        self.assertEqual(total, 43)

    def test_part2_preserves_part1(self):
        """Test Part 2 doesn't affect Part 1 result"""
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
        self.assertEqual(result['part2'], 43)

    def test_part2_empty_grid(self):
        """Test Part 2 with empty grid"""
        input_text = ""
        total = solve_part2(input_text)
        self.assertEqual(total, 0)

    def test_remove_rolls(self):
        """Test remove_rolls function"""
        grid = [['@', '@', '.'], ['@', '.', '.']]
        positions = [(0, 0), (0, 1)]
        new_grid = remove_rolls(grid, positions)

        self.assertEqual(new_grid[0][0], '.')
        self.assertEqual(new_grid[0][1], '.')
        self.assertEqual(new_grid[1][0], '@')  # Unchanged

    def test_part2_single_iteration(self):
        """Test Part 2 with all rolls accessible in first iteration"""
        input_text = "@..\n.@.\n..@"
        total = solve_part2(input_text)
        # All 3 rolls are accessible in first iteration (0-1 neighbors each)
        self.assertEqual(total, 3)

    def test_part2_iteration_termination(self):
        """Test Part 2 iteration stops when no accessible rolls remain"""
        input_text = ".....\n.@@@.\n.@@@.\n.@@@.\n....."
        total = solve_part2(input_text)
        # Should remove some rolls but stop when none are accessible
        self.assertGreater(total, 0)
        self.assertLessEqual(total, 9)


if __name__ == '__main__':
    unittest.main()
