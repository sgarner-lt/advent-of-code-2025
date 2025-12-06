import day03
import gleam/list
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

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

// Test complete solve function with sample input
pub fn solve_sample_input_test() {
  let input = "987654321111111\n811111111111119\n234234234234278\n818181911112111"
  day03.solve(input)
  |> should.equal(Ok(357))
}

// Test empty list returns error
pub fn find_max_empty_list_test() {
  day03.find_max([])
  |> should.be_error()
}
