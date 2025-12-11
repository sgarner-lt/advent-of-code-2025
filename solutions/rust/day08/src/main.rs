use std::cmp::Ordering;
// use std::cmp::Reverse;
use std::collections::HashMap;
use std::io::{self, Read};
// use std::collections::{HashMap, HashSet};

fn main() {
    let mut input = String::new();
    io::stdin()
        .read_to_string(&mut input)
        .expect("Failed to read from stdin");

    let (part1_result, part2_result) = solve(&input);

    // Output JSON format for testing framework
    println!(
        "{{\"part1\": {}, \"part2\": {}}}",
        part1_result, part2_result
    );
}

/// Represents a 3d coordinate
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
struct Coordinate {
    x: i32,
    y: i32,
    z: i32,
}
impl Coordinate {
    fn new(x: i32, y: i32, z: i32) -> Self {
        Coordinate { x, y, z }
    }
}
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
struct Circuit {
    components: Vec<Coordinate>,
}
impl Circuit {
    fn new(components: Vec<Coordinate>) -> Self {
        Circuit { components }
    }

    fn add_coordinate(&mut self, item: Coordinate) {
        self.components.push(item);
    }
}

fn process_circuits(
    mut circuits: HashMap<Coordinate, Circuit>,
    mut distances: HashMap<(Coordinate, Coordinate), f32>,
) -> HashMap<Coordinate, Circuit> {
    loop {
        // 1. Find the min pair (this part was fine)
        let min_pair = distances
            .iter()
            .min_by(|(_, dist_a), (_, dist_b)| {
                // partial_cmp returns an Option<Ordering>. We unwrap here assuming no NaNs.
                dist_a.partial_cmp(dist_b).unwrap_or(Ordering::Less)
                // Or you could use f32::total_cmp if using Rust 1.62+ and want IEEE 754 total ordering
                // dist_a.total_cmp(dist_b)
            })
            .map(|((c1, c2), _)| (*c1, *c2));

        // Use 'if let' for cleaner handling of the Option returned by map
        if let Some((c1, c2)) = min_pair {
            // --- Borrowing Logic Start ---

            // We can't use `get_mut` multiple times safely in the same scope,
            // especially not if we plan to insert things.
            // We handle all four cases using the Entry API effectively.

            // Check if both exist first to match original logic intent
            if circuits.contains_key(&c1) && circuits.contains_key(&c2) {
                println!("Both coordinates are already in circuits.");
            } else if let Some(c1_circ) = circuits.get_mut(&c1) {
                // Case 2: C1 exists, C2 does not.
                println!("C1 exists, adding C2 to its circuit and linking C2's key.");
                c1_circ.add_coordinate(c2);

                // CRITICAL FIX: We need to clone the circuit object to insert it under the new key `c2`.
                // Otherwise, we try to put the same *instance* of Circuit in the HashMap twice (by value).
                let new_c2_circuit = c1_circ.clone();
                circuits.insert(c2, new_c2_circuit);
            } else if let Some(c2_circ) = circuits.get_mut(&c2) {
                // Case 3: C2 exists, C1 does not.
                println!("C2 exists, adding C1 to its circuit and linking C1's key.");
                c2_circ.add_coordinate(c1);

                // CRITICAL FIX: Clone the circuit object to insert it under the new key `c1`.
                let new_c1_circuit = c2_circ.clone();
                circuits.insert(c1, new_c1_circuit);
            } else {
                // Case 4: Neither exists.
                println!("Neither exists, creating new circuits.");
                let new_circuit = Circuit::new(vec![c1, c2]);

                // Insert both keys referencing the *same* new circuit data (via clone)
                circuits.insert(c1, new_circuit.clone());
                circuits.insert(c2, new_circuit);
            }

            // --- Borrowing Logic End ---

            // This line was fine, assuming distances is mutable
            distances.remove(&(c1, c2));
        } else {
            println!("No pairs found in distances map.");
            break;
        }
    }

    // Return the updated map
    circuits
}

fn solve(input: &str) -> (String, String) {
    let grid = parse_grid(input);

    println!("Parsed grid successfully. {:?}", grid);

    let mut distances: HashMap<(Coordinate, Coordinate), f32> = HashMap::new();
    for coord in &grid {
        for coord2 in &grid {
            if coord != coord2 {
                let dist = (((coord.x - coord2.x).pow(2)
                    + (coord.y - coord2.y).pow(2)
                    + (coord.z - coord2.z).pow(2)) as f32)
                    .sqrt();

                distances.insert((coord.clone(), coord2.clone()), dist);
            }
        }
    }
    let mut circuits: HashMap<Coordinate, Circuit> = HashMap::new();
    let result = process_circuits(circuits, distances);
    let mut circuit_vec: Vec<(&Coordinate, &Circuit)> = result.iter().collect();

    circuit_vec.sort_by(|(_, a), (_, b)| {
        // Compare b's length to a's length to reverse the order (descending)
        b.components.len().cmp(&a.components.len())
    });

    println!(
        "Final Circuits: {:?}",
        circuit_vec
            .iter()
            .map(|(_, circ)| circ.components.len())
            .collect::<Vec<usize>>()
    );

    let top_3 = circuit_vec.drain(0..2);
    let mult_top_three = top_3.fold(1, |acc, (_, circuit)| acc * circuit.components.len() as u32);

    (mult_top_three.to_string(), "null".to_string())
}

/// Parse input into a 2D grid of characters
fn parse_grid(input: &str) -> Vec<Coordinate> {
    input
        .lines()
        .map(|line| line.trim())
        .filter(|line| !line.is_empty())
        .map(|line| {
            let coords: Vec<i32> = line
                .split(",")
                .map(|s| s.parse::<i32>().expect("Failed to parse integer"))
                .collect();
            Coordinate::new(coords[0], coords[1], coords[2])
        })
        .collect()
}

// fn part1(input: &str) -> i32 {
//     // TODO: Implement Part 1 solution
//     0
// }

// fn part2(input: &str) -> i32 {
//     // TODO: Implement Part 2 solution
//     0
// }
