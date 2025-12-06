import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

// Main entry point
pub fn main() {
  // Read input from stdin (using /dev/stdin as a file)
  let content = case simplifile.read("/dev/stdin") {
    Ok(text) -> text
    Error(_) -> ""
  }

  case solve(content) {
    Ok(answer) -> {
      let json = build_json(answer)
      io.println(json)
    }
    Error(err) -> io.println("Error solving: " <> err)
  }
}

// Solve the puzzle: sum of maximum pairs from each line
pub fn solve(input: String) -> Result(Int, String) {
  input
  |> string.split("\n")
  |> list.filter(fn(line) { string.length(string.trim(line)) > 0 })
  |> list.try_map(fn(line) {
    let pairs = extract_pairs(line)
    find_max(pairs)
  })
  |> result.map(fn(maxes) { list.fold(maxes, 0, fn(acc, x) { acc + x }) })
}

// Extract all possible 2-digit pairs from a line by selecting any two positions
// For each pair of positions (i, j) where i < j, creates a 2-digit number
pub fn extract_pairs(line: String) -> List(Int) {
  let chars = string.to_graphemes(line)
  do_extract_pairs(chars, 0, [])
}

// Recursive helper to extract all pairs
fn do_extract_pairs(chars: List(String), i: Int, acc: List(Int)) -> List(Int) {
  case chars {
    [] -> acc
    [first, ..rest] -> {
      // Extract pairs starting at position i with all positions after it
      let new_pairs = extract_pairs_from_position(first, rest, i + 1, [])
      do_extract_pairs(rest, i + 1, list.append(acc, new_pairs))
    }
  }
}

// Extract all pairs starting from a given first digit with remaining digits
fn extract_pairs_from_position(
  first_digit: String,
  remaining: List(String),
  j: Int,
  acc: List(Int),
) -> List(Int) {
  case remaining {
    [] -> acc
    [second_digit, ..rest] -> {
      let pair_str = first_digit <> second_digit
      case int.parse(pair_str) {
        Ok(pair_value) -> {
          let new_acc = [pair_value, ..acc]
          extract_pairs_from_position(first_digit, rest, j + 1, new_acc)
        }
        Error(_) -> extract_pairs_from_position(first_digit, rest, j + 1, acc)
      }
    }
  }
}

// Find the maximum value from a list of integers
pub fn find_max(pairs: List(Int)) -> Result(Int, String) {
  case pairs {
    [] -> Error("Empty list")
    [first, ..rest] -> Ok(do_find_max(rest, first))
  }
}

// Recursive helper to find maximum
fn do_find_max(pairs: List(Int), current_max: Int) -> Int {
  case pairs {
    [] -> current_max
    [head, ..tail] -> {
      let new_max = case head > current_max {
        True -> head
        False -> current_max
      }
      do_find_max(tail, new_max)
    }
  }
}

// Build JSON output string
fn build_json(part1: Int) -> String {
  "{\"part1\": " <> int.to_string(part1) <> ", \"part2\": null}"
}
