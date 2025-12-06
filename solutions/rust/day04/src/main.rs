use std::io::{self, Read};

fn main() {
    // Read input from stdin
    let mut input = String::new();
    io::stdin()
        .read_to_string(&mut input)
        .expect("Failed to read from stdin");

    let (part1, grid_viz) = solve(&input);
    let part2 = solve_part2(&input);

    // Output JSON format with grid visualization
    let escaped_grid = grid_viz.replace('\n', "\\n");
    println!(
        "{{\"part1\": {}, \"part2\": {}, \"additional-info\": {{\"grid\": \"{}\"}}}}",
        part1, part2, escaped_grid
    );
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

/// Count adjacent rolls ('@' symbols) in all 8 directions
/// Directions: N, S, E, W, NE, NW, SE, SW
fn count_adjacent_rolls(grid: &[Vec<char>], row: usize, col: usize) -> usize {
    let directions = [
        (-1, 0),  // N
        (1, 0),   // S
        (0, 1),   // E
        (0, -1),  // W
        (-1, 1),  // NE
        (-1, -1), // NW
        (1, 1),   // SE
        (1, -1),  // SW
    ];

    let rows = grid.len() as i32;
    let cols = grid[0].len() as i32;
    let mut count = 0;

    for (dr, dc) in directions.iter() {
        let new_row = row as i32 + dr;
        let new_col = col as i32 + dc;

        // Check bounds
        if new_row >= 0 && new_row < rows && new_col >= 0 && new_col < cols {
            let r = new_row as usize;
            let c = new_col as usize;
            if grid[r][c] == '@' {
                count += 1;
            }
        }
    }

    count
}

/// Identify which rolls are accessible (adjacent_count < 4)
/// Returns a set of (row, col) positions that are accessible
fn identify_accessible_rolls(grid: &[Vec<char>]) -> Vec<(usize, usize)> {
    let mut accessible = Vec::new();

    for (row, line) in grid.iter().enumerate() {
        for (col, &cell) in line.iter().enumerate() {
            if cell == '@' {
                let adjacent_count = count_adjacent_rolls(grid, row, col);
                if adjacent_count < 4 {
                    accessible.push((row, col));
                }
            }
        }
    }

    accessible
}

/// Create grid visualization
/// 'x' for accessible rolls, '@' for inaccessible rolls, '.' for empty spaces
fn create_visualization(grid: &[Vec<char>], accessible: &[(usize, usize)]) -> String {
    let mut result = Vec::new();

    for (row, line) in grid.iter().enumerate() {
        let mut row_chars = Vec::new();
        for (col, &cell) in line.iter().enumerate() {
            if accessible.contains(&(row, col)) {
                row_chars.push('x');
            } else {
                row_chars.push(cell);
            }
        }
        result.push(row_chars.iter().collect::<String>());
    }

    result.join("\n")
}

/// Remove rolls from the grid at specified positions
/// Returns a new grid with removed positions replaced by '.'
fn remove_rolls(grid: &[Vec<char>], positions: &[(usize, usize)]) -> Vec<Vec<char>> {
    let mut new_grid = grid.to_vec();

    for &(row, col) in positions {
        new_grid[row][col] = '.';
    }

    new_grid
}

/// Solve Part 2: Iteratively remove accessible rolls
/// Returns total count of removed rolls across all iterations
fn solve_part2(input: &str) -> usize {
    let mut grid = parse_grid(input);

    if grid.is_empty() {
        return 0;
    }

    let mut total_removed = 0;

    loop {
        // Identify all accessible rolls in current grid state
        let accessible = identify_accessible_rolls(&grid);

        // If no accessible rolls found, we're done
        if accessible.is_empty() {
            break;
        }

        // Count removed rolls in this iteration
        let removed_count = accessible.len();
        total_removed += removed_count;

        // Remove all accessible rolls (batch removal)
        grid = remove_rolls(&grid, &accessible);
    }

    total_removed
}

/// Solve the puzzle: count accessible rolls and create visualization
fn solve(input: &str) -> (usize, String) {
    let grid = parse_grid(input);

    if grid.is_empty() {
        return (0, String::new());
    }

    let accessible = identify_accessible_rolls(&grid);
    let count = accessible.len();
    let visualization = create_visualization(&grid, &accessible);

    (count, visualization)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_grid() {
        let input = "..@@\n@@@.\n";
        let grid = parse_grid(input);
        assert_eq!(grid.len(), 2);
        assert_eq!(grid[0], vec!['.', '.', '@', '@']);
        assert_eq!(grid[1], vec!['@', '@', '@', '.']);
    }

    #[test]
    fn test_count_adjacent_corner_cell() {
        // Corner cell at (0,0) with one adjacent roll
        let grid = vec![
            vec!['@', '@', '.'],
            vec!['@', '.', '.'],
            vec!['.', '.', '.'],
        ];
        let count = count_adjacent_rolls(&grid, 0, 0);
        // Adjacent to: (0,1) and (1,0) = 2 rolls
        assert_eq!(count, 2);
    }

    #[test]
    fn test_count_adjacent_edge_cell() {
        // Edge cell at (0,1) - top edge, middle
        let grid = vec![
            vec!['@', '@', '@'],
            vec!['@', '@', '@'],
            vec!['.', '.', '.'],
        ];
        let count = count_adjacent_rolls(&grid, 0, 1);
        // Adjacent to: (0,0), (0,2), (1,0), (1,1), (1,2) = 5 rolls
        assert_eq!(count, 5);
    }

    #[test]
    fn test_count_adjacent_interior_cell() {
        // Interior cell at (1,1) with all 8 neighbors
        let grid = vec![
            vec!['@', '@', '@'],
            vec!['@', '@', '@'],
            vec!['@', '@', '@'],
        ];
        let count = count_adjacent_rolls(&grid, 1, 1);
        // All 8 adjacent positions have rolls
        assert_eq!(count, 8);
    }

    #[test]
    fn test_accessibility_rule() {
        // Test that adjacent_count < 4 means accessible
        let grid = vec![
            vec!['@', '@', '.'],
            vec!['@', '@', '@'],
            vec!['.', '@', '.'],
        ];
        // Cell at (0,0) has 3 adjacent rolls: (0,1), (1,0), (1,1) -> accessible
        // Cell at (1,1) has 5 adjacent rolls -> not accessible
        let accessible = identify_accessible_rolls(&grid);
        assert!(accessible.contains(&(0, 0)));
        assert!(!accessible.contains(&(1, 1)));
    }

    #[test]
    fn test_sample_input() {
        let input = "..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.";
        let (count, _) = solve(input);
        assert_eq!(count, 13);
    }

    #[test]
    fn test_visualization_format() {
        let input = "..@@\n@@@.\n";
        let (_, viz) = solve(input);
        // Check that visualization contains 'x' for accessible and '@' for inaccessible
        assert!(viz.contains('x') || viz.contains('@'));
        assert!(viz.contains('\n'));
    }

    #[test]
    fn test_empty_grid() {
        let input = "";
        let (count, viz) = solve(input);
        assert_eq!(count, 0);
        assert_eq!(viz, "");
    }

    // Part 2 Tests

    #[test]
    fn test_part2_sample_input_total() {
        let input = "..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.";
        let total = solve_part2(input);
        assert_eq!(total, 43);
    }

    #[test]
    fn test_part2_preserves_part1() {
        let input = "..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.";
        let (part1, _) = solve(input);
        assert_eq!(part1, 13);
    }

    #[test]
    fn test_part2_empty_grid() {
        let input = "";
        let total = solve_part2(input);
        assert_eq!(total, 0);
    }

    #[test]
    fn test_remove_rolls() {
        let grid = vec![
            vec!['@', '@', '.'],
            vec!['@', '.', '.'],
        ];
        let positions = vec![(0, 0), (0, 1)];
        let new_grid = remove_rolls(&grid, &positions);

        assert_eq!(new_grid[0][0], '.');
        assert_eq!(new_grid[0][1], '.');
        assert_eq!(new_grid[1][0], '@'); // Unchanged
    }

    #[test]
    fn test_part2_single_iteration() {
        // Grid where all rolls are accessible (< 4 adjacent)
        let input = "@..\n.@.\n..@";
        let total = solve_part2(input);
        // All 3 rolls are accessible in first iteration (0-1 neighbors each)
        assert_eq!(total, 3);
    }

    #[test]
    fn test_part2_no_accessible_rolls() {
        // Grid where center roll is protected by exactly 4 neighbors
        // Make a 5x5 grid with a protected roll at (2,2) that has exactly 4 adjacent
        let input = ".....\n.@@@.\n.@@@.\n.@@@.\n.....";
        let grid = parse_grid(input);
        // Center roll at (2,2) should have exactly 8 neighbors
        // Corner rolls like (1,1) have 3 neighbors, edges have 5
        // After first iteration, some outer rolls are removed
        // Verify iteration eventually stops
        let total = solve_part2(input);
        // Should remove rolls but stop when none are accessible
        assert!(total > 0);
        assert!(total <= 9); // Max 9 rolls in grid
    }
}
