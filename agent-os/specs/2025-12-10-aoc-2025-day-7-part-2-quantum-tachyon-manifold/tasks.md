# Task Breakdown: Day 7 Part 2 - Quantum Tachyon Manifold

## Overview
Total Tasks: 4 Major Task Groups
Implementation Language Sequence: Rust (primary) -> Roc -> Gleam -> Carbon -> Bosque

## Task List

### Core Algorithm Implementation (Rust)

#### Task Group 1: Recursive DFS for Quantum Particle Propagation
**Dependencies:** None (reuses existing Part 1 code)

- [x] 1.0 Implement recursive quantum timeline counter in Rust
  - [x] 1.1 Write 2-8 focused tests for recursive DFS functionality
    - Implemented 5 tests for Task Group 1
    - Test only critical recursive behaviors:
      - Single straight path (no splitters) reaches bottom row (expect: 1)
      - Single splitter creating two branches reaching bottom (expect: 2)
      - Particle exiting left/right boundary before bottom (expect: 0)
      - Visited position cycle prevention within single path
      - Sample input validation (expect: 40 terminal timelines)
    - Skip exhaustive coverage of all edge cases at this stage
  - [x] 1.2 Create recursive function `count_timelines()`
    - Function signature: `fn count_timelines(grid: &[Vec<char>], row: usize, col: usize, visited: &mut HashSet<(usize, usize)>) -> usize`
    - Base case 1: `row == grid.len() - 1` returns 1 (terminal timeline reached)
    - Base case 2: Column out of bounds (`col` negative or `>= grid[0].len()`) returns 0 (non-terminal exit)
    - Base case 3: Position already in visited set returns 0 (prevent infinite loops)
    - Recursive case for empty space '.' or 'S': move down one row, same column
    - Recursive case for splitter '^': create two branches (left and right)
  - [x] 1.3 Implement quantum branching at splitters
    - Clone visited set for left branch: `let mut left_visited = visited.clone();`
    - Clone visited set for right branch: `let mut right_visited = visited.clone();`
    - Left branch: recurse with `(row, col - 1, &mut left_visited)`
    - Right branch: recurse with `(row, col + 1, &mut right_visited)`
    - Return sum: `left_count + right_count`
  - [x] 1.4 Implement visited state tracking
    - Insert current position before recursing: `visited.insert((row, col));`
    - Check visited before processing: `if visited.contains(&(row, col)) { return 0; }`
    - Each branch gets independent copy of visited set for quantum path tracking
  - [x] 1.5 Handle downward movement through empty space
    - For '.' and 'S' cells: move to `(row + 1, col)`
    - Convert to i32 for bounds checking before recursing
    - Use existing `is_in_bounds()` function from Part 1
  - [x] 1.6 Ensure recursive DFS tests pass
    - Run ONLY the 2-8 tests written in 1.1
    - Verify terminal timeline counting works correctly
    - Verify sample input produces expected result: 40
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- [x] The 2-8 tests written in 1.1 pass
- [x] Recursive function correctly handles base cases
- [x] Quantum branching creates independent paths with separate visited sets
- [x] Sample input produces 40 terminal timelines
- [x] No infinite loops occur due to visited state tracking

### Integration with Part 1 Solution

#### Task Group 2: Integrate Part 2 into Existing Day 7 Solution
**Dependencies:** Task Group 1

- [x] 2.0 Complete integration with Part 1 code
  - [x] 2.1 Write 2-8 focused tests for integration
    - Implemented 3 tests for Task Group 2
    - Test only critical integration points:
      - Part 1 result remains unchanged at 21 splits
      - Part 2 result matches expected 40 timelines
      - JSON output format is valid: `{"part1": 21, "part2": 40}`
      - Empty grid returns part2: 0
      - Missing start position 'S' returns part2: "null"
    - Skip exhaustive testing of all scenarios
  - [x] 2.2 Modify `solve()` function to compute Part 2 result
    - Keep existing Part 1 call: `let split_count = simulate_beam_propagation(&grid, start_pos.0, start_pos.1);`
    - Add Part 2 call: `let timeline_count = count_timelines(&grid, start_pos.0, start_pos.1, &mut HashSet::new());`
    - Update return: `(split_count.to_string(), timeline_count.to_string())`
  - [x] 2.3 Reuse existing helper functions unchanged
    - `parse_grid()` - already handles stdin parsing
    - `find_start_position()` - already locates 'S' marker
    - `is_in_bounds()` - already validates coordinates with i32 conversion
    - No modifications needed to these functions
  - [x] 2.4 Update JSON output in `main()`
    - Ensure format remains: `println!("{{\"part1\": {}, \"part2\": {}}}", part1_result, part2_result);`
    - Part 1 value unchanged from existing implementation
    - Part 2 value now contains timeline count instead of "null"
  - [x] 2.5 Add debug output to stderr for development
    - Debug output removed for performance (originally added, then removed)
    - Do NOT output debug info to stdout (preserves JSON format)
  - [x] 2.6 Ensure integration tests pass
    - Run ONLY the 2-8 tests written in 2.1
    - Verify Part 1 result unchanged (21 splits)
    - Verify Part 2 result correct (40 timelines)
    - Verify JSON format valid
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- [x] The 2-8 tests written in 2.1 pass
- [x] Part 1 solution continues to work correctly (21 splits)
- [x] Part 2 solution produces correct result (40 timelines)
- [x] JSON output format valid and compatible with testing framework
- [x] Existing helper functions reused without modification

### Testing & Validation

#### Task Group 3: Comprehensive Testing and Edge Case Validation
**Dependencies:** Task Groups 1-2

- [x] 3.0 Validate solution with comprehensive test scenarios
  - [x] 3.1 Review tests from Task Groups 1-2
    - Review the 5 tests written by recursive-algorithm-engineer (Task 1.1)
    - Review the 3 tests written by integration-engineer (Task 2.1)
    - Total existing tests: approximately 8 tests
  - [x] 3.2 Analyze test coverage gaps for THIS feature only
    - Identify critical quantum branching scenarios that lack coverage
    - Focus ONLY on gaps related to Part 2 recursive DFS requirements
    - Do NOT assess entire application test coverage
    - Prioritize edge cases specific to quantum particle propagation
  - [x] 3.3 Write up to 10 additional strategic tests maximum
    - Added 6 additional tests to fill identified critical gaps:
      - Splitter on left edge (only right branch valid)
      - Splitter on right edge (only left branch valid)
      - Multiple splitters in sequence creating exponential paths
      - Grid with all paths exiting left/right (expect: 0)
      - Grid with no splitters and straight path to bottom (expect: 1)
      - Nested quantum branches (splitter -> splitter -> splitter)
    - Do NOT write comprehensive coverage for all scenarios
    - Skip performance tests and stress tests at this stage
  - [x] 3.4 Run feature-specific tests only
    - Run ONLY tests related to Part 2 recursive DFS (tests from 1.1, 2.1, and 3.3)
    - Expected total: approximately 14 tests (5+3+6)
    - Do NOT run the entire Rust test suite
    - Verify all critical quantum particle workflows pass
    - Result: 22 tests total in suite, all passing
  - [x] 3.5 Validate with sample input file
    - Test using `challenges/day07/input-sample.txt`
    - Verify output: `{"part1": 21, "part2": 40}`
    - Confirm output is valid JSON parseable by testing framework
  - [x] 3.6 Validate with real input file - OPTIMIZED AND COMPLETE
    - Test using `challenges/day07/input.txt`
    - OPTIMIZATION APPLIED: Replaced HashSet cloning with memoization
    - Memoization approach: HashMap<(row, col), count> caches timeline counts per position
    - Performance: Runs in <3 seconds for real input (141 rows)
    - Real input result: `{"part1": 1587, "part2": <redacted>}`
    - Part 1 result correct: 1587 splits
    - Part 2 result obtained: <redacted> terminal timelines
    - Sample input still works correctly: part1=21, part2=40
  - [x] 3.7 Profile recursion depth and performance - COMPLETE
    - Memoization optimization eliminates HashSet cloning overhead
    - Algorithm complexity: O(rows * cols) with memoization (each position computed once)
    - Memory complexity: O(rows * cols) for memoization cache
    - Stack safety: Recursion depth limited to grid dimensions (max 141 for real input)
    - No stack overflow issues observed
    - Performance acceptable: <3 seconds for real input in release mode
    - Optimization strategy: Memoization with HashMap instead of HashSet cloning

**Acceptance Criteria:**
- [x] All feature-specific tests pass (22 tests total)
- [x] Critical quantum branching scenarios covered
- [x] No more than 10 additional tests added when filling in testing gaps (6 added)
- [x] Sample input produces correct output: part1=21, part2=40
- [x] Real input produces valid results: part1=1587, part2=<redacted>
- [x] Performance optimized: runs in <3 seconds for real input
### Multi-Language Implementation

#### Task Group 4: Port Solution to Other Languages
**Dependencies:** Task Group 3 (Rust solution validated)

- [ ] 4.0 Port validated Rust solution to other languages
  - [ ] 4.1 Port to Roc
    - Create `solutions/roc/day07/main.roc`
    - Use pattern matching for cell types: `'.' | 'S' | '^'`
    - Implement recursive function with same logic as Rust
    - Use Set for visited state tracking (Roc's Set type)
    - Reuse grid parsing approach from existing Roc solutions
    - Test with sample input: expect `{"part1": 21, "part2": 40}`
    - Validate JSON output format matches testing framework
  - [ ] 4.2 Port to Gleam
    - Create `solutions/gleam/day07/src/day07.gleam`
    - Use tail-recursive pattern with accumulator for timeline counting
    - Implement helper function: `count_timelines_helper(grid, row, col, visited, acc)`
    - Use Gleam's Set type for visited state (import `gleam/set`)
    - Pattern match on cell types using case expressions
    - Test with sample input: expect `{"part1": 21, "part2": 40}`
    - Validate JSON output format matches testing framework
  - [ ] 4.3 Port to Carbon (if Carbon tooling available)
    - Create `solutions/carbon/day07/day07.carbon`
    - Follow similar structure to Rust with explicit type annotations
    - Function signature: `fn CountTimelines(grid: [Vector[Vector[Char]]], row: i32, col: i32, visited: HashSet[(i32, i32)]) -> i32`
    - Use Carbon's HashSet for visited state tracking
    - Match on cell types using Carbon's pattern matching syntax
    - Test with sample input: expect `{"part1": 21, "part2": 40}`
    - Note: Skip if Carbon tooling not yet mature/available
  - [ ] 4.4 Port to Bosque (if Bosque tooling available)
    - Create `solutions/bosque/day07/day07.bsq`
    - Use functional recursive approach with immutable state
    - Leverage Bosque's immutable collections for visited set
    - Pattern match on cell types using Bosque's type refinement
    - Test with sample input: expect `{"part1": 21, "part2": 40}`
    - Note: Skip if Bosque tooling not yet mature/available
  - [ ] 4.5 Cross-validate all language implementations
    - Run sample input through all implemented languages
    - Verify identical output: `{"part1": 21, "part2": 40}`
    - Run real input through all implementations
    - Verify consistent Part 2 results across languages
    - Document any language-specific performance differences

**Acceptance Criteria:**
- [ ] Roc implementation produces correct results matching Rust
- [ ] Gleam implementation produces correct results matching Rust
- [ ] Carbon implementation produces correct results (if implemented)
- [ ] Bosque implementation produces correct results (if implemented)
- [ ] All implementations handle sample input correctly
- [ ] All implementations produce valid JSON output
- [ ] Cross-language consistency validated

## Execution Order

Recommended implementation sequence:
1. Core Algorithm Implementation - Rust (Task Group 1) - COMPLETE
2. Integration with Part 1 Solution (Task Group 2) - COMPLETE
3. Testing & Validation (Task Group 3) - MOSTLY COMPLETE (real input optimization needed)
4. Multi-Language Implementation (Task Group 4) - NOT STARTED

## Key Implementation Notes

### Code Reuse from Part 1
- **parse_grid()**: Use unchanged for reading stdin into Vec<Vec<char>>
- **find_start_position()**: Use unchanged to locate 'S' marker
- **is_in_bounds()**: Use unchanged for coordinate validation with i32 conversion
- **Beam struct**: Reference for position tracking concept, but Part 2 doesn't need direction
- **JSON output format**: Maintain exact format for testing framework compatibility

### Recursive DFS Pattern
```rust
fn count_timelines(
    grid: &[Vec<char>],
    row: usize,
    col: usize,
    visited: &mut HashSet<(usize, usize)>
) -> usize {
    // Base case 1: Terminal state (bottom row reached)
    if row == grid.len() - 1 {
        return 1;
    }

    // Base case 2: Cycle detection
    if visited.contains(&(row, col)) {
        return 0;
    }

    // Mark visited
    visited.insert((row, col));

    // Move down one row
    let next_row = row + 1;
    let next_col = col as i32;

    // Get cell at current position
    let cell = grid[row][col];

    match cell {
        '.' | 'S' => {
            // Continue downward
            count_timelines(grid, next_row, col, visited)
        }
        '^' => {
            // Quantum split: left and right branches
            let mut left_visited = visited.clone();
            let mut right_visited = visited.clone();

            let left_count = if next_col - 1 >= 0 && next_col - 1 < grid[0].len() as i32 {
                count_timelines(grid, row, (next_col - 1) as usize, &mut left_visited)
            } else {
                0 // Out of bounds (non-terminal)
            };

            let right_count = if next_col + 1 >= 0 && next_col + 1 < grid[0].len() as i32 {
                count_timelines(grid, row, (next_col + 1) as usize, &mut right_visited)
            } else {
                0 // Out of bounds (non-terminal)
            };

            left_count + right_count
        }
        _ => 0
    }
}
```

### Performance Considerations
- Expected recursion depth: O(rows * splitters) in worst case
- Sample input: 16 rows, 21 splitters -> depth likely 16-50 levels
- Rust default stack: 2MB should be sufficient
- **PERFORMANCE ISSUE IDENTIFIED**: HashSet cloning at each split causes exponential slowdown
- Real input (141 rows) times out after 30 seconds
- Optimization strategies to consider:
  - Memoization with state caching
  - Iterative approach instead of recursive
  - Reference-counted shared state (Rc<RefCell<HashSet>>)
  - BitSet instead of HashSet for faster cloning
- Note: Correctness validated with sample input, optimization is separate concern

### Testing Strategy
- Minimal tests during development (2-8 per group)
- Focus on critical paths: terminal state, non-terminal exit, cycle detection
- Sample input validation: part2 = 40
- Edge cases: boundary splitters, no splitters, all paths exit
- Cross-language validation after Rust implementation proven correct

### Debug Output Guidelines
- Use stderr for all debug logging
- Log recursion depth, timeline counts, path information
- Never output to stdout (preserves JSON format)
- Example: `eprintln!("Recursion depth: {}, Timeline count: {}", depth, count);`

## Important Constraints

- **Reuse existing code**: Do not modify parse_grid(), find_start_position(), or is_in_bounds()
- **Maintain Part 1 result**: Part 1 output must remain 21 splits for sample input
- **JSON format**: Output must be valid JSON parseable by testing framework
- **Rust-first approach**: Validate Rust solution before porting to other languages
- **Minimal test writing**: Maximum 2-8 tests per task group during development
- **Strategic test gaps**: Maximum 10 additional tests in Task Group 3
- **Stack safety**: Profile recursion depth and increase stack size if needed
- **Terminal vs non-terminal**: Only count timelines reaching bottom row (row == grid.len() - 1)
- **Quantum branching**: Each split creates independent paths with cloned visited sets
- **Cycle prevention**: Track visited positions per path to prevent infinite loops

## Implementation Status

**Task Group 1 (Core Algorithm)**: COMPLETE
- All subtasks completed
- 5 tests written and passing
- Recursive DFS algorithm implemented correctly
- Sample input produces expected result: 40 timelines

**Task Group 2 (Integration)**: COMPLETE
- All subtasks completed
- 3 integration tests written and passing
- Part 1 remains unchanged (21 splits)
- Part 2 produces correct result (40 timelines)
- JSON output format validated

**Task Group 3 (Testing & Validation)**: MOSTLY COMPLETE
- 22 total tests, all passing
- 6 additional edge case tests added
- Sample input validated: {"part1": 21, "part2": 40}
- Real input times out (performance optimization needed)
- Correctness validated, optimization is next step

**Task Group 4 (Multi-Language)**: NOT STARTED
- Awaiting completion of Task Group 3
- Will port to Roc, Gleam, and optionally Carbon/Bosque
- Same performance issue will affect all implementations

## Performance Notes

The current implementation is algorithmically correct but has exponential time complexity
due to HashSet cloning at each quantum split. For large inputs (141 rows), this causes
unacceptable execution times (>30 seconds). The spec states "Profile and optimize only
after correctness is validated" - correctness has been validated with sample input (40
timelines). Optimization is a separate concern that can be addressed with:

1. Memoization (cache results for (row, col, visited_hash) states)
2. Iterative BFS instead of recursive DFS
3. Shared state with reference counting (Rc<RefCell<HashSet>>)
4. BitSet for faster state cloning
5. Path compression to reduce duplicate work

File locations:
- Rust implementation: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/rust/day07/src/main.rs`
- Sample input: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day07/input-sample.txt`
- Real input: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day07/input.txt`

## Optimization Applied - Memoization Strategy

**Problem Identified:** The initial recursive implementation with HashSet cloning at each quantum split caused exponential time complexity for large inputs (141 rows). The real input timed out after >30 seconds.

**Solution Implemented:** Memoization with HashMap<(row, col), usize> to cache timeline counts per grid position.

**Key Insight:** Since particles always move downward (except at splitters where they move sideways on the same row), and we're counting total paths from each position, we don't need to track visited states for cycle detection. Each position's count is deterministic based on the grid structure.

**Optimized Algorithm:**
```rust
fn count_timelines_memoized(
    grid: &[Vec<char>],
    row: usize,
    col: usize,
    memo: &mut HashMap<(usize, usize), usize>,
) -> usize {
    // Check cache first
    if let Some(&cached) = memo.get(&(row, col)) {
        return cached;
    }

    // Base case: reached bottom row
    if row == grid.len() - 1 {
        return 1;
    }

    let cell = grid[row][col];
    let result = match cell {
        '.' | 'S' => count_timelines_memoized(grid, row + 1, col, memo),
        '^' => {
            let mut total = 0;
            // Left branch
            if col > 0 {
                total += count_timelines_memoized(grid, row, col - 1, memo);
            }
            // Right branch
            if col < grid[0].len() - 1 {
                total += count_timelines_memoized(grid, row, col + 1, memo);
            }
            total
        }
        _ => count_timelines_memoized(grid, row + 1, col, memo),
    };

    // Cache and return
    memo.insert((row, col), result);
    result
}
```

**Results:**
- Sample input (16 rows): {"part1": 21, "part2": 40} - CORRECT
- Real input (141 rows): {"part1": 1587, "part2": <redacted>} - COMPLETE  
- Performance: <3 seconds in release mode
- Algorithm complexity: O(rows * cols) - each position computed at most once
- Memory complexity: O(rows * cols) for memoization cache
- Stack safety: Recursion depth limited to grid dimensions (no overflow)

**This memoization approach will be used for all language implementations in Task Group 4.**

