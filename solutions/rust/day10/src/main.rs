use rayon::prelude::*;
use std::fmt;
use std::io::{self, Read};

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
struct JoltageRequirement {
    data: Vec<usize>,
}
impl JoltageRequirement {
    fn new(data: Vec<usize>) -> Self {
        JoltageRequirement { data }
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
}
impl Machine {
    fn new(
        indicator_light_diag: IndicatorLightDiagram,
        button_wiring_schemas: Vec<ButtonWiringSchematic>,
        joltage_reqs: JoltageRequirement,
    ) -> Self {
        Machine {
            indicator_light_diag,
            button_wiring_schemas,
            joltage_reqs,
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

use std::rc::Rc;

enum SearchNode {
    Start {
        initial_state: IndicatorLightDiagram,
    },
    Intermediate {
        parent: Rc<SearchNode>,
        button_schema: ButtonWiringSchematic,
        current_state: IndicatorLightDiagram,
    },
    Goal {
        parent: Rc<SearchNode>,
    },
}
fn next_steps(
    _current_node: &Rc<SearchNode>,
    _machine: &Machine,
) -> Vec<(Rc<SearchNode>, IndicatorLightDiagram)> {
    match _current_node.as_ref() {
        SearchNode::Start { initial_state } => {
            let mut next_nodes: Vec<(Rc<SearchNode>, IndicatorLightDiagram)> = vec![];
            for schema in &_machine.button_wiring_schemas {
                // Apply schema to initial_state to get new_state
                let new_state = initial_state.apply_button_schema(schema);
                if new_state == _machine.indicator_light_diag {
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
            button_schema,
            current_state,
        } => {
            let mut next_nodes: Vec<(Rc<SearchNode>, IndicatorLightDiagram)> = vec![];
            for schema in &_machine.button_wiring_schemas {
                if button_schema == schema {
                    continue; // Avoid repeating the same button press
                }
                // Apply schema to current_state to get new_state
                let new_state = current_state.apply_button_schema(schema);
                if new_state == _machine.indicator_light_diag {
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

fn breadth_first_search(_machine: &Machine) -> Option<Rc<SearchNode>> {
    use std::collections::HashSet;

    let initial_state = IndicatorLightDiagram::new(_machine.indicator_light_diag.data.len());
    let initial_node = Rc::new(SearchNode::Start {
        initial_state: initial_state.clone(),
    });

    // frontier contains pairs of (node, state) so we can check visited states cheaply
    let mut frontier: Vec<(Rc<SearchNode>, IndicatorLightDiagram)> =
        vec![(Rc::clone(&initial_node), initial_state.clone())];
    let mut visited: HashSet<IndicatorLightDiagram> = HashSet::new();
    visited.insert(initial_state);

    while !frontier.is_empty() {
        let (current_node, current_state) = frontier.remove(0);
        match current_node.as_ref() {
            SearchNode::Goal { .. } => return Some(current_node),
            _ => {
                let next_nodes = next_steps(&current_node, _machine);
                for (node, state) in next_nodes {
                    if visited.contains(&state) {
                        continue;
                    }
                    if state == _machine.indicator_light_diag {
                        return Some(node);
                    }
                    visited.insert(state.clone());
                    frontier.push((node, state));
                }
            }
        }
    }
    None
}

fn solve_part1(_problem: &Problem) -> u32 {
    _problem
        .machines
        .par_iter()
        .map(|machine| {
            if let Some(goal_node) = breadth_first_search(machine) {
                // Count the number of button presses to reach the goal
                let mut count = 0;
                let mut current_node = Some(goal_node);
                while let Some(node_rc) = current_node {
                    match node_rc.as_ref() {
                        SearchNode::Intermediate { parent, .. } => {
                            count += 1;
                            current_node = Some(Rc::clone(parent));
                        }
                        SearchNode::Goal { parent, .. } => {
                            count += 1;
                            current_node = Some(Rc::clone(parent));
                        }
                        SearchNode::Start { .. } => break,
                    }
                }
                count
            } else {
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
    // let part1 = part1(&points);
    println!("Parsed Problem:\n{}", problem);

    let part1: u32 = solve_part1(&problem);

    println!(
        "{{\"part1\": {}, \"part2\": {}}}",
        part1.to_string(),
        "null".to_string()
    );
}

fn parse_problem(input: &str) -> Problem {
    println!("Parsing problem...");
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

            let joltage_data: Vec<usize> = raw_elements
                .last()
                .unwrap()
                .replace("{", "")
                .replace("}", "")
                .split(",")
                .map(|c| c.parse::<usize>().expect("Failed to parse digit"))
                .collect();
            let joltage_reqs = JoltageRequirement::new(joltage_data);

            Machine::new(indicator_light_diag, button_wiring_schemas, joltage_reqs)
        })
        .collect();
    Problem::new(machines)
}
