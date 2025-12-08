use std::io::{self, Read};

fn main() {
    // Read input from stdin
    let mut input = String::new();
    match io::stdin().read_to_string(&mut input) {
        Ok(_) => {
            match solve(&input) {
                Ok((part1, part2)) => {
                    // Output JSON format for testing framework
                    println!("{{\"part1\": {}, \"part2\": {}}}", part1, part2);
                }
                Err(e) => {
                    eprintln!("Error solving puzzle: {}", e);
                    println!("{{\"part1\": null, \"part2\": null}}");
                    std::process::exit(1);
                }
            }
        }
        Err(e) => {
            eprintln!("Failed to read from stdin: {}", e);
            println!("{{\"part1\": null, \"part2\": null}}");
            std::process::exit(1);
        }
    }
}

/// Parse a range line in format "start-end"
/// Returns Some((start, end)) if valid, None otherwise
fn parse_range(line: &str) -> Option<(i64, i64)> {
    let line = line.trim();
    if line.is_empty() {
        return None;
    }

    let parts: Vec<&str> = line.split('-').collect();
    if parts.len() != 2 {
        return None;
    }

    let start = parts[0].parse::<i64>().ok()?;
    let end = parts[1].parse::<i64>().ok()?;

    // Validate that start <= end
    if start > end {
        return None;
    }

    Some((start, end))
}

/// Check if an ID is fresh (falls within any of the given ranges)
/// Ranges are inclusive: range_start <= id <= range_end
fn is_fresh(id: i64, ranges: &[(i64, i64)]) -> bool {
    for &(start, end) in ranges {
        if id >= start && id <= end {
            return true;
        }
    }
    false
}

/// Parse the input and count fresh ingredients
/// Returns (part1_count, part2_result) where part2_result is None for now
fn solve(input: &str) -> Result<(i64, String), String> {
    // Split input into two groups separated by blank line
    let groups: Vec<&str> = input.split("\n\n").collect();

    if groups.len() != 2 {
        return Err("Input must have exactly two groups separated by a blank line".to_string());
    }

    // Parse ranges from first group
    let mut ranges: Vec<(i64, i64)> = Vec::new();
    for line in groups[0].lines() {
        let line = line.trim();
        if line.is_empty() {
            continue;
        }
        match parse_range(line) {
            Some(range) => ranges.push(range),
            None => return Err(format!("Failed to parse range: {}", line)),
        }
    }

    // Parse available IDs from second group
    let mut available_ids: Vec<i64> = Vec::new();
    for line in groups[1].lines() {
        let line = line.trim();
        if line.is_empty() {
            continue;
        }
        match line.parse::<i64>() {
            Ok(id) => available_ids.push(id),
            Err(_) => return Err(format!("Failed to parse ID: {}", line)),
        }
    }

    // Count how many available IDs are fresh
    let mut fresh_count = 0;
    for id in available_ids {
        if is_fresh(id, &ranges) {
            fresh_count += 1;
        }
    }

    Ok((fresh_count, "null".to_string()))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_range_valid() {
        let range = parse_range("3-5").unwrap();
        assert_eq!(range, (3, 5));
    }

    #[test]
    fn test_parse_range_large_numbers() {
        let range = parse_range("20362219004570-27230899748695").unwrap();
        assert_eq!(range, (20362219004570, 27230899748695));
    }

    #[test]
    fn test_parse_range_invalid() {
        assert!(parse_range("5-3").is_none()); // start > end
        assert!(parse_range("abc").is_none()); // not a range
        assert!(parse_range("").is_none()); // empty
    }

    #[test]
    fn test_parse_id() {
        // Test that "17" can be parsed as i64
        let id: i64 = "17".parse().unwrap();
        assert_eq!(id, 17);
    }

    #[test]
    fn test_is_fresh_in_range() {
        let ranges = vec![(3, 5)];
        assert!(is_fresh(5, &ranges));
        assert!(is_fresh(3, &ranges)); // Start boundary
        assert!(is_fresh(4, &ranges)); // Middle
    }

    #[test]
    fn test_is_fresh_not_in_range() {
        let ranges = vec![(3, 5)];
        assert!(!is_fresh(8, &ranges));
        assert!(!is_fresh(1, &ranges));
        assert!(!is_fresh(6, &ranges)); // Just outside
    }

    #[test]
    fn test_is_fresh_overlapping_ranges() {
        let ranges = vec![(16, 20), (12, 18)];
        assert!(is_fresh(17, &ranges)); // In both ranges
        assert!(is_fresh(13, &ranges)); // In second range only
        assert!(is_fresh(19, &ranges)); // In first range only
    }

    #[test]
    fn test_is_fresh_at_boundaries() {
        let ranges = vec![(3, 5), (10, 14)];
        assert!(is_fresh(3, &ranges));  // Start of first range
        assert!(is_fresh(5, &ranges));  // End of first range
        assert!(is_fresh(10, &ranges)); // Start of second range
        assert!(is_fresh(14, &ranges)); // End of second range
        assert!(!is_fresh(2, &ranges)); // Just before first range
        assert!(!is_fresh(6, &ranges)); // Just after first range
        assert!(!is_fresh(9, &ranges)); // Between ranges
    }

    #[test]
    fn test_sample_input() {
        let input = "3-5
10-14
16-20
12-18

1
5
8
11
17
32";
        let (part1, _) = solve(input).unwrap();
        assert_eq!(part1, 3);
    }

    #[test]
    fn test_empty_ranges() {
        let ranges: Vec<(i64, i64)> = vec![];
        assert!(!is_fresh(5, &ranges));
    }

    #[test]
    fn test_empty_ids() {
        let input = "3-5

";
        let (part1, _) = solve(input).unwrap();
        assert_eq!(part1, 0);
    }
}
