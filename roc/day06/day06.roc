app [main!] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.17.0/lZFLstMUCUvd5bjnnpYromZJXkQUrdhbva4xdBInicE.tar.br",
}

import pf.Stdout
import pf.File
import pf.Path

main! = \{} ->
    input = read_input! "../../challenges/day06/input.txt"
    part1_result = part1 input
    part2_result = part2 input

    Stdout.line! "Part 1: $(Num.toStr part1_result)"
    Stdout.line! "Part 2: $(Num.toStr part2_result)"

read_input! : Str -> Str
read_input! = \path ->
    path_obj = Path.fromStr path
    File.readUtf8! path_obj

part1 : Str -> I32
part1 = \_input ->
    # TODO: Implement Part 1 solution
    0

part2 : Str -> I32
part2 = \_input ->
    # TODO: Implement Part 2 solution
    0
