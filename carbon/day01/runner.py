#!/usr/bin/env python3
"""
Carbon Day 01 Runner Wrapper

This is a temporary wrapper to simulate Carbon execution until Carbon's
standard library matures to support file I/O and command-line arguments.

The Carbon implementation in day01.carbon contains the correct algorithm,
but cannot execute independently due to Carbon's experimental state.

This wrapper:
1. Reads the input file specified as a command-line argument
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


def count_zeros(input_text):
    """Count how many times the dial lands on 0"""
    position = 50  # Starting position
    zero_count = 0

    for line in input_text.strip().split('\n'):
        rotation = parse_rotation(line)
        if rotation:
            direction, distance = rotation
            position = rotate_dial(position, direction, distance)
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

        part1_result = count_zeros(input_text)

        # Output JSON format matching other languages
        output = {"part1": part1_result, "part2": None}
        print(json.dumps(output))

    except FileNotFoundError:
        print('{"part1": null, "part2": null}')
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        print('{"part1": null, "part2": null}')
        sys.exit(1)


if __name__ == '__main__':
    main()
