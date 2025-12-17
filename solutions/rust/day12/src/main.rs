use core::fmt;
use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_type = match args.get(1).map(|s| s.as_str()) {
        Some("r") => "",
        Some("s") => "-sample",
        _ => "",
    };
    let input_path = &format!("../../../challenges/day12/input{}.txt", input_type);
    let input = read_input(input_path);
    let problem = parse_problem(&input);
    println!("{:?}", problem);
    for s in &problem.shapes {
        let orients = get_all_orientations(s);
        println!("Shape {} has {} orientations", s.index, orients.len());
        for o in &orients {
            println!("  {:?}", o);
        }
    }
    println!("Part 1: {}", part1(&problem));
    // println!("Part 2: {}", part2(&problem));
}

#[derive(Debug)]
struct Shape {
    index: usize,
    coords: Vec<(usize, usize)>,
}
impl fmt::Display for Shape {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        writeln!(f, "Shape {}:", self.index)?;
        let mut grid = vec![vec!['.'; 3]; 3];
        for &(r, c) in &self.coords {
            grid[r][c] = '#';
        }
        for row in grid {
            let line: String = row.into_iter().collect();
            writeln!(f, "{}", line)?;
        }
        Ok(())
    }
}

#[derive(Debug)]
struct Region {
    width: usize,
    height: usize,
    shape_conts: Vec<usize>,
}

#[derive(Debug)]
struct Problem {
    shapes: Vec<Shape>,
    regions: Vec<Region>,
}

fn read_input(path: &str) -> String {
    fs::read_to_string(path).expect("Failed to read input file")
}
fn parse_shape(shape_lines: &Vec<&&str>) -> Shape {
    let index = shape_lines
        .iter()
        .take(1)
        .map(|idx| idx.replace(":", "").parse::<usize>().unwrap())
        .next()
        .unwrap();
    let coords = shape_lines
        .iter()
        .skip(1)
        .enumerate()
        .map(|(x, &line)| {
            line.chars().enumerate().filter_map(
                move |(y, c)| {
                    if c == '#' { Some((x, y)) } else { None }
                },
            )
        })
        .flatten()
        .collect::<Vec<_>>();
    Shape { index, coords }
}

use std::collections::HashSet;

// Normalizes a shape's coordinates so the top-left point is at (0,0) and sorts for consistent HashSet hashing
fn normalize_shape(coords: Vec<(usize, usize)>) -> Vec<(usize, usize)> {
    let min_r = coords.iter().map(|&(r, _)| r).min().unwrap_or(0);
    let min_c = coords.iter().map(|&(_, c)| c).min().unwrap_or(0);

    let mut normalized: Vec<(usize, usize)> = coords
        .into_iter()
        .map(|(r, c)| (r - min_r, c - min_c))
        .collect();
    normalized.sort_unstable(); // Sort ensures the Vec<Vec<T>> is hashable/comparable
    normalized
}

// Rotates coordinates 90 degrees clockwise within a 3x3 boundary and normalizes
fn rotate_90_clockwise(coords: &[(usize, usize)]) -> Vec<(usize, usize)> {
    // Rotate around the bounding square of size S = max(max_r, max_c) + 1
    let max_r = coords.iter().map(|&(r, _)| r).max().unwrap_or(0);
    let max_c = coords.iter().map(|&(_, c)| c).max().unwrap_or(0);
    let s = std::cmp::max(max_r, max_c) + 1;
    let rotated = coords
        .iter()
        .map(|&(r, c)| (c, s - 1 - r))
        .collect::<Vec<_>>();
    normalize_shape(rotated)
}

// Flips coordinates horizontally (mirrors across a vertical axis) and normalizes
fn flip_horizontal(coords: &[(usize, usize)]) -> Vec<(usize, usize)> {
    let max_r = coords.iter().map(|&(r, _)| r).max().unwrap_or(0);
    let max_c = coords.iter().map(|&(_, c)| c).max().unwrap_or(0);
    let s = std::cmp::max(max_r, max_c) + 1;
    let flipped = coords
        .iter()
        .map(|&(r, c)| (r, s - 1 - c))
        .collect::<Vec<_>>();
    normalize_shape(flipped)
}

// Return unique normalized orientations (as raw coord Vecs) for a base shape
fn get_all_orientations(initial_shape: &Shape) -> Vec<Vec<(usize, usize)>> {
    let mut unique_orientations: HashSet<Vec<(usize, usize)>> = HashSet::new();

    let base = normalize_shape(initial_shape.coords.clone());
    let flipped = flip_horizontal(&initial_shape.coords);

    for mut variant in vec![base, flipped] {
        for _ in 0..4 {
            unique_orientations.insert(normalize_shape(variant.clone()));
            variant = rotate_90_clockwise(&variant);
        }
    }

    unique_orientations.into_iter().collect()
}

fn is_placement_valid(
    shape_coords: &Vec<(usize, usize)>,
    top_left_r: usize,
    top_left_c: usize,
    region: &Region,
) -> bool {
    for &(sr, sc) in shape_coords {
        let r = top_left_r + sr;
        let c = top_left_c + sc;
        if r >= region.height || c >= region.width {
            return false; // Out of bounds
        }
    }
    true
}

fn generate_dlx_options(base_shapes: &Vec<Shape>, region: &Region) -> (Vec<Vec<usize>>, usize) {
    // Returns (options, num_primary_columns)
    let mut options_matrix: Vec<Vec<usize>> = Vec::new();

    let cell_count = region.width * region.height;

    // For each shape type, get all unique orientations
    let all_orients_per_shape: Vec<Vec<Vec<(usize, usize)>>> = base_shapes
        .iter()
        .map(|s| get_all_orientations(s))
        .collect();

    // Count total shape instances
    let mut total_shape_instances = 0usize;
    for &count in &region.shape_conts {
        total_shape_instances += count;
    }

    // We'll place shape-instance columns first (0..total_shape_instances-1)
    // and cells after that (offset = total_shape_instances)
    let cell_offset = total_shape_instances;

    let mut shape_instance_index = 0usize;
    println!(
        "total_shape_instances: {} cell_offset: {} cell_count: {}",
        total_shape_instances, cell_offset, cell_count
    );
    let mut placements_per_instance: Vec<usize> = Vec::new();
    for (shape_type_idx, orients) in all_orients_per_shape.iter().enumerate() {
        let count_for_type = region.shape_conts[shape_type_idx];
        for _instance in 0..count_for_type {
            let mut this_instance_count = 0usize;
            let instance_col = shape_instance_index; // primary column
            for orient in orients {
                for r in 0..region.height {
                    for c in 0..region.width {
                        if is_placement_valid(orient, r, c, region) {
                            let mut current_option: Vec<usize> = Vec::new();
                            // add the shape-instance primary column (1-based)
                            current_option.push(instance_col + 1);
                            // add covered cell secondary columns (offset, 1-based)
                            for (sr, sc) in orient {
                                let linear_index = (r + sr) * region.width + (c + sc);
                                current_option.push(cell_offset + linear_index + 1);
                            }
                            current_option.sort_unstable();
                            options_matrix.push(current_option);
                            this_instance_count += 1;
                        }
                    }
                }
            }
            placements_per_instance.push(this_instance_count);
            shape_instance_index += 1;
        }
    }

    for (i, &count) in placements_per_instance.iter().enumerate() {
        println!("shape-instance {} placements: {}", i, count);
    }

    // Add 'blank' options so that each cell column can be covered once
    // This allows cells to remain empty (covered by a blank) while preventing overlaps.
    for linear_index in 0..cell_count {
        options_matrix.push(vec![cell_offset + linear_index + 1]);
    }

    (options_matrix, total_shape_instances + cell_count)
}

use dlx_rs::Solver;

fn solve_tiling_problem(base_shapes: &Vec<Shape>, region: &Region) -> bool {
    let (options, total_columns) = generate_dlx_options(base_shapes, region);

    let mut s = Solver::new(total_columns);

    println!("Total columns: {}", total_columns);
    println!("Total options: {}", options.len());
    if let Some(opt) = options.get(0) {
        println!("Sample option (first): {:?}", opt);
    }

    for (index, option) in options.iter().enumerate() {
        s.add_option(format!("opt_{}", index), &option);
    }

    let solution = s.solve();
    println!("Raw solver output: {:?}", solution);
    let solution_exists = solution.is_some();
    println!("Solution exists: {}", solution_exists);
    solution_exists
}

fn parse_problem(input: &str) -> Problem {
    let raw_lines = input
        .lines()
        .map(|line| line.trim())
        .filter(|l| !l.is_empty())
        .collect::<Vec<_>>();

    let mut shapes: Vec<Shape> = Vec::new();
    for shape_idx in 0..6 {
        let shape_raw = raw_lines
            .iter()
            .skip(shape_idx * 4)
            .take(4)
            .collect::<Vec<_>>();
        let shape = parse_shape(&shape_raw);
        shapes.push(shape);
    }

    let regions = raw_lines
        .iter()
        .skip(24)
        .map(|&line| {
            let parts = line.split_whitespace().collect::<Vec<_>>();
            let dims = parts[0]
                .split('x')
                .map(|d| d.replace(":", "").parse::<usize>().unwrap())
                .collect::<Vec<_>>();
            // Input format may be WxH or HxW; assume first is width then height (as used elsewhere)
            println!("dims: {:?}", dims);
            let shape_conts = parts[1..]
                .iter()
                .map(|&s| s.parse::<usize>().unwrap())
                .collect::<Vec<_>>();
            Region {
                width: dims[0],
                height: dims[1],
                shape_conts,
            }
        })
        .collect::<Vec<_>>();

    Problem { shapes, regions }
}

fn part1(problem: &Problem) -> i32 {
    let shapes = &problem.shapes;

    problem
        .regions
        .iter()
        .enumerate()
        .map(|(index, region)| {
            println!("Solving for region: {:?}", region);
            if solve_tiling_problem(shapes, region) {
                println!("Solution found for region: {:?} at index {}", region, index);
                1
            } else {
                println!(
                    "Solution not found for region: {:?} at index {}",
                    region, index
                );
                0
            }
        })
        .sum()
}

fn part2(problem: &Problem) -> i32 {
    // TODO: Implement Part 2 solution
    0
}

#[cfg(test)]
mod tests {
    use super::*;

    fn sample_input_path() -> String {
        // Match the same sample path used by main (relative to crate dir)
        format!(
            "{}/../../../challenges/day12/input-sample.txt",
            env!("CARGO_MANIFEST_DIR")
        )
    }

    #[test]
    fn region0_is_solvable() {
        let input = read_input(&sample_input_path());
        let problem = parse_problem(&input);
        assert!(solve_tiling_problem(&problem.shapes, &problem.regions[0]));
    }

    #[test]
    #[ignore]
    fn region1_is_solvable() {
        let input = read_input(&sample_input_path());
        let problem = parse_problem(&input);
        assert!(solve_tiling_problem(&problem.shapes, &problem.regions[1]));
    }

    #[ignore]
    #[test]
    fn region2_is_not_solvable() {
        let input = read_input(&sample_input_path());
        let problem = parse_problem(&input);
        assert!(!solve_tiling_problem(&problem.shapes, &problem.regions[2]));
    }
}
