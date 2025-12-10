import day07
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// Test grid parsing
pub fn parse_grid_test() {
  let input = "...\n.S.\n.^."
  let grid = day07.parse_grid(input)
  grid
  |> should.equal([
    [".", ".", "."],
    [".", "S", "."],
    [".", "^", "."],
  ])
}

// Test finding start position
pub fn find_start_position_test() {
  let grid = [
    [".", ".", "."],
    [".", "S", "."],
    [".", "^", "."],
  ]
  let result = day07.find_start_position(grid)
  result
  |> should.equal(Ok(#(1, 1)))
}

// Test boundary checking
pub fn is_in_bounds_test() {
  let grid = [
    [".", ".", "."],
    [".", "S", "."],
    [".", "^", "."],
  ]
  day07.is_in_bounds(grid, 0, 0)
  |> should.equal(True)

  day07.is_in_bounds(grid, 2, 2)
  |> should.equal(True)

  day07.is_in_bounds(grid, -1, 0)
  |> should.equal(False)

  day07.is_in_bounds(grid, 0, -1)
  |> should.equal(False)

  day07.is_in_bounds(grid, 3, 0)
  |> should.equal(False)

  day07.is_in_bounds(grid, 0, 3)
  |> should.equal(False)
}

// Test getting cell from grid
pub fn get_cell_test() {
  let grid = [
    [".", ".", "."],
    [".", "S", "."],
    [".", "^", "."],
  ]
  day07.get_cell(grid, 1, 1)
  |> should.equal("S")

  day07.get_cell(grid, 2, 1)
  |> should.equal("^")

  day07.get_cell(grid, 0, 0)
  |> should.equal(".")
}

// Test single splitter simulation
pub fn single_splitter_test() {
  let input = ".S.\n...\n.^."
  let result = day07.solve(input)
  case result {
    Ok(#(part1, _)) -> part1 |> should.equal(1)
    Error(_) -> should.fail()
  }
}

// Test beam exits grid
pub fn beam_exits_grid_test() {
  let input = ".S.\n..."
  let result = day07.solve(input)
  case result {
    Ok(#(part1, _)) -> part1 |> should.equal(0)
    Error(_) -> should.fail()
  }
}

// Test splitter on edge
pub fn splitter_on_edge_test() {
  let input = "S..\n...\n^.."
  let result = day07.solve(input)
  case result {
    Ok(#(part1, _)) -> part1 |> should.equal(1)
    Error(_) -> should.fail()
  }
}

// Test sample input
pub fn sample_input_test() {
  let input =
    ".......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
..............."
  let result = day07.solve(input)
  case result {
    Ok(#(part1, _)) -> part1 |> should.equal(21)
    Error(_) -> should.fail()
  }
}
