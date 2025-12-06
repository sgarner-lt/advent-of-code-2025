import gleam/int
import gleam/io
import gleam/list
import gleam/order
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
    Ok(#(part1, part2)) -> {
      let json = build_json(part1, part2)
      io.println(json)
    }
    Error(err) -> io.println("Error solving: " <> err)
  }
}

// Solve the puzzle: returns (part1_sum, part2_sum) as tuple
// Part 1: sum of maximum 2-digit pairs from each line
// Part 2: sum of maximum 12-digit numbers from each line
pub fn solve(input: String) -> Result(#(Int, Int), String) {
  let lines =
    input
    |> string.split("\n")
    |> list.filter(fn(line) { string.length(string.trim(line)) > 0 })

  // Process each line to get (part1_value, part2_value) tuple
  case
    list.try_map(lines, fn(line) {
      // Get Part 1 value
      let part1_result = case extract_pairs(line) |> find_max {
        Ok(max) -> Ok(max)
        Error(_) -> Ok(0)
      }

      // Get Part 2 value
      let part2_result = case extract_max_k_digits(line, 12) {
        Ok(max) -> Ok(max)
        Error(_) -> Ok(0)
      }

      // Combine into tuple
      case part1_result, part2_result {
        Ok(p1), Ok(p2) -> Ok(#(p1, p2))
        _, _ -> Error("Failed to process line")
      }
    })
  {
    Ok(tuples) -> {
      // Sum part1 values
      let part1_sum =
        list.fold(tuples, 0, fn(acc, tuple) {
          let #(p1, _) = tuple
          acc + p1
        })

      // Sum part2 values
      let part2_sum =
        list.fold(tuples, 0, fn(acc, tuple) {
          let #(_, p2) = tuple
          acc + p2
        })

      Ok(#(part1_sum, part2_sum))
    }
    Error(err) -> Error(err)
  }
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

// Extracts the maximum k-digit number from a line using a greedy algorithm
//
// Algorithm: For each position i (0 to k-1) in the result:
// 1. Calculate search window: from current_pos to (line_length - remaining_digits)
// 2. Find the maximum digit in this search window
// 3. Append the maximum digit to the result
// 4. Update current_pos to immediately after the selected digit
//
// This greedy approach guarantees the lexicographically largest k-digit number,
// which equals the maximum numeric value for fixed-length numbers.
pub fn extract_max_k_digits(line: String, k: Int) -> Result(Int, String) {
  let chars = string.to_graphemes(line)
  let length = list.length(chars)

  // Validate input: need at least k digits
  case length < k {
    True -> Error("Line has fewer than k digits")
    False -> {
      // Validate all characters are digits
      let all_digits =
        list.all(chars, fn(c) {
          case int.parse(c) {
            Ok(_) -> True
            Error(_) -> False
          }
        })

      case all_digits {
        False -> Error("Line contains non-digit characters")
        True -> {
          // Extract k digits using greedy algorithm
          do_extract_max_k_digits(chars, k, 0, "", length)
        }
      }
    }
  }
}

// Recursive helper for extract_max_k_digits
// Builds the result string one digit at a time
fn do_extract_max_k_digits(
  chars: List(String),
  k: Int,
  current_pos: Int,
  acc: String,
  total_length: Int,
) -> Result(Int, String) {
  let acc_length = string.length(acc)

  // Base case: we've extracted k digits
  case acc_length == k {
    True -> int.parse(acc) |> result.map_error(fn(_) { "Failed to parse result" })
    False -> {
      let remaining_digits = k - acc_length
      // Calculate search window: must leave enough digits to complete the k-digit number
      let search_end = total_length - remaining_digits + 1

      // Find the maximum digit in the search window [current_pos, search_end)
      case find_max_in_window(chars, current_pos, search_end) {
        Ok(#(max_digit, max_pos)) -> {
          // Append the maximum digit to the result
          let new_acc = acc <> max_digit
          // Move current position to immediately after the selected digit
          let new_pos = max_pos + 1
          do_extract_max_k_digits(chars, k, new_pos, new_acc, total_length)
        }
        Error(err) -> Error(err)
      }
    }
  }
}

// Find the maximum digit in a search window [start, end)
// Returns (max_digit, max_position)
fn find_max_in_window(
  chars: List(String),
  start: Int,
  end: Int,
) -> Result(#(String, Int), String) {
  // Get the slice of characters in the search window
  let window =
    chars
    |> list.index_map(fn(c, i) { #(c, i) })
    |> list.filter(fn(tuple) {
      let #(_, i) = tuple
      i >= start && i < end
    })

  case window {
    [] -> Error("Empty search window")
    [first, ..rest] -> {
      let #(first_char, first_pos) = first
      // Find the maximum digit and its position
      let #(max_char, max_pos) =
        list.fold(rest, #(first_char, first_pos), fn(acc, tuple) {
          let #(acc_char, acc_pos) = acc
          let #(curr_char, curr_pos) = tuple
          // Compare strings using string.compare
          case string.compare(curr_char, acc_char) {
            order.Gt -> #(curr_char, curr_pos)
            _ -> #(acc_char, acc_pos)
          }
        })
      Ok(#(max_char, max_pos))
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

// Build JSON output string with both part1 and part2
fn build_json(part1: Int, part2: Int) -> String {
  "{\"part1\": "
  <> int.to_string(part1)
  <> ", \"part2\": "
  <> int.to_string(part2)
  <> "}"
}
