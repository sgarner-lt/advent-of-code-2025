use std::io::{self, Read};

fn main() {
    // Read input from stdin
    let mut input = String::new();
    io::stdin()
        .read_to_string(&mut input)
        .expect("Failed to read from stdin");

    let (part1, grid_viz) = solve(&input);

    // Output JSON format with grid visualization
    let escaped_grid = grid_viz.replace('\n', "\\n");
    println!(
        "{{\"part1\": {}, \"part2\": null, \"additional-info\": {{\"grid\": \"{}\"}}}}",
        part1, escaped_grid
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
}
