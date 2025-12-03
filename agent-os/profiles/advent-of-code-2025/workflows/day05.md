# Day 05 Workflow

Solve Advent of Code Day 05 in all 5 languages in parallel.

## Overview
This workflow coordinates solving Day 05's puzzle using Rust, Roc, Gleam, Carbon, and Bosque simultaneously.

## Setup Phase

1. Create project structure:
```
day05/
  ├── rust/
  ├── roc/
  ├── gleam/
  ├── carbon/
  ├── bosque/
  ├── input.txt
  ├── sample.txt
  └── README.md
```

2. Download puzzle input and save to `day05/input.txt`
3. Extract sample data and save to `day05/sample.txt`
4. Document problem in `day05/README.md`

## Parallel Implementation

Launch 5 agents in parallel:

- **rust-solver**: Implement in `day05/rust/`
- **roc-solver**: Implement in `day05/roc/`
- **gleam-solver**: Implement in `day05/gleam/`
- **carbon-solver**: Implement in `day05/carbon/`
- **bosque-solver**: Implement in `day05/bosque/`

Each agent should:
1. Parse the input
2. Implement Part 1 solution
3. Test with sample data
4. Validate with actual input

## Validation Phase

1. Verify all 5 implementations produce the same answer
2. Compare approaches and performance
3. Submit the answer

## Part 2

Extend all 5 implementations in parallel for Part 2.

## Standards Applied
- aoc-problem-solving.md
- aoc-testing.md
- aoc-optimization.md
