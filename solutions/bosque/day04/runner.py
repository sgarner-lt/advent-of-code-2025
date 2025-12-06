#!/usr/bin/env python3
"""
Bosque Day 04 Runner Wrapper

This is a temporary wrapper to handle I/O for Bosque until BosqueCore's
standard library supports stdin and I/O operations.

The Bosque implementation in solution.bsq contains the correct algorithm,
but cannot execute independently due to BosqueCore's lack of I/O support.

This wrapper:
1. Reads input from stdin
2. Implements the same paper roll accessibility algorithm as the Bosque code
3. Outputs the result in the required JSON format

The algorithm logic here mirrors the Bosque implementation in solution.bsq

Algorithm:

Part 1:
- Parse input grid where '@' represents paper rolls and '.' represents empty space
- For each paper roll position, count adjacent rolls in all 8 directions (N, S, E, W, NE, NW, SE, SW)
- A roll is accessible if it has fewer than 4 adjacent rolls (count < 4)
- Count total accessible rolls
- Generate grid visualization: 'x' for accessible, '@' for inaccessible, '.' for empty

Part 2:
- Start with initial grid
- Iterate until no accessible rolls remain:
  1. Identify all accessible rolls (< 4 adjacent)
  2. Remove all identified rolls as a batch (replace with '.')
  3. Update grid state
  4. Count removed rolls
- Return total count of removed rolls across all iterations

Example:
- Input grid (10x10 sample)
- Expected output: {"part1": 13, "part2": 43, "additional-info": {"grid": "..."}}
"""

import sys
import json
import copy


def parse_grid(input_text):
    """
    Parse input into a 2D grid of characters.

    Args:
        input_text: Multi-line string containing grid

    Returns:
        List of lists representing the grid

    Mirrors: function parseGrid(input: String): List<List<Char>>
    """
    lines = input_text.strip().split('\n')
    grid = []
    for line in lines:
        trimmed = line.strip()
        if trimmed:
            grid.append(list(trimmed))
    return grid


def count_adjacent_rolls(grid, row, col):
    """
    Count adjacent paper rolls ('@' symbols) in all 8 directions.

    Directions: N, S, E, W, NE, NW, SE, SW

    Args:
        grid: 2D list of characters
        row: Row index
        col: Column index

    Returns:
        Integer count of adjacent rolls

    Mirrors: function countAdjacentRolls(grid: List<List<Char>>, row: Int, col: Int): Int
    """
    directions = [
        (-1, 0),   # N
        (1, 0),    # S
        (0, 1),    # E
        (0, -1),   # W
        (-1, 1),   # NE
        (-1, -1),  # NW
        (1, 1),    # SE
        (1, -1),   # SW
    ]

    rows = len(grid)
    cols = len(grid[0]) if rows > 0 else 0
    count = 0

    for dr, dc in directions:
        new_row = row + dr
        new_col = col + dc

        # Check bounds
        if 0 <= new_row < rows and 0 <= new_col < cols:
            if grid[new_row][new_col] == '@':
                count += 1

    return count


def identify_accessible_rolls(grid):
    """
    Identify which rolls are accessible (adjacent_count < 4).

    A roll is accessible if it has fewer than 4 adjacent rolls in the
    8 surrounding positions.

    Args:
        grid: 2D list of characters

    Returns:
        List of (row, col) tuples for accessible positions

    Mirrors: function identifyAccessibleRolls(grid: List<List<Char>>): List<Position>
    """
    accessible = []

    for row in range(len(grid)):
        for col in range(len(grid[row])):
            if grid[row][col] == '@':
                adjacent_count = count_adjacent_rolls(grid, row, col)
                if adjacent_count < 4:
                    accessible.append((row, col))

    return accessible


def create_visualization(grid, accessible):
    """
    Create grid visualization.

    Marks accessible rolls with 'x', keeps inaccessible rolls as '@',
    and keeps empty spaces as '.'.

    Args:
        grid: 2D list of characters
        accessible: List of (row, col) tuples for accessible positions

    Returns:
        String representation of the grid with newlines

    Mirrors: function createVisualization(grid: List<List<Char>>, accessible: List<Position>): String
    """
    result = []

    for row in range(len(grid)):
        row_chars = []
        for col in range(len(grid[row])):
            if (row, col) in accessible:
                row_chars.append('x')
            else:
                row_chars.append(grid[row][col])
        result.append(''.join(row_chars))

    return '\n'.join(result)


def remove_rolls(grid, positions):
    """
    Remove rolls from the grid at specified positions.

    Args:
        grid: 2D list of characters
        positions: List of (row, col) tuples to remove

    Returns:
        New grid with removed positions replaced by '.'

    Mirrors: function removeRolls(grid: List<List<Char>>, positions: List<Position>): List<List<Char>>
    """
    # Create a deep copy to avoid modifying original
    new_grid = copy.deepcopy(grid)

    for row, col in positions:
        new_grid[row][col] = '.'

    return new_grid


def solve_part2(input_text):
    """
    Solve Part 2: Iteratively remove accessible rolls.

    Args:
        input_text: Multi-line string containing grid

    Returns:
        Integer count of total removed rolls

    Mirrors: function solvePart2Loop(grid: List<List<Char>>, totalRemoved: Int): Int
    """
    grid = parse_grid(input_text)

    if not grid:
        return 0

    total_removed = 0

    while True:
        # Identify all accessible rolls in current grid state
        accessible = identify_accessible_rolls(grid)

        # If no accessible rolls found, we're done
        if not accessible:
            break

        # Count removed rolls in this iteration
        removed_count = len(accessible)
        total_removed += removed_count

        # Remove all accessible rolls (batch removal)
        grid = remove_rolls(grid, accessible)

    return total_removed


def solve(input_text):
    """
    Main solve function that processes grid and returns count with visualization.

    Args:
        input_text: Multi-line string containing grid

    Returns:
        Dictionary with 'part1' count, 'part2' count, and 'additional-info' grid

    Mirrors: function solve(input: String): {part1: Int, part2: Int, additionalInfo: {grid: String}}
    """
    grid = parse_grid(input_text)

    if not grid:
        return {"part1": 0, "part2": 0, "additional-info": {"grid": ""}}

    # Part 1: Initial accessible rolls
    accessible = identify_accessible_rolls(grid)
    count = len(accessible)
    visualization = create_visualization(grid, accessible)

    # Part 2: Total removed rolls through iterative removal
    part2_count = solve_part2(input_text)

    return {
        "part1": count,
        "part2": part2_count,
        "additional-info": {
            "grid": visualization
        }
    }


def main():
    """Main entry point - reads from stdin"""
    try:
        # Read input from stdin
        input_text = sys.stdin.read()

        result = solve(input_text)

        # Output JSON format matching other languages
        print(json.dumps(result))

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        print('{"part1": null, "part2": null, "additional-info": {"grid": ""}}')
        sys.exit(1)


if __name__ == '__main__':
    main()
