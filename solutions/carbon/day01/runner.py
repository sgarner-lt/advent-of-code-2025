#!/usr/bin/env python3
"""
Carbon Day 01 Runner Wrapper

⚠️ DEPRECATED: This Python wrapper is no longer used.

As of December 2025, Day 1 uses a real Carbon implementation:
- Source: day01_simple.carbon
- Execution: Compiled with Bazel inside Docker/Podman container
- Runner: scripts/runners/run_carbon.sh

This file is kept for historical reference only. The runner script now
executes actual Carbon code instead of using this Python wrapper.

See:
- docs/languages/carbon.md for container setup
- solutions/carbon/day01/README.md for implementation details

---

LEGACY DOCUMENTATION (No Longer Applicable):

This was a temporary wrapper to simulate Carbon execution until Carbon's
standard library matured to support stdin and I/O operations.

The Carbon implementation in day01.carbon contains the correct algorithm,
but cannot execute independently due to Carbon's experimental state.

This wrapper:
1. Reads input from stdin
2. Implements the same rotation algorithm as the Carbon code
3. Outputs the result in the required JSON format

The algorithm logic here mirrors the Carbon implementation in day01.carbon
"""

import sys
import json


def parse_rotation(line):
    """Parse a rotation instruction like 'L68' or 'R48'"""
    line = line.strip()
    if not line:
        return None

    direction = line[0]
    try:
        distance = int(line[1:])
        return (direction, distance)
    except ValueError:
        return None


def rotate_dial(position, direction, distance):
    """Rotate the dial from current position"""
    if direction == 'L':
        new_position = position - distance
    else:  # 'R'
        new_position = position + distance

    # Handle modulo for circular wraparound (0-99)
    new_position = new_position % 100
    if new_position < 0:
        new_position = new_position + 100

    return new_position


def count_zero_crossings(position, direction, distance):
    """
    Count how many times the dial crosses through position 0 during a rotation.

    This function calculates zero crossings by breaking the rotation into:
    1. Complete circles (each crosses 0 exactly once)
    2. A remainder rotation (may or may not cross 0 depending on position and direction)

    Arguments:
        position: Current dial position (0-99)
        direction: Rotation direction ('L' or 'R')
        distance: Rotation amount (non-negative integer)

    Returns:
        Integer count of zero crossings (>= 0)
    """
    if distance == 0:
        return 0

    # Calculate complete circles and remainder
    complete_circles = distance // 100
    remainder = distance % 100

    # Each complete circle crosses zero exactly once
    crossings = complete_circles

    # Check if remainder rotation crosses zero based on direction
    if direction == 'R':
        # Distance to reach 0 going right (clockwise)
        distance_to_zero = 100 - position
        if remainder >= distance_to_zero:
            crossings += 1
    else:  # direction == 'L'
        # Distance to reach 0 going left (counterclockwise)
        distance_to_zero = position
        if position > 0 and remainder >= distance_to_zero:
            crossings += 1

    return crossings


def count_zeros(input_text):
    """
    Count how many times the dial lands on 0 (Part 1) and crosses through 0 (Part 2)

    Returns tuple: (part1_count, part2_count)
    """
    position = 50  # Starting position
    part1_count = 0
    part2_count = 0

    for line in input_text.strip().split('\n'):
        rotation = parse_rotation(line)
        if rotation:
            direction, distance = rotation

            # Calculate Part 2: count zero crossings during rotation
            part2_count += count_zero_crossings(position, direction, distance)

            # Update position
            position = rotate_dial(position, direction, distance)

            # Calculate Part 1: count when dial lands on 0
            if position == 0:
                part1_count += 1

    return (part1_count, part2_count)


def main():
    """Main entry point - reads from stdin"""
    try:
        # Read input from stdin
        input_text = sys.stdin.read()

        part1_result, part2_result = count_zeros(input_text)

        # Output JSON format matching other languages
        output = {"part1": part1_result, "part2": part2_result}
        print(json.dumps(output))

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        print('{"part1": null, "part2": null}')
        sys.exit(1)


if __name__ == '__main__':
    main()
