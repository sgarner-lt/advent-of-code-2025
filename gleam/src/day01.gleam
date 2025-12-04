import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

// Direction type for rotation
pub type Direction {
  Left
  Right
}

// Main entry point
pub fn main() {
  // Get input file path from command line or use default
  let input_path = "../challenges/day01/input.txt"

  case read_input(input_path) {
    Ok(content) -> {
      case solve(content) {
        Ok(answer) -> {
          let json = build_json(answer)
          io.println(json)
        }
        Error(err) -> io.println("Error solving: " <> err)
      }
    }
    Error(_) -> io.println("Failed to read input file")
  }
}

// Read input file
fn read_input(path: String) -> Result(String, simplifile.FileError) {
  simplifile.read(path)
}

// Parse a single instruction line like "L68" or "R48"
pub fn parse_instruction(line: String) -> Result(#(Direction, Int), String) {
  let trimmed = string.trim(line)

  case string.length(trimmed) {
    0 -> Error("Empty instruction")
    _ -> {
      // Get first character for direction
      let direction_char = string.slice(trimmed, 0, 1)
      let distance_str = string.slice(trimmed, 1, string.length(trimmed) - 1)

      case direction_char, int.parse(distance_str) {
        "L", Ok(distance) -> Ok(#(Left, distance))
        "R", Ok(distance) -> Ok(#(Right, distance))
        _, Error(_) -> Error("Invalid distance: " <> distance_str)
        _, _ -> Error("Invalid direction: " <> direction_char)
      }
    }
  }
}

// Rotate dial from current position by distance in given direction
// Returns new position after rotation with wraparound (0-99)
pub fn rotate(position: Int, direction: Direction, distance: Int) -> Int {
  case direction {
    Left -> {
      // For left rotation, subtract distance and handle negative wraparound
      let new_pos = position - distance
      modulo(new_pos, 100)
    }
    Right -> {
      // For right rotation, add distance
      let new_pos = position + distance
      modulo(new_pos, 100)
    }
  }
}

// Proper modulo function that handles negative numbers correctly
fn modulo(value: Int, divisor: Int) -> Int {
  let remainder = value % divisor
  case remainder < 0 {
    True -> remainder + divisor
    False -> remainder
  }
}

// Count how many times the dial lands on 0 after rotations
pub fn count_zeros(
  start_position: Int,
  instructions: List(#(Direction, Int)),
) -> Int {
  do_count_zeros(start_position, instructions, 0)
}

// Helper function to count zeros with accumulator
fn do_count_zeros(
  position: Int,
  instructions: List(#(Direction, Int)),
  count: Int,
) -> Int {
  case instructions {
    [] -> count
    [#(direction, distance), ..rest] -> {
      let new_position = rotate(position, direction, distance)
      let new_count = case new_position {
        0 -> count + 1
        _ -> count
      }
      do_count_zeros(new_position, rest, new_count)
    }
  }
}

// Parse all instructions from input
fn parse_instructions(input: String) -> Result(List(#(Direction, Int)), String) {
  input
  |> string.split("\n")
  |> list.filter(fn(line) { string.length(string.trim(line)) > 0 })
  |> list.try_map(parse_instruction)
}

// Solve the puzzle
fn solve(input: String) -> Result(Int, String) {
  case parse_instructions(input) {
    Ok(instructions) -> {
      let start_position = 50
      let answer = count_zeros(start_position, instructions)
      Ok(answer)
    }
    Error(err) -> Error(err)
  }
}

// Build JSON output string
fn build_json(part1: Int) -> String {
  "{\"part1\": " <> int.to_string(part1) <> ", \"part2\": null}"
}
