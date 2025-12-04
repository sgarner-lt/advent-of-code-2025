# Specification: Day 1 Part 2 - Cross-Language Zero Crossing Implementation

## Goal
Implement Advent of Code Day 1 Part 2 solution across all 5 languages (Bosque, Carbon, Gleam, Roc, Rust) to count dial crossings through position 0 during rotations, not just final positions at 0, with cross-language validation ensuring all implementations produce identical results.

## User Stories
- As a puzzle solver, I want to count every time the dial crosses through position 0 during a rotation so that I can solve Part 2 using password method 0x434C49434B
- As a developer, I want all 5 language implementations to produce identical results so that I can validate correctness across different language paradigms

## Specific Requirements

**Zero Crossing Algorithm Function**
- Create new function `count_zero_crossings(current_position, direction, amount)` that returns count of zero crossings
- Takes current dial position (0-99 integer), rotation direction ('L' or 'R'), and rotation amount (positive integer)
- Calculates crossings using effective rotation size before wraparound occurs
- Uses division by 100 for large rotations (e.g., R1000 crosses 0 ten times)
- Handles both clockwise (Right) and counterclockwise (Left) rotations correctly
- Does not modify or call the existing `rotate_dial` function
- Returns integer count of how many times position 0 is crossed during the rotation movement

**Part 2 Main Logic Integration**
- Update each language's main solving function to calculate both Part 1 and Part 2 answers in single pass through input
- Part 1 logic remains unchanged (count final positions at 0)
- Part 2 adds zero crossing counts for each rotation instruction
- Output both answers in JSON format: `{"part1": <integer>, "part2": <integer>}`
- Reuse existing input parsing and position tracking from Part 1

**Preserve Existing Part 1 Code**
- Do not modify `rotate_dial` or equivalent rotation function from Part 1
- Keep all input parsing logic unchanged
- Maintain existing position tracking mechanisms
- Preserve all Part 1 helper functions as-is
- Only add new zero crossing calculation function and integrate into main logic

**Handle Large Rotation Amounts**
- For rotations greater than 100, divide by 100 to get complete circles count
- Each complete circle crosses zero exactly once (regardless of starting position)
- Handle remainder after division as partial rotation using standard logic
- Example: R1000 from position 50 yields 10 complete circles = 10 crossings
- Ensure division approach is consistent across all 5 languages

**Cross-Language Consistency Validation**
- All 5 implementations must use equivalent algorithm logic even when language idioms differ
- Sample input must produce `{"part1": 3, "part2": 6}` in all languages
- Real puzzle input must produce identical numerical results across all languages
- Part 1 answers must remain unchanged from previous implementation (1097 for real input)

**Edge Case Handling**
- Starting at position 0: determine whether to count as initial crossing or not
- Ending at position 0: ensure not double-counted between crossing and final position
- Exact multiples of 100: handle rotations like R100, L200 correctly
- Zero-distance rotations: handle gracefully without errors
- Large distances (>1000): ensure algorithm remains efficient using division approach

**Testing Strategy**
- Add unit tests for `count_zero_crossings` function with simple, crossing, and large rotation cases
- Validate sample input produces expected Part 2 answer of 6
- Verify Part 1 answer remains unchanged at 3 for sample input
- Test against real puzzle input and verify Part 1 answer unchanged at 1097
- Run cross-language validation comparing all 5 implementations on both sample and real inputs

**JSON Output Format**
- Maintain existing JSON output structure from Part 1
- Output format: `{"part1": <integer>, "part2": <integer>}`
- Replace `"part2": null` with calculated Part 2 integer answer
- Ensure valid JSON syntax with proper escaping and formatting
- Output to stdout for consumption by test harness

**Language-Specific Implementation**
- Rust: use standard library, native pattern matching, add tests using `#[test]` macro
- Gleam: use functional style, pattern matching, extend existing test suite with gleeunit
- Roc: use expect statements for inline tests, maintain pure functional approach
- Carbon: work within experimental language constraints, manual test functions like Part 1
- Bosque: use assertion-based testing, handle potential runtime environment limitations

**Documentation and Observations**
- Document algorithm approach in code comments for clarity
- Note any language-specific challenges encountered during implementation
- Record informal observations about code readability and implementation ease per language
- Capture lessons learned about each language's strengths for this problem type

## Visual Design
No visual assets provided.

## Existing Code to Leverage

**Part 1 Rotation Logic (all languages)**
- Existing `rotate_dial` / `rotate` / `rotateDial` functions handle dial position updates with wraparound
- These functions correctly implement modulo 100 arithmetic for circular dial (0-99)
- Do not modify these functions; use them as-is for position tracking
- Reference their implementation to understand direction handling (Left subtracts, Right adds)
- Reuse the same Direction enum/type definitions from Part 1

**Part 1 Input Parsing (all languages)**
- Existing parsing functions extract direction ('L' or 'R') and distance from instruction strings
- These handle line-by-line input processing, whitespace trimming, and empty line filtering
- Reuse parsing logic to extract direction and amount needed for `count_zero_crossings` function
- Leverage existing error handling for invalid input formats
- Maintain same input file path handling from command-line arguments

**Part 1 Test Infrastructure (all languages)**
- Rust: `#[cfg(test)]` module with `#[test]` functions, can add new test cases for Part 2
- Gleam: gleeunit test framework in test/ directory, add new test functions to existing suite
- Roc: inline expect statements throughout codebase, add expects for zero crossing logic
- Carbon: manual test functions (TestXyz pattern), add new manual test functions for Part 2
- Bosque: function-based tests with assertions, add new test functions following naming pattern

**JSON Output Formatting Pattern (all languages)**
- Rust: uses `println!` with format string `{{"part1": {}, "part2": null}}`
- Gleam: `build_json` helper function constructs JSON string with integer-to-string conversion
- Roc: string interpolation with `Num.to_str` for integer values in JSON template
- Carbon: would use C++ printf interop with manual JSON string construction
- Bosque: `String::concat` to build JSON output string from parts
- Extend existing patterns to include Part 2 integer value instead of null

**Position Tracking State (all languages)**
- All implementations maintain current position as mutable state or accumulated through fold/walk
- Starting position is 50 for all implementations
- Position is updated after each rotation instruction using the rotate function
- Maintain same state tracking approach, just add parallel zero crossing count accumulator

## Out of Scope
- Performance optimization beyond division approach for large rotations
- Visualization of dial rotations or crossing points
- Alternative algorithm implementations for comparison (though documenting alternatives is acceptable)
- Modifying Part 1 code structure, algorithms, or function signatures
- Creating new build or run scripts (reuse existing run-*.sh scripts)
- Comprehensive edge case testing beyond critical validation cases
- Benchmarking or formal performance comparisons between languages
- Adding new dependencies beyond what's already used in Part 1
- Creating GUI or interactive visualization tools
- Supporting additional input formats beyond existing line-by-line instruction format
