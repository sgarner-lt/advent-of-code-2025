#!/usr/bin/env python3
"""
Carbon Day 04 Runner Wrapper

⚠️ DEPRECATED: Python wrapper approach is deprecated.

This implementation still uses a Python wrapper instead of real Carbon code.
Day 1 has been migrated to use real Carbon with container execution, and
this day should be migrated to follow the same pattern.

Migration reference:
- See solutions/carbon/day01/ for real Carbon implementation
- Use Bazel build system inside Docker/Podman container
- Character-based I/O with Core library
- See docs/languages/carbon.md for setup details

---

CURRENT STATUS (Needs Migration):

This is a temporary wrapper to simulate Carbon execution until Carbon's
standard library matures to support stdin and I/O operations.

The Carbon implementation in day04.carbon contains the correct algorithm,
but cannot execute independently due to Carbon's experimental state.

This wrapper:
1. Reads input from stdin
2. Implements the same algorithm as the Carbon code
3. Outputs the result in the required JSON format

The algorithm logic here mirrors the Carbon implementation in day04.carbon

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

Expected results:
- Sample input: {"part1": 13, "part2": 43, "additional-info": {"grid": "..."}}
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

    Args:
        grid: 2D list of characters

    Returns:
        List of (row, col) tuples for accessible positions
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

    'x' for accessible rolls, '@' for inaccessible rolls, '.' for empty spaces

    Args:
        grid: 2D list of characters
        accessible: List of (row, col) tuples for accessible positions

    Returns:
        String representation of the grid with newlines
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
    Solve the puzzle: count accessible rolls and create visualization.

    Args:
        input_text: Multi-line string containing grid

    Returns:
        Dictionary with 'part1' count, 'part2' count, and 'additional-info' grid visualization
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
