// Advent of Code 2025 - Day 06 - Trash Compactor Math Worksheet
// Carbon implementation with embedded I/O utilities

import Core library "io";
import Core library "range";

// I/O utilities (from advent2024/io_utils.carbon)
var unread_char: i32 = 0;

fn ReadChar() -> i32 {
  if (unread_char != 0) {
    var result: i32 = unread_char - 2;
    unread_char = 0;
    return result;
  }
  return Core.ReadChar();
}

fn UnreadChar(c: i32) {
  unread_char = c + 2;
}

fn ReadInt64(p: i64*) -> bool {
  var read_any_digits: bool = false;
  *p = 0;

  while (true) {
    var c: i32 = ReadChar();
    if (c < 0x30 or c > 0x39) {
      UnreadChar(c);
      break;
    }
    *p = *p * 10;
    *p = *p + ((c - 0x30) as i64);
    read_any_digits = true;
  }
  return read_any_digits;
}

fn PrintInt64NoNewline(n_val: i64) {
  var pow10: i64 = 1;
  var n: i64 = n_val;
  if (n == 0) {
    Core.PrintChar('0');
    return;
  }
  while (n / 10 >= pow10) {
    pow10 = pow10 * 10;
  }
  while (pow10 != 0) {
    let d: i64 = n / pow10;
    Core.PrintChar(((d + 0x30) as u8) as char);
    n = n % pow10;
    pow10 = pow10 / 10;
  }
}

fn ConsumeChar(c: i32) -> bool {
  var next: i32 = ReadChar();
  if (next != c) {
    UnreadChar(next);
    return false;
  }
  return true;
}

fn SkipWhitespace() {
  while (true) {
    var c: i32 = ReadChar();
    if (c != 0x20 and c != 0x09 and c != 0x0D) {
      // Not space, tab, or CR
      UnreadChar(c);
      break;
    }
  }
}

fn SkipNewline() -> bool {
  ConsumeChar(0x0D);
  return ConsumeChar(0x0A);
}

// Storage for the 2D grid
// Real input: 4 rows, 1000 columns
var grid: array(array(i64, 1000), 10);
var num_rows: i32 = 0;
var num_cols: array(i32, 10);

// Storage for problems (vertical columns)
// Max 1000 problems, 10 numbers each
var problems: array(array(i64, 10), 1000);
// Operation for each problem (0x2A for *, 0x2B for +)
var operations: array(i32, 1000);
var problem_lengths: array(i32, 1000);
var num_problems: i32 = 0;

fn ReadInput() {
  num_rows = 0;

  while (true) {
    var c: i32 = ReadChar();
    if (c == Core.EOF() or c < 0) {
      break;
    }

    // Check for newline at start (empty line)
    if (c == 0x0A) {
      if (num_rows == 0) {
        // First line is blank, skip it
        continue;
      }
      // Blank line after content, end of input
      break;
    }

    // Unread the character and process the line
    UnreadChar(c);

    // Read numbers on this line
    num_cols[num_rows] = 0;
    while (true) {
      SkipWhitespace();

      var ch: i32 = ReadChar();
      if (ch == 0x0A or ch == Core.EOF() or ch < 0) {
        // End of line
        break;
      }

      UnreadChar(ch);

      // Try to read a number
      var num: i64;
      if (ReadInt64(&num)) {
        grid[num_rows][num_cols[num_rows]] = num;
        ++num_cols[num_rows];
      } else {
        // Not a number, check if it's an operation symbol
        var op: i32 = ReadChar();
        if (op == 0x2A or op == 0x2B) {
          // Store operation as negative to distinguish from numbers
          // * = -1, + = -2
          if (op == 0x2A) {
            grid[num_rows][num_cols[num_rows]] = -1;
          } else {
            grid[num_rows][num_cols[num_rows]] = -2;
          }
          ++num_cols[num_rows];
        }
      }
    }

    if (num_cols[num_rows] > 0) {
      ++num_rows;
    }
  }
}

fn TransposeToProblems() {
  if (num_rows == 0) {
    num_problems = 0;
    return;
  }

  // Find max columns
  var max_cols: i32 = 0;
  for (r: i32 in Core.Range(num_rows)) {
    if (num_cols[r] > max_cols) {
      max_cols = num_cols[r];
    }
  }

  num_problems = max_cols;

  // Transpose: each column becomes a problem
  for (col: i32 in Core.Range(max_cols)) {
    problem_lengths[col] = 0;
    for (row: i32 in Core.Range(num_rows)) {
      if (col < num_cols[row]) {
        problems[col][problem_lengths[col]] = grid[row][col];
        ++problem_lengths[col];
      }
    }

    // Extract operation from last element
    if (problem_lengths[col] > 0) {
      let last_val: i64 = problems[col][problem_lengths[col] - 1];
      if (last_val == -1) {
        // *
        operations[col] = 0x2A;
      } else if (last_val == -2) {
        // +
        operations[col] = 0x2B;
      } else {
        // No operation found, default to +
        operations[col] = 0x2B;
      }
    }
  }
}

fn CalculateProblem(problem_idx: i32) -> i64 {
  var result: i64 = 0;
  let len: i32 = problem_lengths[problem_idx];

  if (len < 2) {
    return 0;
  }

  // Get all numbers (exclude last element which is the operation)
  var op: i32 = operations[problem_idx];

  if (op == 0x2A) {
    // Multiplication
    result = 1;
    for (i: i32 in Core.Range(len - 1)) {
      let val: i64 = problems[problem_idx][i];
      if (val > 0) {
        result = result * val;
      }
    }
  } else {
    // Addition
    result = 0;
    for (i: i32 in Core.Range(len - 1)) {
      let val: i64 = problems[problem_idx][i];
      if (val > 0) {
        result = result + val;
      }
    }
  }

  return result;
}

fn SolveAllProblems() -> i64 {
  var grand_total: i64 = 0;

  for (i: i32 in Core.Range(num_problems)) {
    let problem_result: i64 = CalculateProblem(i);
    grand_total = grand_total + problem_result;
  }

  return grand_total;
}

fn Run() {
  ReadInput();
  TransposeToProblems();
  let answer: i64 = SolveAllProblems();

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
  PrintInt64NoNewline(answer);
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
