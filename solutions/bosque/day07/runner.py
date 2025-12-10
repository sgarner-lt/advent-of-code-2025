#!/usr/bin/env python3
"""
Python runner for Bosque Day 07 - Tachyon Manifold Beam Splitter Simulation

This script implements the logic described in solution.bsq since Bosque's
standard library and tooling are still in development. It reads from stdin,
processes the input according to the Bosque algorithm, and outputs JSON.

The implementation follows the exact algorithm specified in solution.bsq:
1. Parse input into a 2D grid of characters
2. Find starting position 'S' in the grid
3. Simulate beam propagation:
   - Beam starts at 'S' moving downward
   - Beam passes through '.' freely
   - When beam encounters '^', the beam stops and two new beams are created
   - Only count each splitter once (first hit activates it)
4. Count the total number of times beams are split
5. Return JSON format: {"part1": split_count, "part2": null}

Expected results:
- Sample input: {"part1": 21, "part2": null}
- Real input: {"part1": <redacted>, "part2": null}
"""

import sys
import json


class Beam:
    """
    Represents a beam with position (row, col).
    All beams move downward (increment row by 1 each step).

    Mirrors: entity Beam in solution.bsq
    """
    def __init__(self, row, col):
        self.row = row
        self.col = col

    def __eq__(self, other):
        return self.row == other.row and self.col == other.col

    def __hash__(self):
        return hash((self.row, self.col))

    def __repr__(self):
        return f"Beam({self.row}, {self.col})"


def parse_grid(input_text):
    """
    Parse input into a 2D grid of characters.
    Returns list of lists where each inner list is a row of characters.

    Mirrors: function parseGrid(input: String): List<List<String>>
    """
    lines = input_text.strip().split('\n')
    grid = []

    for line in lines:
        line = line.strip()
        if line:
            # Convert each character to a list element
            row = list(line)
            grid.append(row)

    return grid


def find_start_position(grid):
    """
    Find the starting position 'S' in the grid.
    Returns (row, col) tuple or None if not found.

    Mirrors: function findStartPosition(grid: List<List<String>>): {row: Int, col: Int}?
    """
    for row in range(len(grid)):
        for col in range(len(grid[row])):
            if grid[row][col] == 'S':
                return (row, col)
    return None


def is_in_bounds(grid, row, col):
    """
    Check if a position is within grid bounds.

    Mirrors: function isInBounds(grid: List<List<String>>, row: Int, col: Int): Bool
    """
    if not grid:
        return False

    rows = len(grid)
    cols = len(grid[0]) if rows > 0 else 0

    return 0 <= row < rows and 0 <= col < cols


def get_cell(grid, row, col):
    """
    Get cell at position (row, col).
    Returns the character at that position or empty string if out of bounds.

    Mirrors: function getCell(grid: List<List<String>>, row: Int, col: Int): String
    """
    if not is_in_bounds(grid, row, col):
        return ""

    return grid[row][col]


def simulate_beam_propagation(grid, start_row, start_col):
    """
    Simulate beam propagation and count splits.
    Uses a set to track activated splitters (count each only once).

    Mirrors: function simulateBeamPropagation(grid: List<List<String>>, startRow: Int, startCol: Int): Int
    """
    # Active beams queue
    active_beams = [Beam(start_row, start_col)]

    # Track activated splitters (only count each once)
    activated_splitters = set()

    # Track visited beam positions to avoid infinite loops
    visited_beams = set()

    split_count = 0
    iteration = 0
    max_iterations = 100000  # Safety limit

    while active_beams and iteration < max_iterations:
        iteration += 1
        next_beams = []
        seen_this_iteration = set()

        for beam in active_beams:
            # Skip if already visited
            beam_key = (beam.row, beam.col)
            if beam_key in visited_beams:
                continue
            visited_beams.add(beam_key)

            # Move beam one step downward
            new_row = beam.row + 1
            new_col = beam.col

            # Check if new position is within bounds
            if not is_in_bounds(grid, new_row, new_col):
                # Beam exited grid
                continue

            cell = get_cell(grid, new_row, new_col)
            new_beam = Beam(new_row, new_col)

            if cell == '.':
                # Continue tracking beam through empty space
                if new_beam not in seen_this_iteration:
                    next_beams.append(new_beam)
                    seen_this_iteration.add(new_beam)

            elif cell == '^':
                # Hit a splitter
                splitter_key = (new_row, new_col)

                # Only count if not already activated
                if splitter_key not in activated_splitters:
                    split_count += 1
                    activated_splitters.add(splitter_key)

                # Create left beam at (new_row, new_col - 1)
                left_col = new_col - 1
                if is_in_bounds(grid, new_row, left_col):
                    left_beam = Beam(new_row, left_col)
                    if left_beam not in seen_this_iteration:
                        next_beams.append(left_beam)
                        seen_this_iteration.add(left_beam)

                # Create right beam at (new_row, new_col + 1)
                right_col = new_col + 1
                if is_in_bounds(grid, new_row, right_col):
                    right_beam = Beam(new_row, right_col)
                    if right_beam not in seen_this_iteration:
                        next_beams.append(right_beam)
                        seen_this_iteration.add(right_beam)

            elif cell == 'S':
                # Starting position acts as empty space
                if new_beam not in seen_this_iteration:
                    next_beams.append(new_beam)
                    seen_this_iteration.add(new_beam)

            else:
                # Unknown cell type - treat as empty
                if new_beam not in seen_this_iteration:
                    next_beams.append(new_beam)
                    seen_this_iteration.add(new_beam)

        active_beams = next_beams

    if iteration >= max_iterations:
        print(f"WARNING: Reached maximum iterations limit!", file=sys.stderr)

    return split_count


def solve(input_text):
    """
    Solve the puzzle: parse grid, find start, simulate, count splits.
    Returns (part1, part2) tuple.

    Mirrors: function solve(input: String): {part1: Int, part2: Int}
    """
    # Parse input into grid
    grid = parse_grid(input_text)

    if not grid:
        return (0, None)

    # Find starting position
    start_pos = find_start_position(grid)

    if start_pos is None:
        print("Error: No starting position 'S' found in grid", file=sys.stderr)
        return (0, None)

    # Part 1: Count beam splits
    split_count = simulate_beam_propagation(grid, start_pos[0], start_pos[1])

    return (split_count, None)


def main():
    """
    Main entry point.
    Reads from stdin, processes input, and outputs JSON.
    """
    try:
        # Read input from stdin
        input_text = sys.stdin.read()

        # Solve the puzzle
        part1, part2 = solve(input_text)

        # Output JSON format for cross-language validation
        result = {
            "part1": part1,
            "part2": part2
        }
        print(json.dumps(result))

        return 0

    except Exception as e:
        # Error handling: output null results
        print(json.dumps({"part1": None, "part2": None}), file=sys.stderr)
        print(f"Error: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
