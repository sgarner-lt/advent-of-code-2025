import day05
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// Test range parsing: "3-5" should parse to #(3, 5)
pub fn parse_range_simple_test() {
  day05.parse_range("3-5")
  |> should.equal(Ok(#(3, 5)))
}

// Test range parsing with larger numbers
pub fn parse_range_large_numbers_test() {
  day05.parse_range("20362219004570-27230899748695")
  |> should.equal(Ok(#(20_362_219_004_570, 27_230_899_748_695)))
}

// Test range parsing with whitespace
pub fn parse_range_with_whitespace_test() {
  day05.parse_range("  10-14  ")
  |> should.equal(Ok(#(10, 14)))
}

// Test range parsing with invalid format
pub fn parse_range_invalid_format_test() {
  day05.parse_range("invalid")
  |> should.be_error()
}

// Test range parsing with non-numeric values
pub fn parse_range_non_numeric_test() {
  day05.parse_range("a-b")
  |> should.be_error()
}

// Test ID freshness checking: ID 5 is in range #(3, 5)
pub fn is_fresh_id_in_range_test() {
  let ranges = [#(3, 5)]
  day05.is_fresh(5, ranges)
  |> should.be_true()
}

// Test ID freshness checking: ID 8 is not in range #(3, 5)
pub fn is_fresh_id_not_in_range_test() {
  let ranges = [#(3, 5)]
  day05.is_fresh(8, ranges)
  |> should.be_false()
}

// Test ID at range start boundary
pub fn is_fresh_at_start_boundary_test() {
  let ranges = [#(3, 5)]
  day05.is_fresh(3, ranges)
  |> should.be_true()
}

// Test ID at range end boundary
pub fn is_fresh_at_end_boundary_test() {
  let ranges = [#(3, 5)]
  day05.is_fresh(5, ranges)
  |> should.be_true()
}

// Test ID below range
pub fn is_fresh_below_range_test() {
  let ranges = [#(3, 5)]
  day05.is_fresh(2, ranges)
  |> should.be_false()
}

// Test ID above range
pub fn is_fresh_above_range_test() {
  let ranges = [#(3, 5)]
  day05.is_fresh(6, ranges)
  |> should.be_false()
}

// Test overlapping ranges: ID 17 is fresh if in multiple ranges
pub fn is_fresh_overlapping_ranges_test() {
  let ranges = [#(16, 20), #(12, 18)]
  day05.is_fresh(17, ranges)
  |> should.be_true()
}

// Test ID in multiple non-overlapping ranges
pub fn is_fresh_multiple_ranges_test() {
  let ranges = [#(3, 5), #(10, 14), #(16, 20)]
  day05.is_fresh(11, ranges)
  |> should.be_true()
}

// Test ID not in any range
pub fn is_fresh_not_in_any_range_test() {
  let ranges = [#(3, 5), #(10, 14), #(16, 20)]
  day05.is_fresh(8, ranges)
  |> should.be_false()
}

// Test sample input: Expected output part1=3
pub fn solve_sample_input_test() {
  let input = "3-5
10-14
16-20
12-18

1
5
8
11
17
32"

  day05.solve(input)
  |> should.equal(Ok(3))
}

// Test with empty ranges
pub fn solve_empty_ranges_test() {
  let input = "

1
5"

  day05.solve(input)
  |> should.equal(Ok(0))
}

// Test with no IDs
pub fn solve_no_ids_test() {
  let input = "3-5
10-14

"

  day05.solve(input)
  |> should.equal(Ok(0))
}

// Test all IDs are fresh
pub fn solve_all_fresh_test() {
  let input = "1-100

5
10
50"

  day05.solve(input)
  |> should.equal(Ok(3))
}

// Test no IDs are fresh
pub fn solve_none_fresh_test() {
  let input = "10-20

1
2
30"

  day05.solve(input)
  |> should.equal(Ok(0))
}
