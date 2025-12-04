import gleam/io
import gleam/result
import simplifile

pub fn main() {
  let input = read_input("../../challenges/day10/input.txt")
  case input {
    Ok(content) -> {
      io.println("Part 1: " <> part1(content))
      io.println("Part 2: " <> part2(content))
    }
    Error(_) -> io.println("Failed to read input file")
  }
}

fn read_input(path: String) -> Result(String, simplifile.FileError) {
  simplifile.read(path)
}

fn part1(input: String) -> String {
  // TODO: Implement Part 1 solution
  "0"
}

fn part2(input: String) -> String {
  // TODO: Implement Part 2 solution
  "0"
}
