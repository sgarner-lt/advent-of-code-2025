import day04
import gleam/list
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// Test grid parsing from input
pub fn parse_grid_test() {
  let input = "..@@\n@@@.\n"
  let grid = day04.parse_grid(input)
  list.length(grid) |> should.equal(2)
  case list.first(grid) {
    Ok(row) -> row |> should.equal([".", ".", "@", "@"])
    Error(_) -> should.fail()
  }
}

// Test counting adjacent cells for corner position
pub fn count_adjacent_corner_test() {
  let grid = [
    ["@", "@", "."],
    ["@", ".", "."],
    [".", ".", "."],
  ]
  // Corner cell (0,0) has 2 adjacent rolls: (0,1) and (1,0)
  day04.count_adjacent_rolls(grid, 0, 0)
  |> should.equal(2)
}

// Test counting adjacent cells for edge position
pub fn count_adjacent_edge_test() {
  let grid = [
    ["@", "@", "@"],
    ["@", "@", "@"],
    [".", ".", "."],
  ]
  // Edge cell (0,1) has 5 adjacent rolls
  day04.count_adjacent_rolls(grid, 0, 1)
  |> should.equal(5)
}

// Test counting adjacent cells for interior position
pub fn count_adjacent_interior_test() {
  let grid = [
    ["@", "@", "@"],
    ["@", "@", "@"],
    ["@", "@", "@"],
  ]
  // Interior cell (1,1) has all 8 neighbors
  day04.count_adjacent_rolls(grid, 1, 1)
  |> should.equal(8)
}

// Test accessibility rule (adjacent_count < 4)
pub fn accessibility_rule_test() {
  let grid = [
    ["@", "@", "."],
    ["@", "@", "@"],
    [".", "@", "."],
  ]
  let accessible = day04.identify_accessible_rolls(grid)
  // Cell (0,0) has 3 adjacent -> accessible
  list.contains(accessible, #(0, 0)) |> should.be_true()
  // Cell (1,1) has 5 adjacent -> not accessible
  list.contains(accessible, #(1, 1)) |> should.be_false()
}

// Test sample input produces 13 accessible rolls
pub fn sample_input_test() {
  let input =
    "..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@."
  case day04.solve(input) {
    Ok(#(count, _)) -> count |> should.equal(13)
    Error(_) -> should.fail()
  }
}

// Test visualization contains expected characters
pub fn visualization_format_test() {
  let input = "..@@\n@@@.\n"
  case day04.solve(input) {
    Ok(#(_, viz)) -> {
      // Visualization should contain 'x' or '@'
      let has_x = list.contains(day04.parse_grid(viz) |> list.flatten(), "x")
      let has_at = list.contains(day04.parse_grid(viz) |> list.flatten(), "@")
      should.be_true(has_x || has_at)
    }
    Error(_) -> should.fail()
  }
}

// Test empty grid handling
pub fn empty_grid_test() {
  let input = ""
  case day04.solve(input) {
    Ok(#(count, viz)) -> {
      count |> should.equal(0)
      viz |> should.equal("")
    }
    Error(_) -> should.fail()
  }
}
