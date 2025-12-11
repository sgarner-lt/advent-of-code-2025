// use std::cmp::Ordering;
// use std::cmp::Reverse;
use std::collections::HashMap;
use std::collections::HashSet;
use std::io::{self, Read};
use uuid::Uuid;
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
    id: Uuid,
    components: Vec<Coordinate>,
}
impl Circuit {
    fn new(components: Vec<Coordinate>) -> Self {
        Circuit {
            id: Uuid::new_v4(),
            components,
        }
    }

    fn add_coordinate(&mut self, item: Coordinate) {
        self.components.push(item);
    }
}

fn process_circuits(
    mut circuits: HashMap<Coordinate, Circuit>,
    mut distances: HashMap<(Coordinate, Coordinate), f64>,
) -> HashMap<Coordinate, Circuit> {
    let mut connections_made = 0;
    while connections_made < 11 {
        println!("--- Connections Made: {} ---", connections_made);
        // 1. Find the min pair (this part was fine)
        let min_pair = distances
            .iter()
            .min_by(|a, b| {
                // Compare the f64 values (b.1 and a.1).
                // f64 doesn't implement the Ord trait required by cmp(), so we use partial_cmp().
                // We must handle the Option returned by partial_cmp(), using unwrap() if we're sure
                // the values are not NaN, or by providing a default Ordering.
                a.1.total_cmp(b.1)
            })
            .map(|(k, _v)| *k);

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
                connections_made += 1;
            } else if let Some(c2_circ) = circuits.get_mut(&c2) {
                // Case 3: C2 exists, C1 does not.
                println!("C2 exists, adding C1 to its circuit and linking C1's key.");
                c2_circ.add_coordinate(c1);

                // CRITICAL FIX: Clone the circuit object to insert it under the new key `c1`.
                let new_c1_circuit = c2_circ.clone();
                circuits.insert(c1, new_c1_circuit);
                connections_made += 1;
            } else {
                // Case 4: Neither exists.
                println!("Neither exists, creating new circuits.");
                let new_circuit = Circuit::new(vec![c1, c2]);
                let cloned_circuit = new_circuit.clone();

                // Insert both keys referencing the *same* new circuit data (via clone)
                circuits.insert(c1, cloned_circuit);
                circuits.insert(c2, new_circuit);
                connections_made += 1;
            }

            // --- Borrowing Logic End ---

            // This line was fine, assuming distances is mutable
            distances.remove(&(c1, c2));
            distances.remove(&(c2, c1));
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

    let mut distances: HashMap<(Coordinate, Coordinate), f64> = HashMap::new();
    for coord in &grid {
        for coord2 in &grid {
            if coord != coord2 {
                let x_squared = (coord.x - coord2.x).pow(2) as f64;
                let y_squared = (coord.y - coord2.y).pow(2) as f64;
                let z_squared = (coord.z - coord2.z).pow(2) as f64;

                let dist = (x_squared + y_squared + z_squared).sqrt();

                distances.insert((coord.clone(), coord2.clone()), dist);
            }
        }
    }
    let mut circuits: HashMap<Coordinate, Circuit> = HashMap::new();
    let result: HashMap<Coordinate, Circuit> = process_circuits(circuits, distances);
    let mut grouped_map: HashMap<Uuid, HashSet<Coordinate>> = HashMap::new();

    for (_key, item) in result {
        // Use entry() to check if the ID already exists in the grouped_map.
        // If it does, get the mutable reference to the Vec.
        // If it doesn't, insert a new empty Vec.
        grouped_map
            .entry(item.id)
            .or_insert_with(HashSet::new)
            .extend(item.components);
    }
    println!("Final Grouped Map: {:?}", grouped_map);

    let mut circuit_vec: Vec<usize> = grouped_map.iter().map(|(_, v)| v.len()).collect();

    circuit_vec.sort();
    circuit_vec.reverse();

    println!("Final Circuits: {:?}", circuit_vec);

    let top_3 = circuit_vec.drain(0..3);

    println!("Top 3 Circuits: {:?}", top_3);
    let mult_top_three = top_3.fold(1, |acc, x| acc * x);

    (mult_top_three.to_string(), "null".to_string())
}

/*

Final Grouped Map:
{
52762f71-605e-4dfb-999d-7b1016554431: {
    Coordinate { x: 819, y: 987, z: 18 },
    Coordinate { x: 941, y: 993, z: 340 },
    Coordinate { x: 970, y: 615, z: 88 }},

e78d2783-399f-4f74-9126-c759cf1598a8: {
Coordinate { x: 862, y: 61, z: 35 },
Coordinate { x: 984, y: 92, z: 344 }},

875072b8-a164-4241-a2de-70c000c1d75c: {
Coordinate { x: 57, y: 618, z: 57 },
Coordinate { x: 466, y: 668, z: 158 },
Coordinate { x: 352, y: 342, z: 300 },
Coordinate { x: 542, y: 29, z: 236 }},

1e82bdf7-ad2d-4d37-aee0-7d8729a0301b: {
Coordinate { x: 52, y: 470, z: 668 },
Coordinate { x: 117, y: 168, z: 530 },
Coordinate { x: 216, y: 146, z: 977 }},

1a85bc24-13cc-4f1d-b7cc-90793ddeed6e: {
Coordinate { x: 346, y: 949, z: 466 },
Coordinate { x: 431, y: 825, z: 988 },
Coordinate { x: 425, y: 690, z: 689 },
Coordinate { x: 592, y: 479, z: 940 },
Coordinate { x: 162, y: 817, z: 812 }},

 f38380e3-192f-4a8b-a8ff-f70901b81013: {
 Coordinate { x: 906, y: 360, z: 560 },
 Coordinate { x: 739, y: 650, z: 466 },
 Coordinate { x: 805, y: 96, z: 715 }}}





*/

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

#[cfg(test)]
mod tests {
    use super::*;

    // Part 1 tests
    #[test]
    fn test_parse_grid() {
        let input = "162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689";

        let grid = parse_grid(input);
        assert_eq!(grid.len(), 20);

        let expected =vec![
            Coordinate { x: 162, y: 817, z: 812 },
            Coordinate { x: 57, y: 618, z: 57 },
            Coordinate { x: 906, y: 360, z: 560 },
            Coordinate { x: 592, y: 479, z: 940 },
            Coordinate { x: 352, y: 342, z: 300 },
            Coordinate { x: 466, y: 668, z: 158 },
            Coordinate { x: 542, y: 29, z: 236 },
            Coordinate { x: 431, y: 825, z: 988 },
            Coordinate { x: 739, y: 650, z: 466 },
            Coordinate { x: 52, y: 470, z: 668 },
            Coordinate { x: 216, y: 146, z: 977 },
            Coordinate { x: 819, y: 987, z: 18 },
            Coordinate { x: 117, y: 168, z: 530 },
            Coordinate { x: 805, y: 96, z: 715 },
            Coordinate { x: 346, y: 949, z: 466 },
            Coordinate { x: 970, y: 615, z: 88 },
            Coordinate { x: 941, y: 993, z: 340 },
            Coordinate { x: 862, y: 61, z: 35 },
            Coordinate { x: 984, y: 92, z: 344 },
            Coordinate { x: 425, y: 690, z: 689 },
        ];

        assert_eq!( grid, expected );
    }
}
