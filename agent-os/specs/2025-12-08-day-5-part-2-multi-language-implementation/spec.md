# Specification: Day 5 Part 2 Multi-Language Implementation

## Goal
Extend Day 5 Part 1 solutions across all 4 languages (Rust, Gleam, Carbon, Bosque) to calculate Part 2 result by counting unique ingredient IDs across all fresh ingredient ID ranges, returning both Part 1 and Part 2 results in JSON format.

## User Stories
- As a developer, I want to extend existing Part 1 implementations so that they also calculate Part 2 without breaking existing functionality
- As a validator, I want all 4 language implementations to produce identical results for both parts so that cross-language consistency is verified

## Specific Requirements

**Calculate unique ingredient IDs across all ranges**
- Parse fresh ingredient ID ranges from first section of input (before blank line)
- For each range (format: START-END), generate all ingredient IDs within that range (inclusive)
- Collect all ingredient IDs from all ranges into a set to handle overlapping ranges correctly
- Count the total number of unique ingredient IDs in the set
- Example: ranges 3-5, 10-14, 16-20, 12-18 produce 14 unique IDs (3,4,5,10,11,12,13,14,15,16,17,18,19,20)

**Ignore available IDs section for Part 2**
- Part 2 calculation uses only the fresh ingredient ID ranges (first section)
- Second section (available IDs list) is already parsed for Part 1 but not used for Part 2
- Do not modify Part 1 logic which checks available IDs against ranges

**Return both results in JSON format**
- Extend solve function to return tuple: (part1_result, part2_result)
- Output JSON format: `{"part1": X, "part2": Y}` where X and Y are integers
- Part 1 result remains unchanged from existing implementation
- Part 2 result is the count of unique ingredient IDs across all ranges

**Handle large 64-bit integer values**
- Use i64 (Rust), Int (Gleam), i64 (Carbon), Int (Bosque) for ingredient ID storage
- Real input contains very large numbers like 20362219004570-27230899748695
- Sample input has smaller numbers but solution must handle both

**Reuse existing parsing and range logic**
- Keep existing parse_range function that validates START <= END
- Reuse input splitting logic that separates ranges from available IDs
- Maintain existing error handling patterns for invalid input
- Do not modify Part 1 calculation logic

**Pass integration tests**
- Sample input must produce: `{"part1": 3, "part2": 14}`
- Real input validation: `./scripts/test_integration.sh 5 --timeout 300`
- All 4 languages must produce identical results for cross-language validation
- Integration test framework expects JSON output on stdout

**Rust implementation approach**
- Use HashSet<i64> to collect unique IDs from all ranges
- Iterate through each range and insert all IDs from start to end (inclusive)
- Import std::collections::HashSet at top of file
- Return (part1, part2) tuple from solve function
- Update JSON output in main to print part2 value instead of "null"

**Gleam implementation approach**
- Parse input from stdin (NOT from file path)
- Create set/dict structure to track unique IDs across ranges
- Use gleam/set module for set operations
- Return Result type containing both part1 and part2 values
- Output JSON format to stdout matching other languages

**Carbon implementation approach**
- Use global arrays to track unique ingredient IDs (no dynamic allocation)
- Create boolean array indexed by ingredient ID or use sorted array approach
- Iterate through ranges and mark/collect unique IDs
- Update JSON output section to print part2 value
- Maintain existing I/O utilities pattern (ReadChar, ReadInt64, etc)

**Bosque implementation approach**
- Update solution.bsq with Part 2 algorithm using set operations
- Python runner.py mirrors the Bosque algorithm for execution
- Runner reads from stdin and outputs JSON format
- Algorithm in solution.bsq is the canonical implementation
- Python wrapper exists only for I/O due to Bosque limitations

## Visual Design
No visual assets provided - this is an algorithmic problem.

## Existing Code to Leverage

**Rust Part 1 implementation (solutions/rust/day05/src/main.rs)**
- Reuse parse_range function that validates and parses "START-END" format
- Reuse input splitting logic that separates two sections by blank line
- Keep existing is_fresh function for Part 1 logic
- Use existing error handling with Result<(i64, String), String> pattern
- Modify solve return type from (i64, String) to (i64, i64) for both parts
- JSON output in main already structured for both parts, just update part2 value

**Gleam Part 1 stub (solutions/gleam/day05/src/day05.gleam)**
- Currently reads from file path, needs to be changed to stdin
- Part 1 and Part 2 functions return "0" - need full implementation
- Should follow Rust pattern: parse ranges, parse IDs, calculate both parts
- Use gleam/set or gleam/dict for unique ID tracking

**Carbon Part 1 implementation (solutions/carbon/day05/day05_simple.carbon)**
- Reuse ReadRanges function that parses ranges into global arrays
- Reuse ReadInt64 and character I/O utilities
- Global storage pattern: range_starts, range_ends, num_ranges
- JSON output already prints both part1 and part2, update part2 calculation
- For Part 2, iterate through ranges and collect unique IDs

**Bosque Part 1 implementation (solutions/bosque/day05/solution.bsq)**
- Algorithm documented in solution.bsq with parseRange, isFresh, solve functions
- Python runner.py and test_runner.py handle execution and testing
- Extend solve function return type to include part2: Int
- Python runner mirrors the Bosque algorithm structure for I/O

**Language-specific patterns from documentation**
- Rust: HashSet for unique collection, strong error handling with Result types
- Gleam: Functional patterns with immutable data, use pipe operator for clarity
- Carbon: Global arrays for storage, character-by-character I/O, no dynamic allocation
- Bosque: Python wrappers for I/O only, real algorithm in .bsq file

## Out of Scope
- Performance optimizations beyond basic set operations
- Interval merging algorithms or range compression
- Visualization of ranges or ingredient IDs
- Additional metrics or statistics beyond the count
- Creating new test files or modifying test framework
- Benchmarking or performance comparison between languages
- Analysis of implementation approaches across languages
- Documentation or README updates beyond code comments
- Using Python or any language other than the 4 target languages
- Modifying integration test framework or expected output files
