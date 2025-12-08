# Specification: Day 5 Part 1 Multi-Language AOC Solution

## Goal
Implement Day 5 Part 1 solution across all 4 languages (Rust, Gleam, Carbon, Bosque) to count how many available ingredient IDs fall within fresh ingredient ID ranges, following the established patterns from Days 1-4.

## User Stories
- As a developer, I want to parse ingredient database files with two groups (ranges and IDs) so that I can determine ingredient freshness
- As a tester, I want unit tests for parsing and range checking logic so that I can verify correctness before full integration

## Specific Requirements

**Input Parsing from stdin**
- Read complete input from stdin until EOF
- Split input into two groups separated by a blank line
- Group 1: Fresh ingredient ID ranges in format "start-end" (e.g., "3-5" or "20362219004570-27230899748695")
- Group 2: Available ingredient IDs as single numbers, one per line
- Handle large 64-bit integers for IDs (ranges can be in the billions)
- Trim whitespace from lines and skip empty lines within groups
- Use same stdin reading pattern as established in day01 implementations

**Range Parsing Logic**
- Parse range format "start-end" by splitting on hyphen character
- Extract start and end values as 64-bit integers (i64 or equivalent)
- Validate that start <= end for each range
- Ranges are inclusive (both start and end are included)
- Store ranges in a simple list/vector structure for iteration
- Create dedicated range parsing function with unit tests

**ID Freshness Checking**
- For each available ingredient ID, check if it falls within ANY fresh range
- An ID is fresh if: range_start <= id <= range_end for at least one range
- Use simple nested loop approach: iterate through all ranges for each ID
- Do not optimize with range merging or sorting (keep maintainable for Part 2)
- Create dedicated range checking function (e.g., is_in_range, is_fresh) with unit tests

**Counting Fresh Ingredients**
- Count how many available ingredient IDs are fresh (return count)
- Track count as integer accumulator during iteration
- Return final count as part1 result

**JSON Output to stdout**
- Output exactly: `{"part1": <count>, "part2": null}` where count is integer
- Use same JSON formatting pattern from day01 implementations
- Output to stdout only (no extra debug information)
- Output on single line with no trailing newline beyond what println/print adds

**Error Handling**
- Output `{"part1": null, "part2": null}` if parsing fails or input invalid
- Log specific error messages to stderr (not stdout)
- Exit with non-zero code on failure (1 or higher)
- Handle edge cases: empty input, malformed ranges, non-numeric values

**Unit Testing for All Languages**
- Test range parsing: "3-5" should parse to start=3, end=5
- Test ID parsing: "17" should parse to id=17
- Test range checking: ID 5 is in range 3-5, ID 8 is not in range 3-5
- Test overlapping ranges: ID 17 is fresh if in range 16-20 OR 12-18
- Test sample input: Expected output `{"part1": 3, "part2": null}`
- Test edge cases: IDs at range boundaries, IDs outside all ranges
- Follow language-specific test patterns from day01

**Sample Integration Testing**
- Run each language implementation with sample input file
- Sample input: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day05/input-sample.txt`
- Expected output: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day05/input-sample-expected-output.txt`
- Create shell script (e.g., `test_day05_sample.sh`) following patterns from other days
- Verify JSON output matches expected byte-for-byte

**Full Integration with Test Framework**
- Solutions must work with existing runner scripts: `scripts/runners/run_{language}.sh`
- Must be discoverable by `scripts/test_execution.sh` parallel test framework
- Accept day number and input path as arguments to runners
- Must execute within 60 second timeout (default framework timeout)
- Follow directory structure: `solutions/{language}/day05/`

**Language-Specific Implementation Details**
- Rust: Main in `src/main.rs`, unit tests in `#[cfg(test)]` modules, use i64 for integers
- Gleam: Main in `src/day05.gleam`, tests in `test/day05_test.gleam`, use Int type, read from file path passed as argument
- Carbon: Implementation in `day05_simple.carbon`, Python wrapper `runner.py`, Python unit tests in `test_carbon_day05.py`
- Bosque: Implementation in `solution.bsq`, Python wrapper `runner.py` with algorithm logic mirroring Bosque code

## Visual Design
No visual assets provided.

## Existing Code to Leverage

**Day 01 Rust Implementation (`solutions/rust/day01/src/main.rs`)**
- Stdin reading pattern: `io::stdin().read_to_string(&mut input)`
- JSON output format: `println!("{{\"part1\": {}, \"part2\": {}}}", part1, part2)`
- Unit test structure with `#[cfg(test)]` module
- Parse-process-output pattern with dedicated `solve()` function
- Error handling with `expect()` on stdin read

**Day 01 Gleam Implementation (`solutions/gleam/day01/src/day01.gleam`)**
- File reading with `simplifile.read(path)` using path argument
- Result type handling with `case` expressions for Ok/Error
- JSON building function: `build_json(part1: Int, part2: result) -> String`
- Tuple unpacking for parsing results: `#(direction, distance)`
- Unit test structure following Gleam test conventions

**Day 01 Carbon Runner (`solutions/carbon/day01/runner.py`)**
- Python wrapper reading stdin with `sys.stdin.read()`
- Algorithm implementation in Python mirroring Carbon logic
- JSON output with `json.dumps({"part1": result, "part2": result})`
- Error handling with try/except and stderr logging
- Exit code 1 on errors

**Day 01 Bosque Runner (`solutions/bosque/day01/runner.py`)**
- Python wrapper with algorithm logic mirroring Bosque implementation
- Dedicated parsing functions (e.g., `parse_is_left`, `parse_distance`)
- Main solve function returning tuple `(part1_answer, part2_answer)`
- JSON output format matching other languages
- Comment headers documenting which Bosque functions are mirrored

**Carbon Unit Test Pattern (`solutions/carbon/day01/test_carbon_day01.py`)**
- Python unittest importing functions from runner module
- Clear test naming: `test_parse_left_rotation`, `test_sample_input`
- Print statements for test pass confirmation
- `run_all_tests()` function executing all tests with pass/fail tracking
- Return boolean success and exit with code 0 or 1

**Test Execution Framework (`scripts/test_execution.sh`)**
- Parallel test execution for all 4 languages
- Timeout handling (default 60 seconds)
- Process output capture in temporary directory
- Exit code tracking for each language
- Integration with language-specific runners via `run_language_test()` function

**Language Runner Scripts (`scripts/runners/run_{language}.sh`)**
- Accept day number and input path as arguments
- Execute language-specific solution with input
- Return exit code 0 on success, non-zero on failure
- Capture stdout for JSON output parsing

## Out of Scope
- Part 2 implementation (will be separate spec after Part 1 completion)
- Analysis document creation (separate spec as mentioned in requirements)
- Range merging or consolidation optimization
- Binary search or sorted range optimization
- Performance benchmarking or profiling
- Visual debugging output or progress indicators
- Modification of existing test framework or runner scripts
- Database storage of results
- Web interface or API endpoints
- Multi-threaded or parallel processing of IDs
