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

    // Output JSON format for testing framework
    println!("{{\"part1\": {}, \"part2\": null}}", part1_result);
}

fn read_input(path: &str) -> String {
    fs::read_to_string(path).expect("Failed to read input file")
}

#[derive(Debug, PartialEq)]
enum Direction {
    Left,
    Right,
}

#[derive(Debug, PartialEq)]
struct Rotation {
    direction: Direction,
    distance: i32,
}

fn parse_rotation(line: &str) -> Option<Rotation> {
    let line = line.trim();
    if line.is_empty() {
        return None;
    }

    let direction = match line.chars().next()? {
        'L' => Direction::Left,
        'R' => Direction::Right,
        _ => return None,
    };

    let distance = line[1..].parse::<i32>().ok()?;

    Some(Rotation { direction, distance })
}

fn rotate_dial(position: i32, rotation: &Rotation) -> i32 {
    let new_position = match rotation.direction {
        Direction::Left => position - rotation.distance,
        Direction::Right => position + rotation.distance,
    };

    // Handle negative modulo correctly for circular dial (0-99)
    ((new_position % 100) + 100) % 100
}

fn part1(input: &str) -> i32 {
    let mut position = 50;
    let mut zero_count = 0;

    for line in input.lines() {
        if let Some(rotation) = parse_rotation(line) {
            position = rotate_dial(position, &rotation);
            if position == 0 {
                zero_count += 1;
            }
        }
    }

    zero_count
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_left_rotation() {
        let rotation = parse_rotation("L68").unwrap();
        assert_eq!(rotation.direction, Direction::Left);
        assert_eq!(rotation.distance, 68);
    }

    #[test]
    fn test_parse_right_rotation() {
        let rotation = parse_rotation("R48").unwrap();
        assert_eq!(rotation.direction, Direction::Right);
        assert_eq!(rotation.distance, 48);
    }

    #[test]
    fn test_left_rotation_with_wraparound() {
        let rotation = Rotation {
            direction: Direction::Left,
            distance: 10,
        };
        let result = rotate_dial(5, &rotation);
        assert_eq!(result, 95);
    }

    #[test]
    fn test_right_rotation_with_wraparound() {
        let rotation = Rotation {
            direction: Direction::Right,
            distance: 10,
        };
        let result = rotate_dial(95, &rotation);
        assert_eq!(result, 5);
    }

    #[test]
    fn test_rotation_lands_on_zero() {
        let rotation = Rotation {
            direction: Direction::Right,
            distance: 48,
        };
        let result = rotate_dial(52, &rotation);
        assert_eq!(result, 0);
    }

    #[test]
    fn test_sample_input() {
        let input = "L68\nL30\nR48\nL5\nR60\nL55\nL1\nL99\nR14\nL82";
        let result = part1(input);
        assert_eq!(result, 3);
    }
}
