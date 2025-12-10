use std::io::{self, Read};
use std::collections::HashSet;

fn main() {
    // Read input from stdin
    let mut input = String::new();
    io::stdin()
        .read_to_string(&mut input)
        .expect("Failed to read from stdin");

    let (part1_result, part2_result) = solve(&input);

    // Output JSON format for testing framework
    println!("{{\"part1\": {}, \"part2\": {}}}", part1_result, part2_result);
}

/// Represents a beam with position and direction
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
struct Beam {
    row: usize,
    col: usize,
}

impl Beam {
    fn new(row: usize, col: usize) -> Self {
        Beam { row, col }
    }
}

/// Parse input into a 2D grid of characters
fn parse_grid(input: &str) -> Vec<Vec<char>> {
    input
        .lines()
        .map(|line| line.trim())
        .filter(|line| !line.is_empty())
        .map(|line| line.chars().collect())
        .collect()
}

/// Find the starting position marked with 'S'
/// Returns (row, col) coordinates
fn find_start_position(grid: &[Vec<char>]) -> Option<(usize, usize)> {
    for (row, line) in grid.iter().enumerate() {
        for (col, &cell) in line.iter().enumerate() {
            if cell == 'S' {
                return Some((row, col));
            }
        }
    }
    None
}

/// Check if a position is within grid bounds
fn is_in_bounds(grid: &[Vec<char>], row: i32, col: i32) -> bool {
    if grid.is_empty() {
        return false;
    }
    let rows = grid.len() as i32;
    let cols = grid[0].len() as i32;
    row >= 0 && row < rows && col >= 0 && col < cols
}

/// Simulate beam propagation and count splits
fn simulate_beam_propagation(grid: &[Vec<char>], start_row: usize, start_col: usize) -> usize {
    let mut active_beams: Vec<Beam> = vec![Beam::new(start_row, start_col)];
    let mut split_count = 0;
    let mut activated_splitters: HashSet<(usize, usize)> = HashSet::new();
    let mut visited_beams: HashSet<Beam> = HashSet::new();

    // Debug output
    eprintln!("Starting simulation at position ({}, {})", start_row, start_col);
    eprintln!("Grid dimensions: {} rows x {} cols", grid.len(), grid[0].len());

    let mut iteration = 0;
    let max_iterations = 100000; // Safety limit to prevent infinite loops

    while !active_beams.is_empty() && iteration < max_iterations {
        iteration += 1;
        let mut next_beams: Vec<Beam> = Vec::new();
        let mut seen_this_iteration: HashSet<Beam> = HashSet::new();

        for beam in active_beams.iter() {
            // Skip if we've already processed this beam position before
            if visited_beams.contains(beam) {
                continue;
            }
            visited_beams.insert(*beam);

            // Move beam one step downward
            let new_row = beam.row as i32 + 1;
            let new_col = beam.col as i32;

            // Check if new position is within bounds
            if !is_in_bounds(grid, new_row, new_col) {
                eprintln!("Beam at ({}, {}) moved to ({}, {}) - OUT OF BOUNDS",
                         beam.row, beam.col, new_row, new_col);
                continue;
            }

            let new_row_usize = new_row as usize;
            let new_col_usize = new_col as usize;
            let cell = grid[new_row_usize][new_col_usize];

            eprintln!("Beam at ({}, {}) moved to ({}, {}) - found '{}'",
                     beam.row, beam.col, new_row_usize, new_col_usize, cell);

            let new_beam = Beam::new(new_row_usize, new_col_usize);

            match cell {
                '.' => {
                    // Continue tracking beam through empty space
                    // Only add if not already seen this iteration (avoid duplicates)
                    if !seen_this_iteration.contains(&new_beam) {
                        next_beams.push(new_beam);
                        seen_this_iteration.insert(new_beam);
                    }
                }
                '^' => {
                    // Hit a splitter - count it only if not already activated
                    if !activated_splitters.contains(&(new_row_usize, new_col_usize)) {
                        split_count += 1;
                        activated_splitters.insert((new_row_usize, new_col_usize));
                        eprintln!("SPLIT #{} at ({}, {}) - FIRST HIT", split_count, new_row_usize, new_col_usize);
                    } else {
                        eprintln!("Hit splitter at ({}, {}) - ALREADY ACTIVATED", new_row_usize, new_col_usize);
                    }

                    // Create left beam at same row, col - 1
                    let left_col = new_col - 1;
                    if is_in_bounds(grid, new_row, left_col) {
                        let left_beam = Beam::new(new_row_usize, left_col as usize);
                        if !seen_this_iteration.contains(&left_beam) {
                            next_beams.push(left_beam);
                            seen_this_iteration.insert(left_beam);
                            eprintln!("  Created left beam at ({}, {})", new_row_usize, left_col);
                        }
                    } else {
                        eprintln!("  Left beam would be out of bounds at ({}, {})", new_row, left_col);
                    }

                    // Create right beam at same row, col + 1
                    let right_col = new_col + 1;
                    if is_in_bounds(grid, new_row, right_col) {
                        let right_beam = Beam::new(new_row_usize, right_col as usize);
                        if !seen_this_iteration.contains(&right_beam) {
                            next_beams.push(right_beam);
                            seen_this_iteration.insert(right_beam);
                            eprintln!("  Created right beam at ({}, {})", new_row_usize, right_col);
                        }
                    } else {
                        eprintln!("  Right beam would be out of bounds at ({}, {})", new_row, right_col);
                    }
                }
                'S' => {
                    // Starting position acts as empty space
                    if !seen_this_iteration.contains(&new_beam) {
                        next_beams.push(new_beam);
                        seen_this_iteration.insert(new_beam);
                    }
                }
                _ => {
                    // Unknown cell type - treat as empty
                    if !seen_this_iteration.contains(&new_beam) {
                        next_beams.push(new_beam);
                        seen_this_iteration.insert(new_beam);
                    }
                }
            }
        }

        active_beams = next_beams;
        eprintln!("Iteration {}: Active beams: {}", iteration, active_beams.len());
        eprintln!("---");
    }

    if iteration >= max_iterations {
        eprintln!("WARNING: Reached maximum iterations limit!");
    }

    eprintln!("Simulation complete. Total splits: {}", split_count);
    split_count
}

/// Solve both parts of the puzzle
fn solve(input: &str) -> (String, String) {
    let grid = parse_grid(input);

    if grid.is_empty() {
        return ("null".to_string(), "null".to_string());
    }

    // Find starting position
    let start_pos = match find_start_position(&grid) {
        Some(pos) => pos,
        None => {
            eprintln!("Error: No starting position 'S' found in grid");
            return ("null".to_string(), "null".to_string());
        }
    };

    eprintln!("Found start position at ({}, {})", start_pos.0, start_pos.1);

    // Part 1: Count beam splits
    let split_count = simulate_beam_propagation(&grid, start_pos.0, start_pos.1);

    (split_count.to_string(), "null".to_string())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_grid() {
        let input = "...\n.S.\n.^.";
        let grid = parse_grid(input);
        assert_eq!(grid.len(), 3);
        assert_eq!(grid[0], vec!['.', '.', '.']);
        assert_eq!(grid[1], vec!['.', 'S', '.']);
        assert_eq!(grid[2], vec!['.', '^', '.']);
    }

    #[test]
    fn test_find_start_position() {
        let grid = vec![
            vec!['.', '.', '.'],
            vec!['.', 'S', '.'],
            vec!['.', '^', '.'],
        ];
        let start = find_start_position(&grid);
        assert_eq!(start, Some((1, 1)));
    }

    #[test]
    fn test_is_in_bounds() {
        let grid = vec![
            vec!['.', '.', '.'],
            vec!['.', 'S', '.'],
            vec!['.', '^', '.'],
        ];
        assert!(is_in_bounds(&grid, 0, 0));
        assert!(is_in_bounds(&grid, 2, 2));
        assert!(!is_in_bounds(&grid, -1, 0));
        assert!(!is_in_bounds(&grid, 0, -1));
        assert!(!is_in_bounds(&grid, 3, 0));
        assert!(!is_in_bounds(&grid, 0, 3));
    }

    #[test]
    fn test_single_splitter() {
        let input = ".S.\n...\n.^.";
        let (result, _) = solve(input);
        assert_eq!(result, "1");
    }

    #[test]
    fn test_beam_exits_grid() {
        // Beam should exit when it goes past bottom
        let input = ".S.\n...";
        let (result, _) = solve(input);
        assert_eq!(result, "0");
    }

    #[test]
    fn test_splitter_on_edge() {
        // Splitter on left edge - beam hits it directly, should only create right beam
        let input = "S..\n...\n^..";
        let (result, _) = solve(input);
        assert_eq!(result, "1");
    }

    #[test]
    fn test_multiple_splitters() {
        let input = "...S...\n.......\n...^...";
        let (result, _) = solve(input);
        assert_eq!(result, "1");
    }

    #[test]
    fn test_sample_input() {
        let input = ".......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............";
        let (result, _) = solve(input);
        assert_eq!(result, "21");
    }
}
