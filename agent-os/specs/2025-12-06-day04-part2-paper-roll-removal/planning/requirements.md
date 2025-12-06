# Spec Requirements: Day 4 Part 2 - Paper Roll Removal Simulation

## Initial Description
The problem is about iteratively removing accessible rolls of paper from a warehouse grid. Once a roll is removed, it may expose other rolls that can then be accessed and removed by forklifts. The goal is to calculate the total number of rolls that can be removed through this cascading process.

Key details from the problem:
- Start with a grid of paper rolls (marked with @)
- Forklifts can only access and remove rolls that meet certain accessibility criteria
- After removing a roll, check if new rolls become accessible
- Continue until no more rolls can be removed
- Count the total number of removed rolls

The full problem statement shows an example where 43 rolls can be removed through 8 removal iterations (13, 12, 7, 5, 2, 1, 1, 1).

## Requirements Discussion

### First Round Questions

**Q1: Code Reuse** - Should we extend the existing Day 4 Part 1 code to add Part 2 functionality, or create a separate implementation?
**Answer:** Extend Day 4 Part 1 code. Part 1 result and additional-info should stay the same. Return part 2 answer in "result2" field of JSON.

**Q2: Removal Algorithm** - When multiple rolls become accessible in an iteration, should we remove them all at once (batch removal) or one at a time (sequential removal)?
**Answer:** Re-evaluate after each pending removal. Unit tests on iterations should help clarify. (This suggests batch removal per iteration - identify all accessible rolls, remove them together, then re-evaluate)

**Q3: Iterations Tracking** - Should we track and output the number of iterations it took to remove all accessible rolls?
**Answer:** Could add iterations count to additional-info if useful, but user isn't sure they care about it.

**Q4: Output Format** - Should we continue using JSON output format? Should we include intermediate state information?
**Answer:** Yes on JSON. Could add state transition array and return it (array size = number of iterations), but concerned about huge JSON with real input size. Maybe leave out any new info from additional-info.

**Q5: Visualization** - Should we visualize the intermediate states showing which rolls are removed at each iteration?
**Answer:** Skip visualization for now.

**Q6: Accessibility Rule** - To confirm: a roll is accessible if it has fewer than 4 adjacent rolls (out of the 8 surrounding positions)?
**Answer:** Yes, confirmed - roll is accessible if it has < 4 adjacent rolls in 8 surrounding positions.

**Q7: Multi-Language Implementation** - Should we implement this in all 4 languages (Rust, Bosque, Carbon, and the 4th language)?
**Answer:** Yes, always implement in all 4 languages. Use run_<language>.sh scripts and test_integration.sh to validate individual results and cross-language consistency.

**Q8: Edge Cases** - What edge cases should we handle (empty grids, single roll, all rolls accessible, no rolls accessible, etc.)?
**Answer:** Have all input files needed. Don't cover edge cases that don't exist in the input*.txt files.

**Q9: Code Reuse/Performance** - Are there specific patterns or utilities from other days we should leverage? Any performance considerations?
**Answer:** Build upon current day's code. Can copy helpful snippets from other days if needed. Not terribly concerned with performance but 2D arrays are warranted. Each iteration will copy the array.

**Q10: Additional Info** - The problem text mentions using "highlighted @" to indicate pending removal. How should we represent this in our grid visualization?
**Answer:** Use 'p' character to signify pending removal (not highlighted @). The problem text may have lost the highlighted ampersand distinction when copied from HTML. User has added screenshots to `challenges/day04/` folder with naming convention `iterations-partx.png` showing the highlighted ampersands.

### Existing Code to Reference

**Similar Features Identified:**
- Feature: Day 4 Part 1 - Path: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/rust/day04/src/main.rs` (and corresponding Bosque/Carbon implementations)
- Components to potentially reuse:
  - Grid parsing logic (`parse_grid`)
  - Adjacent roll counting (`count_adjacent_rolls`)
  - Accessibility identification (`identify_accessible_rolls`)
  - Grid visualization patterns (`create_visualization`)
- Backend logic to reference: Part 1 solve function returns `(usize, String)` for count and visualization

## Visual Assets

### Files Provided:
Located in `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day04/`:
- `iterations-part1.png`: Shows initial state, first removal (13 rolls marked with 'x'), second removal (12 rolls), and third removal (7 rolls)
- `iterations-part2.png`: Shows fourth removal (5 rolls), fifth removal (2 rolls)
- `iterations-part3.png`: Shows sixth removal (1 roll), seventh removal (1 roll), eighth removal (1 roll)
- `iterations-part4.png`: Shows final removal (1 roll) and final state

### Visual Insights:
- The screenshots show the complete iterative removal process from the problem statement
- Each iteration shows:
  - Header: "Remove N rolls of paper:"
  - Grid state where:
    - '.' = empty space
    - '@' = inaccessible roll (4+ adjacent rolls)
    - 'x' = position where a roll was just removed
    - Highlighted '@' (appears slightly different in original HTML) = pending removal (accessible rolls about to be removed)
- The visualization confirms batch removal per iteration (all accessible rolls identified together, then removed as a batch)
- Total of 8 iterations in the example: 13 + 12 + 7 + 5 + 2 + 1 + 1 + 1 = 43 rolls removed
- Process continues until no more rolls meet the accessibility criteria (< 4 adjacent rolls)
- Fidelity level: Screenshots from Advent of Code website (reference material, not design mockups)

## Requirements Summary

### Functional Requirements
- Extend existing Day 4 Part 1 solution to add Part 2 iterative removal logic
- Maintain Part 1 result and additional-info in JSON output unchanged
- Add Part 2 result in "result2" field showing total rolls removed through all iterations
- Implement iterative removal algorithm:
  1. Identify all accessible rolls (< 4 adjacent rolls)
  2. Mark them for pending removal
  3. Remove all pending rolls simultaneously (batch removal)
  4. Create a copy of the grid for the next iteration
  5. Repeat until no more accessible rolls exist
- Track total count of rolls removed across all iterations
- Accessibility rule: A roll at position (r, c) is accessible if it has fewer than 4 adjacent rolls in the 8 surrounding positions
- Use existing Part 1 adjacency counting logic
- Keep additional-info minimal to avoid huge JSON with real input size (don't add state transitions array)
- Optionally include iteration count in additional-info if implementation makes it trivial

### Reusability Opportunities
- Reuse from Day 4 Part 1:
  - Grid parsing function
  - Adjacent roll counting function (8-directional check)
  - Accessibility identification function
  - JSON output format structure
- Grid copying for each iteration (2D array cloning)
- Batch processing pattern for simultaneous removals

### Scope Boundaries
**In Scope:**
- Iterative removal simulation
- Total roll count across all iterations
- JSON output with result2 field
- Implementation in all 4 languages (Rust, Bosque, Carbon, and 4th language)
- Unit tests covering the iteration logic
- Integration tests for cross-language consistency

**Out of Scope:**
- Visualization of intermediate states
- State transition array in additional-info (too large for real input)
- Detailed iteration-by-iteration output
- Edge cases not present in provided input files
- Performance optimization beyond reasonable 2D array operations
- Representing pending removal states visually (no 'p' character in output - just count the removals)

### Technical Considerations
- Build upon Day 4 Part 1 existing implementations
- Use 2D arrays/vectors for grid representation
- Each iteration creates a copy of the grid (immutable iteration pattern)
- JSON output format: `{"part1": <count>, "part2": <total_removed>, "additional-info": {...}}`
- Run scripts: Use existing `run_<language>.sh` for individual language testing
- Integration testing: Use `test_integration.sh` to validate cross-language consistency
- Unit tests should validate iteration counts on sample input (expected: 8 iterations with sequence 13, 12, 7, 5, 2, 1, 1, 1)
- Input files available: `input-sample.txt`, `input.txt`, `input-sample-expected-output.txt` in `/challenges/day04/`
