// Advent of Code 2025 - Day 07 - Tachyon Manifold Beam Splitter
// Part 1: Count total beam splits as tachyon beams propagate through splitters

import Core library "io";
import library "../common/io_utils";

// Maximum grid dimensions (conservative estimate)
let MAX_GRID_SIZE: i32 = 50;
let MAX_ACTIVE_BEAMS: i32 = 5000;

// Beam representation: row and col position
class Beam {
  var row: i32;
  var col: i32;
}

// Grid structure
class Grid {
  var cells: array(array(i32, 50), 50);
  var rows: i32;
  var cols: i32;
  var start_row: i32;
  var start_col: i32;
}

// Beam queue for active beams
class BeamQueue {
  var beams: array(Beam, 5000);
  var count: i32;
}

// Visited beams tracking (simple array-based set)
// Packed format: row * 1000 + col
class VisitedSet {
  var positions: array(i32, 5000);
  var count: i32;
}

// Activated splitters tracking
// Packed format: row * 1000 + col
class SplitterSet {
  var positions: array(i32, 5000);
  var count: i32;
}

// Helper function to check if a position is in the visited set
fn IsVisited(visited: VisitedSet*, row: i32, col: i32) -> bool {
  var packed: i32 = row * 1000 + col;
  var i: i32 = 0;
  while (i < (*visited).count) {
    if ((*visited).positions[i] == packed) {
      return true;
    }
    i = i + 1;
  }
  return false;
}

// Add a position to the visited set
fn AddVisited(visited: VisitedSet*, row: i32, col: i32) {
  if ((*visited).count < 5000) {
    (*visited).positions[(*visited).count] = row * 1000 + col;
    (*visited).count = (*visited).count + 1;
  }
}

// Check if a splitter position is activated
fn IsSplitterActivated(splitters: SplitterSet*, row: i32, col: i32) -> bool {
  var packed: i32 = row * 1000 + col;
  var i: i32 = 0;
  while (i < (*splitters).count) {
    if ((*splitters).positions[i] == packed) {
      return true;
    }
    i = i + 1;
  }
  return false;
}

// Mark a splitter as activated
fn ActivateSplitter(splitters: SplitterSet*, row: i32, col: i32) {
  if ((*splitters).count < 5000) {
    (*splitters).positions[(*splitters).count] = row * 1000 + col;
    (*splitters).count = (*splitters).count + 1;
  }
}

// Check if a beam is already in the next_beams queue
fn BeamInQueue(queue: BeamQueue*, row: i32, col: i32) -> bool {
  var i: i32 = 0;
  while (i < (*queue).count) {
    if ((*queue).beams[i].row == row and (*queue).beams[i].col == col) {
      return true;
    }
    i = i + 1;
  }
  return false;
}

// Add a beam to the queue
fn AddBeam(queue: BeamQueue*, row: i32, col: i32) {
  if ((*queue).count < MAX_ACTIVE_BEAMS) {
    (*queue).beams[(*queue).count].row = row;
    (*queue).beams[(*queue).count].col = col;
    (*queue).count = (*queue).count + 1;
  }
}

// Check if position is within grid bounds
fn IsInBounds(grid: Grid*, row: i32, col: i32) -> bool {
  return row >= 0 and row < (*grid).rows and col >= 0 and col < (*grid).cols;
}

// Read and parse the grid from stdin
fn ReadGrid(grid: Grid*) -> bool {
  (*grid).rows = 0;
  (*grid).cols = 0;
  (*grid).start_row = -1;
  (*grid).start_col = -1;

  var current_row: i32 = 0;
  var current_col: i32 = 0;
  var c: i32 = ReadChar();

  while (c != Core.EOF() and current_row < MAX_GRID_SIZE) {
    // Check for newline characters
    if (c == 0x0A or c == 0x0D) {
      if (current_col > 0) {
        if ((*grid).cols == 0) {
          (*grid).cols = current_col;
        }
        current_row = current_row + 1;
        current_col = 0;
      }
      c = ReadChar();
      continue;
    }

    if (current_col < MAX_GRID_SIZE) {
      (*grid).cells[current_row][current_col] = c;

      // Check for start position 'S' (ASCII 0x53)
      if (c == 0x53) {
        (*grid).start_row = current_row;
        (*grid).start_col = current_col;
      }

      current_col = current_col + 1;
    }

    c = ReadChar();
  }

  // Handle last line if no trailing newline
  if (current_col > 0) {
    if ((*grid).cols == 0) {
      (*grid).cols = current_col;
    }
    current_row = current_row + 1;
  }

  (*grid).rows = current_row;

  return (*grid).rows > 0 and (*grid).start_row >= 0;
}

// Simulate beam propagation and count splits
fn SimulateBeams(grid: Grid*) -> i32 {
  var active_beams: BeamQueue;
  var next_beams: BeamQueue;
  var visited: VisitedSet;
  var activated_splitters: SplitterSet;
  var split_count: i32 = 0;

  // Initialize structures
  active_beams.count = 0;
  next_beams.count = 0;
  visited.count = 0;
  activated_splitters.count = 0;

  // Add starting beam
  AddBeam(&active_beams, (*grid).start_row, (*grid).start_col);

  var iteration: i32 = 0;
  var max_iterations: i32 = 100000;

  while (active_beams.count > 0 and iteration < max_iterations) {
    iteration = iteration + 1;
    next_beams.count = 0;

    // Process each active beam
    var beam_idx: i32 = 0;
    while (beam_idx < active_beams.count) {
      var beam_row: i32 = active_beams.beams[beam_idx].row;
      var beam_col: i32 = active_beams.beams[beam_idx].col;

      // Skip if already visited
      if (IsVisited(&visited, beam_row, beam_col)) {
        beam_idx = beam_idx + 1;
        continue;
      }

      AddVisited(&visited, beam_row, beam_col);

      // Move beam one step downward
      var new_row: i32 = beam_row + 1;
      var new_col: i32 = beam_col;

      // Check bounds
      if (not IsInBounds(grid, new_row, new_col)) {
        beam_idx = beam_idx + 1;
        continue;
      }

      // Get cell at new position
      var cell: i32 = (*grid).cells[new_row][new_col];

      // Cell is '.' (0x2E) or 'S' (0x53) - empty space
      if (cell == 0x2E or cell == 0x53) {
        // Continue tracking beam through empty space
        if (not BeamInQueue(&next_beams, new_row, new_col)) {
          AddBeam(&next_beams, new_row, new_col);
        }
      } else if (cell == 0x5E) {
        // Cell is '^' (0x5E) - splitter
        // Hit a splitter
        if (not IsSplitterActivated(&activated_splitters, new_row, new_col)) {
          split_count = split_count + 1;
          ActivateSplitter(&activated_splitters, new_row, new_col);
        }

        // Create left beam at (new_row, new_col - 1)
        var left_col: i32 = new_col - 1;
        if (IsInBounds(grid, new_row, left_col)) {
          if (not BeamInQueue(&next_beams, new_row, left_col)) {
            AddBeam(&next_beams, new_row, left_col);
          }
        }

        // Create right beam at (new_row, new_col + 1)
        var right_col: i32 = new_col + 1;
        if (IsInBounds(grid, new_row, right_col)) {
          if (not BeamInQueue(&next_beams, new_row, right_col)) {
            AddBeam(&next_beams, new_row, right_col);
          }
        }
      } else {
        // Unknown cell - treat as empty
        if (not BeamInQueue(&next_beams, new_row, new_col)) {
          AddBeam(&next_beams, new_row, new_col);
        }
      }

      beam_idx = beam_idx + 1;
    }

    // Swap active and next
    var i: i32 = 0;
    while (i < next_beams.count) {
      active_beams.beams[i].row = next_beams.beams[i].row;
      active_beams.beams[i].col = next_beams.beams[i].col;
      i = i + 1;
    }
    active_beams.count = next_beams.count;
  }

  return split_count;
}

// Print JSON output
fn PrintJSON(part1: i32) {
  Core.PrintChar('{');
  Core.PrintChar('"');
  Core.PrintChar('p');
  Core.PrintChar('a');
  Core.PrintChar('r');
  Core.PrintChar('t');
  Core.PrintChar('1');
  Core.PrintChar('"');
  Core.PrintChar(':');
  Core.PrintChar(' ');
  PrintIntNoNewline(part1);
  Core.PrintChar(',');
  Core.PrintChar(' ');
  Core.PrintChar('"');
  Core.PrintChar('p');
  Core.PrintChar('a');
  Core.PrintChar('r');
  Core.PrintChar('t');
  Core.PrintChar('2');
  Core.PrintChar('"');
  Core.PrintChar(':');
  Core.PrintChar(' ');
  Core.PrintChar('n');
  Core.PrintChar('u');
  Core.PrintChar('l');
  Core.PrintChar('l');
  Core.PrintChar('}');
  Core.PrintChar('\n');
}

fn Run() {
  var grid: Grid;

  // Read and parse grid from stdin
  if (not ReadGrid(&grid)) {
    PrintJSON(0);
    return;
  }

  // Simulate beam propagation
  var split_count: i32 = SimulateBeams(&grid);

  // Output result
  PrintJSON(split_count);
}
