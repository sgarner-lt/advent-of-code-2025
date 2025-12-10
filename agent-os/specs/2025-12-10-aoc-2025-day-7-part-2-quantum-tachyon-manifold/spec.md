# Specification: Day 7 Part 2 - Quantum Tachyon Manifold

## Goal
Implement a quantum particle tracking system that uses recursive depth-first search to count distinct terminal timelines when a single tachyon particle travels through a manifold with quantum superposition at splitters, reaching the bottom row of the grid.

## User Stories
- As a physicist, I want to simulate quantum tachyon behavior so that I can count how many distinct timelines result from particle superposition
- As a developer, I want to reuse existing Part 1 code so that I maintain consistency and reduce duplication across both solutions

## Specific Requirements

**Recursive DFS Algorithm for Quantum Particle Propagation**
- Implement recursive function that tracks a single particle moving downward through the grid
- Starting from position S, particle moves down one row per step (row + 1, same column)
- Base case 1: Particle reaches bottom row (row == grid.len() - 1) returns count of 1 terminal timeline
- Base case 2: Particle exits left/right boundaries returns count of 0 (non-terminal, ignored)
- Base case 3: Particle has visited this position in current path returns 0 to prevent infinite loops
- Each recursive call returns an integer count representing number of terminal timelines from that point

**Quantum Superposition Handling at Splitters**
- When particle encounters splitter ('^'), it creates two recursive branches simultaneously
- Left branch: recurse with position (same row, col - 1)
- Right branch: recurse with position (same row, col + 1)
- Return sum of left branch count plus right branch count
- Each branch maintains its own visited state to track independent quantum paths
- Splitter activation counting from Part 1 is NOT needed for Part 2

**Path State Tracking for Loop Prevention**
- Each recursive path maintains its own HashSet of visited positions to prevent cycles
- Visited set tracks (row, col) tuples for current quantum branch only
- When splitting at '^', each new branch receives a cloned copy of parent's visited set
- Before recursing, add current position to visited set for that branch
- This prevents particle from revisiting same position within a single quantum timeline

**Terminal vs Non-Terminal State Detection**
- Terminal state: Particle position where row == grid.len() - 1 (bottom row reached)
- Non-terminal state: Particle exits grid via left boundary (col < 0) or right boundary (col >= grid[0].len())
- Only terminal states contribute count of 1 to final result
- Non-terminal exits contribute count of 0 and are effectively ignored in sum
- Empty space ('.') and starting position ('S') allow particle to continue downward

**Code Reuse from Day 7 Part 1**
- Reuse parse_grid() function unchanged for reading input into Vec<Vec<char>>
- Reuse find_start_position() function unchanged to locate 'S' marker in grid
- Reuse is_in_bounds() function for validating coordinates
- Reuse JSON output format structure: {"part1": <value>, "part2": <value>}
- Part 1 value remains unchanged from existing implementation
- Replace iterative beam propagation with new recursive DFS for Part 2

**Multi-Language Implementation Strategy**
- Implement Rust solution first as primary reference due to performance requirements
- Rust recursive function signature: fn count_timelines(grid, row, col, visited) -> usize
- Ensure Rust solution handles deep recursion safely (consider increasing stack size if needed)
- After Rust validation, port algorithm to Gleam using tail-recursive pattern with accumulator
- Port to Roc using recursive function with pattern matching on cell types
- Port to Carbon following similar structure to Rust with explicit type annotations
- Port to Bosque using functional recursive approach with immutable state

**JSON Output Format**
- Output to stdout must be valid JSON: {"part1": <number>, "part2": <number>}
- part1 field contains result from Part 1 solve (count of activated splitters)
- part2 field contains count of terminal timelines from recursive DFS
- Debug output and path tracking should use stderr only to preserve JSON format
- No additional fields or formatting changes to maintain testing framework compatibility

**Error Handling and Edge Cases**
- Empty grid returns part2: 0
- No starting position 'S' returns error to stderr and null values in JSON
- Maximum recursion depth safeguard with iteration counter or stack size configuration
- Handle grids where all paths lead to non-terminal exits (result: 0)
- Handle grids with no splitters (single straight path counting)
- Handle splitters on grid edges where one branch immediately exits bounds

**Performance and Safety Considerations**
- Rust solution may need increased stack size for deep recursion on large grids
- Use HashSet with efficient hashing (rustc-hash crate if performance issues arise)
- Clone visited sets efficiently when branching (consider Rc or Arc for shared state if needed)
- Profile recursion depth on sample input to validate safety margins
- Expected sample input result: 40 terminal timelines
- Avoid premature optimization - validate correctness first

**Testing Strategy**
- Test with sample input expecting part2: 40 timelines
- Verify Part 1 output remains unchanged at 21 splits
- Test single splitter grid with two branches (expect count: 2)
- Test no splitters straight path (expect count: 1)
- Test splitter on left edge creating only right branch
- Test splitter on right edge creating only left branch
- Test particle path that exits left/right before reaching bottom (expect count: 0)
- Test empty grid and missing start position error handling

## Existing Code to Leverage

**Day 7 Part 1 Grid Parsing and Setup**
- parse_grid() parses stdin input into Vec<Vec<char>> by splitting lines and collecting chars
- find_start_position() iterates grid with enumerate to find 'S' returning Option<(usize, usize)>
- is_in_bounds() validates row/col against grid dimensions with i32 conversions for negative checks
- These functions are production-ready and should be reused without modification
- JSON output format uses println! with string formatting for testing framework compatibility

**Day 7 Part 1 Beam Structure**
- Beam struct with row/col fields can be referenced for position tracking concept
- Part 1 uses HashSet<Beam> for visited tracking - similar pattern needed for Part 2 visited state
- Part 1 iteration safety limit pattern (max_iterations = 100000) can inform recursion depth safeguards
- Iterative beam propagation logic shows how to handle splitter encounters and boundary checks

**Day 4 Grid Navigation Patterns**
- Direction-based movement with i32 offset calculations for row/col positions
- Bounds validation techniques using signed integers to detect negative indices
- Grid cell access patterns with proper bounds checking before indexing
- These patterns directly apply to recursive movement logic in Part 2

**Day 6 State Tracking with HashSet**
- HashSet usage for tracking visited positions with (row, col) tuples
- HashSet::contains() for cycle detection before processing positions
- HashSet::insert() pattern for marking positions as visited
- These patterns apply to per-path visited tracking in recursive DFS

**Gleam Recursive Patterns from Day 7 Part 1**
- Tail-recursive helper function pattern with accumulator parameters
- Pattern matching on list cases for base conditions
- Set operations for state tracking (set.contains, set.insert)
- Result type usage with error propagation for validation

## Out of Scope
- Counting non-terminal exits where particles go off-grid left or right
- Outputting individual path details or tree structures in JSON output
- Visualizing quantum branching paths or timeline trees in output
- Tracking intermediate particle positions through the grid
- Modifying Part 1 solution logic or changing Part 1 result calculation
- Performance optimization before correctness is validated with sample input
- Implementing in all languages simultaneously - Rust-first approach required
- Parallel processing of independent quantum branches
- Memoization or dynamic programming optimization techniques
- Grid visualization or debugging output in JSON response
