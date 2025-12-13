use array2d::Array2D;
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

fn contains_all_red_green_tiles(grid: &Array2D<char>, p1: &Point, p2: &Point) -> bool {
    let x_start = p1.x.min(p2.x);
    let y_start = p1.y.min(p2.y);
    let x_end = p1.x.max(p2.x);
    let y_end = p1.y.max(p2.y);

    for y in y_start..=y_end {
        let y_index = y as usize;
        for x in x_start..=x_end {
            let grid_char = grid[(y_index, x as usize)];
            let is_red_green_tile = grid_char == 'X' || grid_char == '#' || grid_char == 'I';
            if !is_red_green_tile {
                return false;
            }
        }
    }
    true
}

fn part2(un_normalized_points: &HashSet<Point>) -> i64 {
    let min_point_x = un_normalized_points.iter().map(|p| p.x).min().unwrap();
    let min_point_y = un_normalized_points.iter().map(|p| p.y).min().unwrap();
    let points: HashSet<Point> = un_normalized_points
        .iter()
        .map(|p| Point::new(p.x - min_point_x, p.y - min_point_y))
        .collect();
    let grid_max_x_columns = points.iter().map(|p| p.x).max().unwrap() + 2;
    let grid_max_y_rows = points.iter().map(|p| p.y).max().unwrap() + 1;

    let mut grid = Array2D::filled_with('.', grid_max_y_rows as usize, grid_max_x_columns as usize);
    // draw lines between points (green tiles)
    for p1 in &points {
        for p2 in &points {
            if p1 != p2 {
                let x_dif = (p1.x - p2.x).abs();
                let y_dif = (p1.y - p2.y).abs();
                if p1.x == p2.x {
                    let base_x = p1.x as usize;
                    for y in 0..=y_dif {
                        grid[(p1.y.min(p2.y) as usize + y as usize, base_x)] = 'X';
                    }
                }
                if p1.y == p2.y {
                    let base_y = p1.y as usize;
                    for x in 0..=x_dif {
                        grid[(base_y, p1.x.min(p2.x) as usize + x as usize)] = 'X';
                    }
                }
            }
        }
    }

    // plot points (red tiles)
    for y in 0..=grid.num_rows() - 1 {
        let y_index = y as i32;
        for x in 0..=grid.num_columns() - 1 {
            if points.contains(&Point::new(x as i32, y_index)) {
                grid[(y, x)] = '#';
            }
        }
    }

    // fill interior with I (aka green tiles)
    for y in 0..=grid.num_rows() - 1 {
        let mut min_x_red_green_tile = None;
        let mut max_x_red_green_tile = None;
        for x in 0..=grid.num_columns() - 1 {
            let grid_char = grid[(y, x)];
            let is_red_green_tile = grid_char == 'X' || grid_char == '#';
            if is_red_green_tile && min_x_red_green_tile.is_none() {
                min_x_red_green_tile = Some(x);
            } else if is_red_green_tile {
                max_x_red_green_tile = Some(x);
            }
        }
        if let (Some(min_x), Some(max_x)) = (min_x_red_green_tile, max_x_red_green_tile) {
            for x in 0..=grid.num_columns() - 1 {
                let grid_char = grid[(y, x)];
                let is_red_green_tile = grid_char == 'X' || grid_char == '#';
                if !is_red_green_tile && x > min_x && x < max_x {
                    grid[(y, x)] = 'I';
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

    let mut max_area: i64 = 0;
    for p1 in &points {
        let p1x = p1.x as i64;
        let p1y = p1.y as i64;
        for p2 in &points {
            if p1 != p2 {
                let p2x = p2.x as i64;
                let p2y = p2.y as i64;
                if contains_all_red_green_tiles(&grid, &p1, &p2) {
                    let area = ((p1x - p2x).abs() + 1) * ((p1y - p2y).abs() + 1);
                    max_area = max_area.max(area);
                }
                // println!("Comparing Point {} and Point {}: area={}", p1, p2, area);
            }
        }
    }
    max_area
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
