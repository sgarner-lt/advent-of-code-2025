use std::fmt;
use std::io::{self, Read};

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

struct IndicatorLightDiagram {
    data: Vec<bool>,
}
impl IndicatorLightDiagram {
    fn new(data: Vec<bool>) -> Self {
        IndicatorLightDiagram { data }
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

enum SearchNode<'a> {
    Start {
        initial_state: IndicatorLightDiagram,
    },
    Intermediate {
        parent: &'a SearchNode<'a>,
        button_schema: &'a ButtonWiringSchematic,
        current_state: IndicatorLightDiagram,
    },
    Goal {
        parent: &'a SearchNode<'a>,
        final_state: IndicatorLightDiagram,
    },
}

fn solve_part1(_problem: &Problem) -> u32 {
    0
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
            let indicator_light_diag = IndicatorLightDiagram::new(ind_light_data);

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
