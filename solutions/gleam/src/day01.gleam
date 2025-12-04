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
  // Read input from stdin (using /dev/stdin as a file)
  let content = case simplifile.read("/dev/stdin") {
    Ok(text) -> text
    Error(_) -> ""
  }

  case solve(content) {
    Ok(#(part1, part2)) -> {
      let json = build_json(part1, part2)
      io.println(json)
    }
    Error(err) -> io.println("Error solving: " <> err)
  }
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

/// Counts how many times the dial crosses through position 0 during a rotation.
///
/// This function calculates zero crossings by breaking the rotation into:
/// 1. Complete circles (each crosses 0 exactly once)
/// 2. A remainder rotation (may or may not cross 0 depending on position and direction)
///
/// # Arguments
/// * `position` - Current dial position (0-99)
/// * `direction` - The rotation direction (Left or Right)
/// * `distance` - The rotation amount (non-negative integer)
///
/// # Returns
/// Integer count of zero crossings (>= 0)
pub fn count_zero_crossings(
  position: Int,
  direction: Direction,
  distance: Int,
) -> Int {
  case distance {
    0 -> 0
    _ -> {
      // Calculate complete circles and remainder
      let complete_circles = distance / 100
      let remainder = distance % 100

      // Each complete circle crosses zero exactly once
      let crossings_from_circles = complete_circles

      // Check if remainder rotation crosses zero
      let crossings_from_remainder = case direction {
        Right -> {
          // Distance to reach 0 going right (clockwise)
          let distance_to_zero = 100 - position
          case remainder >= distance_to_zero {
            True -> 1
            False -> 0
          }
        }
        Left -> {
          // Distance to reach 0 going left (counterclockwise)
          let distance_to_zero = position
          case position > 0 && remainder >= distance_to_zero {
            True -> 1
            False -> 0
          }
        }
      }

      crossings_from_circles + crossings_from_remainder
    }
  }
}

// Count how many times the dial lands on 0 after rotations (Part 1)
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

// Solve the puzzle - calculate both Part 1 and Part 2 in a single pass
fn solve(input: String) -> Result(#(Int, Int), String) {
  case parse_instructions(input) {
    Ok(instructions) -> {
      let start_position = 50
      let result = solve_both_parts(start_position, instructions)
      Ok(result)
    }
    Error(err) -> Error(err)
  }
}

// Calculate both Part 1 and Part 2 answers in a single pass through instructions
fn solve_both_parts(
  start_position: Int,
  instructions: List(#(Direction, Int)),
) -> #(Int, Int) {
  do_solve_both_parts(start_position, instructions, 0, 0)
}

// Helper function with accumulators for both parts
fn do_solve_both_parts(
  position: Int,
  instructions: List(#(Direction, Int)),
  part1_count: Int,
  part2_count: Int,
) -> #(Int, Int) {
  case instructions {
    [] -> #(part1_count, part2_count)
    [#(direction, distance), ..rest] -> {
      // Calculate Part 2: count zero crossings during rotation
      let crossings = count_zero_crossings(position, direction, distance)
      let new_part2_count = part2_count + crossings

      // Update position
      let new_position = rotate(position, direction, distance)

      // Calculate Part 1: count when dial lands on 0
      let new_part1_count = case new_position {
        0 -> part1_count + 1
        _ -> part1_count
      }

      do_solve_both_parts(new_position, rest, new_part1_count, new_part2_count)
    }
  }
}

// Build JSON output string
fn build_json(part1: Int, part2: Int) -> String {
  "{\"part1\": " <> int.to_string(part1) <> ", \"part2\": " <> int.to_string(part2) <> "}"
}
