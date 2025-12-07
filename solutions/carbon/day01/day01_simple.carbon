// Advent of Code 2025 - Day 01 - Dial Rotation
// Single-file version without external library dependencies

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

fn ReadInt(p: i32*) -> bool {
  var read_any_digits: bool = false;
  *p = 0;
  var is_negative: bool = false;
  var c: i32 = ReadChar();
  if (c == 0x2D) {
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
  var n: i32 = n_val;
  if (n < 0) {
    Core.PrintChar('-');
    n = -n;
  }
  var pow10: i32 = 1;
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

class Rotation {
  var is_left: bool;
  var distance: i32;
}

fn ParseRotation(p: Rotation*) -> bool {
  var c: i32 = ReadChar();
  while (c == 0x20 or c == 0x09 or c == 0x0D or c == 0x0A) {
    if (c == Core.EOF()) {
      return false;
    }
    c = ReadChar();
  }
  if (c == Core.EOF()) {
    return false;
  }
  if (c == 0x4C) {
    (*p).is_left = true;
  } else if (c == 0x52) {
    (*p).is_left = false;
  } else {
    return false;
  }
  var distance: i32 = 0;
  if (not ReadInt(&distance)) {
    return false;
  }
  (*p).distance = distance;
  return true;
}

fn RotateDial(position: i32, rotation: Rotation) -> i32 {
  var new_position: i32 = position;
  if (rotation.is_left) {
    new_position = position - rotation.distance;
  } else {
    new_position = position + rotation.distance;
  }
  new_position = new_position % 100;
  if (new_position < 0) {
    new_position = new_position + 100;
  }
  return new_position;
}

fn CountZeroCrossings(position: i32, rotation: Rotation) -> i32 {
  var amount: i32 = rotation.distance;
  if (amount == 0) {
    return 0;
  }
  var complete_circles: i32 = amount / 100;
  var remainder: i32 = amount % 100;
  var crossings: i32 = complete_circles;
  if (not rotation.is_left) {
    var distance_to_zero: i32 = 100 - position;
    if (remainder >= distance_to_zero) {
      crossings = crossings + 1;
    }
  } else {
    var distance_to_zero: i32 = position;
    if (position > 0 and remainder >= distance_to_zero) {
      crossings = crossings + 1;
    }
  }
  return crossings;
}

fn Run() {
  var position: i32 = 50;
  var part1_count: i32 = 0;
  var part2_count: i32 = 0;
  var rotation: Rotation;
  while (ParseRotation(&rotation)) {
    part2_count = part2_count + CountZeroCrossings(position, rotation);
    position = RotateDial(position, rotation);
    if (position == 0) {
      part1_count = part1_count + 1;
    }
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
  PrintIntNoNewline(part1_count);
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
  PrintIntNoNewline(part2_count);
  Core.PrintChar('}');
  Core.PrintChar('\n');
}
