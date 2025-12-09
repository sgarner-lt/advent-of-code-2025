import gleam/int
import gleam/io
import gleam/list
import gleam/set
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
        Ok(start), Ok(end) -> {
          // Validate that start <= end
          case start <= end {
            True -> Ok(#(start, end))
            False ->
              Error(
                "Invalid range: start must be <= end: "
                <> int.to_string(start)
                <> "-"
                <> int.to_string(end),
              )
          }
        }
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

// Count unique IDs across all ranges using set
pub fn count_unique_ids(ranges: List(#(Int, Int))) -> Int {
  // Calculate total potential IDs across all ranges
  let total_ids =
    ranges
    |> list.fold(0, fn(acc, range) {
      let #(start, end) = range
      acc + { end - start + 1 }
    })

  // For small datasets (< 100k IDs total), use Set approach for simplicity
  case total_ids < 100_000 {
    True -> {
      ranges
      |> list.fold(set.new(), fn(unique_set, range) {
        let #(start, end) = range
        // Generate all IDs in the range and add to set
        list.range(start, end)
        |> list.fold(unique_set, fn(acc_set, id) { set.insert(acc_set, id) })
      })
      |> set.size
    }
    False -> {
      // For large datasets, merge overlapping intervals and count mathematically
      count_unique_ids_merged(ranges)
    }
  }
}

// Count unique IDs by merging overlapping ranges
fn count_unique_ids_merged(ranges: List(#(Int, Int))) -> Int {
  case ranges {
    [] -> 0
    _ -> {
      // Sort ranges by start position
      let sorted_ranges =
        ranges
        |> list.sort(fn(a, b) {
          let #(start_a, _) = a
          let #(start_b, _) = b
          int.compare(start_a, start_b)
        })

      // Merge overlapping intervals
      let merged = merge_ranges(sorted_ranges, [])

      // Count total unique IDs across merged ranges
      merged
      |> list.fold(0, fn(acc, range) {
        let #(start, end) = range
        acc + { end - start + 1 }
      })
    }
  }
}

// Merge overlapping ranges
fn merge_ranges(
  ranges: List(#(Int, Int)),
  merged: List(#(Int, Int)),
) -> List(#(Int, Int)) {
  case ranges, merged {
    [], _ -> list.reverse(merged)
    [range, ..rest], [] -> merge_ranges(rest, [range])
    [current, ..rest], [last, ..merged_rest] -> {
      let #(current_start, current_end) = current
      let #(last_start, last_end) = last

      // Check if current range overlaps or is adjacent to last merged range
      case current_start <= last_end + 1 {
        True -> {
          // Merge by extending the end if needed
          let new_end = int.max(last_end, current_end)
          merge_ranges(rest, [#(last_start, new_end), ..merged_rest])
        }
        False -> {
          // No overlap, add as new range
          merge_ranges(rest, [current, last, ..merged_rest])
        }
      }
    }
  }
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

// Solve the puzzle: count how many available IDs are fresh (Part 1)
// and count unique IDs across all ranges (Part 2)
pub fn solve(input: String) -> Result(#(Int, Int), String) {
  // Split input into two groups separated by blank line
  case string.split(input, "\n\n") {
    [ranges_section, ids_section] -> {
      let ranges_lines = string.split(ranges_section, "\n")
      let ids_lines = string.split(ids_section, "\n")

      case parse_ranges(ranges_lines), parse_ids(ids_lines) {
        Ok(ranges), Ok(ids) -> {
          // Part 1: Count how many available IDs are fresh
          let fresh_ids = list.filter(ids, fn(id) { is_fresh(id, ranges) })
          let part1 = list.length(fresh_ids)

          // Part 2: Count unique IDs across all ranges
          let part2 = count_unique_ids(ranges)

          Ok(#(part1, part2))
        }
        Error(err), _ -> Error(err)
        _, Error(err) -> Error(err)
      }
    }
    _ -> Error("Input must contain two groups separated by a blank line")
  }
}

// Build JSON output string
fn build_json(part1: Int, part2: Int) -> String {
  "{\"part1\": "
  <> int.to_string(part1)
  <> ", \"part2\": "
  <> int.to_string(part2)
  <> "}"
}
