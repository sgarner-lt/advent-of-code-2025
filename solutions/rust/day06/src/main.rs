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

/// Parse input preserving whitespace for proper column alignment
/// Returns raw lines without modification
fn parse_input_raw(input: &str) -> Vec<String> {
    input
        .lines()
        .map(|line| line.to_string())
        .collect()
}

/// Find column boundaries where all rows have whitespace
/// Returns the start positions of each column
fn find_column_boundaries(rows: &[String]) -> Vec<usize> {
    if rows.is_empty() {
        return Vec::new();
    }

    let max_len = rows.iter().map(|r| r.len()).max().unwrap_or(0);
    let mut boundaries = vec![0]; // First column always starts at 0

    let mut in_whitespace = false;

    for pos in 0..max_len {
        // Check if all rows have whitespace or are beyond their length at this position
        let all_whitespace = rows.iter().all(|row| {
            pos >= row.len() || row.chars().nth(pos).map(|c| c.is_whitespace()).unwrap_or(true)
        });

        if all_whitespace && !in_whitespace {
            in_whitespace = true;
        } else if !all_whitespace && in_whitespace {
            boundaries.push(pos);
            in_whitespace = false;
        }
    }

    boundaries
}

/// Extract fixed-width columns from rows based on boundaries
/// Returns Vec of columns, where each column is a Vec of strings (one per row)
fn extract_columns(rows: &[String], boundaries: &[usize]) -> Vec<Vec<String>> {
    let mut columns = Vec::new();

    for i in 0..boundaries.len() {
        let start = boundaries[i];
        let end = if i + 1 < boundaries.len() {
            boundaries[i + 1]
        } else {
            rows.iter().map(|r| r.len()).max().unwrap_or(0)
        };

        let mut column = Vec::new();
        for row in rows {
            if start < row.len() {
                let col_str = if end <= row.len() {
                    &row[start..end]
                } else {
                    &row[start..]
                };
                column.push(col_str.to_string());
            } else {
                column.push(String::new());
            }
        }
        columns.push(column);
    }

    columns
}

/// Parse input into a 2D array of strings (rows and columns) for Part 1
/// Each line is split on whitespace and trimmed
fn parse_input(input: &str) -> Vec<Vec<String>> {
    input
        .lines()
        .map(|line| {
            line.split_whitespace()
                .map(|s| s.trim().to_string())
                .collect()
        })
        .filter(|row: &Vec<String>| !row.is_empty())
        .collect()
}

/// Identify vertical problems by transposing rows into columns
/// Returns a list of problems where each problem is a Vec of values from that column
fn identify_problems(rows: &[Vec<String>]) -> Vec<Vec<String>> {
    if rows.is_empty() {
        return Vec::new();
    }

    // Find the maximum number of columns
    let max_cols = rows.iter().map(|row| row.len()).max().unwrap_or(0);

    let mut problems = Vec::new();

    for col_idx in 0..max_cols {
        let mut column = Vec::new();

        for row in rows {
            if col_idx < row.len() {
                column.push(row[col_idx].clone());
            }
        }

        // Only include non-empty columns
        if !column.is_empty() {
            problems.push(column);
        }
    }

    problems
}

/// Extract operation symbol from the last element of a problem column
/// Returns the first character which should be * or +
fn extract_operation(problem: &[String]) -> Result<char, String> {
    if problem.is_empty() {
        return Err("Empty problem column".to_string());
    }

    let last = &problem[problem.len() - 1];
    let first_char = last.chars().next()
        .ok_or_else(|| "Empty operation string".to_string())?;

    if first_char == '*' || first_char == '+' {
        Ok(first_char)
    } else {
        Err(format!("Invalid operation symbol: {}", first_char))
    }
}

/// Calculate the result of a problem by applying the operation to all numbers
/// Numbers are all elements except the last one (which contains the operation)
fn calculate_problem(problem: &[String], operation: char) -> Result<i64, String> {
    if problem.len() < 2 {
        return Err("Problem must have at least one number and an operation".to_string());
    }

    // Parse all numbers (all elements except the last one)
    let mut numbers = Vec::new();
    for i in 0..problem.len() - 1 {
        let num = problem[i].trim().parse::<i64>()
            .map_err(|e| format!("Failed to parse number '{}': {}", problem[i], e))?;
        numbers.push(num);
    }

    if numbers.is_empty() {
        return Err("No numbers found in problem".to_string());
    }

    // Apply the operation
    match operation {
        '*' => {
            let mut result = numbers[0];
            for &num in &numbers[1..] {
                result = result.checked_mul(num)
                    .ok_or_else(|| "Integer overflow during multiplication".to_string())?;
            }
            Ok(result)
        }
        '+' => {
            let mut result = numbers[0];
            for &num in &numbers[1..] {
                result = result.checked_add(num)
                    .ok_or_else(|| "Integer overflow during addition".to_string())?;
            }
            Ok(result)
        }
        _ => Err(format!("Unsupported operation: {}", operation))
    }
}

/// Solve Part 1: parse input, identify problems, calculate each, and sum results
fn solve_part1(input: &str) -> Result<i64, String> {
    // Parse input into rows
    let rows = parse_input(input);

    if rows.is_empty() {
        return Err("No data found in input".to_string());
    }

    // Identify vertical problems (transpose to columns)
    let problems = identify_problems(&rows);

    if problems.is_empty() {
        return Err("No problems found in input".to_string());
    }

    // Calculate each problem and sum results
    let mut grand_total: i64 = 0;

    for problem in &problems {
        let operation = extract_operation(problem)?;
        let result = calculate_problem(problem, operation)?;

        grand_total = grand_total.checked_add(result)
            .ok_or_else(|| "Integer overflow when summing grand total".to_string())?;
    }

    Ok(grand_total)
}

/// Find the maximum width (number of digits) among all numbers in problems
/// Excludes the operator (last element of each problem)
///
/// This determines how many digit positions we need to process for Part 2.
/// Example: numbers [123, 45, 6] have max width 3 (from "123")
fn find_max_width(problems: &[Vec<String>]) -> usize {
    let mut max_width = 0;

    for problem in problems {
        // Iterate through all elements except the last one (operator)
        for i in 0..problem.len().saturating_sub(1) {
            let width = problem[i].len();
            if width > max_width {
                max_width = width;
            }
        }
    }

    max_width
}

/// Extract digits at a specific column position from a problem column
///
/// Part 2 uses operator-dependent digit extraction patterns:
/// - Multiplication (*): Extract from RIGHT (position 0 = rightmost digit)
///   Example: For numbers [123, 45, 6] at position 0: "3", "5", "6" -> "356"
/// - Addition (+): Extract from LEFT (position 0 = leftmost digit)
///   Example: For numbers [328, 64, 98] at position 0: "3", "6", "9" -> "369"
///
/// The extracted digits are concatenated to form new numbers that are then
/// evaluated according to the original operator (with reversal for addition).
fn extract_column_digits(problem: &[String], column_position: usize, operation: char) -> String {
    let mut digits = String::new();
    let num_rows = problem.len().saturating_sub(1); // Exclude operator

    for row_idx in 0..num_rows {
        let number = &problem[row_idx];
        let num_len = number.len();

        if operation == '*' {
            // Multiplication: extract from right
            // Position 0 gets rightmost, position 1 gets second from right, etc.
            if column_position < num_len {
                let char_index = num_len - 1 - column_position;
                if let Some(ch) = number.chars().nth(char_index) {
                    digits.push(ch);
                }
            }
        } else {
            // Addition: extract from left
            // Position 0 gets leftmost, position 1 gets second from left, etc.
            if column_position < num_len {
                if let Some(ch) = number.chars().nth(column_position) {
                    digits.push(ch);
                }
            }
        }
    }

    digits
}

/// Solve Part 2: Column-based digit extraction with whitespace preservation
///
/// Part 2 requires preserving whitespace alignment because numbers are read
/// vertically by CHARACTER POSITION, not by string position.
///
/// Algorithm:
/// 1. Parse input preserving raw lines (no split_whitespace)
/// 2. Find column boundaries (where ALL rows have whitespace)
/// 3. Extract fixed-width columns (preserving internal spaces)
/// 4. For each column:
///    - The last row contains the operator
///    - Read vertically by character position (left to right)
///    - For each character position, extract non-whitespace digits top-to-bottom
///    - Form numbers from extracted digits
///    - These numbers are then read right-to-left and combined with operator
/// 5. Sum all column results for grand total
///
/// Example with column ["123", " 45", "  6", "*"]:
///   Character position 0: "1" → number 1
///   Character position 1: "24" → number 24
///   Character position 2: "356" → number 356
///   Reading right-to-left: 356 * 24 * 1 = 8544
fn solve_part2(input: &str) -> Result<i64, String> {
    // Parse input preserving whitespace
    let raw_lines = parse_input_raw(input);

    if raw_lines.is_empty() {
        return Err("No data found in input".to_string());
    }

    // Find column boundaries
    let boundaries = find_column_boundaries(&raw_lines);

    if boundaries.is_empty() {
        return Err("No column boundaries found".to_string());
    }

    // Extract fixed-width columns
    let columns = extract_columns(&raw_lines, &boundaries);

    if columns.is_empty() {
        return Err("No columns extracted".to_string());
    }

    let mut grand_total: i64 = 0;

    // Process each column
    for (col_idx, column) in columns.iter().enumerate() {
        if column.is_empty() {
            continue;
        }

        // Last row should contain the operator
        let last_row = &column[column.len() - 1];
        let operation = last_row.trim().chars().next()
            .ok_or_else(|| format!("No operator found in column {}", col_idx))?;

        if operation != '*' && operation != '+' {
            // Skip columns without valid operators
            continue;
        }

        // Number rows are all except the last
        let number_rows = &column[0..column.len()-1];

        if number_rows.is_empty() {
            continue;
        }

        // Find max width among number rows
        let max_width = number_rows.iter().map(|s| s.len()).max().unwrap_or(0);

        if max_width == 0 {
            continue;
        }

        // Extract numbers by reading vertically at each character position
        let mut numbers_right_to_left = Vec::new();

        for char_pos in 0..max_width {
            let mut digits = String::new();

            // Read vertically top-to-bottom at this character position
            for row in number_rows {
                if char_pos < row.len() {
                    if let Some(ch) = row.chars().nth(char_pos) {
                        if !ch.is_whitespace() && ch.is_ascii_digit() {
                            digits.push(ch);
                        }
                    }
                }
            }

            // If we extracted any digits, form a number
            if !digits.is_empty() {
                numbers_right_to_left.push(digits);
            }
        }

        // Numbers are naturally in right-to-left order (character pos 0 is leftmost, but we want rightmost first)
        // So reverse to get right-to-left reading order
        numbers_right_to_left.reverse();

        // Calculate this column's result
        if !numbers_right_to_left.is_empty() {
            let mut problem_with_op = numbers_right_to_left.clone();
            problem_with_op.push(operation.to_string());

            let result = calculate_problem(&problem_with_op, operation)?;

            // Debug output to stderr (not stdout, to preserve JSON output)
            eprintln!("Column {}: {:?} {} = {}", col_idx, &numbers_right_to_left, operation, result);

            grand_total = grand_total.checked_add(result)
                .ok_or_else(|| "Integer overflow when summing grand total".to_string())?;
        }
    }

    Ok(grand_total)
}

/// Solve both parts of the puzzle
fn solve(input: &str) -> Result<(i64, i64), String> {
    let part1 = solve_part1(input)?;
    let part2 = solve_part2(input)?;
    Ok((part1, part2))
}

#[cfg(test)]
mod tests {
    use super::*;

    // Part 1 tests
    #[test]
    fn test_parse_input_simple() {
        let input = "123 328\n45 64\n*  +";
        let rows = parse_input(input);
        assert_eq!(rows.len(), 3);
        assert_eq!(rows[0], vec!["123", "328"]);
        assert_eq!(rows[1], vec!["45", "64"]);
        assert_eq!(rows[2], vec!["*", "+"]);
    }

    #[test]
    fn test_identify_problems_sample() {
        let rows = vec![
            vec!["123".to_string(), "328".to_string()],
            vec!["45".to_string(), "64".to_string()],
            vec!["*".to_string(), "+".to_string()],
        ];

        let problems = identify_problems(&rows);
        assert_eq!(problems.len(), 2);
        assert_eq!(problems[0], vec!["123", "45", "*"]);
        assert_eq!(problems[1], vec!["328", "64", "+"]);
    }

    #[test]
    fn test_extract_operation_multiply() {
        let problem = vec!["123".to_string(), "45".to_string(), "*".to_string()];
        let op = extract_operation(&problem).unwrap();
        assert_eq!(op, '*');
    }

    #[test]
    fn test_extract_operation_add() {
        let problem = vec!["328".to_string(), "64".to_string(), "+".to_string()];
        let op = extract_operation(&problem).unwrap();
        assert_eq!(op, '+');
    }

    #[test]
    fn test_calculate_problem_multiply() {
        let problem = vec!["123".to_string(), "45".to_string(), "6".to_string(), "*".to_string()];
        let result = calculate_problem(&problem, '*').unwrap();
        assert_eq!(result, 33210); // 123 * 45 * 6
    }

    #[test]
    fn test_calculate_problem_add() {
        let problem = vec!["328".to_string(), "64".to_string(), "98".to_string(), "+".to_string()];
        let result = calculate_problem(&problem, '+').unwrap();
        assert_eq!(result, 490); // 328 + 64 + 98
    }

    #[test]
    fn test_solve_sample_input_part1() {
        let input = "123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +  ";

        let result = solve_part1(input).unwrap();
        assert_eq!(result, 4277556);
    }

    #[test]
    fn test_solve_small_example() {
        let input = "10 20\n5 10\n* +";
        let result = solve_part1(input).unwrap();
        assert_eq!(result, 80); // (10 * 5) + (20 + 10) = 50 + 30 = 80
    }

    // Part 2 tests
    #[test]
    fn test_find_max_width() {
        let problems = vec![
            vec!["123".to_string(), "45".to_string(), "6".to_string(), "*".to_string()],
            vec!["328".to_string(), "64".to_string(), "98".to_string(), "+".to_string()],
            vec!["51".to_string(), "387".to_string(), "215".to_string(), "*".to_string()],
            vec!["64".to_string(), "23".to_string(), "314".to_string(), "+".to_string()],
        ];

        let max_width = find_max_width(&problems);
        assert_eq!(max_width, 3); // "123", "387", "215", "314" all have 3 digits
    }

    #[test]
    fn test_extract_column_digits_multiply() {
        let problem = vec!["123".to_string(), "45".to_string(), "6".to_string(), "*".to_string()];

        // Position 0 (rightmost): all numbers contribute
        let result = extract_column_digits(&problem, 0, '*');
        assert_eq!(result, "356"); // "3" from 123, "5" from 45, "6" from 6

        // Position 1: all numbers that have it
        let result = extract_column_digits(&problem, 1, '*');
        assert_eq!(result, "24"); // "2" from 123, "4" from 45

        // Position 2: only first number
        let result = extract_column_digits(&problem, 2, '*');
        assert_eq!(result, "1"); // "1" from 123
    }

    #[test]
    fn test_extract_column_digits_addition() {
        let problem = vec!["328".to_string(), "64".to_string(), "98".to_string(), "+".to_string()];

        // Position 0 (leftmost): all numbers contribute their first digit
        let result = extract_column_digits(&problem, 0, '+');
        assert_eq!(result, "369"); // "3" from 328, "6" from 64, "9" from 98

        // Position 1: all numbers that have it contribute their second digit
        let result = extract_column_digits(&problem, 1, '+');
        assert_eq!(result, "248"); // "2" from 328, "4" from 64, "8" from 98

        // Position 2: only 328 has a third digit
        let result = extract_column_digits(&problem, 2, '+');
        assert_eq!(result, "8"); // "8" from 328 only
    }

    #[test]
    fn test_extract_column_digits_addition_varying_lengths() {
        let problem = vec!["64".to_string(), "23".to_string(), "314".to_string(), "+".to_string()];

        // Position 0 (leftmost): all contribute first digit
        let result = extract_column_digits(&problem, 0, '+');
        assert_eq!(result, "623"); // "6" from 64, "2" from 23, "3" from 314

        // Position 1: all contribute second digit
        let result = extract_column_digits(&problem, 1, '+');
        assert_eq!(result, "431"); // "4" from 64, "3" from 23, "1" from 314

        // Position 2: only 314 has a third digit
        let result = extract_column_digits(&problem, 2, '+');
        assert_eq!(result, "4"); // "4" from 314 only
    }

    #[test]
    fn test_solve_part2_sample() {
        let input = "123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +  ";

        let result = solve_part2(input).unwrap();
        assert_eq!(result, 3263827);
    }
}
