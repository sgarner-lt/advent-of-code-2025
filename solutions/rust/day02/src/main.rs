use std::io::{self, Read};

fn main() {
    // Read input from stdin
    let mut input = String::new();
    io::stdin()
        .read_to_string(&mut input)
        .expect("Failed to read from stdin");

    let (part1_result, part2_result) = solve(&input);

    // Output JSON format for testing framework
    println!(
        "{{\"part1\": {}, \"part2\": {}}}",
        part1_result,
        match part2_result {
            Some(val) => val.to_string(),
            None => "null".to_string(),
        }
    );
}

/// Checks if a product ID string is made only of some sequence of digits repeated twice.
/// Returns true if invalid (entire number is pattern repeated exactly twice), false if valid.
///
/// The number must be splittable into two equal halves that are identical.
/// For example: 55 (5 repeated), 6464 (64 repeated), 123123 (123 repeated).
///
/// Algorithm:
/// - Check if the length is even (must be for exact split)
/// - Split the string in half
/// - Compare the two halves - if equal, it's invalid
///
/// # Examples
/// ```
/// assert_eq!(is_invalid_id("11"), true);      // "1" repeated
/// assert_eq!(is_invalid_id("1212"), true);    // "12" repeated
/// assert_eq!(is_invalid_id("123456"), false); // not a repeated pattern
/// assert_eq!(is_invalid_id("123412"), false); // not split in half
/// ```
fn is_invalid_id(number_str: &str) -> bool {
    let len = number_str.len();

    // Must have even length to split in half
    if len % 2 != 0 {
        return false;
    }

    let half = len / 2;
    let first_half = &number_str[..half];
    let second_half = &number_str[half..];

    first_half == second_half
}

/// Checks if a product ID string is made only of some sequence of digits repeated 2 or more times.
/// Returns true if invalid (entire number is pattern repeated 2+ times), false if valid.
///
/// The number can be split into any equal-length pattern repeated at least twice.
/// For example: 111 (1 repeated 3 times), 565656 (56 repeated 3 times), 2121212121 (21 repeated 5 times).
///
/// Algorithm:
/// - For each possible pattern length from 1 to length/2
/// - Check if length is evenly divisible by pattern length
/// - Extract the first N characters as the pattern
/// - Verify entire string equals pattern repeated length/N times
/// - Return true on first match (short-circuit optimization)
///
/// # Examples
/// ```
/// assert_eq!(is_invalid_id_part2("111"), true);        // "1" repeated 3 times
/// assert_eq!(is_invalid_id_part2("565656"), true);     // "56" repeated 3 times
/// assert_eq!(is_invalid_id_part2("123456"), false);    // not a repeated pattern
/// assert_eq!(is_invalid_id_part2("11"), true);         // "1" repeated 2 times (still invalid)
/// ```
fn is_invalid_id_part2(number_str: &str) -> bool {
    let len = number_str.len();

    // Check each possible pattern length from 1 to length/2
    for pattern_length in 1..=(len / 2) {
        // Only check if length is evenly divisible by pattern length
        if len % pattern_length != 0 {
            continue;
        }

        // Extract the pattern (first N characters)
        let pattern = &number_str[..pattern_length];

        // Calculate how many repetitions we need
        let repetitions = len / pattern_length;

        // Build the expected string by repeating the pattern
        let expected = pattern.repeat(repetitions);

        // If the expected matches the original, it's invalid
        if expected == number_str {
            return true;
        }
    }

    false
}

/// Parses comma-separated ranges from input string.
/// Returns a vector of (start, end) tuples representing inclusive ranges.
///
/// # Examples
/// ```
/// let ranges = parse_ranges("11-22,95-115").unwrap();
/// assert_eq!(ranges, vec![(11, 22), (95, 115)]);
/// ```
fn parse_ranges(input: &str) -> Result<Vec<(i64, i64)>, String> {
    let input = input.trim();
    if input.is_empty() {
        return Err("Empty input".to_string());
    }

    let mut ranges = Vec::new();

    for range_str in input.split(',') {
        let range_str = range_str.trim();
        if range_str.is_empty() {
            continue;
        }

        let parts: Vec<&str> = range_str.split('-').collect();
        if parts.len() != 2 {
            return Err(format!("Invalid range format: {}", range_str));
        }

        let start = parts[0]
            .trim()
            .parse::<i64>()
            .map_err(|e| format!("Invalid start number '{}': {}", parts[0], e))?;

        let end = parts[1]
            .trim()
            .parse::<i64>()
            .map_err(|e| format!("Invalid end number '{}': {}", parts[1], e))?;

        ranges.push((start, end));
    }

    Ok(ranges)
}

/// Processes a range of numbers and returns a vector of invalid IDs found.
/// An ID is invalid if it's made only of some sequence repeated twice.
///
/// # Arguments
/// * `start` - Starting number (inclusive)
/// * `end` - Ending number (inclusive)
///
/// # Returns
/// Vector of invalid product IDs found in the range
fn process_range(start: i64, end: i64) -> Vec<i64> {
    let mut invalid_ids = Vec::new();

    for num in start..=end {
        let num_str = num.to_string();
        if is_invalid_id(&num_str) {
            invalid_ids.push(num);
        }
    }

    invalid_ids
}

/// Processes a range of numbers and returns the sum of invalid IDs found (Part 2).
/// An ID is invalid if it's made only of some sequence repeated 2 or more times.
///
/// # Arguments
/// * `start` - Starting number (inclusive)
/// * `end` - Ending number (inclusive)
///
/// # Returns
/// Sum of all invalid product IDs found in the range
fn process_range_part2(start: i64, end: i64) -> i64 {
    let mut sum = 0i64;

    for num in start..=end {
        let num_str = num.to_string();
        if is_invalid_id_part2(&num_str) {
            sum += num;
        }
    }

    sum
}

/// Main solution function that processes all ranges and computes the sum of invalid IDs.
///
/// # Arguments
/// * `input` - Input string containing comma-separated ranges
///
/// # Returns
/// Tuple of (part1_sum, Some(part2_sum))
fn solve(input: &str) -> (i64, Option<i64>) {
    let ranges = match parse_ranges(input) {
        Ok(r) => r,
        Err(e) => {
            eprintln!("Error parsing ranges: {}", e);
            return (0, None);
        }
    };

    let mut part1_sum = 0i64;
    let mut part2_sum = 0i64;

    for (start, end) in &ranges {
        let invalid_ids = process_range(*start, *end);
        part1_sum += invalid_ids.iter().sum::<i64>();
    }

    for (start, end) in ranges {
        part2_sum += process_range_part2(start, end);
    }

    (part1_sum, Some(part2_sum))
}

#[cfg(test)]
mod tests {
    use super::*;

    // Task 1.1: Pattern Detection Unit Tests

    #[test]
    fn test_single_repeated_digit() {
        // Test "11" -> invalid (single digit "1" repeated twice)
        assert_eq!(is_invalid_id("11"), true);
        // Additional test for "22"
        assert_eq!(is_invalid_id("22"), true);
    }

    #[test]
    fn test_two_digit_repeated_pattern() {
        // Test "1212" -> invalid (pattern "12" repeated twice)
        assert_eq!(is_invalid_id("1212"), true);
    }

    #[test]
    fn test_longer_repeated_pattern() {
        // Test "123123" -> invalid (pattern "123" repeated twice)
        assert_eq!(is_invalid_id("123123"), true);
    }

    #[test]
    fn test_valid_no_repetition() {
        // Test "123456" -> valid (not a repeated pattern)
        assert_eq!(is_invalid_id("123456"), false);
    }

    #[test]
    fn test_single_digit_valid() {
        // Test "1" -> valid (odd length, cannot split in half)
        assert_eq!(is_invalid_id("1"), false);
        // Test "5" -> valid
        assert_eq!(is_invalid_id("5"), false);
    }

    #[test]
    fn test_mid_length_pattern() {
        // Test "12345656" -> invalid ("5656" as second half equals "5656" split? No.)
        // Actually, 12345656 split in half is "1234" and "5656" - not equal
        assert_eq!(is_invalid_id("12345656"), false);
    }

    #[test]
    fn test_partial_match() {
        // Test "123412" -> valid (not split exactly in half: "123" != "412")
        assert_eq!(is_invalid_id("123412"), false);
    }

    #[test]
    fn test_multiple_overlapping_patterns() {
        // Test "121212" -> invalid ("121" == "212"? No, "121" != "212")
        // Wait, split "121212" in half: "121" and "212" - not equal, so valid!
        // But this should be invalid per the requirements...
        // Let me check: "121212" is "12" repeated 3 times, not 2 times
        // For a pattern repeated exactly twice: we'd need the entire number to be split in half
        // Actually, per problem "made only of some sequence of digits repeated twice"
        // This means the sequence can be of any length, but must repeat exactly twice
        // So "121212" could be interpreted as "121" + "212" (not equal) - valid
        // OR as containing "12" repeated (but that's NOT the entire number)
        // Based on examples: 55, 6464, 123123 - all split exactly in half
        // So "121212" = "121" + "212" which are NOT equal, so this is actually VALID
        // But wait, let me reconsider... NO, the problem says "repeated twice"
        // I think I need to check if ANY starting position gives us a pattern repeated exactly twice
        // Let me re-read requirements more carefully...
        assert_eq!(is_invalid_id("121212"), false);
    }

    // Part 2 Pattern Detection Tests (Task 1.1)

    #[test]
    fn test_part2_single_char_three_reps() {
        // Test "111" -> "1" repeated 3 times (invalid in Part 2)
        assert_eq!(is_invalid_id_part2("111"), true);
        // Test "999" -> "9" repeated 3 times (invalid in Part 2)
        assert_eq!(is_invalid_id_part2("999"), true);
    }

    #[test]
    fn test_part2_multi_char_three_reps() {
        // Test "565656" -> "56" repeated 3 times (invalid in Part 2)
        assert_eq!(is_invalid_id_part2("565656"), true);
        // Test "824824824" -> "824" repeated 3 times (invalid in Part 2)
        assert_eq!(is_invalid_id_part2("824824824"), true);
    }

    #[test]
    fn test_part2_many_repetitions() {
        // Test "2121212121" -> "21" repeated 5 times (invalid in Part 2)
        assert_eq!(is_invalid_id_part2("2121212121"), true);
    }

    #[test]
    fn test_part2_edge_cases() {
        // Test "11" -> still invalid in Part 2 (2 repetitions)
        assert_eq!(is_invalid_id_part2("11"), true);
        // Test "123456" -> still valid in Part 2 (no repeating pattern)
        assert_eq!(is_invalid_id_part2("123456"), false);
    }

    #[test]
    fn test_part2_includes_part1_invalid() {
        // All Part 1 invalid IDs should remain invalid in Part 2
        assert_eq!(is_invalid_id_part2("11"), true);
        assert_eq!(is_invalid_id_part2("1212"), true);
        assert_eq!(is_invalid_id_part2("123123"), true);
        assert_eq!(is_invalid_id_part2("99"), true);
        assert_eq!(is_invalid_id_part2("1010"), true);
    }

    // Task 1.2: Range-based Unit Tests

    #[test]
    fn test_range_11_to_22() {
        // Range 11-22 should return [11, 22] (two invalid IDs)
        let invalid_ids = process_range(11, 22);
        assert_eq!(invalid_ids, vec![11, 22]);
    }

    #[test]
    fn test_range_95_to_115() {
        // Range 95-115 should return [99] (one invalid ID)
        let invalid_ids = process_range(95, 115);
        assert_eq!(invalid_ids, vec![99]);
    }

    #[test]
    fn test_range_998_to_1012() {
        // Range 998-1012 should return [1010] (one invalid ID)
        let invalid_ids = process_range(998, 1012);
        assert_eq!(invalid_ids, vec![1010]);
    }

    #[test]
    fn test_range_1188511880_to_1188511890() {
        // Range 1188511880-1188511890 should return [1188511885]
        let invalid_ids = process_range(1188511880, 1188511890);
        assert_eq!(invalid_ids, vec![1188511885]);
    }

    #[test]
    fn test_range_222220_to_222224() {
        // Range 222220-222224 should return [222222]
        let invalid_ids = process_range(222220, 222224);
        assert_eq!(invalid_ids, vec![222222]);
    }

    #[test]
    fn test_range_1698522_to_1698528_no_invalid() {
        // Range 1698522-1698528 should return [] (no invalid IDs)
        let invalid_ids = process_range(1698522, 1698528);
        assert_eq!(invalid_ids, vec![]);
    }

    #[test]
    fn test_range_446443_to_446449() {
        // Range 446443-446449 should return [446446]
        let invalid_ids = process_range(446443, 446449);
        assert_eq!(invalid_ids, vec![446446]);
    }

    #[test]
    fn test_range_38593856_to_38593862() {
        // Range 38593856-38593862 should return [38593859]
        let invalid_ids = process_range(38593856, 38593862);
        assert_eq!(invalid_ids, vec![38593859]);
    }

    // Additional helper tests

    #[test]
    fn test_parse_single_range() {
        let ranges = parse_ranges("11-22").unwrap();
        assert_eq!(ranges, vec![(11, 22)]);
    }

    #[test]
    fn test_parse_multiple_ranges() {
        let ranges = parse_ranges("11-22,95-115").unwrap();
        assert_eq!(ranges, vec![(11, 22), (95, 115)]);
    }

    #[test]
    fn test_parse_with_whitespace() {
        let ranges = parse_ranges(" 11-22 , 95-115 ").unwrap();
        assert_eq!(ranges, vec![(11, 22), (95, 115)]);
    }

    #[test]
    fn test_solve_simple_example() {
        let input = "11-22";
        let (sum, _) = solve(input);
        // 11 + 22 = 33
        assert_eq!(sum, 33);
    }

    // Additional verification tests for specific numbers

    #[test]
    fn test_specific_invalid_ids() {
        // From problem: 55, 6464, 123123 should be invalid
        assert_eq!(is_invalid_id("55"), true);
        assert_eq!(is_invalid_id("6464"), true);
        assert_eq!(is_invalid_id("123123"), true);

        // From ranges: these should be invalid
        assert_eq!(is_invalid_id("99"), true);
        assert_eq!(is_invalid_id("1010"), true);
        assert_eq!(is_invalid_id("222222"), true);
        assert_eq!(is_invalid_id("446446"), true);
    }

    // Task 2.1: Integration Tests

    #[test]
    fn test_integration_sample_input() {
        // Test with the full sample input from problem statement
        let input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";
        let (sum, _) = solve(input);
        // Expected sum from problem statement: 1227775554
        assert_eq!(sum, 1227775554);
    }

    #[test]
    fn test_integration_range_with_no_invalid_ids() {
        // Test a range that has no invalid IDs
        let input = "1698522-1698528";
        let (sum, _) = solve(input);
        assert_eq!(sum, 0);
    }

    #[test]
    fn test_integration_multiple_ranges_sum() {
        // Test multiple ranges and verify the sum
        let input = "11-22,95-115"; // Should be 11 + 22 + 99 = 132
        let (sum, _) = solve(input);
        assert_eq!(sum, 132);
    }

    // Part 2 Integration Tests (Task 1.5)

    #[test]
    fn test_part2_integration_sample_input() {
        // Test with the full sample input from problem statement
        let input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";
        let (part1_sum, part2_sum) = solve(input);

        // Verify Part 1 sum remains correct
        assert_eq!(part1_sum, 1227775554);

        // Verify Part 2 sum
        assert_eq!(part2_sum, Some(4174379265));
    }

    #[test]
    fn test_part2_range_95_to_115() {
        // Range 95-115: Part 2 should include [99, 111]
        // 99 is "9" repeated, 111 is "1" repeated 3 times
        let sum = process_range_part2(95, 115);
        assert_eq!(sum, 99 + 111); // 210
    }

    #[test]
    fn test_part2_range_998_to_1012() {
        // Range 998-1012: Part 2 should include [999, 1010]
        // 999 is "9" repeated 3 times, 1010 is "10" repeated
        let sum = process_range_part2(998, 1012);
        assert_eq!(sum, 999 + 1010); // 2009
    }

    #[test]
    fn test_part2_range_565653_to_565659() {
        // Range 565653-565659: Part 2 should include [565656]
        // 565656 is "56" repeated 3 times
        let sum = process_range_part2(565653, 565659);
        assert_eq!(sum, 565656);
    }
}
