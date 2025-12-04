app [main!] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.20.0/X73hGh05nNTkDHU06FHC0YfFaQB1pimX7gncRcao5mU.tar.br",
}

import pf.Stdout
import pf.File
import pf.Arg

main! = \args ->
    input_path = when List.get args 1 is
        Ok arg -> Arg.display arg
        Err _ -> "../../challenges/day01/input.txt"

    input = read_input! input_path
    result = process_rotations input

    Stdout.line! "{\"part1\": $(Num.to_str result.part1), \"part2\": $(Num.to_str result.part2)}"

read_input! : Str => Str
read_input! = \path ->
    when File.read_utf8! path is
        Ok content -> content
        Err _ -> crash "Failed to read file"

Direction : [Left, Right]

Instruction : { direction : Direction, distance : I32 }

parse_instruction : Str -> Result Instruction [InvalidFormat]
parse_instruction = \line ->
    when Str.to_utf8 line is
        [] -> Err InvalidFormat
        [first, .. as rest] ->
            direction = when first is
                76 -> Ok Left  # 'L' = 76
                82 -> Ok Right # 'R' = 82
                _ -> Err InvalidFormat

            when direction is
                Ok dir ->
                    number_str = Str.from_utf8 rest |> Result.with_default ""
                    when Str.to_i32 number_str is
                        Ok dist -> Ok { direction: dir, distance: dist }
                        Err _ -> Err InvalidFormat
                Err _ -> Err InvalidFormat

rotate : I32, Instruction -> I32
rotate = \position, instruction ->
    when instruction.direction is
        Left ->
            newPos = position - instruction.distance
            ((newPos % 100) + 100) % 100
        Right ->
            (position + instruction.distance) % 100

## Counts how many times the dial crosses through position 0 during a rotation.
##
## This function calculates zero crossings by breaking the rotation into:
## 1. Complete circles (each crosses 0 exactly once)
## 2. A remainder rotation (may or may not cross 0 depending on position and direction)
countZeroCrossings : I32, Instruction -> I32
countZeroCrossings = \position, instruction ->
    amount = instruction.distance

    if amount == 0 then
        0
    else
        # Calculate complete circles and remainder
        complete_circles = amount // 100
        remainder = amount % 100

        # Each complete circle crosses zero exactly once
        crossings_from_circles = complete_circles

        # Check if remainder rotation crosses zero
        crossings_from_remainder = when instruction.direction is
            Right ->
                # Distance to reach 0 going right (clockwise)
                distance_to_zero = 100 - position
                if remainder >= distance_to_zero then
                    1
                else
                    0
            Left ->
                # Distance to reach 0 going left (counterclockwise)
                distance_to_zero = position
                if position > 0 && remainder >= distance_to_zero then
                    1
                else
                    0

        crossings_from_circles + crossings_from_remainder

process_rotations : Str -> { part1 : I32, part2 : I32 }
process_rotations = \input ->
    lines = Str.split_on input "\n"
        |> List.map Str.trim
        |> List.drop_if \line -> Str.is_empty line

    initial_state = { position: 50, part1: 0, part2: 0 }

    final_state = List.walk lines initial_state \state, line ->
        when parse_instruction line is
            Ok instruction ->
                # Calculate Part 2: count zero crossings during rotation
                crossings = countZeroCrossings state.position instruction

                # Update position
                new_position = rotate state.position instruction

                # Calculate Part 1: count when dial lands on 0
                new_part1 = if new_position == 0 then state.part1 + 1 else state.part1

                { position: new_position, part1: new_part1, part2: state.part2 + crossings }
            Err _ -> state

    { part1: final_state.part1, part2: final_state.part2 }

# Inline tests for rotation logic (Part 1)
expect
    # Test right rotation without wraparound
    instruction = { direction: Right, distance: 10 }
    result = rotate 50 instruction
    result == 60

expect
    # Test left rotation without wraparound
    instruction = { direction: Left, distance: 10 }
    result = rotate 50 instruction
    result == 40

expect
    # Test right rotation with wraparound
    instruction = { direction: Right, distance: 10 }
    result = rotate 95 instruction
    result == 5

expect
    # Test left rotation with wraparound
    instruction = { direction: Left, distance: 10 }
    result = rotate 5 instruction
    result == 95

expect
    # Test parsing left instruction
    result = parse_instruction "L68"
    result == Ok { direction: Left, distance: 68 }

expect
    # Test parsing right instruction
    result = parse_instruction "R48"
    result == Ok { direction: Right, distance: 48 }

expect
    # Test rotation to position 0
    instruction = { direction: Right, distance: 48 }
    result = rotate 52 instruction
    result == 0

expect
    # Test sample input produces correct count for Part 1
    sample_input = "L68\nL30\nR48\nL5\nR60\nL55\nL1\nL99\nR14\nL82\n"
    result = process_rotations sample_input
    result.part1 == 3

# Inline tests for countZeroCrossings function (Part 2)
expect
    # Test no crossing: R10 from position 50
    instruction = { direction: Right, distance: 10 }
    crossings = countZeroCrossings 50 instruction
    crossings == 0

expect
    # Test simple right crossing: R10 from position 95
    instruction = { direction: Right, distance: 10 }
    crossings = countZeroCrossings 95 instruction
    crossings == 1

expect
    # Test simple left crossing: L10 from position 5
    instruction = { direction: Left, distance: 10 }
    crossings = countZeroCrossings 5 instruction
    crossings == 1

expect
    # Test large rotation: R1000 from position 50 crosses 10 times
    instruction = { direction: Right, distance: 1000 }
    crossings = countZeroCrossings 50 instruction
    crossings == 10

expect
    # Test exact multiple: R100 from position 0
    instruction = { direction: Right, distance: 100 }
    crossings = countZeroCrossings 0 instruction
    crossings == 1

expect
    # Test starting at zero (right): R10 from position 0
    instruction = { direction: Right, distance: 10 }
    crossings = countZeroCrossings 0 instruction
    crossings == 0

expect
    # Test starting at zero (left): L10 from position 0
    instruction = { direction: Left, distance: 10 }
    crossings = countZeroCrossings 0 instruction
    crossings == 0

expect
    # Test ending at zero: L10 from position 10
    instruction = { direction: Left, distance: 10 }
    crossings = countZeroCrossings 10 instruction
    crossings == 1

expect
    # Test sample input produces correct Part 2 answer
    sample_input = "L68\nL30\nR48\nL5\nR60\nL55\nL1\nL99\nR14\nL82\n"
    result = process_rotations sample_input
    result.part2 == 6

expect
    # Test sample input produces both correct answers
    sample_input = "L68\nL30\nR48\nL5\nR60\nL55\nL1\nL99\nR14\nL82\n"
    result = process_rotations sample_input
    result.part1 == 3 && result.part2 == 6
