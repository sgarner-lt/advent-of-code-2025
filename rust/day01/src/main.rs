use std::io::{self, Read};

fn main() {
    // Read input from stdin
    let mut input = String::new();
    io::stdin()
        .read_to_string(&mut input)
        .expect("Failed to read from stdin");

    let (part1_result, part2_result) = solve(&input);

    // Output JSON format for testing framework
    println!("{{\"part1\": {}, \"part2\": {}}}", part1_result, part2_result);
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

/// Counts how many times the dial crosses through position 0 during a rotation.
///
/// This function calculates zero crossings by breaking the rotation into:
/// 1. Complete circles (each crosses 0 exactly once)
/// 2. A remainder rotation (may or may not cross 0 depending on position and direction)
///
/// # Arguments
/// * `position` - Current dial position (0-99)
/// * `rotation` - The rotation instruction (direction and distance)
///
/// # Returns
/// Integer count of zero crossings (>= 0)
fn count_zero_crossings(position: i32, rotation: &Rotation) -> i32 {
    let amount = rotation.distance;

    if amount == 0 {
        return 0;
    }

    // Calculate complete circles and remainder
    let complete_circles = amount / 100;
    let remainder = amount % 100;

    // Each complete circle crosses zero exactly once
    let mut crossings = complete_circles;

    match rotation.direction {
        Direction::Right => {
            // Distance to reach 0 going right (clockwise)
            let distance_to_zero = 100 - position;
            if remainder >= distance_to_zero {
                crossings += 1;
            }
        }
        Direction::Left => {
            // Distance to reach 0 going left (counterclockwise)
            let distance_to_zero = position;
            if position > 0 && remainder >= distance_to_zero {
                crossings += 1;
            }
        }
    }

    crossings
}

fn solve(input: &str) -> (i32, i32) {
    let mut position = 50;
    let mut part1_count = 0;
    let mut part2_count = 0;

    for line in input.lines() {
        if let Some(rotation) = parse_rotation(line) {
            // Calculate Part 2: count zero crossings during rotation
            part2_count += count_zero_crossings(position, &rotation);

            // Update position
            position = rotate_dial(position, &rotation);

            // Calculate Part 1: count when dial lands on 0
            if position == 0 {
                part1_count += 1;
            }
        }
    }

    (part1_count, part2_count)
}

#[cfg(test)]
mod tests {
    use super::*;

    // Existing Part 1 tests

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
        let (part1, part2) = solve(input);
        assert_eq!(part1, 3);
        assert_eq!(part2, 6);
    }

    // New Part 2 tests for count_zero_crossings

    #[test]
    fn test_right_crossing_once() {
        let rotation = Rotation {
            direction: Direction::Right,
            distance: 10,
        };
        let crossings = count_zero_crossings(95, &rotation);
        assert_eq!(crossings, 1);
    }

    #[test]
    fn test_left_crossing_once() {
        let rotation = Rotation {
            direction: Direction::Left,
            distance: 10,
        };
        let crossings = count_zero_crossings(5, &rotation);
        assert_eq!(crossings, 1);
    }

    #[test]
    fn test_large_rotation_multiple_crossings() {
        let rotation = Rotation {
            direction: Direction::Right,
            distance: 1000,
        };
        let crossings = count_zero_crossings(50, &rotation);
        assert_eq!(crossings, 10);
    }

    #[test]
    fn test_exact_multiple_of_100() {
        let rotation = Rotation {
            direction: Direction::Right,
            distance: 100,
        };
        let crossings = count_zero_crossings(0, &rotation);
        assert_eq!(crossings, 1);
    }

    #[test]
    fn test_no_crossing() {
        let rotation = Rotation {
            direction: Direction::Right,
            distance: 5,
        };
        let crossings = count_zero_crossings(50, &rotation);
        assert_eq!(crossings, 0);
    }

    #[test]
    fn test_starting_at_zero_right() {
        let rotation = Rotation {
            direction: Direction::Right,
            distance: 10,
        };
        let crossings = count_zero_crossings(0, &rotation);
        assert_eq!(crossings, 0);
    }

    #[test]
    fn test_starting_at_zero_left() {
        let rotation = Rotation {
            direction: Direction::Left,
            distance: 10,
        };
        let crossings = count_zero_crossings(0, &rotation);
        assert_eq!(crossings, 0);
    }

    #[test]
    fn test_ending_at_zero_right() {
        let rotation = Rotation {
            direction: Direction::Right,
            distance: 10,
        };
        let crossings = count_zero_crossings(90, &rotation);
        assert_eq!(crossings, 1);
    }
}
