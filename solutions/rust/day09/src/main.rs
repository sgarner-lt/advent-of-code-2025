use std::collections::BinaryHeap;
use std::collections::HashSet;
use std::fmt;
use std::io::{self, Read};

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Point {
    x: i64,
    y: i64,
}
impl Point {
    fn new(x: i64, y: i64) -> Self {
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
    let grid = parse_grid(&input);
    let mut eval = BinaryHeap::new();
    for p1 in &grid {
        for p2 in &grid {
            if p1 != p2 {
                let area = ((p1.x - p2.x).abs() + 1) * ((p1.y - p2.y).abs() + 1);
                eval.push(area);
                println!("Comparing Point {} and Point {}: area={}", p1, p2, area);
            }
        }
    }
    println!(
        "{{\"part1\": {}, \"part2\": {}}}",
        eval.peek().unwrap().to_string(),
        "null".to_string()
    );
}

fn parse_grid(input: &str) -> HashSet<Point> {
    input
        .lines()
        .map(|line| line.trim())
        .filter(|line| !line.is_empty())
        .map(|line| {
            let coords: Vec<i64> = line
                .split(",")
                .map(|s| s.parse::<i64>().expect("Failed to parse integer"))
                .collect();
            Point::new(coords[0], coords[1])
        })
        .collect()
}

// fn read_input(path: &str) -> String {
//     fs::read_to_string(path).expect("Failed to read input file")
// }

// fn part1(input: &str) -> i32 {
//     // TODO: Implement Part 1 solution
//     0
// }

// fn part2(input: &str) -> i32 {
//     // TODO: Implement Part 2 solution
//     0
// }
