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

// Storage for the 2D grid (Part 1)
// Real input: 4 rows, 1000 columns
var grid: array(array(i64, 1000), 10);
var num_rows: i32 = 0;
var num_cols: array(i32, 10);

// Storage for raw input lines (Part 2)
// Max 10 lines, 5000 chars per line
var raw_lines: array(array(i32, 5000), 10);
var raw_line_lengths: array(i32, 10);
var num_raw_lines: i32 = 0;

// Storage for problems (vertical columns)
// Max 1000 problems, 10 numbers each
var problems: array(array(i64, 10), 1000);
// Operation for each problem (0x2A for *, 0x2B for +)
var operations: array(i32, 1000);
var problem_lengths: array(i32, 1000);
var num_problems: i32 = 0;

fn ReadInput() {
  num_rows = 0;
  num_raw_lines = 0;

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

    // Store raw line first (for Part 2)
    raw_line_lengths[num_raw_lines] = 0;
    while (true) {
      var ch: i32 = ReadChar();
      if (ch == 0x0A or ch == Core.EOF() or ch < 0) {
        break;
      }
      if (ch == 0x0D) {
        // Skip CR
        continue;
      }
      raw_lines[num_raw_lines][raw_line_lengths[num_raw_lines]] = ch;
      ++raw_line_lengths[num_raw_lines];
    }
    ++num_raw_lines;

    // Now process the same line for Part 1 (parse numbers)
    num_cols[num_rows] = 0;
    var char_idx: i32 = 0;
    while (char_idx < raw_line_lengths[num_rows]) {
      var ch: i32 = raw_lines[num_rows][char_idx];

      // Skip whitespace
      if (ch == 0x20 or ch == 0x09) {
        ++char_idx;
        continue;
      }

      // Try to read a number
      if (ch >= 0x30 and ch <= 0x39) {
        var num: i64 = 0;
        while (char_idx < raw_line_lengths[num_rows]) {
          let digit_char: i32 = raw_lines[num_rows][char_idx];
          if (digit_char < 0x30 or digit_char > 0x39) {
            break;
          }
          num = num * 10;
          num = num + ((digit_char - 0x30) as i64);
          ++char_idx;
        }
        grid[num_rows][num_cols[num_rows]] = num;
        ++num_cols[num_rows];
      } else if (ch == 0x2A or ch == 0x2B) {
        // Operation symbol
        if (ch == 0x2A) {
          grid[num_rows][num_cols[num_rows]] = -1;
        } else {
          grid[num_rows][num_cols[num_rows]] = -2;
        }
        ++num_cols[num_rows];
        ++char_idx;
      } else {
        ++char_idx;
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

fn SolvePart1() -> i64 {
  var grand_total: i64 = 0;

  for (i: i32 in Core.Range(num_problems)) {
    let problem_result: i64 = CalculateProblem(i);
    grand_total = grand_total + problem_result;
  }

  return grand_total;
}

// Part 2: Column boundary detection and extraction

// Storage for column boundaries
var column_boundaries: array(i32, 2000);
var num_boundaries: i32 = 0;

// Find column boundaries where all rows have whitespace
fn FindColumnBoundaries() {
  num_boundaries = 0;

  if (num_raw_lines == 0) {
    return;
  }

  // Find max line length
  var max_len: i32 = 0;
  for (i: i32 in Core.Range(num_raw_lines)) {
    if (raw_line_lengths[i] > max_len) {
      max_len = raw_line_lengths[i];
    }
  }

  if (max_len == 0) {
    return;
  }

  // First column always starts at 0
  column_boundaries[num_boundaries] = 0;
  ++num_boundaries;

  var in_whitespace: bool = false;

  for (pos: i32 in Core.Range(max_len)) {
    // Check if all rows have whitespace at this position
    var all_whitespace: bool = true;
    for (row: i32 in Core.Range(num_raw_lines)) {
      if (pos < raw_line_lengths[row]) {
        let ch: i32 = raw_lines[row][pos];
        if (ch != 0x20 and ch != 0x09) {
          all_whitespace = false;
          break;
        }
      }
      // If pos >= line length, consider it whitespace
    }

    if (all_whitespace and not in_whitespace) {
      in_whitespace = true;
    } else if (not all_whitespace and in_whitespace) {
      column_boundaries[num_boundaries] = pos;
      ++num_boundaries;
      in_whitespace = false;
    }
  }
}

// Storage for extracted fixed-width columns
// Max 1000 columns, 10 rows per column, 20 chars per cell
var fixed_columns: array(array(array(i32, 20), 10), 1000);
var fixed_column_lengths: array(array(i32, 10), 1000);
var num_fixed_columns: i32 = 0;

// Extract fixed-width columns based on boundaries
fn ExtractFixedWidthColumns() {
  num_fixed_columns = 0;

  if (num_boundaries == 0) {
    return;
  }

  for (col_idx: i32 in Core.Range(num_boundaries)) {
    let start: i32 = column_boundaries[col_idx];
    var end: i32 = 0;

    if (col_idx + 1 < num_boundaries) {
      end = column_boundaries[col_idx + 1];
    } else {
      // Last column extends to max line length
      end = 0;
      for (row: i32 in Core.Range(num_raw_lines)) {
        if (raw_line_lengths[row] > end) {
          end = raw_line_lengths[row];
        }
      }
    }

    // Extract this column from each row
    for (row: i32 in Core.Range(num_raw_lines)) {
      fixed_column_lengths[col_idx][row] = 0;

      if (start < raw_line_lengths[row]) {
        var actual_end: i32 = end;
        if (end > raw_line_lengths[row]) {
          actual_end = raw_line_lengths[row];
        }

        // Manually iterate from start to actual_end
        var char_pos: i32 = start;
        while (char_pos < actual_end) {
          fixed_columns[col_idx][row][fixed_column_lengths[col_idx][row]] = raw_lines[row][char_pos];
          ++fixed_column_lengths[col_idx][row];
          ++char_pos;
        }
      }
    }
  }

  num_fixed_columns = num_boundaries;
}

// Storage for numbers extracted from vertical reading
// Max 1000 columns, 20 numbers per column
var vertical_numbers: array(array(i64, 20), 1000);
var vertical_number_counts: array(i32, 1000);
var vertical_operations: array(i32, 1000);

// Solve Part 2: Read vertically by character position
fn SolvePart2() -> i64 {
  // Find column boundaries
  FindColumnBoundaries();

  // Extract fixed-width columns
  ExtractFixedWidthColumns();

  if (num_fixed_columns == 0) {
    return 0;
  }

  var grand_total: i64 = 0;

  // Process each fixed-width column
  for (col_idx: i32 in Core.Range(num_fixed_columns)) {
    if (num_raw_lines == 0) {
      continue;
    }

    // Last row should contain the operator
    let last_row: i32 = num_raw_lines - 1;

    // Find operator in last row
    var op: i32 = 0;
    for (char_idx: i32 in Core.Range(fixed_column_lengths[col_idx][last_row])) {
      let ch: i32 = fixed_columns[col_idx][last_row][char_idx];
      if (ch == 0x2A or ch == 0x2B) {
        op = ch;
        break;
      }
    }

    if (op != 0x2A and op != 0x2B) {
      // No valid operator found
      continue;
    }

    vertical_operations[col_idx] = op;

    // Find max width among number rows (all except last)
    var max_width: i32 = 0;
    for (row: i32 in Core.Range(last_row)) {
      if (fixed_column_lengths[col_idx][row] > max_width) {
        max_width = fixed_column_lengths[col_idx][row];
      }
    }

    if (max_width == 0) {
      continue;
    }

    // Extract numbers by reading vertically at each character position
    vertical_number_counts[col_idx] = 0;

    for (char_pos: i32 in Core.Range(max_width)) {
      // Read vertically at this character position
      var digits: array(i32, 10);
      var digit_count: i32 = 0;

      for (row: i32 in Core.Range(last_row)) {
        if (char_pos < fixed_column_lengths[col_idx][row]) {
          let ch: i32 = fixed_columns[col_idx][row][char_pos];
          // Only collect digit characters, skip whitespace
          if (ch >= 0x30 and ch <= 0x39) {
            digits[digit_count] = ch - 0x30;
            ++digit_count;
          }
        }
      }

      // Form number from collected digits
      if (digit_count > 0) {
        var num: i64 = 0;
        for (i: i32 in Core.Range(digit_count)) {
          num = num * 10;
          num = num + ((digits[i]) as i64);
        }
        vertical_numbers[col_idx][vertical_number_counts[col_idx]] = num;
        ++vertical_number_counts[col_idx];
      }
    }

    // Numbers are in left-to-right order, reverse to get right-to-left
    let count: i32 = vertical_number_counts[col_idx];
    for (i: i32 in Core.Range(count / 2)) {
      let temp: i64 = vertical_numbers[col_idx][i];
      vertical_numbers[col_idx][i] = vertical_numbers[col_idx][count - 1 - i];
      vertical_numbers[col_idx][count - 1 - i] = temp;
    }

    // Calculate this column's result
    if (vertical_number_counts[col_idx] > 0) {
      var result: i64 = 0;

      if (op == 0x2A) {
        // Multiplication
        result = 1;
        for (i: i32 in Core.Range(vertical_number_counts[col_idx])) {
          result = result * vertical_numbers[col_idx][i];
        }
      } else {
        // Addition
        result = 0;
        for (i: i32 in Core.Range(vertical_number_counts[col_idx])) {
          result = result + vertical_numbers[col_idx][i];
        }
      }

      grand_total = grand_total + result;
    }
  }

  return grand_total;
}

fn Run() {
  ReadInput();
  TransposeToProblems();
  let part1_answer: i64 = SolvePart1();
  let part2_answer: i64 = SolvePart2();

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
  PrintInt64NoNewline(part1_answer);
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
  PrintInt64NoNewline(part2_answer);
  Core.PrintChar('}');
  Core.PrintChar('\n');
}
