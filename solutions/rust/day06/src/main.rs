use std::io::{self, Read};

fn main() {
    // Read input from stdin
    let mut input = String::new();
    match io::stdin().read_to_string(&mut input) {
        Ok(_) => {
            match solve(&input) {
                Ok(part1) => {
                    // Output JSON format for testing framework
                    println!("{{\"part1\": {}, \"part2\": null}}", part1);
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

/// Parse input into a 2D array of strings (rows and columns)
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

/// Solve the puzzle: parse input, identify problems, calculate each, and sum results
fn solve(input: &str) -> Result<i64, String> {
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

#[cfg(test)]
mod tests {
    use super::*;

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
    fn test_solve_sample_input() {
        let input = "123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +  ";

        let result = solve(input).unwrap();
        assert_eq!(result, 4277556);
    }

    #[test]
    fn test_solve_small_example() {
        let input = "10 20\n5 10\n* +";
        let result = solve(input).unwrap();
        assert_eq!(result, 80); // (10 * 5) + (20 + 10) = 50 + 30 = 80
    }
}
