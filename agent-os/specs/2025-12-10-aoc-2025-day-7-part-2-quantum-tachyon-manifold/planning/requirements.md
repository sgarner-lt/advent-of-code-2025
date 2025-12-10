# Spec Requirements: Day 7 Part 2 - Quantum Tachyon Manifold

## Initial Description

Implement a quantum tachyon manifold solver where:
- A single tachyon particle is sent through the manifold
- At each splitter, the particle takes BOTH left and right paths (quantum superposition)
- This creates multiple timelines using the many-worlds interpretation
- Need to count the total number of distinct timelines after the particle completes all possible journeys

This is Part 2 of Day 7 in the Advent of Code 2025 challenge. Part 1 dealt with classical tachyon manifolds. Part 2 introduces quantum mechanics where particles exist in superposition.

The key challenge is calculating how many different timelines would exist after a single tachyon particle completes all possible paths through the manifold diagram. The problem statement shows examples where 40 different timelines result from various path combinations through the manifold.

## Requirements Discussion

### First Round Questions

**Q1:** Should the solution reuse the Part 1 code for grid parsing and initial setup?
**Answer:** Yes, reuse Part 1 code where it makes sense (grid parsing, initial setup). This will maintain consistency and reduce duplication.

**Q2:** How should we track particle state when splits occur?
**Answer:** Each particle has its own path. When we split, it creates two new paths. If another particle hits the same path, it needs to be tracked separately. Count unique particles reaching terminal state.

**Q3:** What counts as a "timeline" for counting purposes?
**Answer:** Option A - Count terminal timelines only when particle reaches bottom row, ignore non-terminal exits (particles going off-grid left/right).

**Q4:** Should we use recursive DFS or iterative BFS for path exploration?
**Answer:** Option A - Recursive DFS where each splitter creates two recursive calls (left and right paths).

**Q5:** How should paths be represented internally?
**Answer:** The notation was just an example. If using DFS with tree structure, evaluate the tree to count how many unique terminal states there are.

**Q6:** Should the solution output individual path details or just the total count?
**Answer:** Option A - Only track paths internally for debugging (not output). Output format should match Part 1: JSON with both part1 and part2 values.

**Q7:** Should we consider Rust-first exploration for performance?
**Answer:** Yes, Rust-first exploration if needed for performance. This is a computationally intensive problem that may benefit from Rust's performance characteristics.

**Q8:** Are there any features or paths we should explicitly exclude from the scope?
**Answer:** Non-terminal exits (particles going off-grid left/right) should be ignored. Only count particles that reach the bottom row (terminal state).

### Existing Code to Reference

**Similar Features Identified:**

- Feature: Day 7 Part 1 - Classical Tachyon Manifold
  - Path: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/rust/day07/src/main.rs`
  - Components to reuse:
    - Grid parsing logic: `parse_grid()` function
    - Start position finder: `find_start_position()` function
    - Bounds checking: `is_in_bounds()` function
    - Beam struct (can be adapted for quantum particles)
    - JSON output format
  - Key differences to note:
    - Part 1 tracks split COUNT (how many splitters activated)
    - Part 2 tracks terminal TIMELINES (unique particles reaching bottom)
    - Part 1 uses iterative beam propagation
    - Part 2 should use recursive DFS

- Feature: Day 4 - Grid-based Word Search
  - Path: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/rust/day04/src/main.rs`
  - Patterns to reference:
    - 2D grid navigation
    - Adjacency checking in 8 directions
    - Bounds validation patterns

- Feature: Day 6 - Iterative Grid State Changes
  - Path: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/rust/day06/src/main.rs`
  - Patterns to reference:
    - HashSet usage for tracking visited states
    - Iterative state simulation
    - Grid visualization creation (may be useful for debugging)

### Follow-up Questions

None required. All clarifications were addressed in the initial discussion.

## Visual Assets

### Files Provided:
No visual files found.

### Visual Insights:
No visual assets provided.

## Requirements Summary

### Functional Requirements

**Core Algorithm:**
- Classic depth-first ray tracing problem with quantum branching
- Starting from position 'S', particle moves downward one row per step
- When particle encounters splitter ('^'), it creates TWO new particles:
  - One continues left (same row, col - 1)
  - One continues right (same row, col + 1)
- Each split creates distinct particles that must be counted separately
- Each particle maintains its own path identity

**Terminal Conditions:**
- Terminal state: Particle reaches bottom row of grid (successful timeline)
- Non-terminal: Particle exits grid left/right boundaries (don't count these)
- Terminal timelines are what we count for the final answer

**Implementation Strategy:**
- Use recursive DFS approach
- Each splitter hit creates two recursive calls (left branch and right branch)
- Base cases:
  - Particle reaches bottom row → count as 1 terminal timeline
  - Particle exits left/right → return 0 (don't count)
  - Particle hits visited position → handle appropriately to avoid infinite loops

**State Tracking:**
- Each particle has its own path identity
- Track visited positions per path to prevent infinite loops
- Count unique particles that successfully reach terminal state (bottom row)

**Output Format:**
- JSON format: `{"part1": <part1_value>, "part2": <part2_count>}`
- part1 value remains unchanged from Part 1 solution
- part2 value is the count of terminal timelines

**Internal Path Tracking:**
- Paths tracked internally for debugging purposes only
- Not included in output JSON
- Can use debug logging to stderr for development/troubleshooting

### Reusability Opportunities

**From Day 7 Part 1:**
- Grid parsing: `parse_grid()` - parse input into 2D char vector
- Start position finding: `find_start_position()` - locate 'S' marker
- Bounds checking: `is_in_bounds()` - validate coordinates
- JSON output format structure
- Basic Beam struct (adapt to quantum particle concept)

**From Day 4:**
- 2D grid navigation patterns
- Direction-based movement logic
- Bounds validation techniques

**From Day 6:**
- HashSet usage for state tracking
- Position tracking with (row, col) tuples
- State deduplication patterns

**New Components Needed:**
- Recursive DFS function for quantum particle propagation
- Path identity tracking mechanism
- Terminal state detection logic
- Quantum branching handler (creating two particles at splitters)

### Scope Boundaries

**In Scope:**
- Implement Part 2 solution using recursive DFS
- Count terminal timelines (particles reaching bottom row)
- Reuse Part 1 code where applicable (parsing, bounds checking)
- Maintain Part 1 result in output JSON
- Track quantum particle splits and paths
- Handle empty space ('.') and splitters ('^')
- Prevent infinite loops with visited state tracking
- Rust-first implementation with potential exploration in other languages

**Out of Scope:**
- Counting non-terminal exits (particles going off-grid left/right)
- Outputting individual path details in JSON
- Tracking intermediate particle positions in output
- Modifying Part 1 solution logic or output
- Visualization of quantum branching paths (unless for internal debugging)
- Performance optimization before correctness is validated
- Implementing in all 4 languages immediately (Rust-first approach)

**Future Enhancements (Not Part of This Spec):**
- Visual path tree representation
- Performance benchmarking across languages
- Alternative algorithms comparison (BFS vs DFS)
- Memory usage optimization for large grids
- Parallel processing of independent branches

### Technical Considerations

**Integration Points:**
- Must read from stdin like Part 1
- Must output JSON format compatible with testing framework
- Should reuse existing grid parsing infrastructure
- Should maintain consistency with Part 1 function signatures where possible

**Existing System Constraints:**
- Rust solution structure: `solutions/rust/day07/src/main.rs`
- Input files: `challenges/day07/input.txt` and `input-sample.txt`
- Testing framework expects JSON output to stdout
- Debug output should go to stderr to preserve JSON format
- Must handle both sample and real input correctly

**Technology Preferences:**
- Rust-first implementation due to performance requirements
- Use standard library types: Vec, HashSet, HashMap as needed
- Follow existing code patterns from Day 7 Part 1
- Maintain idiomatic Rust code style
- Use itertools crate if helpful for path manipulation
- Consider rustc-hash for faster HashSet operations if needed

**Similar Code Patterns to Follow:**
- Day 7 Part 1: Beam propagation structure, iteration safety limits
- Day 4: Grid navigation with direction vectors
- Day 6: State tracking with HashSet, iterative updates

**Algorithm Notes:**
- Recursive DFS is more natural for branching quantum paths
- Need to prevent infinite loops (particle revisiting same position in same path)
- Consider maximum recursion depth safeguards
- Each recursive branch represents an independent quantum timeline
- Terminal condition is reaching bottom row (not going out of bounds)

**Performance Considerations:**
- Large grids with many splitters could create exponential path growth
- May need memoization or pruning strategies if performance issues arise
- Rust's performance should handle reasonable input sizes efficiently
- Profile and optimize only after correctness is validated

**Testing Strategy:**
- Validate against sample input first (expected output: 40 timelines)
- Ensure Part 1 output remains unchanged
- Test edge cases: splitters on edges, no splitters, all splitters
- Verify terminal vs non-terminal exit handling
- Cross-validate with other language implementations once Rust works
