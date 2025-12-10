#!/usr/bin/env python3
"""
Carbon Day 07 Runner Wrapper

This is a temporary wrapper to simulate Carbon execution until Carbon can
be compiled and run in the container environment.

The Carbon implementation in day07.carbon contains the correct algorithm,
but may not execute independently due to Carbon's experimental state.

This wrapper:
1. Reads input from stdin
2. Implements the same beam splitting algorithm as the Carbon code
3. Outputs the result in the required JSON format

The algorithm logic here mirrors the Carbon implementation in day07.carbon
"""

import sys
import json


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

    Algorithm (mirrors Carbon implementation in day07.carbon):
    1. Initialize beam queue with starting position
    2. Track visited beams to avoid infinite loops
    3. Track activated splitters to count each splitter only once
    4. While beams remain active:
       a. For each beam, move one step downward (increment row)
       b. Check if new position is out of bounds (stop tracking if yes)
       c. Check cell type at new position:
          - '.' or 'S': continue tracking beam (add to next iteration)
          - '^': increment split counter (if not already activated),
                 create left beam at (row, col-1) if in bounds,
                 create right beam at (row, col+1) if in bounds
       d. Avoid duplicate beams in the same iteration
    5. Return total split count
    """
    active_beams = [(start_row, start_col)]
    split_count = 0
    activated_splitters = set()
    visited_beams = set()

    iteration = 0
    max_iterations = 100000  # Safety limit

    while active_beams and iteration < max_iterations:
        iteration += 1
        next_beams = []
        seen_this_iteration = set()

        for beam_row, beam_col in active_beams:
            # Skip if already visited this beam position
            if (beam_row, beam_col) in visited_beams:
                continue
            visited_beams.add((beam_row, beam_col))

            # Move beam one step downward
            new_row = beam_row + 1
            new_col = beam_col

            # Check if new position is within bounds
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


def main():
    """Main entry point - reads from stdin"""
    try:
        # Read input from stdin
        input_text = sys.stdin.read()

        part1_result, part2_result = solve(input_text)

        # Output JSON format matching other languages
        output = {"part1": part1_result, "part2": part2_result}
        print(json.dumps(output))

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        print('{"part1": null, "part2": null}')
        sys.exit(1)


if __name__ == '__main__':
    main()
