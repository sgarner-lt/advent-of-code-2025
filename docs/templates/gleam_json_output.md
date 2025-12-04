# Gleam JSON Output Template

## Overview

This template provides a standard approach for outputting JSON results from Gleam Advent of Code solutions using the `gleam/json` library.

## Dependencies

Add to `gleam.toml`:

```toml
[dependencies]
gleam_stdlib = "~> 0.34"
gleam_json = "~> 1.0"
```

## Basic Template for Integer Answers

```gleam
import gleam/io
import gleam/json
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import simplifile

pub type Answer {
  Answer(part1: Option(Int), part2: Option(Int))
}

fn solve_part1(input: String) -> Option(Int) {
  // Your part 1 solution here
  Some(0)  // Replace with actual answer
}

fn solve_part2(input: String) -> Option(Int) {
  // Your part 2 solution here
  None  // Return None if not yet implemented
}

fn answer_to_json(answer: Answer) -> String {
  let part1_json = case answer.part1 {
    Some(value) -> json.int(value)
    None -> json.null()
  }

  let part2_json = case answer.part2 {
    Some(value) -> json.int(value)
    None -> json.null()
  }

  json.object([
    #("part1", part1_json),
    #("part2", part2_json),
  ])
  |> json.to_string
}

pub fn main() {
  // Get input file path from command line arguments
  case simplifile.read(from: "input.txt") {
    Ok(input) -> {
      let answer = Answer(
        part1: solve_part1(input),
        part2: solve_part2(input),
      )

      let json_output = answer_to_json(answer)
      io.println(json_output)
    }
    Error(_) -> {
      io.println_error("Failed to read input file")
    }
  }
}
```

## Template for String Answers

```gleam
import gleam/io
import gleam/json
import gleam/option.{type Option, None, Some}
import simplifile

pub type Answer {
  Answer(part1: Option(String), part2: Option(String))
}

fn solve_part1(input: String) -> Option(String) {
  // Your part 1 solution here
  Some("ANSWER")
}

fn solve_part2(input: String) -> Option(String) {
  // Your part 2 solution here
  None
}

fn answer_to_json(answer: Answer) -> String {
  let part1_json = case answer.part1 {
    Some(value) -> json.string(value)
    None -> json.null()
  }

  let part2_json = case answer.part2 {
    Some(value) -> json.string(value)
    None -> json.null()
  }

  json.object([
    #("part1", part1_json),
    #("part2", part2_json),
  ])
  |> json.to_string
}

pub fn main() {
  case simplifile.read(from: "input.txt") {
    Ok(input) -> {
      let answer = Answer(
        part1: solve_part1(input),
        part2: solve_part2(input),
      )

      io.println(answer_to_json(answer))
    }
    Error(_) -> {
      io.println_error("Failed to read input file")
    }
  }
}
```

## Template with Command Line Arguments

```gleam
import argv
import gleam/io
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import simplifile

pub type Answer {
  Answer(part1: Option(Int), part2: Option(Int))
}

fn solve_part1(input: String) -> Option(Int) {
  Some(12345)
}

fn solve_part2(input: String) -> Option(Int) {
  Some(67890)
}

fn answer_to_json(answer: Answer) -> String {
  let part1_json = case answer.part1 {
    Some(value) -> json.int(value)
    None -> json.null()
  }

  let part2_json = case answer.part2 {
    Some(value) -> json.int(value)
    None -> json.null()
  }

  json.object([
    #("part1", part1_json),
    #("part2", part2_json),
  ])
  |> json.to_string
}

pub fn main() {
  let args = argv.load().arguments

  case list.first(args) {
    Ok(input_path) -> {
      case simplifile.read(from: input_path) {
        Ok(input) -> {
          let answer = Answer(
            part1: solve_part1(input),
            part2: solve_part2(input),
          )
          io.println(answer_to_json(answer))
        }
        Error(_) -> {
          io.println_error("Failed to read input file: " <> input_path)
        }
      }
    }
    Error(_) -> {
      io.println_error("Usage: gleam run <input_file>")
    }
  }
}
```

## Running the Solution

```bash
# Build
cd gleam/dayXX
gleam build

# Run with input file
gleam run -- ../../challenges/dayXX/input.txt
```

Expected output:
```json
{"part1":12345,"part2":67890}
```

## Testing

```bash
# Run unit tests
gleam test

# Run with sample input
gleam run -- ../../challenges/dayXX/input-sample.txt
```

## Notes

- Use `Option(T)` to represent nullable values
- Pattern match on `Some(value)` and `None` to handle optional values
- Use `json.null()` for parts not yet implemented
- Always output to stdout using `io.println()`
- Output errors to stderr using `io.println_error()`
- Use `simplifile.read()` to read input files
- The `gleam/json` library handles proper escaping and formatting
