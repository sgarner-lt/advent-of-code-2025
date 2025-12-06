# Specification: Day 3 Part 2 - Maximum 12-Digit Number Extraction

## Goal
Extend Day 3 Part 1 implementations to solve Part 2: extract the maximum possible 12-digit number from each line of digit sequences using a greedy algorithm, and output both Part 1 and Part 2 results in JSON format.

## User Stories
- As a puzzle solver, I want to find the maximum 12-digit joltage output from each battery bank so that I can power the escalator
- As a developer, I want all 4 language implementations to produce identical answers so that I can validate cross-language correctness

## Specific Requirements

**Greedy Algorithm Implementation**
- For each position i (0-11) in the 12-digit result, search from current sequence position up to sequence_length minus remaining_digits_needed
- Select the maximum digit found in this search window
- Update current position to immediately after the selected digit
- Repeat until all 12 positions are filled
- This greedy approach guarantees the lexicographically largest 12-digit number, which equals the maximum numeric value

**Integer Overflow Handling**
- 12-digit numbers exceed 32-bit integer capacity (max ~2.1 billion vs ~987 billion)
- Use 64-bit integers (i64/Int64/Long) in all languages for Part 2 calculations
- Part 1 results can remain 32-bit as 2-digit sums won't overflow
- Final sum of all 12-digit numbers must use 64-bit arithmetic

**Extend Existing Part 1 Code**
- Modify main() to call solve() function that returns tuple of (part1_result, part2_result)
- Reuse existing file I/O, input parsing, and line iteration logic from Part 1
- Add new function extract_max_k_digits(line, k) where k=12 for Part 2
- Keep Part 1 logic (k=2) intact and unchanged

**JSON Output Format**
- Change output from {"part1": X, "part2": null} to {"part1": X, "part2": Y}
- Part 1 value remains integer from existing implementation
- Part 2 value is 64-bit integer sum of maximum 12-digit numbers
- Output format must match: {"part1": 357, "part2": 3121910778619} for sample input

**Cross-Language Implementation**
- Implement in Rust at solutions/rust/day03/src/main.rs
- Implement in Gleam at solutions/gleam/src/day03.gleam
- Implement in Roc (find existing structure and follow it)
- Implement in Bosque (find existing structure and follow it)
- All implementations must read from stdin and output to stdout
- All implementations must produce byte-for-byte identical JSON output

**Sample Input Validation**
- Line 1: "987654321111111" yields 987654321111 (remove three 1s from end)
- Line 2: "811111111111119" yields 811111111119 (remove three 1s from middle)
- Line 3: "234234234234278" yields 434234234278 (remove 2, 3, 2 from start)
- Line 4: "818181911112111" yields 888911112111 (remove some 1s from start)
- Expected sum: 3121910778619

**Testing Strategy**
- Add unit tests for extract_max_k_digits with k=12
- Add unit tests verifying greedy algorithm correctness on sample lines
- Extend existing solve() integration test to verify both part1 and part2
- Use test_integration.sh script to validate all 4 languages agree
- Verify sample input produces {"part1": 357, "part2": 3121910778619}

**Helper Function Signature**
- Rust: fn extract_max_k_digits(line: &str, k: usize) -> Option<i64>
- Gleam: pub fn extract_max_k_digits(line: String, k: Int) -> Result(Int, String)
- Each position iteration finds max digit in valid window, advances current position
- Return parsed 12-digit number as 64-bit integer

**Edge Cases to Handle**
- Lines with exactly 12 digits (no removal needed, return entire line)
- Lines with fewer than 12 digits (invalid input, skip or return None/Error)
- All digits are identical (return first 12 digits)
- Empty lines or whitespace-only lines (skip, consistent with Part 1)

**Performance Characteristics**
- O(n*k) time complexity where n=sequence length, k=12 (essentially O(n) since k is constant)
- For n=100 digit input: maximum ~1200 comparisons per line
- No dynamic programming or memoization needed for this greedy approach
- Each line processes independently, no state carried between lines

## Visual Design
No visual assets provided.

## Existing Code to Leverage

**Day 3 Part 1 Rust Implementation (solutions/rust/day03/src/main.rs)**
- File I/O pattern: read from stdin using io::stdin().read_to_string()
- Line iteration and trimming logic
- JSON output formatting with println! macro
- Test structure with #[cfg(test)] mod tests
- extract_pairs() and find_max() patterns can inform extract_max_k_digits() design

**Day 3 Part 1 Gleam Implementation (solutions/gleam/src/day03.gleam)**
- simplifile.read("/dev/stdin") for reading stdin as file
- Line filtering with list.filter and string.trim
- Recursive helpers for pair extraction (model for k-digit extraction)
- build_json() function to format output string
- Can extend to build_json_with_part2() accepting both values

**Day 1 and Day 2 Dual-Output Pattern**
- Day 1 Rust shows (part1_result, part2_result) tuple return from solve()
- Day 2 Rust shows Option<i64> for part2 when not implemented yet
- Both show JSON formatting with part1 and part2 keys in output
- Count tracking patterns (Day 1's zero crossing, Day 2's invalid ID sum) inform sum accumulation logic

**Cross-Language Test Integration (scripts/test_integration.sh)**
- Expects executable to read from stdin via input file redirection
- Parses JSON output with "part1" and "part2" keys
- Validates all languages produce identical answers
- Run with ./scripts/test_integration.sh 3 for Day 3

**Existing solve() Functions**
- Day 1: processes line-by-line with stateful position tracking
- Day 2: uses list.try_map for functional line processing
- Day 3 Part 1: iterates lines, extracts pairs, finds max, sums results
- Pattern to follow: map each line to (part1_contribution, part2_contribution), then sum both

## Out of Scope
- Dynamic programming or brute force approaches for Part 2 (only greedy algorithm)
- Modifications to Part 1 logic or breaking existing Part 1 functionality
- Detailed analysis documentation (separate Day 3 Analysis phase)
- Performance benchmarking beyond basic validation
- UI or visualization of digit selection process
- Alternative output formats besides JSON
- Support for input files other than standard input via stdin
- Rearranging digits (must maintain original sequence order)
- Selecting non-consecutive positions then reordering them (greedy processes left-to-right)
- Handling Part 2 independently from Part 1 (must be same executable)
