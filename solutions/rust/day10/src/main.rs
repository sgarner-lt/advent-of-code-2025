use std::collections::HashSet;
use std::fmt;
use std::fs;
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
                .join("")
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
            "[{}]",
            self.data
                .iter()
                .map(|x| x.to_string())
                .collect::<Vec<String>>()
                .join("")
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
                .map(|x| if *x { "#" } else { "1" })
                .collect::<Vec<&str>>()
                .join("")
        )
    }
}

struct Machine {
    indicatorLightDiagram: IndicatorLightDiagram,
    buttonWiringSchematics: Vec<ButtonWiringSchematic>,
    joltageRequirements: JoltageRequirement,
}
impl Machine {
    fn new(
        indicatorLightDiagram: IndicatorLightDiagram,
        buttonWiringSchematics: Vec<ButtonWiringSchematic>,
        joltageRequirements: JoltageRequirement,
    ) -> Self {
        Machine {
            indicatorLightDiagram,
            buttonWiringSchematics,
            joltageRequirements,
        }
    }
}
impl fmt::Display for Machine {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "{} {} {}",
            self.indicatorLightDiagram,
            self.buttonWiringSchematics
                .iter()
                .map(|x| x.to_string())
                .collect::<Vec<String>>()
                .join(" "),
            self.joltageRequirements
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

fn main() {
    let mut input = String::new();
    io::stdin()
        .read_to_string(&mut input)
        .expect("Failed to read from stdin");
    let problem: Problem = parse_problem(&input);
    // let part1 = part1(&points);
    println!("Parsed Problem:\n{}", problem);

    let part1: i32 = 0;

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
            let ind_light_data: Vec<bool> = raw_elements[0].replace("]", "").replace("]", "")
                .chars()
                .map(|c| match c {
                    '#' => true,
                    '.' => false,
                    _ => panic!("Unexpected character in indicator light diagram"),
                })
                .collect();
            let indicator_light_diagram = IndicatorLightDiagram::new(ind_light_data);

            let button_wiring_schematics = raw_elements.iter().skip(1).filter(|s| s.starts_with("(")).map(|s| {
                let data: Vec<usize> = s.replace("(", "").replace(")", "").split(",")
                    .map(|c| c.parse::<usize>().expect("Failed to parse digit"))
                    .collect();
                ButtonWiringSchematic::new(data)
            }).collect();

            let joltage_data: Vec<usize> = raw_elements.last().unwrap().replace("{", "").replace("}", "")
                .split(",")
                .map(|c| c.parse::<usize>().expect("Failed to parse digit"))
                .collect();
            let joltage_requirement = JoltageRequirement::new(joltage_data);


            let coords: Vec<i32> = line
                .split(",")
                .map(|s| s.parse::<i32>().expect("Failed to parse integer"))
                .collect();
            Point::new(coords[0], coords[1])

            Machine::new(
                indicator_light_diagram,
                button_wiring_schematics,
                joltage_requirement,
            )

        })
        .collect();
    Problem::new(machines)
}
