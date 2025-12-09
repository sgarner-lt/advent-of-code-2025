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

// Test range parsing with invalid format (start > end)
pub fn parse_range_invalid_start_end_test() {
  day05.parse_range("5-3")
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

// Test overlapping ranges: ID 17 is fresh if in multiple ranges
pub fn is_fresh_overlapping_ranges_test() {
  let ranges = [#(16, 20), #(12, 18)]
  day05.is_fresh(17, ranges)
  |> should.be_true()
}

// Part 2 Tests: count_unique_ids

// Test counting unique IDs in a single range
pub fn count_unique_ids_single_range_test() {
  let ranges = [#(3, 5)]
  day05.count_unique_ids(ranges)
  |> should.equal(3)
  // IDs: 3, 4, 5
}

// Test counting unique IDs in multiple non-overlapping ranges
pub fn count_unique_ids_multiple_ranges_test() {
  let ranges = [#(3, 5), #(10, 14)]
  day05.count_unique_ids(ranges)
  |> should.equal(8)
  // IDs: 3, 4, 5, 10, 11, 12, 13, 14
}

// Test counting unique IDs in overlapping ranges
pub fn count_unique_ids_overlapping_ranges_test() {
  let ranges = [#(12, 18), #(16, 20)]
  day05.count_unique_ids(ranges)
  |> should.equal(9)
  // IDs: 12, 13, 14, 15, 16, 17, 18, 19, 20 (no duplicates)
}

// Test counting unique IDs from sample input
pub fn count_unique_ids_sample_ranges_test() {
  let ranges = [#(3, 5), #(10, 14), #(16, 20), #(12, 18)]
  day05.count_unique_ids(ranges)
  |> should.equal(14)
  // IDs: 3, 4, 5, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
}

// Test counting unique IDs with empty list
pub fn count_unique_ids_empty_test() {
  let ranges = []
  day05.count_unique_ids(ranges)
  |> should.equal(0)
}

// Test counting unique IDs with single-point range
pub fn count_unique_ids_single_point_test() {
  let ranges = [#(5, 5)]
  day05.count_unique_ids(ranges)
  |> should.equal(1)
  // Only ID 5
}

// Test sample input: Expected output part1=3, part2=14
pub fn solve_sample_input_test() {
  let input =
    "3-5
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
  |> should.equal(Ok(#(3, 14)))
}

// Test with no IDs - part1=0, but part2 counts unique IDs in ranges
pub fn solve_no_ids_test() {
  let input =
    "3-5
10-14

"

  day05.solve(input)
  |> should.equal(Ok(#(0, 8)))
  // Part 1: 0 (no IDs to check)
  // Part 2: 8 (ranges 3-5 and 10-14 contain 8 unique IDs)
}

// Test all IDs are fresh
pub fn solve_all_fresh_test() {
  let input =
    "1-100

5
10
50"

  day05.solve(input)
  |> should.equal(Ok(#(3, 100)))
  // Part 1: 3 (all IDs are fresh)
  // Part 2: 100 (range 1-100 contains 100 unique IDs)
}

// Test no IDs are fresh
pub fn solve_none_fresh_test() {
  let input =
    "10-20

1
2
30"

  day05.solve(input)
  |> should.equal(Ok(#(0, 11)))
  // Part 1: 0 (no IDs are fresh)
  // Part 2: 11 (range 10-20 contains 11 unique IDs)
}
