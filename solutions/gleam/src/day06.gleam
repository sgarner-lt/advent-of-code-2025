import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  // Read input from stdin (using /dev/stdin as a file)
  let content = case simplifile.read("/dev/stdin") {
    Ok(text) -> text
    Error(_) -> ""
  }

  case solve(content) {
    Ok(#(part1, part2)) -> {
      // Output JSON format for testing framework
      io.println(
        "{\"part1\": "
        <> int.to_string(part1)
        <> ", \"part2\": "
        <> int.to_string(part2)
        <> "}",
      )
    }
    Error(err) -> {
      io.println_error("Error solving puzzle: " <> err)
      io.println("{\"part1\": null, \"part2\": null}")
    }
  }
}

/// Parse input into a 2D list of strings (rows and columns)
/// Each line is split on whitespace and trimmed
/// NOTE: This function is used for Part 1 only. Part 2 uses parse_input_raw()
fn parse_input(input: String) -> List(List(String)) {
  input
  |> string.split("\n")
  |> list.map(fn(line) {
    line
    |> string.split(" ")
    |> list.map(string.trim)
    |> list.filter(fn(s) { string.length(s) > 0 })
  })
  |> list.filter(fn(row) { row != [] })
}

/// Parse input preserving whitespace for proper column alignment
/// Returns raw lines without modification
fn parse_input_raw(input: String) -> List(String) {
  input
  |> string.split("\n")
  |> list.filter(fn(line) { line != "" })
}

/// Find column boundaries where all rows have whitespace
/// Returns the start positions of each column
fn find_column_boundaries(rows: List(String)) -> List(Int) {
  case rows {
    [] -> []
    _ -> {
      let max_len =
        rows
        |> list.map(string.length)
        |> list.fold(0, int.max)

      let #(boundaries, _) =
        list.range(0, max_len - 1)
        |> list.fold(#([0], False), fn(acc, pos) {
          let #(bounds, in_whitespace) = acc

          // Check if all rows have whitespace at this position
          let all_whitespace =
            rows
            |> list.all(fn(row) {
              case pos >= string.length(row) {
                True -> True
                False -> {
                  case string.slice(row, pos, 1) {
                    " " -> True
                    _ -> False
                  }
                }
              }
            })

          case all_whitespace, in_whitespace {
            True, False -> #(bounds, True)
            False, True -> #(list.append(bounds, [pos]), False)
            _, _ -> #(bounds, in_whitespace)
          }
        })

      boundaries
    }
  }
}

/// Extract fixed-width columns from rows based on boundaries
/// Returns list of columns, where each column is a list of strings (one per row)
fn extract_columns(
  rows: List(String),
  boundaries: List(Int),
) -> List(List(String)) {
  let max_len =
    rows
    |> list.map(string.length)
    |> list.fold(0, int.max)

  boundaries
  |> list.index_map(fn(start, i) {
    let end = case list.drop(boundaries, i + 1) |> list.first {
      Ok(next_start) -> next_start
      Error(_) -> max_len
    }

    rows
    |> list.map(fn(row) {
      case start < string.length(row) {
        True -> {
          let actual_end = case end <= string.length(row) {
            True -> end
            False -> string.length(row)
          }
          string.slice(row, start, actual_end - start)
        }
        False -> ""
      }
    })
  })
}

/// Identify vertical problems by transposing rows into columns
/// Returns a list of problems where each problem is a list of values from that column
fn identify_problems(rows: List(List(String))) -> List(List(String)) {
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
        |> list.filter_map(fn(row) {
          // Use list indexing with drop/first pattern
          row
          |> list.drop(col_idx)
          |> list.first
        })
      })
      |> list.filter(fn(column) { column != [] })
    }
  }
}

/// Extract operation symbol from the last element of a problem column
/// Returns the first character which should be * or +
fn extract_operation(problem: List(String)) -> Result(String, String) {
  case list.last(problem) {
    Ok(last) -> {
      case string.first(last) {
        Ok(op) if op == "*" || op == "+" -> Ok(op)
        Ok(ch) -> Error("Invalid operation symbol: " <> ch)
        Error(_) -> Error("Empty operation string")
      }
    }
    Error(_) -> Error("Empty problem column")
  }
}

/// Calculate the result of a problem by applying the operation to all numbers
/// Numbers are all elements except the last one (which contains the operation)
fn calculate_problem(
  problem: List(String),
  operation: String,
) -> Result(Int, String) {
  case list.length(problem) < 2 {
    True -> Error("Problem must have at least one number and an operation")
    False -> {
      // Parse all numbers (all elements except the last one)
      let numbers_result =
        problem
        |> list.take(list.length(problem) - 1)
        |> list.try_map(fn(s) {
          case int.parse(string.trim(s)) {
            Ok(n) -> Ok(n)
            Error(_) -> Error("Failed to parse number: " <> s)
          }
        })

      case numbers_result {
        Error(err) -> Error(err)
        Ok(numbers) -> {
          // Check if numbers list is empty
          case numbers {
            [] -> Error("No numbers found in problem")
            _ -> {
              case operation {
                "*" -> {
                  numbers
                  |> list.fold(1, fn(acc, n) { acc * n })
                  |> Ok
                }
                "+" -> {
                  numbers
                  |> list.fold(0, fn(acc, n) { acc + n })
                  |> Ok
                }
                _ -> Error("Unsupported operation: " <> operation)
              }
            }
          }
        }
      }
    }
  }
}

/// Solve Part 1: parse input, identify problems, calculate each, and sum results
fn solve_part1(input: String) -> Result(Int, String) {
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
          |> result.map(fn(results) { list.fold(results, 0, int.add) })
        }
      }
    }
  }
}

/// Find the maximum width (number of digits) among all numbers in problems
/// Excludes the operator (last element of each problem)
fn find_max_width(problems: List(List(String))) -> Int {
  problems
  |> list.map(fn(problem) {
    problem
    |> list.take(list.length(problem) - 1)
    |> list.map(string.length)
    |> list.fold(0, int.max)
  })
  |> list.fold(0, int.max)
}

/// Extract digits at a specific column position from a problem column
/// For Part 2 cephalopod math with operator-dependent extraction:
/// - Multiplication (*): All numbers use position from RIGHT, reading rightmost digit first
/// - Addition (+): All numbers use position from LEFT, reading leftmost digit first
/// column_position for multiplication: 0 = rightmost digit, 1 = second from right, etc.
/// column_position for addition: 0 = leftmost digit, 1 = second from left, etc.
fn extract_column_digits(
  problem: List(String),
  column_position: Int,
  operation: String,
) -> String {
  let num_rows = list.length(problem) - 1

  problem
  |> list.take(num_rows)
  |> list.filter_map(fn(number) {
    let num_len = string.length(number)

    case operation {
      "*" -> {
        // Multiplication: extract from right, all numbers contribute at same position
        case column_position < num_len {
          True -> {
            let char_index = num_len - 1 - column_position
            case string.slice(number, char_index, 1) {
              "" -> Error(Nil)
              ch -> Ok(ch)
            }
          }
          False -> Error(Nil)
        }
      }
      _ -> {
        // Addition: extract from left
        case column_position < num_len {
          True -> {
            case string.slice(number, column_position, 1) {
              "" -> Error(Nil)
              ch -> Ok(ch)
            }
          }
          False -> Error(Nil)
        }
      }
    }
  })
  |> string.join("")
}

/// Solve Part 2: Column-based digit extraction with whitespace preservation
/// Part 2 requires preserving whitespace alignment because numbers are read
/// vertically by CHARACTER POSITION, not by string position
fn solve_part2(input: String) -> Result(Int, String) {
  // Parse input preserving whitespace
  let raw_lines = parse_input_raw(input)

  case raw_lines {
    [] -> Error("No data found in input")
    _ -> {
      // Find column boundaries
      let boundaries = find_column_boundaries(raw_lines)

      case boundaries {
        [] -> Error("No column boundaries found")
        _ -> {
          // Extract fixed-width columns
          let columns = extract_columns(raw_lines, boundaries)

          case columns {
            [] -> Error("No columns extracted")
            _ -> {
              // Process each column
              columns
              |> list.index_map(fn(column, col_idx) {
                case column {
                  [] -> Ok(0)
                  _ -> {
                    // Last row should contain the operator
                    case list.last(column) {
                      Error(_) -> Ok(0)
                      Ok(last_row) -> {
                        case string.trim(last_row) |> string.first {
                          Error(_) -> Ok(0)
                          Ok(operation) -> {
                            case operation == "*" || operation == "+" {
                              False -> Ok(0)
                              True -> {
                                // Number rows are all except the last
                                let number_rows =
                                  column |> list.take(list.length(column) - 1)

                                case number_rows {
                                  [] -> Ok(0)
                                  _ -> {
                                    // Find max width among number rows
                                    let max_width =
                                      number_rows
                                      |> list.map(string.length)
                                      |> list.fold(0, int.max)

                                    case max_width == 0 {
                                      True -> Ok(0)
                                      False -> {
                                        // Extract numbers by reading vertically at each character position
                                        let numbers_right_to_left =
                                          list.range(0, max_width - 1)
                                          |> list.filter_map(fn(char_pos) {
                                            // Read vertically top-to-bottom at this character position
                                            let digits =
                                              number_rows
                                              |> list.filter_map(fn(row) {
                                                case char_pos < string.length(row) {
                                                  True -> {
                                                    let ch =
                                                      string.slice(row, char_pos, 1)
                                                    case ch {
                                                      " " -> Error(Nil)
                                                      _ -> {
                                                        // Check if it's a digit by trying to parse as int
                                                        case int.parse(ch) {
                                                          Ok(_) -> Ok(ch)
                                                          Error(_) -> Error(Nil)
                                                        }
                                                      }
                                                    }
                                                  }
                                                  False -> Error(Nil)
                                                }
                                              })
                                              |> string.join("")

                                            case string.length(digits) > 0 {
                                              True -> Ok(digits)
                                              False -> Error(Nil)
                                            }
                                          })
                                          |> list.reverse

                                        // Calculate this column's result
                                        case numbers_right_to_left {
                                          [] -> Ok(0)
                                          _ -> {
                                            let problem_with_op =
                                              list.append(numbers_right_to_left, [
                                                operation,
                                              ])
                                            case
                                              calculate_problem(
                                                problem_with_op,
                                                operation,
                                              )
                                            {
                                              Ok(result) -> {
                                                // Debug output to stderr
                                                io.println_error(
                                                  "Column "
                                                  <> int.to_string(col_idx)
                                                  <> ": "
                                                  <> string.join(
                                                    numbers_right_to_left,
                                                    ", ",
                                                  )
                                                  <> " "
                                                  <> operation
                                                  <> " = "
                                                  <> int.to_string(result),
                                                )
                                                Ok(result)
                                              }
                                              Error(err) -> Error(err)
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              })
              |> result.all
              |> result.map(fn(results) { list.fold(results, 0, int.add) })
            }
          }
        }
      }
    }
  }
}

/// Solve both parts of the puzzle
pub fn solve(input: String) -> Result(#(Int, Int), String) {
  case solve_part1(input), solve_part2(input) {
    Ok(part1), Ok(part2) -> Ok(#(part1, part2))
    Error(err), _ -> Error(err)
    _, Error(err) -> Error(err)
  }
}
