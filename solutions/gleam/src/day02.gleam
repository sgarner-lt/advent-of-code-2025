import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import simplifile

/// Main entry point for Day 2
pub fn main() {
  // Read input from stdin (using /dev/stdin as a file)
  let content = case simplifile.read("/dev/stdin") {
    Ok(text) -> text
    Error(_) -> ""
  }

  case solve_both_parts(content) {
    Ok(#(part1, part2)) -> {
      let json = build_json(part1, Some(part2))
      io.println(json)
    }
    Error(err) -> io.println("Error solving: " <> err)
  }
}

/// Checks if a product ID string is invalid (made only of some sequence repeated twice).
/// Returns True if invalid, False if valid.
///
/// The number must be splittable into two equal halves that are identical.
/// For example: 55 (5 repeated), 6464 (64 repeated), 123123 (123 repeated).
///
/// Algorithm:
/// - Check if the length is even (must be for exact split)
/// - Split the string in half
/// - Compare the two halves - if equal, it's invalid
///
/// # Examples
/// ```
/// is_invalid_id("11") == True      // "1" repeated
/// is_invalid_id("1212") == True    // "12" repeated
/// is_invalid_id("123456") == False // not a repeated pattern
/// is_invalid_id("123412") == False // not split in half
/// ```
pub fn is_invalid_id(number_str: String) -> Bool {
  let len = string.length(number_str)

  // Must have even length to split in half
  case len % 2 {
    0 -> {
      let half = len / 2
      let first_half = string.slice(number_str, 0, half)
      let second_half = string.slice(number_str, half, half)

      first_half == second_half
    }
    _ -> False
  }
}

/// Checks if a product ID string is invalid (made only of some sequence repeated 2+ times).
/// Returns True if invalid, False if valid.
///
/// The number can be split into any equal-length pattern repeated at least twice.
/// For example: 111 (1 repeated 3 times), 565656 (56 repeated 3 times), 2121212121 (21 repeated 5 times).
///
/// Algorithm:
/// - For each possible pattern length from 1 to length/2
/// - Check if length is evenly divisible by pattern length
/// - Extract the first N characters as the pattern
/// - Verify entire string equals pattern repeated length/N times
/// - Return True on first match (short-circuit optimization)
///
/// # Examples
/// ```
/// is_invalid_id_part2("111") == True        // "1" repeated 3 times
/// is_invalid_id_part2("565656") == True     // "56" repeated 3 times
/// is_invalid_id_part2("123456") == False    // not a repeated pattern
/// is_invalid_id_part2("11") == True         // "1" repeated 2 times (still invalid)
/// ```
pub fn is_invalid_id_part2(number_str: String) -> Bool {
  let len = string.length(number_str)
  check_pattern_length(number_str, len, 1)
}

/// Helper function to check each pattern length using tail recursion
fn check_pattern_length(number_str: String, len: Int, pattern_length: Int) -> Bool {
  // Base case: if we've checked all pattern lengths up to len/2, return False
  case pattern_length > len / 2 {
    True -> False
    False -> {
      // Only check if length is evenly divisible by pattern length
      case len % pattern_length == 0 {
        True -> {
          // Extract the pattern (first N characters)
          let pattern = string.slice(number_str, 0, pattern_length)

          // Build the expected string by repeating the pattern
          let repetitions = len / pattern_length
          let expected = string.repeat(pattern, repetitions)

          // If the expected matches the original, it's invalid
          case expected == number_str {
            True -> True
            False -> check_pattern_length(number_str, len, pattern_length + 1)
          }
        }
        False -> check_pattern_length(number_str, len, pattern_length + 1)
      }
    }
  }
}

/// Parses comma-separated ranges from input string.
/// Returns a Result with a List of (start, end) tuples representing inclusive ranges.
///
/// # Examples
/// ```
/// parse_ranges("11-22,95-115") == Ok([(11, 22), (95, 115)])
/// ```
pub fn parse_ranges(input: String) -> Result(List(#(Int, Int)), String) {
  let trimmed = string.trim(input)

  case string.length(trimmed) {
    0 -> Error("Empty input")
    _ -> {
      trimmed
      |> string.split(",")
      |> list.try_map(parse_single_range)
    }
  }
}

/// Parses a single range string like "11-22" into a tuple (11, 22)
fn parse_single_range(range_str: String) -> Result(#(Int, Int), String) {
  let trimmed = string.trim(range_str)

  case string.length(trimmed) {
    0 -> Error("Empty range")
    _ -> {
      let parts = string.split(trimmed, "-")

      case parts {
        [start_str, end_str] -> {
          case int.parse(string.trim(start_str)), int.parse(string.trim(end_str)) {
            Ok(start), Ok(end) -> Ok(#(start, end))
            Error(_), _ -> Error("Invalid start number: " <> start_str)
            _, Error(_) -> Error("Invalid end number: " <> end_str)
          }
        }
        _ -> Error("Invalid range format: " <> range_str)
      }
    }
  }
}

/// Processes a range of numbers and returns the sum of invalid IDs found.
/// An ID is invalid if it's made only of some sequence repeated twice.
///
/// # Arguments
/// * `start` - Starting number (inclusive)
/// * `end` - Ending number (inclusive)
///
/// # Returns
/// Sum of all invalid product IDs found in the range
pub fn process_range(start: Int, end: Int) -> Int {
  do_process_range(start, end, 0)
}

/// Helper function to process range with tail recursion
fn do_process_range(current: Int, end: Int, accumulator: Int) -> Int {
  case current > end {
    True -> accumulator
    False -> {
      let num_str = int.to_string(current)
      let new_accumulator = case is_invalid_id(num_str) {
        True -> accumulator + current
        False -> accumulator
      }
      do_process_range(current + 1, end, new_accumulator)
    }
  }
}

/// Processes a range of numbers and returns the sum of invalid IDs found (Part 2).
/// An ID is invalid if it's made only of some sequence repeated 2 or more times.
///
/// # Arguments
/// * `start` - Starting number (inclusive)
/// * `end` - Ending number (inclusive)
///
/// # Returns
/// Sum of all invalid product IDs found in the range
pub fn process_range_part2(start: Int, end: Int) -> Int {
  do_process_range_part2(start, end, 0)
}

/// Helper function to process range for Part 2 with tail recursion
fn do_process_range_part2(current: Int, end: Int, accumulator: Int) -> Int {
  case current > end {
    True -> accumulator
    False -> {
      let num_str = int.to_string(current)
      let new_accumulator = case is_invalid_id_part2(num_str) {
        True -> accumulator + current
        False -> accumulator
      }
      do_process_range_part2(current + 1, end, new_accumulator)
    }
  }
}

/// Main solution function that processes all ranges and computes the sum of invalid IDs (Part 1 only).
///
/// # Arguments
/// * `input` - Input string containing comma-separated ranges
///
/// # Returns
/// Result with the sum of all invalid IDs, or an error message
pub fn solve(input: String) -> Result(Int, String) {
  case parse_ranges(input) {
    Ok(ranges) -> {
      let total_sum = list.fold(ranges, 0, fn(acc, range) {
        let #(start, end) = range
        acc + process_range(start, end)
      })
      Ok(total_sum)
    }
    Error(err) -> Error(err)
  }
}

/// Solution function that computes both Part 1 and Part 2 sums.
///
/// # Arguments
/// * `input` - Input string containing comma-separated ranges
///
/// # Returns
/// Result with tuple (part1_sum, part2_sum), or an error message
pub fn solve_both_parts(input: String) -> Result(#(Int, Int), String) {
  case parse_ranges(input) {
    Ok(ranges) -> {
      let part1_sum = list.fold(ranges, 0, fn(acc, range) {
        let #(start, end) = range
        acc + process_range(start, end)
      })

      let part2_sum = list.fold(ranges, 0, fn(acc, range) {
        let #(start, end) = range
        acc + process_range_part2(start, end)
      })

      Ok(#(part1_sum, part2_sum))
    }
    Error(err) -> Error(err)
  }
}

/// Build JSON output string
fn build_json(part1: Int, part2: Option(Int)) -> String {
  let part2_str = case part2 {
    None -> "null"
    Some(val) -> int.to_string(val)
  }

  "{\"part1\": " <> int.to_string(part1) <> ", \"part2\": " <> part2_str <> "}"
}
