// Part of Advent of Code 2025 Carbon Solutions
// Based on Carbon Language io_utils from advent2024 examples
// Apache License v2.0 with LLVM Exceptions

library "io_utils";

import Core library "io";
import Core library "range";

// If non-zero, this is the most recently read character plus 2.
// The +2 is necessary to distinguish the case of no unread character
// from the case of unreading an EOF.
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

fn ReadInt(p: i32*) -> bool {
  var read_any_digits: bool = false;
  *p = 0;
  var is_negative: bool = false;

  // Check for negative sign
  var c: i32 = ReadChar();
  if (c == 0x2D) {  // '-'
    is_negative = true;
  } else {
    UnreadChar(c);
  }

  while (true) {
    c = ReadChar();
    if (c < 0x30 or c > 0x39) {
      UnreadChar(c);
      break;
    }
    *p *= 10;
    *p += c - 0x30;
    read_any_digits = true;
  }

  if (is_negative) {
    *p = -*p;
  }

  return read_any_digits;
}

fn PrintIntNoNewline(n_val: i32) {
  if (n_val < 0) {
    Core.PrintChar('-');
    n_val = -n_val;
  }

  var pow10: i32 = 1;
  var n: i32 = n_val;
  while (n / 10 >= pow10) {
    pow10 = pow10 * 10;
  }
  while (pow10 != 0) {
    let d: i32 = n / pow10;
    Core.PrintChar(((d + 0x30) as u8) as char);
    n = n % pow10;
    pow10 = pow10 / 10;
  }
}

fn PrintInt(n_val: i32) {
  PrintIntNoNewline(n_val);
  Core.PrintChar('\n');
}

fn PeekChar() -> i32 {
  var next: i32 = ReadChar();
  UnreadChar(next);
  return next;
}

fn ConsumeChar(c: i32) -> bool {
  var next: i32 = ReadChar();
  if (next != c) {
    UnreadChar(next);
    return false;
  }
  return true;
}

fn SkipSpaces() -> bool {
  var skipped_any_spaces: bool = false;
  while (ConsumeChar(0x20)) {
    skipped_any_spaces = true;
  }
  return skipped_any_spaces;
}

fn SkipNewline() -> bool {
  // Optional carriage return.
  ConsumeChar(0x0D);
  // Newline.
  return ConsumeChar(0x0A);
}

fn SkipNChars(n: i32) -> bool {
  for (_: i32 in Core.Range(n)) {
    if (ReadChar() == Core.EOF()) {
      return false;
    }
  }
  return true;
}
