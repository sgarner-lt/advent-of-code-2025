import gleam/int
import gleam/io
import gleam/list
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
    Ok(count) -> {
      let json = build_json(count)
      io.println(json)
    }
    Error(err) -> {
      io.println_error("Error solving: " <> err)
      io.println("{\"part1\": null, \"part2\": null}")
    }
  }
}

// Parse a range string like "3-5" into a tuple of (start, end)
pub fn parse_range(line: String) -> Result(#(Int, Int), String) {
  let trimmed = string.trim(line)

  case string.split(trimmed, "-") {
    [start_str, end_str] -> {
      case int.parse(start_str), int.parse(end_str) {
        Ok(start), Ok(end) -> Ok(#(start, end))
        Error(_), _ -> Error("Failed to parse start of range: " <> start_str)
        _, Error(_) -> Error("Failed to parse end of range: " <> end_str)
      }
    }
    _ -> Error("Invalid range format: " <> trimmed)
  }
}

// Check if an ID is fresh (falls within any of the ranges)
pub fn is_fresh(id: Int, ranges: List(#(Int, Int))) -> Bool {
  list.any(ranges, fn(range) {
    let #(start, end) = range
    id >= start && id <= end
  })
}

// Parse all ranges from the first group
fn parse_ranges(lines: List(String)) -> Result(List(#(Int, Int)), String) {
  lines
  |> list.filter(fn(line) { string.length(string.trim(line)) > 0 })
  |> list.try_map(parse_range)
}

// Parse all available IDs from the second group
fn parse_ids(lines: List(String)) -> Result(List(Int), String) {
  lines
  |> list.filter(fn(line) { string.length(string.trim(line)) > 0 })
  |> list.try_map(fn(line) {
    case int.parse(string.trim(line)) {
      Ok(id) -> Ok(id)
      Error(_) -> Error("Failed to parse ID: " <> line)
    }
  })
}

// Solve the puzzle: count how many available IDs are fresh
pub fn solve(input: String) -> Result(Int, String) {
  // Split input into two groups separated by blank line
  case string.split(input, "\n\n") {
    [ranges_section, ids_section] -> {
      let ranges_lines = string.split(ranges_section, "\n")
      let ids_lines = string.split(ids_section, "\n")

      case parse_ranges(ranges_lines), parse_ids(ids_lines) {
        Ok(ranges), Ok(ids) -> {
          // Count how many IDs are fresh
          let fresh_ids = list.filter(ids, fn(id) { is_fresh(id, ranges) })
          Ok(list.length(fresh_ids))
        }
        Error(err), _ -> Error(err)
        _, Error(err) -> Error(err)
      }
    }
    _ -> Error("Input must contain two groups separated by a blank line")
  }
}

// Build JSON output string
fn build_json(part1: Int) -> String {
  "{\"part1\": " <> int.to_string(part1) <> ", \"part2\": null}"
}
