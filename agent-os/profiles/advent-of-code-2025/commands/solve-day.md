# Solve Advent of Code Day

Help me solve an Advent of Code challenge for a specific day **in parallel across all 5 languages** (Rust, Roc, Gleam, Carbon, Bosque).

## Steps:

1. Read the problem statement for the specified day
2. Analyze the input format and requirements
3. Create multi-language project structure:
   ```
   dayXX/
     ├── rust/
     ├── roc/
     ├── gleam/
     ├── carbon/
     ├── bosque/
     ├── input.txt
     ├── sample.txt
     └── README.md
   ```
4. Launch 5 language-specific agents in parallel:
   - **rust-solver**: Implement in Rust
   - **roc-solver**: Implement in Roc
   - **gleam-solver**: Implement in Gleam
   - **carbon-solver**: Implement in Carbon
   - **bosque-solver**: Implement in Bosque
5. Each agent implements Part 1:
   - Parse the input
   - Implement the algorithm
   - Test with sample data
   - Verify with actual input
6. Validate all 5 implementations produce the same answer
7. If Part 2 is available, extend all 5 implementations in parallel
8. Compare performance and approaches across languages

## Apply Standards:
- aoc-problem-solving.md
- aoc-testing.md
- aoc-optimization.md (if needed)

## Note:
Prefer using day-specific workflows (e.g., `/day01`) for full orchestration.
