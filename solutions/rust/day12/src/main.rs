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
    let rotated = coords.iter().map(|&(r, c)| (c, 2 - r)).collect::<Vec<_>>();
    normalize_shape(rotated)
}

// Flips coordinates horizontally (mirrors across a vertical axis) and normalizes
fn flip_horizontal(coords: &[(usize, usize)]) -> Vec<(usize, usize)> {
    let flipped = coords.iter().map(|&(r, c)| (r, 2 - c)).collect::<Vec<_>>();
    normalize_shape(flipped)
}

fn get_all_orientations(initial_shape: &Shape) -> Vec<Shape> {
    let mut unique_orientations = HashSet::new();
    let mut current_shape_base = initial_shape.coords.to_vec();

    // We generate all rotations for the base orientation and the flipped orientation
    let orientations_to_process = vec![
        normalize_shape(current_shape_base.clone()), // Base
        flip_horizontal(&initial_shape.coords),      // Flipped
    ];

    for mut shape_variant in orientations_to_process {
        for _ in 0..4 {
            // 0, 90, 180, 270 degrees
            let normalized = normalize_shape(shape_variant.clone());
            unique_orientations.insert(normalized);
            shape_variant = rotate_90_clockwise(&shape_variant);
        }
    }

    // Convert HashSet back to a standard Vec for use in the DLX matrix generation
    unique_orientations
        .into_iter()
        .map(|coords| Shape {
            index: initial_shape.index,
            coords,
        })
        .collect()
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

fn generate_dlx_options(shapes: &Vec<Shape>, region: &Region) -> Vec<Vec<usize>> {
    let mut options_matrix: Vec<Vec<usize>> = Vec::new();

    let all_unique_orientations: Vec<Vec<(usize, usize)>> =
        shapes.iter().map(|s| s.coords.clone()).collect();

    // Iterate through every shape, every orientation, every top-left grid position (r, c)
    for shape_orientation in &all_unique_orientations {
        for r in 0..region.height {
            for c in 0..region.width {
                // Check if this specific placement is valid (stays within 50x50 bounds)
                if is_placement_valid(&shape_orientation, r, c, region) {
                    let mut current_option: Vec<usize> = Vec::new();
                    // Convert (r, c) coordinates to a single linear index (0 to 2499 for 50x50)
                    for (sr, sc) in shape_orientation {
                        let linear_index = (r + sr) * region.width + (c + sc);
                        current_option.push(linear_index);
                    }
                    // Sort indices for canonical representation
                    current_option.sort_unstable();
                    options_matrix.push(current_option);
                }
            }
        }
    }
    // Note: If you use different types of shapes, you also need to ensure the number
    // of each shape used is exactly correct, usually done via secondary constraints
    // in the DLX matrix setup. For simple tiling where all shapes are used, the
    // options only cover the cells.

    options_matrix
}

use dlx_rs::Solver;

fn solve_tiling_problem(shapes: &Vec<Shape>, region: &Region) -> bool {
    let options = generate_dlx_options(shapes, region);

    let cell_count = region.width * region.height; // For a 50x50 grid
    let mut s = Solver::new(cell_count);

    for (index, shape_options) in options.iter().enumerate() {
        s.add_option(format!("shape_{}", index), &shape_options);
    }
    // Add the placement to the solver.
    // You can use a String or an Enum to identify the option later.

    // To see how many combinations exist:
    // let total_solutions = s.count();
    let solution_exists = s.solve().is_some();
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
        let orientations = get_all_orientations(&shape);
        shapes.extend(orientations);
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
