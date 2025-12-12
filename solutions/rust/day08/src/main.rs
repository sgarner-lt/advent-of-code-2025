// use std::cmp::Ordering;
// use std::cmp::Reverse;
use ordered_float::NotNan;
use std::cmp::Ordering;
use std::cmp::Reverse;
use std::collections::BinaryHeap;
use std::collections::HashMap;
use std::collections::HashSet;
use std::fmt;
use std::hash::Hash;
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
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, PartialOrd, Ord)]
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
impl fmt::Display for Coordinate {
    // This trait requires the `fmt` method with this exact signature
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        // Use the write! macro to write the formatted output into the Formatter
        write!(f, "{},{},{}", self.x, self.y, self.z)
    }
}
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct CoordinatDistance {
    distance: NotNan<f64>,
    coord_a: Coordinate,
    coord_b: Coordinate,
}
impl fmt::Display for CoordinatDistance {
    // This trait requires the `fmt` method with this exact signature
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        // Use the write! macro to write the formatted output into the Formatter
        write!(
            f,
            "({},{}:{:.0})",
            self.coord_a.x, self.coord_b, self.distance
        )
    }
}
impl Ord for CoordinatDistance {
    fn cmp(&self, other: &Self) -> Ordering {
        // Use f64::total_cmp to create a total ordering
        // Note: This makes it a max-heap by default
        self.distance.total_cmp(&other.distance)
    }
}
impl PartialOrd for CoordinatDistance {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
struct CoordinateCircuit {
    coordinate: Coordinate,
    circuit_id: Option<Uuid>,
}
impl fmt::Display for CoordinateCircuit {
    // This trait requires the `fmt` method with this exact signature
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        // Use the write! macro to write the formatted output into the Formatter
        write!(
            f,
            "{}:{},{},{}",
            self.circuit_id.unwrap_or(Uuid::nil()),
            self.coordinate.x,
            self.coordinate.y,
            self.coordinate.z
        )
    }
}

fn create_first_ten_connections(
    distances: &mut BinaryHeap<Reverse<CoordinatDistance>>,
) -> HashSet<CoordinateCircuit> {
    let mut circuits: HashMap<Coordinate, CoordinateCircuit> = HashMap::new();
    let mut iteration = 0;
    while !distances.is_empty() && iteration < 1000 {
        if let Some(current) = distances.pop() {
            let coord_a = current.0.coord_a;
            let coord_b = current.0.coord_b;

            if circuits.contains_key(&coord_a) && circuits.contains_key(&coord_b) {
                iteration += 1;
                // Both coordinates are already in circuits, skip
                let a_circuit = circuits.get(&coord_a).unwrap().clone();
                let b_circuit = circuits.get(&coord_b).unwrap().clone();
                if a_circuit.circuit_id != b_circuit.circuit_id {
                    // merge circuits
                    for entry in circuits.values_mut() {
                        if entry.circuit_id == a_circuit.circuit_id {
                            entry.circuit_id = b_circuit.circuit_id.clone();
                        }
                    }
                } else {
                    continue;
                }
            } else if circuits.contains_key(&coord_a) && !circuits.contains_key(&coord_b) {
                // coord_a is already in a circuit, add coord_b to that circuit
                let existing_circuit = circuits.get(&coord_a).unwrap();
                let new_circuit = CoordinateCircuit {
                    coordinate: coord_b,
                    circuit_id: existing_circuit.circuit_id,
                };
                circuits.insert(new_circuit.coordinate, new_circuit);
                iteration += 1;
            } else if circuits.contains_key(&coord_b) && !circuits.contains_key(&coord_a) {
                // coord_b is already in a circuit, add coord_a to that circuit
                let existing_circuit = circuits.get(&coord_b).unwrap();
                let new_circuit = CoordinateCircuit {
                    coordinate: coord_a,
                    circuit_id: existing_circuit.circuit_id,
                };
                circuits.insert(new_circuit.coordinate, new_circuit);
                iteration += 1;
            } else {
                let new_circuit_id = Uuid::new_v4();
                let circuit_a = CoordinateCircuit {
                    coordinate: coord_a,
                    circuit_id: Some(new_circuit_id),
                };
                let circuit_b = CoordinateCircuit {
                    coordinate: coord_b,
                    circuit_id: Some(new_circuit_id),
                };
                circuits.insert(circuit_a.coordinate, circuit_a);
                circuits.insert(circuit_b.coordinate, circuit_b);
                iteration += 1;
            }
        }
    }

    circuits.values().cloned().collect()
}

fn compute_distances(grid: &HashSet<Coordinate>) -> BinaryHeap<Reverse<CoordinatDistance>> {
    let mut distances: BinaryHeap<Reverse<CoordinatDistance>> = BinaryHeap::new();
    let mut seen_pairs: HashSet<(Coordinate, Coordinate)> = HashSet::new();
    for coord in grid.clone() {
        for coord2 in grid.clone() {
            if coord != coord2 {
                let x_comp = coord.x as f64 - coord2.x as f64;
                let y_comp = coord.y as f64 - coord2.y as f64;
                let z_comp = coord.z as f64 - coord2.z as f64;

                let x_squared = x_comp * x_comp;
                let y_squared = y_comp * y_comp;
                let z_squared = z_comp * z_comp;

                let dist = (x_squared + y_squared + z_squared).sqrt();
                let dist_nan = NotNan::new(dist).unwrap();
                let coord_dist = CoordinatDistance {
                    distance: dist_nan,
                    coord_a: coord,
                    coord_b: coord2,
                };

                if !seen_pairs.contains(&(coord, coord2)) && !seen_pairs.contains(&(coord2, coord))
                {
                    distances.push(Reverse(coord_dist));
                    seen_pairs.insert((coord, coord2));
                    seen_pairs.insert((coord2, coord));
                } else {
                    continue;
                }
            }
        }
    }
    distances
}

fn group_coordinates_by_circuit(
    circuits: &HashSet<CoordinateCircuit>,
) -> HashMap<Uuid, HashSet<Coordinate>> {
    let mut grouped_map: HashMap<Uuid, HashSet<Coordinate>> = HashMap::new();

    for box_circuit in circuits {
        // Use entry() to check if the ID already exists in the grouped_map.
        // If it does, get the mutable reference to the Vec.
        // If it doesn't, insert a new empty Vec.
        if let Some(cicuit_id) = box_circuit.circuit_id {
            grouped_map
                .entry(cicuit_id)
                .or_insert_with(HashSet::new)
                .insert(box_circuit.coordinate);
        } else {
            grouped_map.insert(
                Uuid::new_v4(),
                [box_circuit.coordinate].iter().cloned().collect(),
            );
        }
    }

    println!("Final Grouped Map: {:?}", grouped_map);

    grouped_map
}

fn circuits_decending(grouped_map: &HashMap<Uuid, HashSet<Coordinate>>) -> Vec<usize> {
    let mut circuit_vec: Vec<usize> = grouped_map.iter().map(|(_, v)| v.len()).collect();

    circuit_vec.sort();
    circuit_vec.reverse();

    println!("Final Circuits: {:?}", circuit_vec);
    circuit_vec
}

fn pick_top_3_circuits(circuit_vec: &Vec<usize>) -> Vec<usize> {
    let top_3 = circuit_vec.iter().take(3).cloned().collect();
    println!("Top 3 Circuits: {:?}", top_3);
    top_3
}

fn calc_top_3_product(top_3: &Vec<usize>) -> u128 {
    top_3
        .iter()
        .fold(1 as u128, |acc, x| (acc as u128) * (*x as u128))
}

fn solve(input: &str) -> (String, String) {
    let grid = parse_grid(input);

    println!("Parsed grid successfully. ");

    let mut distances = compute_distances(&grid);
    println!("computed distances");

    let circuits = create_first_ten_connections(&mut distances);
    println!("created circuits");

    let grouped_map = group_coordinates_by_circuit(&circuits);
    println!("groupd by circuit");

    let circuit_vec = circuits_decending(&grouped_map);
    println!("ordered decending");

    let top_3 = pick_top_3_circuits(&circuit_vec);
    println!("computed top 3");

    let mult_top_three = calc_top_3_product(&top_3);
    println!("calc product of top 3");

    (mult_top_three.to_string(), "null".to_string())
}

/// Parse input into a 2D grid of characters
fn parse_grid(input: &str) -> HashSet<Coordinate> {
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

#[cfg(test)]
mod tests {
    use super::*;

    static SAMPLE_INPUT: &str = "162,817,812
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

    static EXPECTED_DISTANCES_LEN: usize = 190;

    // Part 1 tests

    #[test]
    fn test_create_first_ten_connections() {
        let grid = parse_grid(SAMPLE_INPUT);
        let distances = compute_distances(&grid);
        let circuits = create_first_ten_connections(&distances);

        assert!(distances.len() < EXPECTED_DISTANCES_LEN); // Some distances should have been removed
        assert_eq!(circuits.len(), 13); // Each coordinate should map to a circuit

        for coord in &circuits {
            println!("{}", coord);
            assert!(coord.circuit_id.is_some()); // All circuits should have an ID
        }
        let grouped_by_circuit = group_coordinates_by_circuit(&circuits);
        let mut counts_per_circuit: Vec<usize> = grouped_by_circuit
            .iter()
            .map(|(_id, coords)| coords.len())
            .collect();
        counts_per_circuit.sort();
        counts_per_circuit.reverse();
        println!("Counts per circuit: {:?}", counts_per_circuit);

        let boxes_in_circuits: HashSet<Coordinate> = grouped_by_circuit
            .values()
            .flat_map(|s| s.iter())
            .map(|x| *x)
            .into_iter()
            .collect();
        assert_eq!(
            circuits
                .iter()
                .map(|x| &x.coordinate)
                .collect::<HashSet<_>>(),
            boxes_in_circuits.iter().collect::<HashSet<_>>()
        ); // All coordinates should be accounted for

        assert_eq!(grouped_by_circuit.keys().len(), 4);
    }

    #[test]
    fn test_min_distance_sample() {
        let grid = parse_grid(SAMPLE_INPUT);
        let distances = compute_distances(&grid);
        let mut circuits: HashMap<Coordinate, CoordinateCircuit> = HashMap::new();
        let first_min = find_min_pair(&distances, circuits.clone());

        let expected_first_min = (
            Coordinate::new(162, 817, 812),
            Coordinate::new(425, 690, 689),
        );
        assert_eq!(*first_min.0, expected_first_min.0);
        assert_eq!(&first_min.1.coordinate, &expected_first_min.1);
        let expected_second_min = (
            Coordinate::new(162, 817, 812),
            Coordinate::new(431, 825, 988),
        );
        let the_circuit_id = Uuid::new_v4();
        circuits.insert(
            expected_first_min.0,
            CoordinateCircuit {
                coordinate: expected_first_min.0,
                circuit_id: Some(the_circuit_id),
            },
        );
        circuits.insert(
            expected_first_min.1,
            CoordinateCircuit {
                coordinate: expected_first_min.1,
                circuit_id: Some(the_circuit_id),
            },
        );
        let second_min: (&Coordinate, &CoordinatDistance) =
            find_min_pair(&distances, circuits.clone());
        assert_eq!(*second_min.0, expected_second_min.0);
        assert_eq!(&second_min.1.coordinate, &expected_second_min.1);

        circuits.insert(
            expected_second_min.0,
            CoordinateCircuit {
                coordinate: expected_second_min.0,
                circuit_id: Some(the_circuit_id),
            },
        );

        circuits.insert(
            expected_second_min.1,
            CoordinateCircuit {
                coordinate: expected_second_min.1,
                circuit_id: Some(the_circuit_id),
            },
        );
        let expected_third_min = (
            Coordinate::new(906, 360, 560),
            Coordinate::new(805, 96, 715),
        );
        let third_min = find_min_pair(&distances, circuits.clone());
        assert_eq!(*third_min.0, expected_third_min.0);
        assert_eq!(&third_min.1.coordinate, &expected_third_min.1);
    }

    #[test]
    fn test_compute_distances() {
        let grid = parse_grid(SAMPLE_INPUT);
        let distances = compute_distances(&grid);
        for (cord1, heap) in &distances {
            for closest in heap {
                let cord2 = &closest.0.coordinate;
                let dist = closest.0.distance;
                println!("Distance between {} and {} is {:.0}", cord1, cord2, dist);
            }
        }
        assert_eq!(distances.len(), EXPECTED_DISTANCES_LEN);
        let (first, heap) = distances.iter().take(1).next().unwrap();

        let self_coord = heap.iter().find(|f| f.0.coordinate == *first);
        assert_eq!(self_coord.is_none(), true);
    }

    fn hp(c: Coordinate, d: f64) -> BinaryHeap<Reverse<CoordinatDistance>> {
        let mut heap = BinaryHeap::new();
        heap.push(Reverse(CoordinatDistance {
            coordinate: c,
            distance: NotNan::new(d).unwrap(),
        }));
        heap
    }

    #[test]
    fn test_min_distance() {
        let mut distances: HashMap<Coordinate, BinaryHeap<Reverse<CoordinatDistance>>> =
            HashMap::new();

        let c1 = Coordinate::new(0, 0, 0);
        let c2 = Coordinate::new(1, 1, 1);
        let c3 = Coordinate::new(2, 2, 2);

        distances.insert(c1, hp(c2, 1.732));
        distances.insert(c1, hp(c3, 3.464));
        distances.insert(c2, hp(c3, 2.732));

        let mut circuits: HashMap<Coordinate, CoordinateCircuit> = HashMap::new();
        let min_pair = find_min_pair(&distances, circuits.clone());
        assert_eq!(*min_pair.0, c1);
        assert_eq!(min_pair.1.coordinate, c2);

        let the_circuit_id = Uuid::new_v4();
        circuits.insert(
            c1,
            CoordinateCircuit {
                coordinate: c2,
                circuit_id: Some(the_circuit_id),
            },
        );
        let min_pair2 = find_min_pair(&distances, circuits.clone());
        assert_eq!(*min_pair2.0, c2);
        assert_eq!(min_pair2.1.coordinate, c3);
    }

    #[test]
    fn test_parse_grid() {
        let grid = parse_grid(SAMPLE_INPUT);
        assert_eq!(grid.len(), 20);

        let expected = vec![
            Coordinate {
                x: 162,
                y: 817,
                z: 812,
            },
            Coordinate {
                x: 57,
                y: 618,
                z: 57,
            },
            Coordinate {
                x: 906,
                y: 360,
                z: 560,
            },
            Coordinate {
                x: 592,
                y: 479,
                z: 940,
            },
            Coordinate {
                x: 352,
                y: 342,
                z: 300,
            },
            Coordinate {
                x: 466,
                y: 668,
                z: 158,
            },
            Coordinate {
                x: 542,
                y: 29,
                z: 236,
            },
            Coordinate {
                x: 431,
                y: 825,
                z: 988,
            },
            Coordinate {
                x: 739,
                y: 650,
                z: 466,
            },
            Coordinate {
                x: 52,
                y: 470,
                z: 668,
            },
            Coordinate {
                x: 216,
                y: 146,
                z: 977,
            },
            Coordinate {
                x: 819,
                y: 987,
                z: 18,
            },
            Coordinate {
                x: 117,
                y: 168,
                z: 530,
            },
            Coordinate {
                x: 805,
                y: 96,
                z: 715,
            },
            Coordinate {
                x: 346,
                y: 949,
                z: 466,
            },
            Coordinate {
                x: 970,
                y: 615,
                z: 88,
            },
            Coordinate {
                x: 941,
                y: 993,
                z: 340,
            },
            Coordinate {
                x: 862,
                y: 61,
                z: 35,
            },
            Coordinate {
                x: 984,
                y: 92,
                z: 344,
            },
            Coordinate {
                x: 425,
                y: 690,
                z: 689,
            },
        ]
        .iter()
        .map(|i| *i)
        .collect();

        assert_eq!(grid, expected);
    }
}
