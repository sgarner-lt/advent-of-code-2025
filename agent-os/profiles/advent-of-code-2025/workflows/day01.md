# Day 01 Workflow

Solve Advent of Code Day 01 in all 5 languages in parallel.

## Overview
This workflow coordinates solving Day 01's puzzle using Rust, Roc, Gleam, Carbon, and Bosque simultaneously.

## Setup Phase

1. Create project structure:
```
day01/
  ├── rust/
  ├── roc/
  ├── gleam/
  ├── carbon/
  ├── bosque/
  ├── input.txt
  ├── sample.txt
  └── README.md
```

2. Download puzzle input and save to `day01/input.txt`
3. Extract sample data and save to `day01/sample.txt`
4. Document problem in `day01/README.md`

## Parallel Implementation

Launch 5 agents in parallel to solve the problem in each language:

### Rust Implementation
**Agent**: rust-solver
**Task**: Implement Day 01 solution in Rust
- Set up Cargo project in `day01/rust/`
- Implement parsing and solution logic
- Add tests with sample data
- Validate with actual input

### Roc Implementation
**Agent**: roc-solver
**Task**: Implement Day 01 solution in Roc
- Create `day01/roc/main.roc`
- Implement functional solution
- Add expect tests with sample data
- Validate with actual input

### Gleam Implementation
**Agent**: gleam-solver
**Task**: Implement Day 01 solution in Gleam
- Set up Gleam project in `day01/gleam/`
- Implement type-safe solution
- Add gleeunit tests with sample data
- Validate with actual input

### Carbon Implementation
**Agent**: carbon-solver
**Task**: Implement Day 01 solution in Carbon
- Create `day01/carbon/solution.carbon`
- Implement solution with modern Carbon features
- Add test cases with sample data
- Validate with actual input

### Bosque Implementation
**Agent**: bosque-solver
**Task**: Implement Day 01 solution in Bosque
- Create `day01/bosque/solution.bsq`
- Implement verifiable solution
- Add assertions with sample data
- Validate with actual input

## Validation Phase

1. Verify all 5 implementations produce the same answer for Part 1
2. Compare performance across languages
3. Document any interesting differences in approach
4. Submit the answer (should be the same from all implementations)

## Part 2

Once Part 2 unlocks:
1. Launch all 5 agents again in parallel
2. Extend each implementation for Part 2
3. Validate all produce the same answer
4. Submit Part 2 answer

## Standards Applied
- aoc-problem-solving.md
- aoc-testing.md
- aoc-optimization.md
