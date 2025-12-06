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

// Part 2 Tests

// Test Part 2 with sample input produces total of 43
pub fn part2_sample_input_test() {
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
  let total = day04.solve_part2(input)
  total |> should.equal(43)
}

// Test Part 2 preserves Part 1 result
pub fn part2_preserves_part1_test() {
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

// Test Part 2 with empty grid
pub fn part2_empty_grid_test() {
  let input = ""
  let total = day04.solve_part2(input)
  total |> should.equal(0)
}

// Test remove_rolls function
pub fn remove_rolls_test() {
  let grid = [["@", "@", "."], ["@", ".", "."]]
  let positions = [#(0, 0), #(0, 1)]
  let new_grid = day04.remove_rolls(grid, positions)

  case list.first(new_grid) {
    Ok(row) -> {
      case list.first(row) {
        Ok(cell) -> cell |> should.equal(".")
        Error(_) -> should.fail()
      }
    }
    Error(_) -> should.fail()
  }
}

// Test Part 2 single iteration (all rolls accessible)
pub fn part2_single_iteration_test() {
  let input = "@..\n.@.\n..@"
  let total = day04.solve_part2(input)
  // All 3 rolls are accessible in first iteration (0-1 neighbors each)
  total |> should.equal(3)
}

// Test Part 2 iteration termination
pub fn part2_iteration_termination_test() {
  let input = ".....\n.@@@.\n.@@@.\n.@@@.\n....."
  let total = day04.solve_part2(input)
  // Should remove some rolls but stop when none are accessible
  should.be_true(total > 0)
  should.be_true(total <= 9)
}
