# Rust JSON Output Template

## Overview

This template provides a standard approach for outputting JSON results from Rust Advent of Code solutions using `serde_json`.

## Dependencies

Add to `Cargo.toml`:

```toml
[dependencies]
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
```

## Basic Template for Integer Answers

```rust
use serde::{Serialize, Deserialize};
use std::fs;
use std::io;

#[derive(Serialize, Deserialize)]
struct Answer {
    part1: Option<i64>,
    part2: Option<i64>,
}

fn solve_part1(input: &str) -> Option<i64> {
    // Your part 1 solution here
    Some(0)  // Replace with actual answer
}

fn solve_part2(input: &str) -> Option<i64> {
    // Your part 2 solution here
    None  // Return None if not yet implemented
}

fn main() -> io::Result<()> {
    // Read input from command line argument
    let args: Vec<String> = std::env::args().collect();
    if args.len() < 2 {
        eprintln!("Usage: {} <input_file>", args[0]);
        std::process::exit(1);
    }

    let input = fs::read_to_string(&args[1])?;

    let answer = Answer {
        part1: solve_part1(&input),
        part2: solve_part2(&input),
    };

    // Output JSON to stdout
    let json = serde_json::to_string(&answer)
        .expect("Failed to serialize answer to JSON");
    println!("{}", json);

    Ok(())
}
```

## Template for String Answers

```rust
use serde::{Serialize, Deserialize};
use std::fs;
use std::io;

#[derive(Serialize, Deserialize)]
struct Answer {
    part1: Option<String>,
    part2: Option<String>,
}

fn solve_part1(input: &str) -> Option<String> {
    // Your part 1 solution here
    Some("ANSWER".to_string())
}

fn solve_part2(input: &str) -> Option<String> {
    // Your part 2 solution here
    None
}

fn main() -> io::Result<()> {
    let args: Vec<String> = std::env::args().collect();
    if args.len() < 2 {
        eprintln!("Usage: {} <input_file>", args[0]);
        std::process::exit(1);
    }

    let input = fs::read_to_string(&args[1])?;

    let answer = Answer {
        part1: solve_part1(&input),
        part2: solve_part2(&input),
    };

    let json = serde_json::to_string(&answer)
        .expect("Failed to serialize answer to JSON");
    println!("{}", json);

    Ok(())
}
```

## Template for Mixed Type Answers

```rust
use serde::{Serialize, Deserialize};
use serde_json::Value;
use std::fs;
use std::io;

#[derive(Serialize, Deserialize)]
struct Answer {
    part1: Option<Value>,
    part2: Option<Value>,
}

fn solve_part1(input: &str) -> Option<Value> {
    // Can return integer
    Some(Value::Number(12345.into()))
}

fn solve_part2(input: &str) -> Option<Value> {
    // Can return string
    Some(Value::String("RESULT".to_string()))
}

fn main() -> io::Result<()> {
    let args: Vec<String> = std::env::args().collect();
    if args.len() < 2 {
        eprintln!("Usage: {} <input_file>", args[0]);
        std::process::exit(1);
    }

    let input = fs::read_to_string(&args[1])?;

    let answer = Answer {
        part1: solve_part1(&input),
        part2: solve_part2(&input),
    };

    let json = serde_json::to_string(&answer)
        .expect("Failed to serialize answer to JSON");
    println!("{}", json);

    Ok(())
}
```

## Running the Solution

```bash
# Build
cd rust/dayXX
cargo build --release

# Run with input file
cargo run --release -- ../../challenges/dayXX/input.txt
```

Expected output:
```json
{"part1":12345,"part2":67890}
```

## Testing

```bash
# Run unit tests
cargo test

# Run with sample input
cargo run -- ../../challenges/dayXX/input-sample.txt
```

## Notes

- Use `Option<T>` to represent nullable values (automatically serializes to `null` when `None`)
- Always output to stdout, errors to stderr
- Use `serde_json::to_string()` for compact output (no pretty-printing)
- Read input file path from command line arguments
- Return proper exit codes (0 for success, non-zero for errors)
