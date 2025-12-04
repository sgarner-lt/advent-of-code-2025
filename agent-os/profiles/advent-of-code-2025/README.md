# Advent of Code 2025 Profile

This is a custom Agent OS profile specifically designed for solving Advent of Code 2025 challenges **in parallel across 5 different programming languages**: Rust, Roc, Gleam, Carbon, and Bosque.

## Multi-Language Approach

Each day's puzzle is solved simultaneously in all 5 languages, allowing for:
- **Comparison** of different language paradigms and approaches
- **Learning** by implementing the same problem in multiple ways
- **Validation** by cross-checking answers across implementations
- **Performance** benchmarking across languages

## Profile Components

### Standards
- **global/tech-stack.md**: Complete tech stack definition for all 5 languages
- **aoc-problem-solving.md**: Best practices for approaching and solving AoC problems
- **aoc-testing.md**: Testing strategies for validating solutions
- **aoc-optimization.md**: Performance optimization guidelines
- **aoc-privacy.md**: **CRITICAL** - Answer protection and privacy rules (never include real puzzle answers in documentation)

### Agents
Each language has a specialized solver agent with language-specific expertise:
- **rust-solver.md**: Rust implementation expert
- **roc-solver.md**: Roc functional programming expert
- **gleam-solver.md**: Gleam type-safety expert
- **carbon-solver.md**: Carbon modern C++ successor expert
- **bosque-solver.md**: Bosque verification-oriented expert

### Commands
- **analyze-problem.md**: Analyze a problem and suggest approaches
- **solve-day.md**: Full solution implementation workflow
- **test-solution.md**: Run and validate tests

### Workflows
Day-specific workflows (day01.md through day10.md) that coordinate parallel implementation across all 5 languages.

## Typical Day Structure

```
dayXX/
  ├── rust/         # Rust implementation
  ├── roc/          # Roc implementation
  ├── gleam/        # Gleam implementation
  ├── carbon/       # Carbon implementation
  ├── bosque/       # Bosque implementation
  ├── input.txt     # Puzzle input
  ├── sample.txt    # Sample data
  └── README.md     # Problem notes
```

## Usage

1. Use the day-specific workflow (e.g., `/day01`)
2. All 5 language agents implement the solution in parallel
3. Validate that all implementations produce the same answer
4. Compare approaches, performance, and learning insights
