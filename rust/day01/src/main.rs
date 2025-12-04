use std::env;
use std::fs;

fn main() {
    // Get input file path from command-line argument
    let args: Vec<String> = env::args().collect();
    let input_path = if args.len() > 1 {
        &args[1]
    } else {
        "../../challenges/day01/input.txt"
    };

    let input = read_input(input_path);
    let part1_result = part1(&input);
    let part2_result = part2(&input);

    // Output JSON format for testing framework
    println!("{{\"part1\": {}, \"part2\": {}}}", part1_result, part2_result);
}

fn read_input(path: &str) -> String {
    fs::read_to_string(path).expect("Failed to read input file")
}

fn part1(_input: &str) -> i32 {
    // TODO: Implement Part 1 solution
    // For testing purposes, return a placeholder value
    0
}

fn part2(_input: &str) -> i32 {
    // TODO: Implement Part 2 solution
    // For testing purposes, return a placeholder value
    0
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part1() {
        let input = "test input";
        assert_eq!(part1(input), 0);
    }

    #[test]
    fn test_part2() {
        let input = "test input";
        assert_eq!(part2(input), 0);
    }
}
