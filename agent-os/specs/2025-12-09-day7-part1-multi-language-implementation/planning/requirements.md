# Spec Requirements: Day 7 - Beam Splitter

## Initial Description
Advent of Code Day 7 challenge - Tachyon Manifold beam splitting simulation. A tachyon beam starts at position 'S' and moves downward through a grid. When it encounters a splitter '^', the beam stops and two new beams are emitted horizontally (left and right) which then continue moving downward. The goal is to count how many times beams are split.

## Requirements Discussion

### First Round Questions

**Q1: For Part 1, what's the exact counting mechanism?**
**Answer:** Count the number of times a line is above a splitter OR replace the splitter with an activated splitter marker (e.g., 'a'). Can do it either way - try one approach in Rust first and validate the real answer on the Advent of Code website. Should be verified with unit tests.

**Q2: Do we need to handle any edge cases or invalid inputs?**
**Answer:** Grid will have one 'S' (start position) and multiple '^' (splitters). Empty space is '.'. Beams always start moving downward from S. No special error handling needed beyond basic parsing validation.

**Q3: What data structures should we use for tracking beam state?**
**Answer:** Need to track active beams (position + direction). Use appropriate data structures for each language's idioms:
- Rust: Vec of beam structs or tuples
- Gleam: List of beam records
- Carbon: Vector/array of beam structs
- Bosque: Collection of beam entities

**Q4: Should we implement any visualization or debugging output?**
**Answer:** Yes, print the grid state after each step to help understand the beam propagation. This will be useful for debugging and understanding the solution.

**Q5: How should the solution be structured (modules, functions)?**
**Answer:** Follow standard structure from previous days:
- Parse input into 2D grid
- Find starting position 'S'
- Simulate beam propagation step-by-step
- Track split count or mark splitters as activated
- Return final count

Check both input files:
- `challenges/day07/input-sample.txt` (example from problem)
- `challenges/day07/input.txt` (actual puzzle input)

Expected output for sample is stored in `challenges/day07/input-sample-expected-output.txt`

**Q6: What performance considerations should we keep in mind?**
**Answer:** Should be fast enough - typical AoC inputs are reasonable. No special optimization needed unless solution is too slow. Focus on correctness first.

**Q7: Are there any parts of the solution that should be unit-tested separately?**
**Answer:** Yes:
- Grid parsing
- Finding start position
- Beam splitting logic
- Boundary detection (off board handling)
- Final count calculation

**Q8: Is there anything we explicitly should NOT include?**
**Answer:** Part 2 is not yet revealed. Only implement Part 1 for now.

### Existing Code to Reference

**Similar Features Identified:**
- Previous day solutions (day01-day06) for project structure patterns
- Feature: Day 1 Rust solution - Path: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/rust/day01/`
  - Standard Cargo.toml and src/main.rs structure
- Feature: Day 1 Gleam solution - Path: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/gleam/day01/`
  - src/ and test/ directory structure
- Feature: Existing scaffolding - Paths: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/{rust,gleam,carbon,bosque}/day07/`
  - Empty directories already exist for Day 7 implementations

**Testing framework reference:**
- Scripts: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/scripts/test_integration.sh`
  - Supports `--sample` flag for sample input validation
  - Default runs real input
- Scripts: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/scripts/test_unit.sh`
  - For running unit tests per language

### Follow-up Questions

**Follow-up 1: Input File Clarification - You mentioned "check both input files" - I see three files. Should the expected output for the sample be 21 (matching the problem statement) or 4277556?**
**Answer:** The expected output file was fixed - it should now be 21 (matching the problem statement that says "split a total of 21 times").

**Follow-up 2: Split Counting Clarification - Does this mean we count each time ANY beam crosses a splitter (so if 3 beams hit the same splitter, that's 3 splits) or mark each splitter once when first activated?**
**Answer:** Can do it either way (replace splitter with count number OR 'a' for activated). Let's try one way in Rust first and get a real answer for the real input, then validate it on the website. Yes, can verify with unit test.

**Follow-up 3: Beam Tracking After Split - After splitting, do the left and right beams move one step horizontally first, THEN start moving downward, or immediately start moving downward from the splitter's position?**
**Answer:** Beams go DOWN. Check the problem statement examples for state transitions.

**Follow-up 4: Grid Boundary Behavior - When a beam exits the grid, should we simply stop tracking that beam, count this as an event, or need error handling?**
**Answer:** Off board is out of play. If a splitter is on the edge, it counts for that splitter but the line can't propagate off the graph.

**Follow-up 5: Solution Directory Structure - Should we implement solutions in existing scaffolding directories and create standard project files?**
**Answer:** Yes, use the existing scaffolding directories. Look at other days for examples of project structure.

**Follow-up 6: Testing Script Usage - Should the spec document the exact commands to run?**
**Answer:** All scripts exist already. There's also testing framework with flags already documented. Check out the scripts or read the test framework docs before using stuff. Flags should be documented already. Key commands:
- `./scripts/test_integration.sh 7` for real input
- `./scripts/test_integration.sh 7 --sample` for sample input
- `./scripts/test_unit.sh 7` for unit tests

## Visual Assets

### Files Provided:
No visual assets provided.

### Visual Insights:
N/A - Problem statement text and ASCII diagrams are sufficient for understanding the grid-based beam propagation.

## Requirements Summary

### Functional Requirements

**Core Functionality:**
- Parse a 2D grid containing:
  - 'S' (starting position)
  - '^' (splitter)
  - '.' (empty space)
- Simulate tachyon beam propagation:
  - Beam starts at 'S' and moves downward
  - Beam passes through '.' freely
  - When beam encounters '^', the beam stops and two new beams are created:
    - One beam moves from the immediate left of the splitter
    - One beam moves from the immediate right of the splitter
    - Both new beams move downward
- Count the total number of times beams are split
- Output the final split count

**Input Files:**
- Sample input: `challenges/day07/input-sample.txt`
- Real puzzle input: `challenges/day07/input.txt`
- Expected sample output: `challenges/day07/input-sample-expected-output.txt` (should be 21)

**Output:**
- JSON format: `{"part1": <split_count>, "part2": null}`
- For sample input: `{"part1": 21, "part2": null}`

**Validation:**
- Verify sample input produces expected output (21 splits)
- Submit real input answer to Advent of Code website for validation
- All 4 language implementations must produce identical answers

**Grid Boundary Handling:**
- Beams that exit the grid (left, right, or bottom edge) stop propagating
- If a splitter is on the edge:
  - The split still counts
  - Beams that would go off the grid are not created/tracked
  - Only beams that remain on the grid continue propagating

**Beam State Tracking:**
- Each beam has a position (row, column) and direction (downward for vertical, downward for split beams)
- Split beams: after splitting at a '^', two horizontal positions are created (left and right of splitter)
- These split beams then move downward from their new positions

**Split Counting Options:**
- Either: Count each split event (if same splitter hit multiple times, count each time)
- Or: Mark each splitter once when activated (use 'a' or counter)
- Implementation can choose either approach - validate with real answer

### Reusability Opportunities
- Grid parsing logic similar to previous days (Day 4 word search, Day 6 guard simulation)
- Position/coordinate tracking patterns from Day 6 (guard patrol)
- State simulation logic from previous days
- Standard project structure from Day 1-6:
  - Rust: Cargo.toml + src/main.rs
  - Gleam: src/ and test/ directories
  - Carbon: solution file in directory
  - Bosque: solution file in directory

### Scope Boundaries

**In Scope:**
- Part 1: Count total beam splits in tachyon manifold
- Grid parsing and validation
- Beam propagation simulation
- Split counting mechanism
- Boundary detection and handling
- Cross-language validation (Rust, Gleam, Carbon, Bosque)
- Unit tests for core logic
- Integration tests with sample and real inputs
- Debugging output (grid visualization)

**Out of Scope:**
- Part 2 (not yet revealed)
- Performance optimization (unless solution is too slow)
- Complex visualization beyond simple grid printing
- Interactive debugging tools
- Advanced error recovery

### Technical Considerations

**Integration Points:**
- Use existing testing framework scripts:
  - `./scripts/test_integration.sh 7` for real input validation
  - `./scripts/test_integration.sh 7 --sample` for sample input validation
  - `./scripts/test_unit.sh 7` for unit tests
- Read input files from `challenges/day07/` directory
- Output JSON format matching expected structure
- Follow cross-language validation requirements

**Language-Specific Constraints:**
- Rust: Use idiomatic Rust patterns (Vec, enums for direction, structs for beam state)
- Gleam: Use BEAM-friendly patterns (pattern matching, recursion, lists)
- Carbon: Systems programming approach (experimental language limitations)
- Bosque: Verification-oriented approach (limited tooling)

**Project Structure:**
- Solutions in: `solutions/{language}/day07/`
- Follow existing day patterns:
  - Rust: Cargo.toml, src/main.rs
  - Gleam: gleam.toml, src/day07.gleam, test/day07_test.gleam
  - Carbon: solution.carbon or similar
  - Bosque: solution.bsq or similar

**Problem Statement Reference:**
- Full problem description: `challenges/day07/problem-statement.txt`
- Key insight from problem: "In this example, a tachyon beam is split a total of 21 times."
- Beam splitting visualization shows step-by-step propagation
- After splitting: beams continue downward from left/right positions
- Multiple beams can converge at the same position ("both dumping tachyons into the same place between them")

**Algorithm Approach:**
1. Parse grid into 2D array
2. Find starting position 'S'
3. Initialize beam queue with starting beam (position at S, moving down)
4. While beam queue is not empty:
   - Take next beam from queue
   - Move beam one step downward
   - Check if beam is off grid (stop if yes)
   - Check if beam hit splitter '^':
     - If yes: increment split counter, create two new beams (left and right, both moving down)
   - If beam hit empty space '.', keep beam in queue (continue next step)
5. Return total split count

**State Transition Rules (from problem statement):**
- Beam at empty space → continue moving downward
- Beam at splitter '^' → stop beam, create two beams at left/right positions, both move downward
- Beam converging with another beam → both beams coexist at same position, continue independently
- Beam at grid boundary → stop tracking beam
