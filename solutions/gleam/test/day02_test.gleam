import day02
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// Task 3.1: Pattern Detection Unit Tests

/// Test single repeated digit - "11" should be invalid (single digit "1" repeated twice)
pub fn test_single_repeated_digit_11_test() {
  day02.is_invalid_id("11")
  |> should.equal(True)
}

/// Test another single repeated digit - "22" should be invalid
pub fn test_single_repeated_digit_22_test() {
  day02.is_invalid_id("22")
  |> should.equal(True)
}

/// Test two-digit repeated pattern - "1212" should be invalid (pattern "12" repeated twice)
pub fn test_two_digit_repeated_pattern_test() {
  day02.is_invalid_id("1212")
  |> should.equal(True)
}

/// Test longer repeated pattern - "123123" should be invalid (pattern "123" repeated twice)
pub fn test_longer_repeated_pattern_test() {
  day02.is_invalid_id("123123")
  |> should.equal(True)
}

/// Test valid number with no repetition - "123456" should be valid
pub fn test_valid_no_repetition_test() {
  day02.is_invalid_id("123456")
  |> should.equal(False)
}

/// Test single digit number - "1" should be valid (odd length, cannot split in half)
pub fn test_single_digit_valid_test() {
  day02.is_invalid_id("1")
  |> should.equal(False)
}

/// Test another single digit - "5" should be valid
pub fn test_single_digit_5_valid_test() {
  day02.is_invalid_id("5")
  |> should.equal(False)
}

/// Test mid-length pattern - "12345656" should be valid (first half "1234" != second half "5656")
pub fn test_mid_length_pattern_test() {
  day02.is_invalid_id("12345656")
  |> should.equal(False)
}

/// Test partial match - "123412" should be valid (first half "123" != second half "412")
pub fn test_partial_match_test() {
  day02.is_invalid_id("123412")
  |> should.equal(False)
}

/// Test multiple overlapping patterns - "121212" should be valid (first half "121" != second half "212")
pub fn test_multiple_overlapping_patterns_test() {
  day02.is_invalid_id("121212")
  |> should.equal(False)
}

// Task 3.2: Range-based Unit Tests

/// Test range 11-22 should return 11 + 22 = 33
pub fn test_range_11_to_22_test() {
  day02.process_range(11, 22)
  |> should.equal(33)
}

/// Test range 95-115 should return 99
pub fn test_range_95_to_115_test() {
  day02.process_range(95, 115)
  |> should.equal(99)
}

/// Test range 998-1012 should return 1010
pub fn test_range_998_to_1012_test() {
  day02.process_range(998, 1012)
  |> should.equal(1010)
}

/// Test range 1188511880-1188511890 should return 1188511885
pub fn test_range_1188511880_to_1188511890_test() {
  day02.process_range(1_188_511_880, 1_188_511_890)
  |> should.equal(1_188_511_885)
}

/// Test range 222220-222224 should return 222222
pub fn test_range_222220_to_222224_test() {
  day02.process_range(222_220, 222_224)
  |> should.equal(222_222)
}

/// Test range 1698522-1698528 should return 0 (no invalid IDs)
pub fn test_range_1698522_to_1698528_no_invalid_test() {
  day02.process_range(1_698_522, 1_698_528)
  |> should.equal(0)
}

/// Test range 446443-446449 should return 446446
pub fn test_range_446443_to_446449_test() {
  day02.process_range(446_443, 446_449)
  |> should.equal(446_446)
}

/// Test range 38593856-38593862 should return 38593859
pub fn test_range_38593856_to_38593862_test() {
  day02.process_range(38_593_856, 38_593_862)
  |> should.equal(38_593_859)
}

// Additional Helper Tests

/// Test parsing a single range
pub fn test_parse_single_range_test() {
  day02.parse_ranges("11-22")
  |> should.equal(Ok([#(11, 22)]))
}

/// Test parsing multiple ranges
pub fn test_parse_multiple_ranges_test() {
  day02.parse_ranges("11-22,95-115")
  |> should.equal(Ok([#(11, 22), #(95, 115)]))
}

/// Test parsing ranges with whitespace
pub fn test_parse_with_whitespace_test() {
  day02.parse_ranges(" 11-22 , 95-115 ")
  |> should.equal(Ok([#(11, 22), #(95, 115)]))
}

/// Test solve function with simple example
pub fn test_solve_simple_example_test() {
  case day02.solve("11-22") {
    Ok(sum) -> sum |> should.equal(33)
    Error(_) -> should.fail()
  }
}

// Additional verification tests for specific numbers

/// Test specific invalid IDs from problem statement
pub fn test_specific_invalid_ids_test() {
  // From problem: 55, 6464, 123123 should be invalid
  day02.is_invalid_id("55") |> should.equal(True)
  day02.is_invalid_id("6464") |> should.equal(True)
  day02.is_invalid_id("123123") |> should.equal(True)
}

/// Test specific invalid IDs from ranges
pub fn test_range_specific_invalid_ids_test() {
  day02.is_invalid_id("99") |> should.equal(True)
  day02.is_invalid_id("1010") |> should.equal(True)
  day02.is_invalid_id("222222") |> should.equal(True)
  day02.is_invalid_id("446446") |> should.equal(True)
}

// Integration Tests (Task 3.2 continuation)

/// Test integration with sample input from problem statement
pub fn test_integration_sample_input_test() {
  let input =
    "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

  case day02.solve(input) {
    Ok(sum) -> sum |> should.equal(1_227_775_554)
    Error(_) -> should.fail()
  }
}

/// Test integration with range that has no invalid IDs
pub fn test_integration_range_with_no_invalid_ids_test() {
  case day02.solve("1698522-1698528") {
    Ok(sum) -> sum |> should.equal(0)
    Error(_) -> should.fail()
  }
}

/// Test integration with multiple ranges and verify sum
pub fn test_integration_multiple_ranges_sum_test() {
  // Should be 11 + 22 + 99 = 132
  case day02.solve("11-22,95-115") {
    Ok(sum) -> sum |> should.equal(132)
    Error(_) -> should.fail()
  }
}

// Task 4.1: Integration Tests - Cross-validation with Rust

/// Test integration with sample input file - verify exact match with expected output
/// This test validates the Gleam implementation produces the same result as documented
/// Expected output from sample: 1227775554
pub fn test_integration_sample_file_matches_expected_test() {
  let sample_input =
    "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

  case day02.solve(sample_input) {
    Ok(sum) -> {
      // This MUST match the expected sample output
      sum |> should.equal(1_227_775_554)
    }
    Error(_) -> {
      // If parsing or solving fails, the test should fail
      should.fail()
    }
  }
}

/// Test integration with example ranges - verify Gleam matches Rust implementation
/// This tests a smaller subset to validate correctness of the algorithm
pub fn test_integration_example_ranges_match_rust_test() {
  // Test example: "11-22,95-115" should produce sum of 11 + 22 + 99 = 132
  case day02.solve("11-22,95-115") {
    Ok(sum) -> sum |> should.equal(132)
    Error(_) -> should.fail()
  }
}

/// Test integration with single range example - verify edge case handling
/// Test a range that has exactly one invalid ID to ensure accurate detection
pub fn test_integration_single_invalid_id_test() {
  // Range 998-1012 contains only one invalid ID: 1010
  case day02.solve("998-1012") {
    Ok(sum) -> sum |> should.equal(1010)
    Error(_) -> should.fail()
  }
}
