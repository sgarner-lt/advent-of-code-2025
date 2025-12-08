// Advent of Code 2025 - Day 04 - Paper Roll Accessibility
// Real Carbon implementation without external dependencies

import Core library "io";

// Global grid - Carbon doesn't handle large nested array parameters well
var grid: array(array(i32, 150), 150);
var rows: i32 = 0;
var cols: i32 = 0;

fn PrintInt(n_val: i64) {
  var n: i64 = n_val;
  if (n < 0) {
    Core.PrintChar('-');
    n = -n;
  }
  var pow10: i64 = 1;
  while (n / 10 >= pow10) {
    pow10 = pow10 * 10;
  }
  while (pow10 != 0) {
    let d: i64 = n / pow10;
    let d_i32: i32 = d as i32;
    Core.PrintChar(((d_i32 + 0x30) as u8) as char);
    n = n % pow10;
    pow10 = pow10 / 10;
  }
}

// Parse grid from input
fn ParseGrid() {
  var r: i32 = 0;
  var c: i32 = 0;
  var max_cols: i32 = 0;

  // Initialize grid with '.'
  var init_r: i32 = 0;
  while (init_r < 150) {
    var init_c: i32 = 0;
    while (init_c < 150) {
      grid[init_r][init_c] = 0x2E;
      init_c = init_c + 1;
    }
    init_r = init_r + 1;
  }

  while (r < 150) {
    var ch: i32 = Core.ReadChar();

    if (ch == Core.EOF()) {
      break;
    }

    if (ch == 0x0A or ch == 0x0D) {
      if (c > 0) {
        if (c > max_cols) {
          max_cols = c;
        }
        r = r + 1;
        c = 0;
      }
    } else {
      if (c < 150) {
        grid[r][c] = ch;
        c = c + 1;
      }
    }
  }

  // Handle last line if no newline at end
  if (c > 0) {
    if (c > max_cols) {
      max_cols = c;
    }
    r = r + 1;
  }

  rows = r;
  cols = max_cols;
}

fn CountAdjacent(r: i32, c: i32) -> i32 {
  var count: i32 = 0;

  // Check all 8 directions for '@' (0x40)
  if (r > 0 and grid[r - 1][c] == 0x40) { count = count + 1; }
  if (r < rows - 1 and grid[r + 1][c] == 0x40) { count = count + 1; }
  if (c < cols - 1 and grid[r][c + 1] == 0x40) { count = count + 1; }
  if (c > 0 and grid[r][c - 1] == 0x40) { count = count + 1; }
  if (r > 0 and c < cols - 1 and grid[r - 1][c + 1] == 0x40) { count = count + 1; }
  if (r > 0 and c > 0 and grid[r - 1][c - 1] == 0x40) { count = count + 1; }
  if (r < rows - 1 and c < cols - 1 and grid[r + 1][c + 1] == 0x40) { count = count + 1; }
  if (r < rows - 1 and c > 0 and grid[r + 1][c - 1] == 0x40) { count = count + 1; }

  return count;
}

// Part 1: Count accessible rolls (< 4 adjacent)
fn CountAccessible() -> i32 {
  var count: i32 = 0;

  var r: i32 = 0;
  while (r < rows) {
    var c: i32 = 0;
    while (c < cols) {
      if (grid[r][c] == 0x40) {
        let adjacent: i32 = CountAdjacent(r, c);
        if (adjacent < 4) {
          count = count + 1;
        }
      }
      c = c + 1;
    }
    r = r + 1;
  }

  return count;
}

// Part 2: Remove accessible rolls iteratively
fn RemoveAccessible() -> i32 {
  var total_removed: i32 = 0;
  var to_remove: array(array(i32, 150), 150);

  while (true) {
    var found_any: bool = false;
    var r: i32 = 0;
    while (r < rows) {
      var c: i32 = 0;
      while (c < cols) {
        to_remove[r][c] = 0;
        if (grid[r][c] == 0x40) {
          let adjacent: i32 = CountAdjacent(r, c);
          if (adjacent < 4) {
            to_remove[r][c] = 1;
            found_any = true;
          }
        }
        c = c + 1;
      }
      r = r + 1;
    }

    if (not found_any) {
      break;
    }

    r = 0;
    while (r < rows) {
      var c: i32 = 0;
      while (c < cols) {
        if (to_remove[r][c] == 1) {
          grid[r][c] = 0x2E;
          total_removed = total_removed + 1;
        }
        c = c + 1;
      }
      r = r + 1;
    }
  }

  return total_removed;
}

fn Run() {
  // Parse input
  ParseGrid();

  // Part 1
  let part1: i32 = CountAccessible();

  // Part 2 (uses modified grid)
  let part2: i32 = RemoveAccessible();

  // Output JSON
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
  PrintInt(part1 as i64);
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
  PrintInt(part2 as i64);
  Core.PrintChar('}');
  Core.PrintChar('\n');
}

fn Main() -> i32 {
  Run();
  return 0;
}
