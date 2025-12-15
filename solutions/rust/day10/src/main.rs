// use rayon::prelude::*;
use rayon::prelude::*;
use std::fmt;
use std::io::{self, Read};
use std::rc::Rc;

#[derive(PartialEq, Eq, Hash, Clone, Debug)]
struct ButtonWiringSchematic {
    data: Vec<usize>,
}
impl ButtonWiringSchematic {
    fn new(data: Vec<usize>) -> Self {
        ButtonWiringSchematic { data }
    }
}
impl fmt::Display for ButtonWiringSchematic {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "({})",
            self.data
                .iter()
                .map(|x| x.to_string())
                .collect::<Vec<String>>()
                .join(",")
        )
    }
}
#[derive(PartialEq, Eq, Hash, Clone, Debug)]
struct JoltageRequirement {
    data: Vec<u16>,
}
impl JoltageRequirement {
    fn new(data: Vec<u16>) -> Self {
        JoltageRequirement { data }
    }
}
impl SchematicApplier for JoltageRequirement {
    fn apply_button_schema(&self, _schema: &ButtonWiringSchematic) -> JoltageRequirement {
        // Placeholder implementation
        let mut new_data = self.data.clone();
        for &index in &_schema.data {
            new_data[index] += 1;
        }

        JoltageRequirement::new(new_data)
    }
    fn is_goal(&self, machine: &Machine) -> bool {
        self == &machine.joltage_reqs
    }

    fn initial_state(machine: &Machine) -> Self {
        JoltageRequirement::new(vec![0; machine.joltage_reqs.data.len()])
    }

    fn is_over_limit(&self, machine: &Machine) -> bool {
        let over_limit = self.data.iter().any(|&v| v > machine.jotage_max_limit);

        // if over_limit {
        //     println!(
        //         "Checking over limit: {:?} against max {} => {}",
        //         self.data, machine.jotage_max_limit, over_limit
        //     );
        // }
        over_limit
    }
}

impl fmt::Display for JoltageRequirement {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "{{{}}}",
            self.data
                .iter()
                .map(|x| x.to_string())
                .collect::<Vec<String>>()
                .join(",")
        )
    }
}

#[derive(PartialEq, Eq, Hash, Clone, Debug)]
struct IndicatorLightDiagram {
    data: Vec<bool>,
}
impl IndicatorLightDiagram {
    fn new(size: usize) -> Self {
        let data = vec![false; size];
        IndicatorLightDiagram { data }
    }

    fn apply_button_schema(&self, _schema: &ButtonWiringSchematic) -> IndicatorLightDiagram {
        // Placeholder implementation
        let mut new_data = self.data.clone();
        for &index in &_schema.data {
            new_data[index] = !new_data[index];
        }

        IndicatorLightDiagram { data: new_data }
    }
}
impl SchematicApplier for IndicatorLightDiagram {
    fn apply_button_schema(&self, schema: &ButtonWiringSchematic) -> Self {
        self.apply_button_schema(schema)
    }

    fn is_goal(&self, machine: &Machine) -> bool {
        self == &machine.indicator_light_diag
    }

    fn initial_state(machine: &Machine) -> Self {
        IndicatorLightDiagram::new(machine.indicator_light_diag.data.len())
    }
    fn is_over_limit(&self, _machine: &Machine) -> bool {
        false
    }
}

impl fmt::Display for IndicatorLightDiagram {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "[{}]",
            self.data
                .iter()
                .map(|x| if *x { "#" } else { "." })
                .collect::<Vec<&str>>()
                .join("")
        )
    }
}

struct Machine {
    indicator_light_diag: IndicatorLightDiagram,
    button_wiring_schemas: Vec<ButtonWiringSchematic>,
    joltage_reqs: JoltageRequirement,
    jotage_max_limit: u16,
}
impl Machine {
    fn new(
        indicator_light_diag: IndicatorLightDiagram,
        button_wiring_schemas: Vec<ButtonWiringSchematic>,
        joltage_reqs: JoltageRequirement,
    ) -> Self {
        let max_limit = joltage_reqs.data.iter().max().cloned().unwrap_or(0);
        Machine {
            indicator_light_diag,
            button_wiring_schemas,
            joltage_reqs,
            jotage_max_limit: max_limit,
        }
    }
}
impl fmt::Display for Machine {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "{} {} {}",
            self.indicator_light_diag,
            self.button_wiring_schemas
                .iter()
                .map(|x| x.to_string())
                .collect::<Vec<String>>()
                .join(" "),
            self.joltage_reqs
        )
    }
}

struct Problem {
    machines: Vec<Machine>,
}
impl Problem {
    fn new(machines: Vec<Machine>) -> Self {
        Problem { machines }
    }
}
impl fmt::Display for Problem {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        for machine in &self.machines {
            writeln!(f, "{}", machine)?;
        }
        Ok(())
    }
}

trait SchematicApplier {
    // Required function to apply the button schema
    fn apply_button_schema(&self, schema: &ButtonWiringSchematic) -> Self;

    // Required function to check if the current state is a goal state
    fn is_goal(&self, machine: &Machine) -> bool;

    fn initial_state(machine: &Machine) -> Self;

    fn is_over_limit(&self, machine: &Machine) -> bool;
}

enum SearchNode<T: SchematicApplier + Clone> {
    Start {
        initial_state: T,
    },
    Intermediate {
        parent: Rc<SearchNode<T>>,
        button_schema: ButtonWiringSchematic,
        current_state: T,
    },
    Goal {
        parent: Rc<SearchNode<T>>,
    },
}
fn next_steps<T: SchematicApplier + Clone>(
    _current_node: &Rc<SearchNode<T>>,
    _machine: &Machine,
) -> Vec<(Rc<SearchNode<T>>, T)> {
    match _current_node.as_ref() {
        SearchNode::Start { initial_state } => {
            let mut next_nodes: Vec<(Rc<SearchNode<T>>, T)> = vec![];
            for schema in &_machine.button_wiring_schemas {
                // Apply schema to initial_state to get new_state
                let new_state = initial_state.apply_button_schema(schema);
                if new_state.is_over_limit(_machine) {
                    continue; // Skip states that exceed limits
                } else if new_state.is_goal(_machine) {
                    let node = Rc::new(SearchNode::Goal {
                        parent: Rc::clone(_current_node),
                    });
                    next_nodes.push((node, new_state));
                } else {
                    let node = Rc::new(SearchNode::Intermediate {
                        parent: Rc::clone(_current_node),
                        button_schema: schema.clone(),
                        current_state: new_state.clone(),
                    });
                    next_nodes.push((node, new_state));
                }
            }
            next_nodes
        }
        SearchNode::Intermediate {
            parent: _,
            button_schema: _,
            current_state,
        } => {
            let mut next_nodes: Vec<(Rc<SearchNode<T>>, T)> = vec![];
            for schema in &_machine.button_wiring_schemas {
                // Apply schema to current_state to get new_state
                let new_state = current_state.apply_button_schema(schema);
                if new_state.is_over_limit(_machine) {
                    continue; // Skip states that exceed limits
                } else if new_state.is_goal(_machine) {
                    let node = Rc::new(SearchNode::Goal {
                        parent: Rc::clone(_current_node),
                    });
                    next_nodes.push((node, new_state));
                } else {
                    let node = Rc::new(SearchNode::Intermediate {
                        parent: Rc::clone(_current_node),
                        button_schema: schema.clone(),
                        current_state: new_state.clone(),
                    });
                    next_nodes.push((node, new_state));
                }
            }
            // Check if current_state meets goal condition
            // If so, create Goal node (handled above)
            next_nodes
        }
        SearchNode::Goal { .. } => vec![],
    }
}

use std::collections::{HashSet, VecDeque};

fn breadth_first_search<T: SchematicApplier + Clone + Eq + std::hash::Hash>(
    _machine: &Machine,
) -> Option<Rc<SearchNode<T>>> {
    let initial_state: T = T::initial_state(_machine);
    let initial_node = Rc::new(SearchNode::Start {
        initial_state: initial_state.clone(),
    });

    // frontier is a queue for proper BFS performance
    let mut frontier: VecDeque<(Rc<SearchNode<T>>, T)> =
        VecDeque::from(vec![(Rc::clone(&initial_node), initial_state.clone())]);

    // track visited states to avoid revisiting identical states
    let mut visited: HashSet<T> = HashSet::new();
    visited.insert(initial_state);

    while let Some((current_node, _current_state)) = frontier.pop_front() {
        if let SearchNode::Goal { .. } = current_node.as_ref() {
            return Some(current_node);
        }

        let next_nodes = next_steps(&current_node, _machine);
        for (node, state) in next_nodes {
            if visited.contains(&state) {
                continue;
            }
            if state.is_goal(_machine) {
                return Some(node);
            }
            visited.insert(state.clone());
            frontier.push_back((node, state));
        }
    }
    None
}

fn solve_part1<T: SchematicApplier + Clone + Eq + std::hash::Hash>(_problem: &Problem) -> u32 {
    _problem
        .machines
        .par_iter()
        .map(|machine| {
            if let Some(goal_node) = breadth_first_search::<T>(machine) {
                // Count the number of button presses to reach the goal
                let mut count = 0;
                let mut current_node = Some(goal_node);
                while let Some(node_rc) = current_node {
                    match node_rc.as_ref() {
                        SearchNode::Intermediate { parent, .. } => {
                            count += 1;
                            current_node = Some(Rc::clone(&parent));
                        }
                        SearchNode::Goal { parent, .. } => {
                            count += 1;
                            current_node = Some(Rc::clone(&parent));
                        }
                        SearchNode::Start { .. } => break,
                    }
                }
                println!(
                    "Solution found with {} button presses for machine {}",
                    count, machine.joltage_reqs
                );
                count
            } else {
                println!("No solution found for machine {}", machine.joltage_reqs);
                0 // No solution found
            }
        })
        .sum()
}

fn main() {
    let mut input = String::new();
    io::stdin()
        .read_to_string(&mut input)
        .expect("Failed to read from stdin");
    let problem: Problem = parse_problem(&input);

    println!("Parsed Problem:\n{}", problem);

    let part1: u32 = 0; //solve_part1::<IndicatorLightDiagram>(&problem);
    let part2: u32 = solve_part1::<JoltageRequirement>(&problem);

    println!(
        "{{\"part1\": {}, \"part2\": {}}}",
        part1.to_string(),
        part2.to_string()
    );
}

fn parse_problem(input: &str) -> Problem {
    println!("Parsing problem...");
    let mut max_voltage: u16 = 0;
    let machines = input
        .lines()
        .map(|line| line.trim())
        .filter(|line| !line.is_empty())
        .map(|line| {
            let raw_elements: Vec<&str> = line.split(" ").collect();
            let ind_light_data: Vec<bool> = raw_elements[0]
                .replace("[", "")
                .replace("]", "")
                .chars()
                .map(|c| match c {
                    '#' => true,
                    '.' => false,
                    _ => panic!("Unexpected character in indicator light diagram: {}", c),
                })
                .collect();
            let indicator_light_diag = IndicatorLightDiagram {
                data: ind_light_data,
            };

            let button_wiring_schemas = raw_elements
                .iter()
                .skip(1)
                .filter(|s| s.starts_with("("))
                .map(|s| {
                    let data: Vec<usize> = s
                        .replace("(", "")
                        .replace(")", "")
                        .split(",")
                        .map(|c| c.parse::<usize>().expect("Failed to parse digit"))
                        .collect();
                    ButtonWiringSchematic::new(data)
                })
                .collect();

            let joltage_data: Vec<u16> = raw_elements
                .last()
                .unwrap()
                .replace("{", "")
                .replace("}", "")
                .split(",")
                .map(|c| {
                    let v: u16 = c.parse::<u16>().expect("Failed to parse digit");
                    max_voltage = max_voltage.max(v);
                    v
                })
                .collect();
            let joltage_reqs = JoltageRequirement::new(joltage_data);

            Machine::new(indicator_light_diag, button_wiring_schemas, joltage_reqs)
        })
        .collect();

    println!("Max voltage found: {}\n", max_voltage);
    Problem::new(machines)
}
