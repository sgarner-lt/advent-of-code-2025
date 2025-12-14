use bitvec::prelude::*;
use itertools::Itertools;
use rayon::prelude::*;
use std::collections::HashSet;
use std::fmt;
use std::io::{self, Read};

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Point {
    x: i32,
    y: i32,
}
impl Point {
    fn new(x: i32, y: i32) -> Self {
        Point { x, y }
    }
}
impl fmt::Display for Point {
    // This trait requires the `fmt` method with this exact signature
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        // Use the write! macro to write the formatted output into the Formatter
        write!(f, "{},{}", self.x, self.y)
    }
}

struct BitGridCrate {
    data: BitVec<u64, Lsb0>,
    width: usize,
    height: usize,
}

impl BitGridCrate {
    fn new(width: usize, height: usize) -> Self {
        let total_bits = width * height;
        // Initialize a bitvec with enough capacity, all bits set to false
        let mut data: BitVec<u64, Lsb0> = BitVec::with_capacity(total_bits);
        data.resize(total_bits, false);

        BitGridCrate {
            data,
            width,
            height,
        }
    }

    /// Build a 2D prefix-sum (integral image) where each cell is 1 for true (set) else 0.
    /// The returned Vec has dimensions (height+1) x (width+1) in row-major order so that
    /// sums[(r+1)*(width+1) + (c+1)] gives the prefix up to and including (r,c).
    fn build_prefix_sum(&self) -> Vec<usize> {
        let w = self.width;
        let h = self.height;
        let stride = w + 1;
        let mut sums = vec![0usize; (h + 1) * (w + 1)];

        for r in 0..h {
            let mut row_acc = 0usize;
            for c in 0..w {
                let bit = self.data[r * w + c];
                if bit {
                    row_acc += 1;
                }
                let idx = (r + 1) * stride + (c + 1);
                sums[idx] = sums[(r) * stride + (c + 1)] + row_acc;
            }
        }
        sums
    }

    /// Query the sum of bits in rect inclusive [r0..=r1] x [c0..=c1] using a prefix-sum built
    /// with `build_prefix_sum`. Coordinates must be within bounds.
    fn prefix_sum_query(
        sums: &Vec<usize>,
        width: usize,
        r0: usize,
        c0: usize,
        r1: usize,
        c1: usize,
    ) -> usize {
        let stride = width + 1;
        let a = sums[(r1 + 1) * stride + (c1 + 1)];
        let b = sums[(r0) * stride + (c1 + 1)];
        let c = sums[(r1 + 1) * stride + (c0)];
        let d = sums[(r0) * stride + (c0)];
        a + d - b - c
    }

    // Helper for 1D index calculation
    fn index(&self, x: usize, y: usize) -> Option<usize> {
        if x < self.width && y < self.height {
            Some(y * self.width + x)
        } else {
            None
        }
    }

    // Set a bit
    #[inline]
    fn set(&mut self, x: usize, y: usize, value: bool) {
        if let Some(index) = self.index(x, y) {
            self.data.set(index, value);
        }
    }

    // Get a bit
    #[inline]
    fn get(&self, x: usize, y: usize) -> Option<bool> {
        self.index(x, y).map(|index| self.data[index])
    }
}

fn main() {
    let mut input = String::new();
    io::stdin()
        .read_to_string(&mut input)
        .expect("Failed to read from stdin");
    let points = parse_points(&input);
    // let part1 = part1(&points);
    let part1: i32 = 0;
    let part2: i64 = part2(&points);

    println!(
        "{{\"part1\": {}, \"part2\": {}}}",
        part1.to_string(),
        part2.to_string()
    );
}

fn contains_all_red_green_tiles_using_prefix(
    sums: &Vec<usize>,
    grid_width: usize,
    p1: &Point,
    p2: &Point,
) -> bool {
    let x_start = p1.x.min(p2.x) as usize;
    let y_start = p1.y.min(p2.y) as usize;
    let x_end = p1.x.max(p2.x) as usize;
    let y_end = p1.y.max(p2.y) as usize;

    let area_width = x_end - x_start + 1;
    let area_height = y_end - y_start + 1;
    let expected = area_width * area_height;

    let actual = BitGridCrate::prefix_sum_query(sums, grid_width, y_start, x_start, y_end, x_end);
    actual == expected
}

fn part2(un_normalized_points: &HashSet<Point>) -> i64 {
    // normalize points to start at (0,0)
    println!("Normalizing points...");
    let min_point_x = un_normalized_points.iter().map(|p| p.x).min().unwrap();
    let min_point_y = un_normalized_points.iter().map(|p| p.y).min().unwrap();
    let points: HashSet<Point> = un_normalized_points
        .iter()
        .map(|p| Point::new(p.x - min_point_x, p.y - min_point_y))
        .collect();

    let grid_max_x_columns = points.iter().map(|p| p.x).max().unwrap() + 1;
    let grid_max_y_rows = points.iter().map(|p| p.y).max().unwrap() + 1;

    // create grid
    println!(
        " Creating grid of size {} x {}...",
        grid_max_x_columns, grid_max_y_rows
    );
    let mut grid = BitGridCrate::new(grid_max_x_columns as usize, grid_max_y_rows as usize);

    // draw lines between points (green tiles)
    println!(" Drawing lines between points...");
    for p1 in &points {
        for p2 in &points {
            if p1 != p2 {
                let x_dif = (p1.x - p2.x).abs();
                let y_dif = (p1.y - p2.y).abs();
                if p1.x == p2.x {
                    let base_x = p1.x as usize;
                    for y in 0..=y_dif {
                        grid.set(base_x, p1.y.min(p2.y) as usize + y as usize, true);
                    }
                }
                if p1.y == p2.y {
                    let base_y = p1.y as usize;
                    for x in 0..=x_dif {
                        grid.set(p1.x.min(p2.x) as usize + x as usize, base_y, true);
                    }
                }
            }
        }
    }

    println!(" Plotting points (red tiles)...");
    // plot points (red tiles)
    for y in 0..=grid.height - 1 {
        let y_index = y as i32;
        for x in 0..=grid.width - 1 {
            if points.contains(&Point::new(x as i32, y_index)) {
                grid.set(x, y, true);
            }
        }
    }

    println!(" Plotting points (green internal tiles)...");
    // fill interior with I (aka green tiles)
    for y in 0..=grid.height - 1 {
        let mut min_x_red_green_tile = None;
        let mut max_x_red_green_tile = None;
        for x in 0..=grid.width - 1 {
            let is_red_green_tile = grid.get(x, y).unwrap();
            if is_red_green_tile && min_x_red_green_tile.is_none() {
                min_x_red_green_tile = Some(x);
            } else if is_red_green_tile {
                max_x_red_green_tile = Some(x);
            }
        }
        if let (Some(min_x), Some(max_x)) = (min_x_red_green_tile, max_x_red_green_tile) {
            for x in 0..=grid.width - 1 {
                let is_red_green_tile = grid.get(x, y).unwrap();
                if !is_red_green_tile && x > min_x && x < max_x {
                    grid.set(x, y, true);
                }
            }
        }
    }

    // print grid
    // for y in 0..=grid.num_rows() - 1 {
    //     for x in 0..=grid.num_columns() - 1 {
    //         print!("{}", grid[(y, x)]);
    //     }
    //     println!();
    // }

    println!("Finding max area...");

    // Build prefix sums once for O(1) rectangle checks
    let sums = grid.build_prefix_sum();

    let max_area = points
        .iter()
        .combinations(2)
        .par_bridge()
        .filter_map(|p_vect| {
            let (p1, p2) = (p_vect[0], p_vect[1]);
            let p1x = p1.x as i64;
            let p1y = p1.y as i64;
            let sums = &sums;
            let grid_width = grid.width;

            if p1 != p2 {
                let p2x = p2.x as i64;
                let p2y = p2.y as i64;
                if contains_all_red_green_tiles_using_prefix(sums, grid_width, &p1, &p2) {
                    let area = ((p1x - p2x).abs() + 1) * ((p1y - p2y).abs() + 1);
                    Some(area)
                } else {
                    None
                }
            } else {
                None
            }
        })
        .max();
    max_area.unwrap_or(0)
}

fn part1(points: &HashSet<Point>) -> i64 {
    let mut max_area: i64 = 0;
    for p1 in points {
        let p1x = p1.x as i64;
        let p1y = p1.y as i64;
        for p2 in points {
            if p1 != p2 {
                let p2x = p2.x as i64;
                let p2y = p2.y as i64;
                let area = ((p1x - p2x).abs() + 1) * ((p1y - p2y).abs() + 1);
                max_area = max_area.max(area);
                // println!("Comparing Point {} and Point {}: area={}", p1, p2, area);
            }
        }
    }
    max_area
}

fn parse_points(input: &str) -> HashSet<Point> {
    println!("Parsing points...");
    input
        .lines()
        .map(|line| line.trim())
        .filter(|line| !line.is_empty())
        .map(|line| {
            let coords: Vec<i32> = line
                .split(",")
                .map(|s| s.parse::<i32>().expect("Failed to parse integer"))
                .collect();
            Point::new(coords[0], coords[1])
        })
        .collect()
}
