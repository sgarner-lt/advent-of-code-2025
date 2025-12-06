use std::io::{self, Read};

fn main() {
    // Read input from stdin
    let mut input = String::new();
    io::stdin()
        .read_to_string(&mut input)
        .expect("Failed to read from stdin");

    let (part1, part2) = solve(&input);

    // Output JSON format for testing framework
    println!("{{\"part1\": {}, \"part2\": {}}}", part1, part2);
}

/// Extracts all possible 2-digit pairs from a line by picking any two positions
///
/// For each pair of positions (i, j) where i < j, creates a 2-digit number
/// from digits at those positions. For example, "987" with positions (0,2) yields 97.
fn extract_pairs(line: &str) -> Vec<i32> {
    let mut pairs = Vec::new();
    let chars: Vec<char> = line.chars().collect();

    if chars.len() < 2 {
        return pairs;
    }

    for i in 0..chars.len() {
        for j in (i + 1)..chars.len() {
            // Create 2-digit number from positions i and j
            let first_digit = chars[i];
            let second_digit = chars[j];

            if first_digit.is_ascii_digit() && second_digit.is_ascii_digit() {
                let pair_str = format!("{}{}", first_digit, second_digit);
                if let Ok(pair) = pair_str.parse::<i32>() {
                    pairs.push(pair);
                }
            }
        }
    }

    pairs
}

/// Extracts the maximum k-digit number from a line using a greedy algorithm
///
/// Algorithm: For each position i (0 to k-1) in the result:
/// 1. Calculate search window: from current_pos to (line_length - remaining_digits)
/// 2. Find the maximum digit in this search window
/// 3. Append the maximum digit to the result
/// 4. Update current_pos to immediately after the selected digit
///
/// This greedy approach guarantees the lexicographically largest k-digit number,
/// which equals the maximum numeric value for fixed-length numbers.
///
/// # Arguments
/// * `line` - String containing digit characters
/// * `k` - Number of digits to extract
///
/// # Returns
/// * `Some(i64)` - The maximum k-digit number as a 64-bit integer
/// * `None` - If the line has fewer than k digits or contains non-digit characters
///
/// # Examples
/// ```
/// extract_max_k_digits("987654321111111", 12) == Some(987654321111)
/// extract_max_k_digits("811111111111119", 12) == Some(811111111119)
/// ```
fn extract_max_k_digits(line: &str, k: usize) -> Option<i64> {
    let chars: Vec<char> = line.chars().collect();

    // Validate input: need at least k digits
    if chars.len() < k {
        return None;
    }

    // Validate all characters are digits
    if !chars.iter().all(|c| c.is_ascii_digit()) {
        return None;
    }

    let mut result = String::new();
    let mut current_pos = 0;

    // For each position in the k-digit result
    for i in 0..k {
        let remaining_digits = k - i;
        // Calculate search window: must leave enough digits to complete the k-digit number
        let search_end = chars.len() - remaining_digits + 1;

        // Find the maximum digit in the search window [current_pos, search_end)
        let mut max_digit = chars[current_pos];
        let mut max_pos = current_pos;

        for pos in current_pos..search_end {
            if chars[pos] > max_digit {
                max_digit = chars[pos];
                max_pos = pos;
            }
        }

        // Append the maximum digit to the result
        result.push(max_digit);
        // Move current position to immediately after the selected digit
        current_pos = max_pos + 1;
    }

    // Parse the k-digit string as i64 (64-bit integer)
    result.parse::<i64>().ok()
}

/// Finds the maximum value from a list of pairs
fn find_max(pairs: &[i32]) -> Option<i32> {
    pairs.iter().max().copied()
}

/// Solves the puzzle: returns (part1_sum, part2_sum) as a tuple
///
/// Part 1: Sum of maximum 2-digit pairs from each line
/// Part 2: Sum of maximum 12-digit numbers from each line
fn solve(input: &str) -> (i32, i64) {
    let mut part1_sum = 0;
    let mut part2_sum: i64 = 0;

    for line in input.lines() {
        let trimmed = line.trim();
        if trimmed.is_empty() {
            continue;
        }

        // Part 1: Extract max 2-digit pair
        let pairs = extract_pairs(trimmed);
        if let Some(max) = find_max(&pairs) {
            part1_sum += max;
        }

        // Part 2: Extract max 12-digit number
        if let Some(max_12_digit) = extract_max_k_digits(trimmed, 12) {
            part2_sum += max_12_digit;
        }
    }

    (part1_sum, part2_sum)
}

#[cfg(test)]
mod tests {
    use super::*;

    // ========== Part 1 Tests (Existing) ==========

    #[test]
    fn test_extract_pairs_simple() {
        // Test "987" yields pairs including 98, 97, 87 among others
        let pairs = extract_pairs("987");
        assert!(pairs.contains(&98)); // positions 0,1
        assert!(pairs.contains(&97)); // positions 0,2
        assert!(pairs.contains(&87)); // positions 1,2
    }

    #[test]
    fn test_find_max_from_pairs() {
        // Test finding maximum from a list of pairs
        let pairs = vec![98, 87, 76, 65, 54, 43, 32, 21, 11];
        assert_eq!(find_max(&pairs), Some(98));
    }

    #[test]
    fn test_sample_input_line1() {
        // Test line 1: "987654321111111" → max = 98
        let line = "987654321111111";
        let pairs = extract_pairs(line);
        let max = find_max(&pairs);
        assert_eq!(max, Some(98));
    }

    #[test]
    fn test_sample_input_line2() {
        // Test line 2: "811111111111119" → max = 89 (positions 0 and 14: '8' and '9')
        let line = "811111111111119";
        let pairs = extract_pairs(line);
        let max = find_max(&pairs);
        assert_eq!(max, Some(89));
    }

    #[test]
    fn test_sample_input_line3() {
        // Test line 3: "234234234234278" → max = 78
        let line = "234234234234278";
        let pairs = extract_pairs(line);
        let max = find_max(&pairs);
        assert_eq!(max, Some(78));
    }

    #[test]
    fn test_sample_input_line4() {
        // Test line 4: "818181911112111" → max = 92
        let line = "818181911112111";
        let pairs = extract_pairs(line);
        let max = find_max(&pairs);
        assert_eq!(max, Some(92));
    }

    #[test]
    fn test_complete_sample_input() {
        // Test complete sample input expecting sum of 357
        let input = "987654321111111\n811111111111119\n234234234234278\n818181911112111";
        let (part1, _) = solve(input);
        assert_eq!(part1, 357);
    }

    #[test]
    fn test_short_string() {
        // Test single character returns empty
        let pairs = extract_pairs("9");
        assert_eq!(pairs.len(), 0);
        assert_eq!(find_max(&pairs), None);
    }

    // ========== Part 2 Tests (New) ==========

    #[test]
    fn test_extract_max_k_digits_line1() {
        // Test line 1: "987654321111111" yields 987654321111
        // Remove three 1s from end
        let line = "987654321111111";
        let result = extract_max_k_digits(line, 12);
        assert_eq!(result, Some(987654321111));
    }

    #[test]
    fn test_extract_max_k_digits_line2() {
        // Test line 2: "811111111111119" yields 811111111119
        // Remove three 1s from middle
        let line = "811111111111119";
        let result = extract_max_k_digits(line, 12);
        assert_eq!(result, Some(811111111119));
    }

    #[test]
    fn test_extract_max_k_digits_line3() {
        // Test line 3: "234234234234278" yields 434234234278
        // Remove 2, 3, 2 from start
        let line = "234234234234278";
        let result = extract_max_k_digits(line, 12);
        assert_eq!(result, Some(434234234278));
    }

    #[test]
    fn test_extract_max_k_digits_line4() {
        // Test line 4: "818181911112111" yields 888911112111
        // Remove some 1s from start
        let line = "818181911112111";
        let result = extract_max_k_digits(line, 12);
        assert_eq!(result, Some(888911112111));
    }

    // ========== Integration Tests ==========

    #[test]
    fn test_solve_returns_tuple() {
        // Test that solve() returns (part1, part2) tuple for sample input
        let input = "987654321111111\n811111111111119\n234234234234278\n818181911112111";
        let (part1, part2) = solve(input);
        assert_eq!(part1, 357);
        assert_eq!(part2, 3121910778619);
    }

    #[test]
    fn test_part1_unchanged() {
        // Verify Part 1 result remains unchanged
        let input = "987654321111111\n811111111111119\n234234234234278\n818181911112111";
        let (part1, _) = solve(input);
        assert_eq!(part1, 357);
    }

    #[test]
    fn test_part2_correct_sum() {
        // Verify Part 2 produces correct sum
        let input = "987654321111111\n811111111111119\n234234234234278\n818181911112111";
        let (_, part2) = solve(input);
        assert_eq!(part2, 3121910778619);
    }
}
