import day03
import gleam/list
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// ========== Part 1 Tests (Existing) ==========

// Test extracting pairs from a simple string "987"
pub fn extract_pairs_simple_test() {
  let pairs = day03.extract_pairs("987")
  // Should contain 98 (positions 0,1), 97 (positions 0,2), 87 (positions 1,2)
  list.contains(pairs, 98) |> should.be_true()
  list.contains(pairs, 97) |> should.be_true()
  list.contains(pairs, 87) |> should.be_true()
}

// Test finding maximum from a list of integers
pub fn find_max_from_list_test() {
  let pairs = [98, 87, 76, 65, 54, 43, 32, 21, 11]
  day03.find_max(pairs)
  |> should.equal(Ok(98))
}

// Test processing sample input line 1
pub fn process_line1_test() {
  let line = "987654321111111"
  let pairs = day03.extract_pairs(line)
  let max = day03.find_max(pairs)
  max |> should.equal(Ok(98))
}

// Test processing sample input line 2
pub fn process_line2_test() {
  let line = "811111111111119"
  let pairs = day03.extract_pairs(line)
  let max = day03.find_max(pairs)
  max |> should.equal(Ok(89))
}

// Test processing sample input line 3
pub fn process_line3_test() {
  let line = "234234234234278"
  let pairs = day03.extract_pairs(line)
  let max = day03.find_max(pairs)
  max |> should.equal(Ok(78))
}

// Test processing sample input line 4
pub fn process_line4_test() {
  let line = "818181911112111"
  let pairs = day03.extract_pairs(line)
  let max = day03.find_max(pairs)
  max |> should.equal(Ok(92))
}

// Test empty list returns error
pub fn find_max_empty_list_test() {
  day03.find_max([])
  |> should.be_error()
}

// ========== Part 2 Tests (New) ==========

// Test extract_max_k_digits on line 1: "987654321111111" yields 987654321111
pub fn extract_max_k_digits_line1_test() {
  let line = "987654321111111"
  day03.extract_max_k_digits(line, 12)
  |> should.equal(Ok(987_654_321_111))
}

// Test extract_max_k_digits on line 2: "811111111111119" yields 811111111119
pub fn extract_max_k_digits_line2_test() {
  let line = "811111111111119"
  day03.extract_max_k_digits(line, 12)
  |> should.equal(Ok(811_111_111_119))
}

// Test extract_max_k_digits on line 3: "234234234234278" yields 434234234278
pub fn extract_max_k_digits_line3_test() {
  let line = "234234234234278"
  day03.extract_max_k_digits(line, 12)
  |> should.equal(Ok(434_234_234_278))
}

// Test extract_max_k_digits on line 4: "818181911112111" yields 888911112111
pub fn extract_max_k_digits_line4_test() {
  let line = "818181911112111"
  day03.extract_max_k_digits(line, 12)
  |> should.equal(Ok(888_911_112_111))
}

// ========== Integration Tests ==========

// Test complete solve function with sample input returns both parts
pub fn solve_sample_input_dual_output_test() {
  let input = "987654321111111\n811111111111119\n234234234234278\n818181911112111"
  day03.solve(input)
  |> should.equal(Ok(#(357, 3_121_910_778_619)))
}

// Test Part 1 remains unchanged
pub fn solve_part1_unchanged_test() {
  let input = "987654321111111\n811111111111119\n234234234234278\n818181911112111"
  case day03.solve(input) {
    Ok(#(part1, _)) -> part1 |> should.equal(357)
    Error(_) -> should.fail()
  }
}

// Test Part 2 produces correct sum
pub fn solve_part2_correct_test() {
  let input = "987654321111111\n811111111111119\n234234234234278\n818181911112111"
  case day03.solve(input) {
    Ok(#(_, part2)) -> part2 |> should.equal(3_121_910_778_619)
    Error(_) -> should.fail()
  }
}
