// Advent of Code 2025 - Day 05 - Cafeteria Ingredient Freshness
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

fn SkipNewline() -> bool {
  ConsumeChar(0x0D);
  return ConsumeChar(0x0A);
}

// Storage
var range_starts: array(i64, 200);
var range_ends: array(i64, 200);
var num_ranges: i32 = 0;
var ids: array(i64, 2000);
var num_ids: i32 = 0;

fn ReadRanges() {
  num_ranges = 0;
  while (true) {
    var start: i64;
    if (not ReadInt64(&start)) {
      // No number found - check for blank line
      if (SkipNewline()) {
        // This was a blank line - end of ranges section
        break;
      }
      // EOF or error
      break;
    }

    // Expect hyphen
    if (not ConsumeChar(0x2D)) {
      // Not a range line, skip it
      while (not SkipNewline() and ReadChar() != Core.EOF()) {}
      continue;
    }

    // Read end of range
    var end: i64;
    if (not ReadInt64(&end)) {
      // Malformed range, skip line
      while (not SkipNewline() and ReadChar() != Core.EOF()) {}
      continue;
    }

    // Store range
    range_starts[num_ranges] = start;
    range_ends[num_ranges] = end;
    ++num_ranges;

    // Skip to next line
    SkipNewline();
  }
}

fn ReadIds() {
  num_ids = 0;
  while (true) {
    var id: i64;
    if (not ReadInt64(&id)) {
      break;
    }
    ids[num_ids] = id;
    ++num_ids;
    SkipNewline();
  }
}

fn CountFresh() -> i32 {
  var fresh_count: i32 = 0;
  for (i: i32 in Core.Range(num_ids)) {
    let id: i64 = ids[i];
    for (r: i32 in Core.Range(num_ranges)) {
      if (id >= range_starts[r] and id <= range_ends[r]) {
        ++fresh_count;
        break;
      }
    }
  }
  return fresh_count;
}

fn Run() {
  ReadRanges();
  ReadIds();
  let fresh_count: i32 = CountFresh();

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
  PrintInt64NoNewline(fresh_count as i64);
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
