# Specification: Day 7 Part 1 - Tachyon Manifold Beam Splitter Simulation

## Goal
Implement a simulation that counts how many times a tachyon beam is split as it propagates downward through a grid containing splitters, producing identical answers across 4 programming languages (Rust, Gleam, Carbon, Bosque).

## User Stories
- As a teleporter engineer, I want to analyze beam-splitting properties of the tachyon manifold so that I can repair the broken teleporter
- As a developer, I want cross-language validation to ensure correctness of the beam propagation algorithm across different implementations

## Specific Requirements

**Grid Parsing and Initialization**
- Parse input into 2D character grid where each line represents a row
- Identify and store the starting position marked with 'S'
- Recognize three cell types: 'S' (start), '^' (splitter), '.' (empty space)
- Validate that exactly one 'S' exists in the grid
- Store grid dimensions for boundary checking during simulation

**Beam State Tracking**
- Maintain a queue or collection of active beams being tracked
- Each beam has a position (row, column) and direction (always downward)
- Initialize simulation with one beam at starting position 'S' moving downward
- Use language-appropriate data structures (Rust: Vec, Gleam: List, Carbon: Vector, Bosque: Collection)
- Remove beams from tracking when they exit grid boundaries or hit splitters

**Beam Propagation Step-by-Step**
- Process beams iteratively: move each beam one step downward (increment row by 1)
- Check if beam position is within grid bounds after each move
- If beam exits bottom/left/right of grid, stop tracking that beam
- If beam lands on empty space '.', continue tracking for next step
- Continue simulation until no active beams remain in queue

**Splitter Interaction Logic**
- When beam lands on splitter '^', increment split counter by 1
- Stop the current beam (remove from active beam queue)
- Create two new beams: one at immediate left position (same row, col-1), one at immediate right (same row, col+1)
- Both new beams move downward from their respective positions
- If left or right position is off-grid, do not create that beam (only create beams that remain on grid)
- Multiple beams can occupy the same position simultaneously and continue independently

**Split Counting Mechanism**
- Maintain integer counter initialized to 0
- Increment counter each time any beam encounters a splitter '^'
- If same splitter is hit multiple times by different beams, count each hit
- Final answer is the total number of split events that occurred
- Alternative approach: mark splitters as activated with 'a' or number when first hit (either counting method is acceptable)

**Grid Boundary Handling**
- Check boundaries before creating new beams from splitter
- If splitter is on left edge (col=0), only create right beam
- If splitter is on right edge (col=width-1), only create left beam
- If splitter is on bottom edge, the split still counts but no beams propagate further
- Beams that would go outside grid (negative indices or beyond dimensions) are never created

**Output Format and Validation**
- Output JSON format: {"part1": split_count, "part2": null}
- Sample input must produce exactly 21 splits
- All 4 language implementations must produce identical answers for both sample and real inputs
- Print to stdout for testing framework to capture

**Multi-Language Implementation Structure**
- Rust: Use Cargo.toml in solutions/rust/day07/, implement in src/main.rs with #[cfg(test)] unit tests
- Gleam: Use gleam.toml in solutions/gleam/day07/, implement in src/day07.gleam with test/day07_test.gleam
- Carbon: Place solution in solutions/carbon/day07/ following Carbon syntax conventions
- Bosque: Place solution in solutions/bosque/day07/ following Bosque language patterns

**Testing and Validation Strategy**
- Unit tests for: grid parsing, finding start position, beam splitting logic, boundary detection, split counting
- Integration test with sample input expecting result: {"part1": 21, "part2": null}
- Integration test with real input using ./scripts/test_integration.sh 7
- Sample input validation using ./scripts/test_integration.sh 7 --sample
- Unit test execution using ./scripts/test_unit.sh 7

**Debugging and Visualization**
- Print grid state after each simulation step to stderr (not stdout, to preserve JSON output)
- Show beam positions with '|' character overlaid on grid
- Display split counter value during simulation
- Visual output helps understand beam propagation and verify correctness

## Visual Design
No visual assets provided - problem uses ASCII grid representation in text format.

## Existing Code to Leverage

**Day 6 Rust Grid Simulation Pattern**
- Uses Vec<Vec<char>> for 2D grid storage
- Implements guard patrol simulation with position tracking and direction changes
- Pattern for reading stdin and outputting JSON format
- Direction enum and position tracking with boundary checking
- Similar step-by-step state machine simulation approach can be adapted for beam propagation

**Day 4 Rust Grid Parsing**
- Function parse_grid() converts input string into 2D Vec<Vec<char>>
- Filters empty lines and trims whitespace
- Boundary checking with grid dimensions (rows.len(), cols.len())
- Position validation using i32 for signed arithmetic, then converting to usize
- Can reuse grid parsing and boundary checking patterns

**Day 1 Rust Project Structure**
- Standard Cargo.toml with package metadata and dependencies section
- src/main.rs with main() function reading stdin using io::stdin().read_to_string()
- solve() function signature returning tuple (part1_result, part2_result)
- #[cfg(test)] mod tests section with unit tests using assert_eq!
- JSON output format using println! macro

**Gleam Day 6 Stdin Reading Pattern**
- Uses simplifile.read("/dev/stdin") for stdin input
- Pattern matching with Ok/Error for error handling
- JSON output construction with string concatenation and int.to_string()
- Error messages printed to stderr with io.println_error()
- Similar tuple unpacking for solve() function returning both parts

**Cross-Language Testing Framework**
- ./scripts/test_integration.sh accepts day number and optional flags (--sample, --verbose, --timeout)
- Runs all 4 languages in parallel and validates answers match
- ./scripts/test_unit.sh executes language-specific unit test commands
- Framework expects JSON output format on stdout with "part1" and "part2" keys
- Exit code 0 for success, non-zero for failures

## Out of Scope
- Part 2 of Day 7 (not yet revealed by Advent of Code)
- Performance optimization beyond basic correctness (unless solution is unacceptably slow)
- Advanced visualization tools or interactive debugging interfaces
- GUI or web-based grid display
- Handling malformed or invalid input beyond basic parsing validation
- Beam splitting patterns other than those specified (e.g., diagonal splits, multi-way splits)
- Animation or frame-by-frame replay capabilities
- Persistent state storage or caching of simulation results
- Parallel beam processing or concurrency optimizations
- Support for grid sizes beyond those in actual puzzle inputs
