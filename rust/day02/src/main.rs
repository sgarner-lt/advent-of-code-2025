use std::fs;

fn main() {
    let input = read_input("../../challenges/day02/input.txt");
    println!("Part 1: {}", part1(&input));
    println!("Part 2: {}", part2(&input));
}

fn read_input(path: &str) -> String {
    fs::read_to_string(path).expect("Failed to read input file")
}

fn part1(input: &str) -> i32 {
    // TODO: Implement Part 1 solution
    0
}

fn part2(input: &str) -> i32 {
    // TODO: Implement Part 2 solution
    0
}
