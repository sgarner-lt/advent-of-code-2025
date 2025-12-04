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


def solve_part1(input_text):
    """
    Process all rotation instructions and count zeros

    Mirrors: function solvePart1(input: String): Int
    """
    lines = input_text.split('\n')
    position = 50
    zero_count = 0

    for line in lines:
        line = line.strip()

        if len(line) > 0:
            is_left = parse_is_left(line)
            distance = parse_distance(line)

            if is_left is not None and distance is not None:
                position = rotate_dial(position, is_left, distance)

                if position == 0:
                    zero_count += 1

    return zero_count


def main():
    """Main entry point"""
    if len(sys.argv) < 2:
        print('{"part1": null, "part2": null}')
        sys.exit(1)

    input_path = sys.argv[1]

    try:
        with open(input_path, 'r') as f:
            input_text = f.read()

        answer = solve_part1(input_text)

        # Output JSON format matching other languages
        output = {"part1": answer, "part2": None}
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
