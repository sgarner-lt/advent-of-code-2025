use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_type = match args[1].as_str() {
        "r" => "",
        "s" => "-sample",
        _ => "",
    };
    println!("Arguments: {:?}", args);
    let input_path = &format!("../../../challenges/day11/input{}.txt", input_type);
    println!("Using input file: {}", input_path);
    let input = read_input(input_path);
    let devices = parse_input(&input);
    println!("Parsed Input: {:?}", devices.devices);
    println!("Part 1: {}", part1(&devices));
    println!("Part 2: {}", part2(&devices));
}

fn read_input(path: &str) -> String {
    fs::read_to_string(path).expect("Failed to read input file")
}

#[derive(Debug)]
struct Device {
    label: String,
    outputs: Vec<String>,
}

#[derive(Debug)]
struct Devices {
    devices: Vec<Device>,
}

fn parse_input(input: &str) -> Devices {
    let devices: Vec<Device> = input
        .lines()
        .map(|l| l.trim())
        .map(|l| l.split_ascii_whitespace().collect())
        .map(|parts: Vec<&str>| {
            let label = parts[0].to_string().replace(":", "");
            let outputs = parts.iter().skip(1).map(|s| s.to_string()).collect();
            Device { label, outputs }
        })
        .collect();
    Devices {
        devices: devices.into_iter().collect(),
    }
}

#[derive(Debug, Clone)]
struct YouPath {
    visited: Vec<String>,
    is_complete: bool,
}

fn part1(devices: &Devices) -> i32 {
    // TODO: Implement Part 1 solution
    let device_by_label: std::collections::HashMap<String, &Device> = devices
        .devices
        .iter()
        .map(|d| (d.label.clone(), d))
        .collect();
    let _out_devices = devices.devices.iter().filter(|d| d.label == "out");
    let you_device = device_by_label.get("you").unwrap();
    let mut you_paths: Vec<YouPath> = Vec::new();
    you_paths.push(YouPath {
        visited: vec![you_device.label.clone()],
        is_complete: false,
    });

    let mut all_complete = false;
    let mut complete_paths = Vec::new();

    while !all_complete {
        let mut new_paths = Vec::new();
        for path in you_paths.iter_mut().filter(|p| !p.is_complete) {
            let current_label = path.visited.last().unwrap();
            if current_label == "out" {
                path.is_complete = true;
                complete_paths.push(path.clone());
                continue;
            }
            let current_device = device_by_label.get(current_label).unwrap();
            for output in &current_device.outputs {
                if !path.visited.contains(output) {
                    let mut new_path = path.visited.clone();
                    new_path.push(output.clone());
                    new_paths.push(YouPath {
                        visited: new_path,
                        is_complete: false,
                    });
                }
            }
        }
        if new_paths.is_empty() {
            all_complete = true;
        } else {
            you_paths = new_paths
        }
    }

    complete_paths.iter().count() as i32
}

fn part2(devices: &Devices) -> i32 {
    // TODO: Implement Part 2 solution
    0
}
