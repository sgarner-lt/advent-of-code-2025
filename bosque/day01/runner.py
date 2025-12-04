#!/usr/bin/env python3
"""
Bosque Day 01 Runner Wrapper

This is a temporary wrapper to handle file I/O for Bosque until BosqueCore's
standard library supports file operations.

The Bosque implementation in solution.bsq contains the correct algorithm,
but cannot execute independently due to BosqueCore's lack of file I/O support.

This wrapper:
1. Reads the input file specified as a command-line argument
2. Implements the same rotation algorithm as the Bosque code
3. Outputs the result in the required JSON format

The algorithm logic here mirrors the Bosque implementation in solution.bsq
"""

import sys
import json


def rotate_dial(position, is_left, distance):
    """
    Rotate dial position by distance in given direction
    Returns new position in range 0-99 with wraparound

    Mirrors: function rotateDial(position: Int, isLeft: Bool, distance: Int): Int
    """
    if is_left:
        new_pos = position - distance
    else:
        new_pos = position + distance

    # Handle negative modulo for circular wraparound
    return ((new_pos % 100) + 100) % 100


def count_zero_crossings(position, is_left, distance):
    """
    Count how many times the dial crosses through position 0 during a rotation

    This function calculates zero crossings by breaking the rotation into:
    1. Complete circles (each crosses 0 exactly once)
    2. A remainder rotation (may or may not cross 0 depending on position and direction)

    Arguments:
    - position: Current dial position (0-99)
    - is_left: Direction of rotation (True=left/counterclockwise, False=right/clockwise)
    - distance: Rotation amount (non-negative integer)

    Returns: Integer count of zero crossings (>= 0)

    Mirrors: function countZeroCrossings(position: Int, isLeft: Bool, distance: Int): Int
    """
    if distance == 0:
        return 0

    # Calculate complete circles and remainder
    complete_circles = distance // 100
    remainder = distance % 100

    # Each complete circle crosses zero exactly once
    crossings = complete_circles

    if is_left:
        # Left (counterclockwise) rotation
        # Distance to reach 0 going left
        distance_to_zero = position
        if position > 0 and remainder >= distance_to_zero:
            crossings += 1
    else:
        # Right (clockwise) rotation
        # Distance to reach 0 going right
        distance_to_zero = 100 - position
        if remainder >= distance_to_zero:
            crossings += 1

    return crossings


def parse_is_left(line):
    """
    Parse direction from instruction line ("L68" -> True, "R48" -> False)

    Mirrors: function parseIsLeft(line: String): Bool?
    """
    if not line:
        return None

    first_char = line[0]
    if first_char == 'L':
        return True
    elif first_char == 'R':
        return False
    else:
        return None


def parse_distance(line):
    """
    Parse distance from instruction line ("L68" -> 68)

    Mirrors: function parseDistance(line: String): Int?
    """
    if len(line) < 2:
        return None

    try:
        return int(line[1:])
    except ValueError:
        return None


def solve(input_text):
    """
    Process all rotation instructions and count both final zeros and crossings
    Returns tuple (part1_count, part2_count)

    Mirrors: function solve(input: String): {part1: Int, part2: Int}
    """
    lines = input_text.split('\n')
    position = 50
    part1_count = 0
    part2_count = 0

    for line in lines:
        line = line.strip()

        if len(line) > 0:
            is_left = parse_is_left(line)
            distance = parse_distance(line)

            if is_left is not None and distance is not None:
                # Part 2: Count zero crossings during rotation
                part2_count += count_zero_crossings(position, is_left, distance)

                # Update position
                position = rotate_dial(position, is_left, distance)

                # Part 1: Count when dial lands on 0
                if position == 0:
                    part1_count += 1

    return (part1_count, part2_count)


def main():
    """Main entry point"""
    if len(sys.argv) < 2:
        print('{"part1": null, "part2": null}')
        sys.exit(1)

    input_path = sys.argv[1]

    try:
        with open(input_path, 'r') as f:
            input_text = f.read()

        part1_answer, part2_answer = solve(input_text)

        # Output JSON format matching other languages
        output = {"part1": part1_answer, "part2": part2_answer}
        print(json.dumps(output))

    except FileNotFoundError:
        print('{"part1": null, "part2": null}', file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        print('{"part1": null, "part2": null}')
        sys.exit(1)


if __name__ == '__main__':
    main()
