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
    Ok(part1) -> {
      let json = build_json(part1)
      io.println(json)
    }
    Error(err) -> {
      io.println_error("Error solving: " <> err)
      io.println("{\"part1\": null, \"part2\": null}")
    }
  }
}

// Parse input into a 2D list of strings (rows and columns)
// Each line is split on whitespace
pub fn parse_input(input: String) -> List(List(String)) {
  input
  |> string.split("\n")
  |> list.map(fn(line) {
    line
    |> string.split(" ")
    |> list.filter(fn(s) { string.length(string.trim(s)) > 0 })
    |> list.map(string.trim)
  })
  |> list.filter(fn(row) { row != [] })
}

// Get element at index from list
fn list_at(lst: List(a), index: Int) -> Result(a, Nil) {
  case index < 0 {
    True -> Error(Nil)
    False -> {
      lst
      |> list.drop(index)
      |> list.first
    }
  }
}

// Identify vertical problems by transposing rows into columns
pub fn identify_problems(rows: List(List(String))) -> List(List(String)) {
  case rows {
    [] -> []
    _ -> {
      // Find the maximum number of columns
      let max_cols =
        rows
        |> list.map(list.length)
        |> list.fold(0, int.max)

      // Transpose rows into columns
      list.range(0, max_cols - 1)
      |> list.map(fn(col_idx) {
        rows
        |> list.filter_map(fn(row) { list_at(row, col_idx) })
      })
      |> list.filter(fn(col) { col != [] })
    }
  }
}

// Extract operation symbol from the last element of a problem column
pub fn extract_operation(problem: List(String)) -> Result(String, String) {
  case list.last(problem) {
    Ok(last) -> {
      case string.first(last) {
        Ok(first_char) -> {
          case first_char {
            "*" -> Ok("*")
            "+" -> Ok("+")
            _ -> Error("Invalid operation symbol: " <> first_char)
          }
        }
        Error(_) -> Error("Empty operation string")
      }
    }
    Error(_) -> Error("Empty problem column")
  }
}

// Calculate the result of a problem by applying the operation to all numbers
pub fn calculate_problem(
  problem: List(String),
  operation: String,
) -> Result(Int, String) {
  case list.length(problem) < 2 {
    True -> Error("Problem must have at least one number and an operation")
    False -> {
      // Parse all numbers (all elements except the last one)
      let numbers_result =
        problem
        |> list.reverse
        |> list.drop(1)
        |> list.reverse
        |> list.try_map(fn(s) {
          case int.parse(string.trim(s)) {
            Ok(num) -> Ok(num)
            Error(_) -> Error("Failed to parse number: " <> s)
          }
        })

      case numbers_result {
        Ok(numbers) -> {
          case numbers {
            [] -> Error("No numbers found in problem")
            [first, ..rest] -> {
              case operation {
                "*" -> {
                  let result =
                    rest
                    |> list.fold(first, fn(acc, num) { acc * num })
                  Ok(result)
                }
                "+" -> {
                  let result =
                    rest
                    |> list.fold(first, fn(acc, num) { acc + num })
                  Ok(result)
                }
                _ -> Error("Unsupported operation: " <> operation)
              }
            }
          }
        }
        Error(err) -> Error(err)
      }
    }
  }
}

// Solve the puzzle: parse input, identify problems, calculate each, and sum results
pub fn solve(input: String) -> Result(Int, String) {
  // Parse input into rows
  let rows = parse_input(input)

  case rows {
    [] -> Error("No data found in input")
    _ -> {
      // Identify vertical problems (transpose to columns)
      let problems = identify_problems(rows)

      case problems {
        [] -> Error("No problems found in input")
        _ -> {
          // Calculate each problem and sum results
          problems
          |> list.try_map(fn(problem) {
            case extract_operation(problem) {
              Ok(operation) -> calculate_problem(problem, operation)
              Error(err) -> Error(err)
            }
          })
          |> result.map(fn(results) {
            list.fold(results, 0, fn(acc, r) { acc + r })
          })
        }
      }
    }
  }
}

// Build JSON output string
fn build_json(part1: Int) -> String {
  "{\"part1\": " <> int.to_string(part1) <> ", \"part2\": null}"
}
