# Specification: Day 4 Part 2 - Paper Roll Removal Simulation

## Goal
Extend Day 4 Part 1 to implement an iterative removal algorithm that repeatedly removes accessible paper rolls from a warehouse grid until no more rolls can be accessed, returning the total count of all removed rolls.

## User Stories
- As a puzzle solver, I want to calculate the total number of paper rolls that can be removed through iterative forklift operations so that I can optimize warehouse operations
- As a developer, I want to extend the existing Part 1 solution to add Part 2 functionality while preserving Part 1 results so that both answers are available in the JSON output

## Specific Requirements

**Iterative Removal Algorithm**
- Identify all accessible rolls in the current grid state (rolls with fewer than 4 adjacent rolls)
- Remove all identified accessible rolls simultaneously as a batch (not one at a time)
- Create a copy of the grid for the next iteration with removed rolls replaced by empty spaces
- Repeat the process until no more accessible rolls exist
- Track the total count of removed rolls across all iterations
- Expected result for sample input: 43 rolls removed over 8 iterations (13, 12, 7, 5, 2, 1, 1, 1)

**Grid State Management**
- Use 2D array/vector representation for the grid
- Each iteration creates a new copy of the grid (immutable iteration pattern)
- Replace removed roll positions with '.' (empty space) characters
- Preserve grid dimensions throughout all iterations
- Re-evaluate accessibility after each batch removal using the updated grid state

**Code Extension from Part 1**
- Extend existing Day 4 Part 1 implementations in all languages (Rust, Gleam, Carbon, Bosque)
- Reuse Part 1 functions: parse_grid, count_adjacent_rolls, identify_accessible_rolls
- Keep Part 1 result and additional-info unchanged in JSON output
- Add new solve_part2 function that wraps the iterative removal logic
- Maintain consistent code structure and style with Part 1 implementation

**JSON Output Format**
- Preserve existing structure: part1 field contains Part 1 count (initially accessible rolls)
- Add result2 field containing Part 2 count (total removed rolls across all iterations)
- Keep additional-info minimal to avoid large JSON with real input size
- Do not include state transition arrays or iteration-by-iteration details
- Optional: include iteration count in additional-info only if implementation makes it trivial

**Accessibility Rule Consistency**
- A roll at position (r, c) is accessible if it has fewer than 4 adjacent rolls
- Check all 8 surrounding positions: N, S, E, W, NE, NW, SE, SW
- Use the same count_adjacent_rolls logic from Part 1
- Only count rolls ('@' characters) as adjacent, not empty spaces or out-of-bounds positions
- Re-apply this rule after each batch removal to find newly accessible rolls

**Multi-Language Implementation**
- Implement in Rust: extend solutions/rust/day04/src/main.rs
- Implement in Gleam: extend solutions/gleam/src/day04.gleam
- Implement in Carbon: extend solutions/carbon/day04/day04.carbon
- Implement in Bosque: extend solutions/bosque/day04/ implementation
- Use existing run_<language>.sh scripts for individual validation
- Run test_integration.sh to validate cross-language consistency

**Testing Strategy**
- Add unit tests that validate the iteration count on sample input (expect 8 iterations)
- Add unit tests that validate the removal count per iteration (13, 12, 7, 5, 2, 1, 1, 1)
- Test that Part 1 result remains unchanged when Part 2 is added
- Test that the final answer matches expected output: 43 for sample input
- Use test_integration.sh to verify all 4 languages produce identical results
- Skip edge cases not present in provided input files

**Input Files**
- Use existing input-sample.txt for the example (10x10 grid)
- Use existing input.txt for the real puzzle input
- Reference input-sample-expected-output.txt for validation
- All files located in challenges/day04/ directory
- Input format: multi-line text with '@' for rolls and '.' for empty spaces

**Algorithm Performance**
- Use 2D arrays/vectors for efficient grid access
- Grid copying per iteration is acceptable (not optimizing for minimal allocations)
- Each iteration requires O(rows * cols) scanning to identify accessible rolls
- Total complexity: O(iterations * rows * cols * 8) for adjacency checks
- Performance not critical, but implementation should complete in reasonable time

**Success Criteria**
- Part 2 correctly returns 43 for the sample input
- All 4 language implementations produce identical results
- Part 1 result and additional-info remain unchanged
- JSON output includes both part1 and result2 fields
- Integration tests pass for both sample and real inputs
- Unit tests validate iteration behavior and removal counts

## Visual Design

**`challenges/day04/iterations-part1.png`**
- Shows initial grid state with rolls ('@') and empty spaces ('.')
- First removal: 13 rolls marked with 'x' characters in output grid
- Second removal: 12 rolls removed, showing cascading effect
- Third removal: 7 rolls removed as more become accessible
- Illustrates batch removal concept: all accessible rolls identified before removal

**`challenges/day04/iterations-part2.png`**
- Fourth removal: 5 rolls removed from remaining grid
- Fifth removal: 2 rolls removed as cluster shrinks
- Shows progressive reduction in density of remaining rolls
- Demonstrates how removal exposes edge rolls that become accessible

**`challenges/day04/iterations-part3.png`**
- Sixth, seventh, eighth removals: 1 roll each iteration
- Shows final iterations where single rolls become accessible
- Illustrates the cascading process reaching completion
- Removal slows as fewer rolls remain and most are well-protected

**`challenges/day04/iterations-part4.png`**
- Final state after all accessible rolls removed
- Shows remaining inaccessible cluster of rolls (all have 4+ adjacent rolls)
- Confirms stopping condition: no more rolls meet accessibility criteria
- Total removed: 13+12+7+5+2+1+1+1 = 43 rolls

## Existing Code to Leverage

**`solutions/rust/day04/src/main.rs` - Grid Parsing**
- parse_grid function converts multi-line string input into Vec<Vec<char>>
- Filters empty lines and trims whitespace
- Returns 2D vector suitable for indexing by [row][col]
- Reuse this exact logic for Part 2 initial grid setup

**`solutions/rust/day04/src/main.rs` - Adjacency Counting**
- count_adjacent_rolls checks all 8 directions with bounds checking
- Uses i32 arithmetic to safely handle negative positions
- Returns count of '@' characters in surrounding positions
- Critical for Part 2: reuse this for accessibility checks after each removal

**`solutions/rust/day04/src/main.rs` - Accessibility Identification**
- identify_accessible_rolls returns Vec of (row, col) tuples for accessible rolls
- Iterates entire grid and applies accessibility rule (adjacent_count < 4)
- Part 2 needs this function in the iteration loop to find rolls to remove each round

**`solutions/rust/day04/src/main.rs` - JSON Output Structure**
- Main function outputs JSON with part1, part2, and additional-info fields
- Part 2 should extend this to populate result2 field instead of null
- Keep additional-info structure but may skip adding new visualization data

**`solutions/rust/day04/src/main.rs` - Test Patterns**
- Existing tests cover parse_grid, count_adjacent_rolls, identify_accessible_rolls
- Part 2 tests should follow same pattern: unit tests per function, sample input validation
- Add tests for iteration logic, removal counts, and final totals

## Out of Scope
- Visualization of intermediate grid states (no grid output for each iteration)
- State transition arrays in additional-info (would make JSON too large for real input)
- Detailed iteration-by-iteration breakdown in output
- Edge cases not present in provided input files (empty grids, single roll, etc.)
- Performance optimization beyond reasonable 2D array operations
- Representing pending removal states with 'p' character (internal logic only)
- Creating new visualization formats or rendering tools
- Parallel processing or optimization for large grids
- Tracking which specific rolls were removed in each iteration (only count matters)
- Adding iteration count to additional-info (optional, not required unless trivial)
