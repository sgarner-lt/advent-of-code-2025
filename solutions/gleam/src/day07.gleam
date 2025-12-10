import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/set.{type Set}
import gleam/string
import simplifile

/// Represents a beam with position
pub type Beam {
  Beam(row: Int, col: Int)
}

/// Main entry point
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

/// Parse input into a 2D grid of characters
pub fn parse_grid(input: String) -> List(List(String)) {
  input
  |> string.split("\n")
  |> list.map(string.trim)
  |> list.filter(fn(line) { string.length(line) > 0 })
  |> list.map(fn(line) { string.to_graphemes(line) })
}

/// Find the starting position marked with 'S'
/// Returns (row, col) coordinates
pub fn find_start_position(
  grid: List(List(String)),
) -> Result(#(Int, Int), String) {
  grid
  |> list.index_map(fn(row, row_idx) {
    row
    |> list.index_map(fn(cell, col_idx) { #(cell, row_idx, col_idx) })
  })
  |> list.flatten
  |> list.find(fn(tuple) {
    let #(cell, _row, _col) = tuple
    cell == "S"
  })
  |> result.map(fn(tuple) {
    let #(_cell, row, col) = tuple
    #(row, col)
  })
  |> result.replace_error("No starting position 'S' found in grid")
}

/// Check if a position is within grid bounds
pub fn is_in_bounds(grid: List(List(String)), row: Int, col: Int) -> Bool {
  case grid {
    [] -> False
    _ -> {
      let rows = list.length(grid)
      let cols = case list.first(grid) {
        Ok(first_row) -> list.length(first_row)
        Error(_) -> 0
      }
      row >= 0 && row < rows && col >= 0 && col < cols
    }
  }
}

/// Get cell at position in grid
pub fn get_cell(grid: List(List(String)), row: Int, col: Int) -> String {
  grid
  |> list.drop(row)
  |> list.first
  |> result.map(fn(row_list) {
    row_list
    |> list.drop(col)
    |> list.first
    |> result.unwrap("")
  })
  |> result.unwrap("")
}

/// Simulate beam propagation and count splits
/// This function tracks activated splitters to count each only once
pub fn simulate_beam_propagation(
  grid: List(List(String)),
  start_row: Int,
  start_col: Int,
) -> Int {
  do_simulate(
    grid,
    [Beam(start_row, start_col)],
    0,
    set.new(),
    set.new(),
    0,
  )
}

/// Helper function for beam simulation with tail recursion
fn do_simulate(
  grid: List(List(String)),
  active_beams: List(Beam),
  split_count: Int,
  activated_splitters: Set(#(Int, Int)),
  visited_beams: Set(Beam),
  iteration: Int,
) -> Int {
  let max_iterations = 100_000

  case active_beams, iteration < max_iterations {
    [], _ -> split_count
    _, False -> split_count
    _, True -> {
      // Process all active beams for this iteration
      let #(next_beams, new_split_count, new_activated, new_visited) =
        process_beams(
          grid,
          active_beams,
          split_count,
          activated_splitters,
          visited_beams,
        )

      do_simulate(
        grid,
        next_beams,
        new_split_count,
        new_activated,
        new_visited,
        iteration + 1,
      )
    }
  }
}

/// Process all beams in current iteration
fn process_beams(
  grid: List(List(String)),
  beams: List(Beam),
  split_count: Int,
  activated_splitters: Set(#(Int, Int)),
  visited_beams: Set(Beam),
) -> #(List(Beam), Int, Set(#(Int, Int)), Set(Beam)) {
  beams
  |> list.fold(
    #([], split_count, activated_splitters, visited_beams),
    fn(acc, beam) {
      let #(next_beams, count, activated, visited) = acc

      // Skip if we've already processed this beam position
      case set.contains(visited, beam) {
        True -> acc
        False -> {
          let new_visited = set.insert(visited, beam)

          // Move beam one step downward
          let new_row = beam.row + 1
          let new_col = beam.col

          // Check if new position is within bounds
          case is_in_bounds(grid, new_row, new_col) {
            False -> #(next_beams, count, activated, new_visited)
            True -> {
              let cell = get_cell(grid, new_row, new_col)
              let new_beam = Beam(new_row, new_col)

              case cell {
                "." | "S" -> {
                  // Continue tracking beam through empty space or start
                  let updated_beams = case
                    list.any(next_beams, fn(b) { b == new_beam })
                  {
                    True -> next_beams
                    False -> [new_beam, ..next_beams]
                  }
                  #(updated_beams, count, activated, new_visited)
                }
                "^" -> {
                  // Hit a splitter
                  let splitter_pos = #(new_row, new_col)
                  let #(new_count, new_activated) = case
                    set.contains(activated, splitter_pos)
                  {
                    False -> #(count + 1, set.insert(activated, splitter_pos))
                    True -> #(count, activated)
                  }

                  // Create left and right beams
                  let left_col = new_col - 1
                  let right_col = new_col + 1

                  let beams_with_left = case
                    is_in_bounds(grid, new_row, left_col)
                  {
                    True -> {
                      let left_beam = Beam(new_row, left_col)
                      case list.any(next_beams, fn(b) { b == left_beam }) {
                        True -> next_beams
                        False -> [left_beam, ..next_beams]
                      }
                    }
                    False -> next_beams
                  }

                  let beams_with_both = case
                    is_in_bounds(grid, new_row, right_col)
                  {
                    True -> {
                      let right_beam = Beam(new_row, right_col)
                      case list.any(beams_with_left, fn(b) { b == right_beam }) {
                        True -> beams_with_left
                        False -> [right_beam, ..beams_with_left]
                      }
                    }
                    False -> beams_with_left
                  }

                  #(beams_with_both, new_count, new_activated, new_visited)
                }
                _ -> {
                  // Unknown cell type - treat as empty
                  let updated_beams = case
                    list.any(next_beams, fn(b) { b == new_beam })
                  {
                    True -> next_beams
                    False -> [new_beam, ..next_beams]
                  }
                  #(updated_beams, count, activated, new_visited)
                }
              }
            }
          }
        }
      }
    },
  )
}

/// Count quantum timelines using memoized recursive approach
/// Returns number of distinct terminal timelines reaching bottom row
pub fn count_timelines_memoized(
  grid: List(List(String)),
  row: Int,
  col: Int,
  memo: Dict(#(Int, Int), Int),
) -> #(Int, Dict(#(Int, Int), Int)) {
  // Check if we've already computed this position
  case dict.get(memo, #(row, col)) {
    Ok(cached) -> #(cached, memo)
    Error(_) -> {
      // Base case: reached bottom row
      let rows = list.length(grid)
      case row == rows - 1 {
        True -> #(1, memo)
        False -> {
          let cell = get_cell(grid, row, col)

          let #(result, new_memo) = case cell {
            "." | "S" -> {
              // Move down one row
              count_timelines_memoized(grid, row + 1, col, memo)
            }
            "^" -> {
              // Quantum split: left and right branches
              let #(left_count, memo_after_left) = case col > 0 {
                True -> count_timelines_memoized(grid, row, col - 1, memo)
                False -> #(0, memo)
              }

              let cols = case list.first(grid) {
                Ok(first_row) -> list.length(first_row)
                Error(_) -> 0
              }

              let #(right_count, memo_after_right) = case col < cols - 1 {
                True ->
                  count_timelines_memoized(grid, row, col + 1, memo_after_left)
                False -> #(0, memo_after_left)
              }

              #(left_count + right_count, memo_after_right)
            }
            _ -> {
              // Unknown cell - move down
              count_timelines_memoized(grid, row + 1, col, memo)
            }
          }

          // Cache the result
          let updated_memo = dict.insert(new_memo, #(row, col), result)
          #(result, updated_memo)
        }
      }
    }
  }
}

/// Solve the puzzle
pub fn solve(input: String) -> Result(#(Int, Int), String) {
  let grid = parse_grid(input)

  case grid {
    [] -> Error("Empty grid")
    _ -> {
      case find_start_position(grid) {
        Error(err) -> Error(err)
        Ok(#(start_row, start_col)) -> {
          // Part 1: Count beam splits
          let split_count = simulate_beam_propagation(grid, start_row, start_col)

          // Part 2: Count quantum timelines using memoization
          let #(timeline_count, _memo) =
            count_timelines_memoized(grid, start_row, start_col, dict.new())

          Ok(#(split_count, timeline_count))
        }
      }
    }
  }
}
