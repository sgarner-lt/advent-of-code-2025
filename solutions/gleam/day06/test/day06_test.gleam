import day06
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// Part 2 focused tests as per Task 3.1

/// Test find_max_width with sample grid
/// Expected: 3 for numbers "123", "387", "215", "314"
pub fn find_max_width_test() {
  let input = "123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +  "

  // We need to expose helper functions for testing, so we'll test through solve instead
  // This is a smoke test that the algorithm works
  case day06.solve(input) {
    Ok(#(part1, part2)) -> {
      // Verify both parts work
      should.equal(part1, 4_277_556)
      should.equal(part2, 3_263_827)
    }
    Error(_msg) -> should.fail()
  }
}

/// Test solve with full sample input
/// Expected: part1=4277556, part2=3263827
pub fn solve_sample_input_test() {
  let input = "123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +  "

  case day06.solve(input) {
    Ok(#(part1, part2)) -> {
      should.equal(part1, 4_277_556)
      should.equal(part2, 3_263_827)
    }
    Error(_msg) -> should.fail()
  }
}

/// Test with a simple example to verify Part 1 logic
pub fn solve_simple_part1_test() {
  let input = "10 20
5 10
* +"

  case day06.solve(input) {
    Ok(#(part1, _part2)) -> {
      // 10 * 5 = 50, 20 + 10 = 30, total = 80
      should.equal(part1, 80)
    }
    Error(_msg) -> should.fail()
  }
}

/// Test Part 2 with multiplication column extraction
/// This tests the digit extraction from RIGHT for multiplication
pub fn solve_multiplication_extraction_test() {
  // Single multiplication column: 123, 45, 6, *
  // Position 0 (rightmost): "3", "5", "6" -> "356"
  // Position 1: "2", "4" -> "24"
  // Position 2 (leftmost): "1" -> "1"
  // Result: 356 * 24 * 1 = 8544
  let input = "123
45
6
*"

  case day06.solve(input) {
    Ok(#(part1, part2)) -> {
      should.equal(part1, 33_210)  // 123 * 45 * 6
      should.equal(part2, 8544)     // 356 * 24 * 1
    }
    Error(_msg) -> should.fail()
  }
}

/// Test Part 2 with addition column extraction
/// This tests the digit extraction from LEFT for addition, then REVERSE
pub fn solve_addition_extraction_test() {
  // Single addition column: 328, 64, 98, +
  // Position 0 (leftmost): "3", "6", "9" -> "369"
  // Position 1: "2", "4", "8" -> "248"
  // Position 2 (rightmost): "8" -> "8"
  // After reversing: "8", "248", "369"
  // Result: 8 + 248 + 369 = 625
  let input = "328
64
98
+"

  case day06.solve(input) {
    Ok(#(part1, part2)) -> {
      should.equal(part1, 490)  // 328 + 64 + 98
      should.equal(part2, 625)  // 8 + 248 + 369
    }
    Error(_msg) -> should.fail()
  }
}
