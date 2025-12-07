// Advent of Code 2025 - Day 02 - Invalid Product IDs
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

fn ReadInt(p: i64*) -> bool {
  var read_any_digits: bool = false;
  *p = 0;
  var c: i32 = ReadChar();
  while (true) {
    if (c < 0x30 or c > 0x39) {
      UnreadChar(c);
      break;
    }
    *p *= 10;
    *p += (c - 0x30) as i64;
    read_any_digits = true;
    c = ReadChar();
  }
  return read_any_digits;
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

// Count digits in a number
fn CountDigits(n_val: i64) -> i32 {
  var n: i64 = n_val;
  if (n == 0) {
    return 1;
  }
  var count: i32 = 0;
  while (n > 0) {
    n = n / 10;
    count = count + 1;
  }
  return count;
}

// Get the Nth digit from the right (0-indexed)
fn GetDigit(n: i64, pos: i32) -> i32 {
  var temp: i64 = n;
  var i: i32 = 0;
  while (i < pos) {
    temp = temp / 10;
    i = i + 1;
  }
  return (temp % 10) as i32;
}

// Check if a number is invalid (Part 1: pattern repeated exactly twice)
fn IsInvalidPart1(n: i64) -> bool {
  var length: i32 = CountDigits(n);

  // Must have even length to split in half
  if (length % 2 != 0) {
    return false;
  }

  var half: i32 = length / 2;
  var i: i32 = 0;
  while (i < half) {
    let left_digit: i32 = GetDigit(n, length - 1 - i);
    let right_digit: i32 = GetDigit(n, half - 1 - i);
    if (left_digit != right_digit) {
      return false;
    }
    i = i + 1;
  }

  return true;
}

// Check if a number is invalid (Part 2: pattern repeated 2+ times)
fn IsInvalidPart2(n: i64) -> bool {
  var length: i32 = CountDigits(n);

  // Try each possible pattern length from 1 to length/2
  var pattern_length: i32 = 1;
  while (pattern_length <= length / 2) {
    // Only check if length is evenly divisible by pattern length
    if (length % pattern_length == 0) {
      // Check if pattern repeats throughout the number
      var is_pattern: bool = true;
      var pos: i32 = 0;
      while (pos < length) {
        var pattern_pos: i32 = pos % pattern_length;
        let digit1: i32 = GetDigit(n, length - 1 - pos);
        let digit2: i32 = GetDigit(n, length - 1 - pattern_pos);
        if (digit1 != digit2) {
          is_pattern = false;
          break;
        }
        pos = pos + 1;
      }

      if (is_pattern) {
        return true;
      }
    }

    pattern_length = pattern_length + 1;
  }

  return false;
}

// Parse a single range and process it
fn ProcessRange(part1_sum: i64*, part2_sum: i64*) -> bool {
  var start: i64 = 0;
  var end: i64 = 0;

  // Skip whitespace and commas
  var c: i32 = ReadChar();
  while (c == 0x20 or c == 0x09 or c == 0x0A or c == 0x0D or c == 0x2C) {
    if (c == Core.EOF()) {
      return false;
    }
    c = ReadChar();
  }

  if (c == Core.EOF()) {
    return false;
  }

  UnreadChar(c);

  // Read start of range
  if (not ReadInt(&start)) {
    return false;
  }

  // Expect hyphen
  c = ReadChar();
  if (c != 0x2D) {
    return false;
  }

  // Read end of range
  if (not ReadInt(&end)) {
    return false;
  }

  // Process all numbers in range
  var num: i64 = start;
  while (num <= end) {
    if (IsInvalidPart1(num)) {
      *part1_sum += num;
    }
    if (IsInvalidPart2(num)) {
      *part2_sum += num;
    }
    num = num + 1;
  }

  return true;
}

fn Run() {
  var part1_sum: i64 = 0;
  var part2_sum: i64 = 0;

  // Process all ranges from input
  while (ProcessRange(&part1_sum, &part2_sum)) {
    // Continue processing ranges
  }

  // Print JSON output
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
