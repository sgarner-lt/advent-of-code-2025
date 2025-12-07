// Advent of Code 2025 - Day 02 - Product ID Validation
// Part 1: Count IDs that are exactly split in half with both halves identical
// Part 2: Count IDs that are any pattern repeated 2 or more times

import Core library "io";
import library "../common/io_utils";

// Maximum length for a product ID
let MAX_ID_LENGTH: i32 = 100;

// Read a product ID (sequence of digits) from stdin
// Returns the length of the ID (0 if EOF or error)
fn ReadProductId(buffer: array(i32, 100)*) -> i32 {
  var length: i32 = 0;
  var c: i32 = ReadChar();

  // Skip whitespace
  while (c == 0x20 or c == 0x09 or c == 0x0D or c == 0x0A) {
    if (c == Core.EOF()) {
      return 0;
    }
    c = ReadChar();
  }

  // Check for EOF
  if (c == Core.EOF()) {
    return 0;
  }

  // Read digits
  while (c >= 0x30 and c <= 0x39) {  // '0' to '9'
    if (length < MAX_ID_LENGTH) {
      (*buffer)[length] = c;
      length = length + 1;
    }
    c = ReadChar();
    if (c == Core.EOF() or c == 0x0A or c == 0x0D) {
      break;
    }
  }

  return length;
}

// Check if two halves of the buffer are identical
fn AreHalvesEqual(buffer: array(i32, 100)*, length: i32) -> bool {
  // Must have even length
  if (length % 2 != 0) {
    return false;
  }

  var half: i32 = length / 2;
  var i: i32 = 0;
  while (i < half) {
    if ((*buffer)[i] != (*buffer)[half + i]) {
      return false;
    }
    i = i + 1;
  }
  return true;
}

// Check if the buffer is a repeated pattern of given pattern_length
fn IsRepeatedPattern(buffer: array(i32, 100)*, length: i32, pattern_length: i32) -> bool {
  // Length must be evenly divisible by pattern length
  if (length % pattern_length != 0) {
    return false;
  }

  var repetitions: i32 = length / pattern_length;
  if (repetitions < 2) {
    return false;
  }

  // Check if each repetition matches the first pattern
  var rep: i32 = 1;
  while (rep < repetitions) {
    var i: i32 = 0;
    while (i < pattern_length) {
      if ((*buffer)[i] != (*buffer)[rep * pattern_length + i]) {
        return false;
      }
      i = i + 1;
    }
    rep = rep + 1;
  }

  return true;
}

// Part 1: Check if ID is exactly split in half with both halves identical
fn IsInvalidPart1(buffer: array(i32, 100)*, length: i32) -> bool {
  return AreHalvesEqual(buffer, length);
}

// Part 2: Check if ID is any pattern repeated 2+ times
fn IsInvalidPart2(buffer: array(i32, 100)*, length: i32) -> bool {
  // Try each possible pattern length from 1 to length/2
  var pattern_length: i32 = 1;
  while (pattern_length <= length / 2) {
    if (IsRepeatedPattern(buffer, length, pattern_length)) {
      return true;
    }
    pattern_length = pattern_length + 1;
  }
  return false;
}

fn Run() {
  var part1_count: i32 = 0;
  var part2_count: i32 = 0;
  var buffer: array(i32, 100);
  var length: i32 = 0;

  // Read all product IDs from stdin
  length = ReadProductId(&buffer);
  while (length > 0) {
    // Part 1: count IDs with identical halves
    if (IsInvalidPart1(&buffer, length)) {
      part1_count = part1_count + 1;
    }

    // Part 2: count IDs with any repeated pattern
    if (IsInvalidPart2(&buffer, length)) {
      part2_count = part2_count + 1;
    }

    length = ReadProductId(&buffer);
  }

  // Output JSON format: {"part1": N, "part2": N}
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
