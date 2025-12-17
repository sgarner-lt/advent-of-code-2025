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
    println!("Part 1: {}", part1(&input));
    println!("Part 2: {}", part2(&input));
}

#[derive(Debug)]
struct Shape {
    index: usize,
    coords: Vec<(usize, usize)>,
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

fn parse_problem(input: &str) -> Problem {
    let raw_lines = input
        .lines()
        .map(|line| line.trim())
        .filter(|l| !l.is_empty())
        .collect::<Vec<_>>();

    let mut shapes = Vec::new();
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

fn part1(input: &str) -> i32 {
    // TODO: Implement Part 1 solution
    0
}

fn part2(input: &str) -> i32 {
    // TODO: Implement Part 2 solution
    0
}
