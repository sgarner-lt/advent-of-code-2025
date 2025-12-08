// Advent of Code 2025 - Day 03 - Maximum Digit Extraction
// Single-file Carbon implementation without external library dependencies

import Core library "io";

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

fn ProcessLine(part1_sum: i64*, part2_sum: i64*) -> bool {
  var digit_buffer: array(i32, 100);
  var len: i32 = 0;
  var c: i32 = ReadChar();

  while (c == 0x20 or c == 0x09 or c == 0x0A or c == 0x0D) {
    if (c == Core.EOF()) {
      return false;
    }
    c = ReadChar();
  }

  if (c == Core.EOF()) {
    return false;
  }

  while (len < 100) {
    if (c == Core.EOF() or c == 0x0A or c == 0x0D) {
      break;
    }

    if (c >= 0x30 and c <= 0x39) {
      digit_buffer[len] = c - 0x30;
      len = len + 1;
    }

    c = ReadChar();
  }

  if (len == 0) {
    return false;
  }

  var max_pair: i64 = 0;
  if (len >= 2) {
    var i: i32 = 0;
    while (i < len) {
      var j: i32 = i + 1;
      while (j < len) {
        let first: i64 = digit_buffer[i] as i64;
        let second: i64 = digit_buffer[j] as i64;
        let pair: i64 = first * 10 + second;
        if (pair > max_pair) {
          max_pair = pair;
        }
        j = j + 1;
      }
      i = i + 1;
    }
  }
  *part1_sum += max_pair;

  var max_12_digit: i64 = 0;
  if (len >= 12) {
    var result: i64 = 0;
    var current_pos: i32 = 0;
    var pos_in_result: i32 = 0;

    while (pos_in_result < 12) {
      let remaining_digits: i32 = 12 - pos_in_result;
      let search_end: i32 = len - remaining_digits + 1;

      var max_digit: i32 = digit_buffer[current_pos];
      var max_pos: i32 = current_pos;
      var pos: i32 = current_pos;

      while (pos < search_end) {
        if (digit_buffer[pos] > max_digit) {
          max_digit = digit_buffer[pos];
          max_pos = pos;
        }
        pos = pos + 1;
      }

      result = result * 10 + (max_digit as i64);
      current_pos = max_pos + 1;
      pos_in_result = pos_in_result + 1;
    }
    max_12_digit = result;
  }
  *part2_sum += max_12_digit;

  return true;
}

fn Run() {
  var part1_sum: i64 = 0;
  var part2_sum: i64 = 0;

  while (ProcessLine(&part1_sum, &part2_sum)) {
  }

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
  PrintInt(part1_sum);
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
  PrintInt(part2_sum);
  Core.PrintChar('}');
  Core.PrintChar('\n');
}

fn Main() -> i32 {
  Run();
  return 0;
}
