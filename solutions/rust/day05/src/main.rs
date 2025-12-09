use std::io::{self, Read};
use std::collections::HashSet;

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

/// Merge overlapping ranges and count unique IDs
/// For small ranges (< 100k IDs), uses HashSet for exact counting
/// For large ranges, merges intervals and counts mathematically
fn count_unique_ids(ranges: &[(i64, i64)]) -> i64 {
    if ranges.is_empty() {
        return 0;
    }

    // Calculate total potential IDs across all ranges
    let total_ids: i64 = ranges.iter().map(|(start, end)| end - start + 1).sum();

    // For small datasets (< 100k IDs total), use HashSet approach for simplicity
    if total_ids < 100_000 {
        let mut unique_ids = HashSet::new();
        for &(start, end) in ranges {
            for id in start..=end {
                unique_ids.insert(id);
            }
        }
        return unique_ids.len() as i64;
    }

    // For large datasets, merge overlapping intervals and count mathematically
    // Sort ranges by start position
    let mut sorted_ranges = ranges.to_vec();
    sorted_ranges.sort_by_key(|r| r.0);

    // Merge overlapping intervals
    let mut merged: Vec<(i64, i64)> = Vec::new();
    for &(start, end) in &sorted_ranges {
        if merged.is_empty() {
            merged.push((start, end));
        } else {
            let last_idx = merged.len() - 1;
            let (last_start, last_end) = merged[last_idx];

            // Check if current range overlaps or is adjacent to last merged range
            if start <= last_end + 1 {
                // Merge by extending the end if needed
                merged[last_idx] = (last_start, last_end.max(end));
            } else {
                // No overlap, add as new range
                merged.push((start, end));
            }
        }
    }

    // Count total unique IDs across merged ranges
    merged.iter().map(|(start, end)| end - start + 1).sum()
}

/// Parse the input and count fresh ingredients
/// Returns (part1_count, part2_count)
fn solve(input: &str) -> Result<(i64, i64), String> {
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

    // Part 1: Count how many available IDs are fresh
    let mut fresh_count = 0;
    for id in available_ids {
        if is_fresh(id, &ranges) {
            fresh_count += 1;
        }
    }

    // Part 2: Count unique ingredient IDs across all ranges
    let unique_count = count_unique_ids(&ranges);

    Ok((fresh_count, unique_count))
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
        let (part1, part2) = solve(input).unwrap();
        assert_eq!(part1, 3);
        assert_eq!(part2, 14);
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
        let (part1, part2) = solve(input).unwrap();
        assert_eq!(part1, 0);
        assert_eq!(part2, 3); // Range 3-5 has 3 unique IDs
    }

    // Part 2 specific tests
    #[test]
    fn test_count_unique_ids_single_range() {
        let ranges = vec![(3, 5)];
        let count = count_unique_ids(&ranges);
        assert_eq!(count, 3); // IDs: 3, 4, 5
    }

    #[test]
    fn test_count_unique_ids_multiple_ranges() {
        let ranges = vec![(3, 5), (10, 14)];
        let count = count_unique_ids(&ranges);
        assert_eq!(count, 8); // IDs: 3, 4, 5, 10, 11, 12, 13, 14
    }

    #[test]
    fn test_count_unique_ids_overlapping_ranges() {
        let ranges = vec![(12, 18), (16, 20)];
        let count = count_unique_ids(&ranges);
        assert_eq!(count, 9); // IDs: 12, 13, 14, 15, 16, 17, 18, 19, 20 (no duplicates)
    }

    #[test]
    fn test_count_unique_ids_sample_input_ranges() {
        let ranges = vec![(3, 5), (10, 14), (16, 20), (12, 18)];
        let count = count_unique_ids(&ranges);
        assert_eq!(count, 14); // IDs: 3,4,5,10,11,12,13,14,15,16,17,18,19,20
    }

    #[test]
    fn test_count_unique_ids_empty() {
        let ranges: Vec<(i64, i64)> = vec![];
        let count = count_unique_ids(&ranges);
        assert_eq!(count, 0);
    }

    #[test]
    fn test_count_unique_ids_single_point_range() {
        let ranges = vec![(5, 5)];
        let count = count_unique_ids(&ranges);
        assert_eq!(count, 1); // Only ID 5
    }

    #[test]
    fn test_count_unique_ids_adjacent_ranges() {
        let ranges = vec![(3, 5), (6, 8)];
        let count = count_unique_ids(&ranges);
        assert_eq!(count, 6); // IDs: 3, 4, 5, 6, 7, 8
    }

    #[test]
    fn test_count_unique_ids_large_ranges() {
        // Test with very large ranges that would be impractical to enumerate
        let ranges = vec![(1, 1_000_000), (500_000, 1_500_000)];
        let count = count_unique_ids(&ranges);
        // Range 1-1000000 has 1,000,000 IDs
        // Range 500000-1500000 overlaps from 500000-1000000 (500,001 IDs overlap)
        // So unique IDs = 1,000,000 + 500,000 = 1,500,000
        assert_eq!(count, 1_500_000);
    }

    #[test]
    fn test_count_unique_ids_multiple_overlaps() {
        // Test case with multiple overlapping ranges
        let ranges = vec![(1, 10), (5, 15), (12, 20), (18, 25)];
        let count = count_unique_ids(&ranges);
        // After merging: (1, 25) = 25 unique IDs
        assert_eq!(count, 25);
    }
}
