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
    part1_result = part1 input

    Stdout.line! "{\"part1\": $(Num.to_str part1_result), \"part2\": null}"

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

process_rotations : Str -> I32
process_rotations = \input ->
    lines = Str.split_on input "\n"
        |> List.map Str.trim
        |> List.drop_if \line -> Str.is_empty line

    initial_state = { position: 50, count: 0 }

    final_state = List.walk lines initial_state \state, line ->
        when parse_instruction line is
            Ok instruction ->
                new_position = rotate state.position instruction
                new_count = if new_position == 0 then state.count + 1 else state.count
                { position: new_position, count: new_count }
            Err _ -> state

    final_state.count

part1 : Str -> I32
part1 = \input ->
    process_rotations input

# Inline tests for rotation logic
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
    # Test sample input produces correct count
    sample_input = "L68\nL30\nR48\nL5\nR60\nL55\nL1\nL99\nR14\nL82\n"
    result = process_rotations sample_input
    result == 3
