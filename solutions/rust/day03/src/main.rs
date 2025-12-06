use std::io::{self, Read};

fn main() {
    // Read input from stdin
    let mut input = String::new();
    io::stdin()
        .read_to_string(&mut input)
        .expect("Failed to read from stdin");

    let result = solve(&input);

    // Output JSON format for testing framework
    println!("{{\"part1\": {}, \"part2\": null}}", result);
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

/// Finds the maximum value from a list of pairs
fn find_max(pairs: &[i32]) -> Option<i32> {
    pairs.iter().max().copied()
}

/// Solves the puzzle: sum of maximum pairs from each line
fn solve(input: &str) -> i32 {
    let mut sum = 0;

    for line in input.lines() {
        let trimmed = line.trim();
        if trimmed.is_empty() {
            continue;
        }

        let pairs = extract_pairs(trimmed);
        if let Some(max) = find_max(&pairs) {
            sum += max;
        }
    }

    sum
}

#[cfg(test)]
mod tests {
    use super::*;

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
        let result = solve(input);
        assert_eq!(result, 357);
    }

    #[test]
    fn test_short_string() {
        // Test single character returns empty
        let pairs = extract_pairs("9");
        assert_eq!(pairs.len(), 0);
        assert_eq!(find_max(&pairs), None);
    }
}
