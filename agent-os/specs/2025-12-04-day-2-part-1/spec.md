# Specification: Day 2 Part 1 - Invalid Product ID Detection

## Goal
Identify and sum all invalid product IDs within given ranges, where an invalid ID contains any substring pattern repeated consecutively (e.g., 11, 1212, 123123).

## User Stories
- As a gift shop clerk, I want to identify invalid product IDs so that I can clean up the corrupted database
- As a developer, I want to implement the pattern detection algorithm across multiple languages so that I can validate correctness through cross-language testing

## Specific Requirements

**Input Parsing**
- Read single-line input from challenges/day02/input.txt containing comma-separated ranges
- Parse ranges in format "start-end" where both are integers (e.g., "11-22,95-115")
- Handle ranges with large numbers (up to 10+ digits) and large counts (200k+ numbers per range)
- Trim whitespace and handle empty input gracefully

**Range Processing**
- For each range, generate all integers from start to end inclusive
- Convert each integer to string for pattern detection
- Process ranges sequentially to avoid memory overflow with large ranges
- No leading zeros in product IDs (0101 is not valid, but 101 is)

**Pattern Detection Algorithm**
- Check if a number string contains ANY consecutively repeated substring pattern
- Iterate through substring lengths L from 1 to floor(string_length / 2)
- For each length L, slide through string checking if any L-length substring appears twice consecutively
- Return true (invalid) immediately upon finding first repeated pattern
- Return false (valid) only if no patterns found at any length

**Invalid ID Accumulation**
- Sum all invalid product IDs found across all ranges
- Use appropriate integer types to handle large sums (expected result: 1227775554 for example input)
- Output final sum as single integer to stdout

**Multi-Language Implementation**
- Implement identical logic in Rust, Gleam, Carbon, and Bosque
- Follow project structure: solutions/{language}/day02/
- Read from shared input file at challenges/day02/input.txt
- All languages must produce identical output for validation

**Testing Strategy**
- Unit tests for individual pattern detection cases (11, 12, 1212, 123456, etc.)
- Unit tests for range parsing and generation
- Integration test using full input file to verify expected sum
- Cross-language validation to ensure all implementations agree

**Output Format**
- Print single integer sum to stdout
- Optional: JSON format {"part1": sum, "part2": null} for testing framework compatibility
- No additional debug output in final solution

**Performance Requirements**
- Target execution time: under 15 seconds per language
- Optimize for correctness first, then profile if too slow
- Consider early termination in pattern detection once match found

## Visual Design
No visual assets provided for this algorithmic challenge.

## Existing Code to Leverage

**Day 1 Rust Implementation (solutions/rust/day01/src/main.rs)**
- stdin reading pattern: use io::stdin().read_to_string(&mut input)
- Line-by-line parsing with .lines() iterator
- Parse strings to integers with .parse::<i32>().ok()
- Unit test structure with #[test] and assert_eq! macros
- solve() function pattern that returns tuple for part1/part2

**Day 1 Gleam Implementation (solutions/gleam/day01/src/day01.gleam)**
- File reading with simplifile.read(path) returning Result type
- String splitting with string.split("\n") for line parsing
- Integer parsing with int.parse() returning Result
- Pattern matching on Result types for error handling
- JSON output building with string concatenation

**Rust String Slicing Pattern**
- Use &str[start..end] for extracting substrings
- Use .chars().next() for first character access
- String length via .len() method

**Gleam String Operations**
- Use string.slice(str, start, length) for substring extraction
- Use string.length() to get string length
- Pattern matching on string prefixes for validation

**Common Testing Patterns**
- Create unit tests for edge cases: single digits, repeated digits, no repetition
- Test range boundaries and wraparound conditions
- Integration test with full input file as final validation
- Use descriptive test names that explain what is being tested

## Out of Scope
- Day 2 Part 2 implementation (separate spec after Part 1 completion)
- Performance optimization beyond 15-second target
- Parallel processing of ranges
- Caching or memoization of pattern detection results
- Leading zero handling (problem states no leading zeros exist)
- UI or visualization of invalid IDs
- Detailed performance benchmarking or profiling
- Language comparison analysis or performance metrics
- Alternative algorithm implementations or optimizations
- Database storage of results
