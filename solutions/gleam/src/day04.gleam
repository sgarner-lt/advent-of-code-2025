import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

// Main entry point
pub fn main() {
  let input_path = "../../challenges/day04/input.txt"

  case read_input(input_path) {
    Ok(content) -> {
      case solve(content) {
        Ok(#(count, grid_viz)) -> {
          let json = build_json(count, grid_viz)
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

// Parse input into a 2D grid of strings (characters)
pub fn parse_grid(input: String) -> List(List(String)) {
  input
  |> string.split("\n")
  |> list.map(string.trim)
  |> list.filter(fn(line) { string.length(line) > 0 })
  |> list.map(string.to_graphemes)
}

// Get cell at position using list operations
fn get_cell_at(
  grid: List(List(String)),
  row: Int,
  col: Int,
) -> Result(String, Nil) {
  grid
  |> list.drop(row)
  |> list.first()
  |> fn(result) {
    case result {
      Ok(line) ->
        line
        |> list.drop(col)
        |> list.first()
      Error(_) -> Error(Nil)
    }
  }()
}

// Count adjacent rolls ('@' symbols) in all 8 directions
pub fn count_adjacent_rolls(
  grid: List(List(String)),
  row: Int,
  col: Int,
) -> Int {
  let directions = [
    #(-1, 0),   // N
    #(1, 0),    // S
    #(0, 1),    // E
    #(0, -1),   // W
    #(-1, 1),   // NE
    #(-1, -1),  // NW
    #(1, 1),    // SE
    #(1, -1),   // SW
  ]

  let rows = list.length(grid)
  let cols = case list.first(grid) {
    Ok(first_row) -> list.length(first_row)
    Error(_) -> 0
  }

  directions
  |> list.fold(0, fn(count, dir) {
    let #(dr, dc) = dir
    let new_row = row + dr
    let new_col = col + dc

    // Check bounds
    case new_row >= 0 && new_row < rows && new_col >= 0 && new_col < cols {
      True -> {
        case get_cell_at(grid, new_row, new_col) {
          Ok("@") -> count + 1
          _ -> count
        }
      }
      False -> count
    }
  })
}

// Identify accessible rolls (adjacent_count < 4) using index_map
pub fn identify_accessible_rolls(
  grid: List(List(String)),
) -> List(#(Int, Int)) {
  grid
  |> list.index_map(fn(line, row) {
    line
    |> list.index_map(fn(cell, col) {
      case cell {
        "@" -> {
          let adjacent_count = count_adjacent_rolls(grid, row, col)
          case adjacent_count < 4 {
            True -> Ok(#(row, col))
            False -> Error(Nil)
          }
        }
        _ -> Error(Nil)
      }
    })
    |> list.filter_map(fn(x) { x })
  })
  |> list.flatten()
}

// Create grid visualization
pub fn create_visualization(
  grid: List(List(String)),
  accessible: List(#(Int, Int)),
) -> String {
  grid
  |> list.index_map(fn(line, row) {
    line
    |> list.index_map(fn(cell, col) {
      case list.contains(accessible, #(row, col)) {
        True -> "x"
        False -> cell
      }
    })
    |> string.join("")
  })
  |> string.join("\n")
}

// Solve the puzzle: count accessible rolls and create visualization
pub fn solve(input: String) -> Result(#(Int, String), String) {
  let grid = parse_grid(input)

  case list.is_empty(grid) {
    True -> Ok(#(0, ""))
    False -> {
      let accessible = identify_accessible_rolls(grid)
      let count = list.length(accessible)
      let visualization = create_visualization(grid, accessible)
      Ok(#(count, visualization))
    }
  }
}

// Build JSON output string with escaped newlines
fn build_json(count: Int, grid: String) -> String {
  let escaped_grid = string.replace(grid, "\n", "\\n")
  "{\"part1\": "
  <> int.to_string(count)
  <> ", \"part2\": null, \"additional-info\": {\"grid\": \""
  <> escaped_grid
  <> "\"}}"
}
