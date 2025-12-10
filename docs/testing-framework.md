# Testing Framework Documentation

## Overview

The Advent of Code 2025 testing framework provides cross-language validation for solutions written in Rust, Roc, Gleam, Carbon, and Bosque. It enables parallel test execution, standardized JSON output, and automated answer comparison across all language implementations.

## Quick Start

### Run Integration Tests

Test all languages for a specific day:

```bash
./scripts/test_integration.sh 1
```

### Run Unit Tests (TDD Workflow)

Run only unit tests without cross-language validation:

```bash
./scripts/test_unit.sh 1
```

### View Results

After running integration tests, view the markdown report:

```bash
cat test_results.md
```

## JSON Output Contract

All language implementations must output their solutions in a standardized JSON format to stdout. This contract ensures consistent parsing and cross-language validation.

### Required Format

```json
{"part1": <value>, "part2": <value>}
```

### Supported Value Types

- **Integers**: For numeric answers (e.g., `123`, `456`)
- **Strings**: For text-based answers (e.g., `"abc123"`, `"ANSWER"`)
- **null**: For parts not yet implemented

### Contract Rules

1. JSON must be a valid object (dictionary) with exactly two keys: `part1` and `part2`
2. Both keys must be present even if not yet implemented (use `null` for unimplemented parts)
3. Values can be integers, strings, or `null` - no other types allowed
4. No additional metadata fields are required (no timing, language version, etc.)
5. Output must be valid JSON (properly escaped strings, correct syntax)
6. Output must go to **stdout** (not stderr)

### Valid Examples

Integer answers:
```json
{"part1": 12345, "part2": 67890}
```

String answers:
```json
{"part1": "ANSWER", "part2": "RESULT"}
```

Mixed types:
```json
{"part1": 999, "part2": "mixed"}
```

Partial implementation (part2 not done):
```json
{"part1": 42, "part2": null}
```

Both parts not implemented:
```json
{"part1": null, "part2": null}
```

### Invalid Examples

Missing keys:
```json
{"part1": 123}  // ERROR: Missing part2
```

Wrong value type:
```json
{"part1": [1, 2, 3], "part2": 456}  // ERROR: part1 must be int, string, or null
```

Additional metadata:
```json
{"part1": 123, "part2": 456, "time": "50ms"}  // ERROR: Extra fields not allowed
```

Malformed JSON:
```json
{part1: 123, part2: 456}  // ERROR: Keys must be quoted
```

## Language-Specific Implementation Examples

### Rust

Use `serde_json` for JSON serialization:

```rust
use serde::{Serialize, Deserialize};
use serde_json;

#[derive(Serialize, Deserialize)]
struct Answer {
    part1: Option<i64>,
    part2: Option<i64>,
}

fn main() {
    let answer = Answer {
        part1: Some(12345),
        part2: Some(67890),
    };

    let json = serde_json::to_string(&answer).unwrap();
    println!("{}", json);
}
```

For string answers:
```rust
#[derive(Serialize, Deserialize)]
struct Answer {
    part1: Option<String>,
    part2: Option<String>,
}
```

### Gleam

Use the `gleam/json` library for encoding:

```gleam
import gleam/json
import gleam/io
import gleam/option.{Some, None}

pub type Answer {
  Answer(part1: option.Option(Int), part2: option.Option(Int))
}

pub fn main() {
  let answer = Answer(Some(12345), Some(67890))

  let json_value = json.object([
    #("part1", json.int(option.unwrap(answer.part1, 0))),
    #("part2", json.int(option.unwrap(answer.part2, 0))),
  ])

  io.println(json.to_string(json_value))
}
```

For null values:
```gleam
let json_value = json.object([
  #("part1", json.null()),
  #("part2", json.int(67890)),
])
```

### Roc

Use the `Str` module for JSON string formatting:

```roc
app "advent-solution"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.8.1/x8URkvfyi9I0QhmVG98roKBUs_AZRkLFwFJVJ3942YA.tar.br" }
    imports [pf.Stdout]
    provides [main] to pf

main =
    part1 = Num.toStr 12345
    part2 = Num.toStr 67890
    json = "{\"part1\": \(part1), \"part2\": \(part2)}"
    Stdout.line json
```

For null values:
```roc
json = "{\"part1\": null, \"part2\": 67890}"
```

For string answers, ensure proper escaping:
```roc
part1Str = "\"ANSWER\""  # Quote the string value
json = "{\"part1\": \(part1Str), \"part2\": null}"
```

### Carbon (Experimental)

Carbon is an experimental language with limited standard library support. Solutions run inside a Docker/Podman container that includes the Carbon toolchain and Bazel build system. Output JSON character-by-character using the Core library:

```carbon
import Core library "io";

fn PrintIntNoNewline(n_val: i32) {
  var n: i32 = n_val;
  if (n < 0) {
    Core.PrintChar('-');
    n = -n;
  }
  var pow10: i32 = 1;
  while (n / 10 >= pow10) {
    pow10 = pow10 * 10;
  }
  while (pow10 != 0) {
    let d: i32 = n / pow10;
    Core.PrintChar(((d + 0x30) as u8) as char);
    n = n % pow10;
    pow10 = pow10 / 10;
  }
}

fn Run() {
  var part1: i32 = 12345;
  var part2: i32 = 67890;

  // Print JSON character-by-character
  Core.PrintChar('{');
  Core.PrintChar('"');
  Core.PrintChar('p');
  Core.PrintChar('a');
  Core.PrintChar('r');
  Core.PrintChar('t');
  Core.PrintChar('1');
  Core.PrintChar('"');
  Core.PrintChar(':');
  Core.PrintChar(' ');
  PrintIntNoNewline(part1);
  Core.PrintChar(',');
  Core.PrintChar(' ');
  Core.PrintChar('"');
  Core.PrintChar('p');
  Core.PrintChar('a');
  Core.PrintChar('r');
  Core.PrintChar('t');
  Core.PrintChar('2');
  Core.PrintChar('"');
  Core.PrintChar(':');
  Core.PrintChar(' ');
  PrintIntNoNewline(part2);
  Core.PrintChar('}');
  Core.PrintChar('\n');
}
```

**Note:** Carbon has no string type or format functions. All output must be character-by-character using hex codes (e.g., `0x30` for '0', `0x7B` for '{'}). The `Run()` function is the entry point. For null values, you would print the literal text "null" character-by-character instead of calling `PrintIntNoNewline`.

**Container Execution:** Carbon solutions are compiled with Bazel inside a container and executed automatically by the `run_carbon.sh` script. **Carbon requires a 300-second timeout** because Bazel compilation in the container takes longer than other languages. See [docs/languages/carbon.md](languages/carbon.md) for details on the containerized build process.

### Bosque

Use string construction for JSON output:

```bosque
namespace Advent;

entrypoint function main(): Int {
    let part1 = 12345i;
    let part2 = 67890i;

    let json = String::format("{\"part1\": {0}, \"part2\": {1}}", part1, part2);
    _println(json);

    return 0i;
}
```

For null values:
```bosque
let json = String::format("{\"part1\": null, \"part2\": {0}}", part2);
```

## Command-Line Interface

### Integration Test Script

The main integration test script runs all languages in parallel and performs cross-language validation.

#### Usage

```bash
./scripts/test_integration.sh <day_number> [options]
```

#### Options

- `--verbose` or `-v`: Show detailed output from all commands
- `--timeout N`: Set custom timeout in seconds (default: 60)
- `--sample`: Use sample input instead of real input
- `--help` or `-h`: Show help message

#### Exit Codes

- `0`: All tests passed and all languages agree
- `1`: One or more tests failed or answers diverge

### Unit Test Script

The unit test script runs language-specific unit tests without cross-language validation. Use this for TDD workflow.

#### Usage

```bash
./scripts/test_unit.sh <day_number> [options]
```

#### Options

- `--verbose` or `-v`: Show detailed output from test commands
- `--help` or `-h`: Show help message

#### Exit Codes

- `0`: All unit tests passed
- `1`: One or more unit tests failed

## Usage Examples

### Example 1: Test Day 1 with Sample Input

Run integration tests using the sample input file:

```bash
./scripts/test_integration.sh 1 --sample
```

This will:
1. Look for `challenges/day01/input-sample.txt`
2. Run all 5 languages in parallel with the sample input
3. Compare answers across languages
4. Generate `test_results.md` with results

Expected output:
```
[INFO] Advent of Code Integration Test Runner
[INFO] Day: 1
[INFO] Using input file: /path/to/challenges/day01/input-sample.txt
[SUCCESS] rust test completed successfully
[SUCCESS] gleam test completed successfully
...
[SUCCESS] All tests passed and all languages agree!
```

### Example 2: Test Day 5 with Real Input and Verbose Output

Run integration tests with detailed logging:

```bash
./scripts/test_integration.sh 5 --verbose
```

This will:
1. Use `challenges/day05/input.txt` (real puzzle input)
2. Show all command execution details
3. Display stdout/stderr from each language
4. Show JSON parsing and validation steps

Verbose output includes:
- Language runner commands being executed
- JSON output from each language
- Validation comparison details
- Detailed error messages if any failures occur

### Example 3: Run Only Unit Tests for Day 3

For TDD workflow, run unit tests without integration:

```bash
./scripts/test_unit.sh 3
```

This will:
1. Run `cargo test` for Rust
2. Run `gleam test` for Gleam
3. Run `roc test` for Roc
4. Run unit tests for Carbon and Bosque
5. Report pass/fail per language
6. Skip cross-language validation

Use this command during development to quickly iterate:
```bash
# Write some code
vim solutions/rust/day03/src/lib.rs

# Test it
./scripts/test_unit.sh 3

# Repeat
```

### Example 4: Test with Custom Timeout of 120 Seconds

For slower solutions, increase the timeout:

```bash
./scripts/test_integration.sh 10 --timeout 120
```

This will:
1. Set timeout to 120 seconds per language
2. Kill any process that exceeds the timeout
3. Report timeout as a test failure

Default timeout is 60 seconds. Use custom timeouts for:
- Complex algorithms that take longer to run
- Large input files
- Debug builds (without optimizations)
- **Carbon solutions: Always use 300 seconds** due to Bazel compilation in container

### Example 5: Verbose Testing with Sample Input

Combine multiple flags:

```bash
./scripts/test_integration.sh 7 --sample --verbose --timeout 30
```

This combines:
- Sample input (`--sample`)
- Detailed output (`--verbose`)
- Custom timeout (`--timeout 30`)

## Markdown Report

After each integration test run, a markdown report is generated at `test_results.md` in the project root.

### Report Sections

1. **Test Run Information**
   - Timestamp
   - Day number tested

2. **Language Results**
   - Per-language section with pass/fail status
   - JSON output from each language
   - Part 1 and Part 2 answers
   - Error messages for failed languages

3. **Cross-Language Validation**
   - Part 1 Analysis: Agreement or divergence
   - Part 2 Analysis: Agreement or divergence
   - Lists of agreeing languages
   - Lists of divergent answers with values

4. **Failed Languages**
   - Languages that failed to run
   - Error messages explaining failures

### Example Report

```markdown
# Test Results for Day 01

**Test Run:** 2025-12-03 14:30:00

---

## Language Results

### Rust

**Status:** PASS

**JSON Output:**
```json
{"part1": 12345, "part2": 67890}
```

- **Part 1:** 12345
- **Part 2:** 67890

### Gleam

**Status:** PASS

**JSON Output:**
```json
{"part1": 12345, "part2": 67890}
```

- **Part 1:** 12345
- **Part 2:** 67890

---

## Cross-Language Validation

### Part 1 Analysis

**All languages agree on Part 1!**

- **Common Answer:** 12345
- **Agreeing Languages:** rust, gleam, roc

### Part 2 Analysis

**Divergent answers detected for Part 2:**

- **rust:** 67890
- **gleam:** 99999

---

*Generated by Advent of Code 2025 Testing Framework*
```

## JSON Utility Functions

The testing framework provides several utility functions for working with JSON output. These are located in `scripts/json_utils.sh`:

### parse_json_answer

Extract a specific part's answer from JSON output.

```bash
source scripts/json_utils.sh

json='{"part1": 123, "part2": 456}'
part1_answer=$(parse_json_answer "$json" "part1")
echo "$part1_answer"  # Outputs: 123
```

### validate_json_format

Check if JSON matches the required contract.

```bash
json='{"part1": 123, "part2": 456}'
if validate_json_format "$json"; then
    echo "Valid format"
else
    echo "Invalid format"
fi
```

### is_json_malformed

Detect malformed or invalid JSON syntax.

```bash
json='{"part1": INVALID}'
if is_json_malformed "$json"; then
    echo "JSON is malformed"
fi
```

### extract_both_parts

Get both part1 and part2 values in one call.

```bash
json='{"part1": 111, "part2": 222}'
result=$(extract_both_parts "$json")
echo "$result"  # Outputs: 111 222
```

## Testing

To test the JSON utilities:

```bash
./scripts/test_json_utils.sh
```

This runs 8 focused test groups covering:
1. Parsing valid JSON with integers
2. Parsing JSON with null values
3. Parsing JSON with string values
4. Handling malformed JSON
5. Handling missing keys
6. Validating correct JSON format
7. Detecting empty and invalid input
8. Extracting both parts simultaneously

All tests must pass before the JSON utilities can be used in the integration testing framework.

## Error Handling

The JSON utilities provide clear error messages for common issues:

- **Malformed JSON**: "Failed to parse JSON or missing key 'partN'"
- **Missing keys**: "Missing required key: part1" or "Missing required key: part2"
- **Invalid types**: "Invalid type for partN: <type_name>"
- **Empty input**: Functions return error codes and log descriptive messages

All errors are logged using the standard logging utilities from `scripts/common.sh`.

## File Structure

The testing framework follows this structure:

```
scripts/
  common.sh                  # Reusable logging and utility functions
  json_utils.sh              # JSON parsing and validation
  test_execution.sh          # Parallel test execution engine
  test_discovery.sh          # Test input file discovery
  validate_answers.sh        # Cross-language answer validation
  generate_report.sh         # Markdown report generation
  test_integration.sh        # Main integration test script
  test_unit.sh              # Unit test script
  runners/
    run_rust.sh             # Rust test runner
    run_gleam.sh            # Gleam test runner
    run_roc.sh              # Roc test runner
    run_carbon.sh           # Carbon test runner
    run_bosque.sh           # Bosque test runner

challenges/
  dayXX/
    input.txt               # Real puzzle input
    input-sample.txt        # Sample puzzle input
    problem-statement.txt   # Optional reference

<language>/
  dayXX/
    # Language-specific implementation structure

docs/
  testing-framework.md      # This documentation

test_results.md            # Generated report (in project root)
```

## Test Data Conventions

### Input Files Location

All input files for a given day are placed in the `challenges/dayXX/` directory where `XX` is the zero-padded day number (01-25).

### File Types

⚠️ **CRITICAL: All files in `challenges/` are READ-ONLY. Never modify them!**

1. **Real Puzzle Input**: `input.txt` (READ-ONLY)
   - This is the actual input from Advent of Code for your account
   - Download from adventofcode.com after starting the puzzle
   - Used by default when running integration tests
   - **Cannot be recovered if lost or overwritten**

2. **Sample Puzzle Input**: `input-sample.txt` (READ-ONLY)
   - The example input provided in the problem statement
   - Typically smaller and easier to debug
   - Used when running with `--sample` flag
   - Used for validation against expected outputs

3. **Expected Sample Output**: `input-sample-expected-output.txt` (READ-ONLY)
   - Contains the expected JSON output for sample input
   - Format: `{"part1": <value>, "part2": <value>}`
   - Used by verification processes to validate implementations
   - Values come from the problem statement

4. **Problem Statement**: `problem-statement.txt` (optional, READ-ONLY)
   - Reference copy of the puzzle description
   - Not used by the testing framework
   - Helpful for offline reference

### File Protection

**Why files are READ-ONLY:**
- `input.txt` is your personal puzzle input and cannot be recovered if lost
- Sample files are reference data for validation
- Expected output files are used for automated verification
- Any modification breaks the testing framework

For complete file handling guidelines, see: `agent-os/profiles/advent-of-code-2025/standards/aoc-file-handling.md`

### Directory Structure Example

```
challenges/
  day01/
    input.txt                        # Your real puzzle input (READ-ONLY)
    input-sample.txt                 # Example from problem statement (READ-ONLY)
    input-sample-expected-output.txt # Expected output for validation (READ-ONLY)
    problem-statement.txt            # Optional reference (READ-ONLY)
  day02/
    input.txt                        # (READ-ONLY)
    input-sample.txt                 # (READ-ONLY)
    input-sample-expected-output.txt # (READ-ONLY)
  ...
```

## TDD Workflow

The testing framework supports Test-Driven Development:

1. **Write Unit Tests**
   - Add tests to your language-specific test file
   - Example: `solutions/rust/day01/src/lib.rs` with `#[cfg(test)]` module

2. **Run Unit Tests**
   ```bash
   ./scripts/test_unit.sh 1
   ```

3. **Implement Solution**
   - Write code to make tests pass
   - Iterate quickly with unit tests

4. **Run Integration Tests**
   ```bash
   ./scripts/test_integration.sh 1
   ```

5. **Verify Cross-Language Agreement**
   - Check `test_results.md` for validation results
   - Fix any divergences

## Troubleshooting

### No Input Files Found

**Error:** `Failed to find real input file for day 1`

**Solution:** Create the input file:
```bash
mkdir -p challenges/day01
touch challenges/day01/input.txt
# Add puzzle input to the file
```

### Language Not Implemented

**Error:** `rust: Implementation not found at solutions/rust/day01, skipping`

**Solution:** Create the language directory structure:
```bash
mkdir -p solutions/rust/day01
cd solutions/rust/day01
cargo init --name day01
```

### Timeout Exceeded

**Error:** `Timeout exceeded for rust (PID: 12345) - killing process`

**Solution:** Increase timeout or optimize your solution:
```bash
./scripts/test_integration.sh 1 --timeout 120
```

### Malformed JSON Output

**Error:** `malformed JSON`

**Solution:** Check your solution's stdout:
```bash
./scripts/test_integration.sh 1 --verbose
```

Ensure output matches: `{"part1": <value>, "part2": <value>}`

### Compilation Failures

**Error:** `Rust execution failed with exit code: 1`

**Solution:** Check stderr in verbose mode:
```bash
./scripts/test_integration.sh 1 --verbose
```

Fix compilation errors in your code.

## Error Handling Documentation

The testing framework handles various error scenarios gracefully to ensure robust operation. This section documents how each type of error is detected, reported, and handled.

### Missing Implementations

**How Framework Handles:**
- Each language runner checks if the implementation directory exists before attempting to run
- If directory is missing (e.g., `solutions/rust/day01` doesn't exist), the runner reports "not implemented"
- Framework continues with remaining languages instead of failing fast
- Missing implementations are clearly marked in the markdown report

**What You'll See:**
```
[WARN] rust: Implementation not found at solutions/rust/day01, skipping
```

**Impact:**
- Test execution continues normally
- Other languages still run and are validated
- Markdown report shows "NOT IMPLEMENTED" status for that language
- Exit code remains 0 if other languages succeed

**When This Happens:**
- You haven't created the solution directory yet
- Solution directory is in wrong location
- Directory name doesn't match expected pattern (dayXX)

### Compilation Failures

**How Framework Handles:**
- Each runner executes the language's build/compile command
- Compilation errors are captured from stderr
- Non-zero exit code from compiler triggers failure status
- Stderr output is preserved and included in markdown report
- Framework continues with remaining languages

**What You'll See:**
```
[ERROR] rust: Compilation failed
[ERROR] Compiler output: error[E0425]: cannot find value `x` in this scope
```

**Impact:**
- Language marked as FAILED in report
- Compiler error messages included in report
- Other languages continue execution
- Integration test returns exit code 1

**When This Happens:**
- Syntax errors in your code
- Type errors or borrowing violations
- Missing dependencies in package manifest
- Incorrect language version or compiler flags

**How to Debug:**
```bash
# Run with verbose mode to see full compiler output
./scripts/test_integration.sh 1 --verbose

# Or compile directly to see errors
cd solutions/rust/day01
cargo build
```

### Runtime Crashes

**How Framework Handles:**
- Each language execution is run in a controlled subprocess
- Runtime crashes (segfaults, panics, exceptions) are caught
- Non-zero exit code triggers failure status
- Stderr output captured (may include stack trace)
- Framework kills orphaned processes and cleans up
- Execution continues with remaining languages

**What You'll See:**
```
[ERROR] gleam: Runtime error (exit code: 101)
[ERROR] thread 'main' panicked at 'index out of bounds: the len is 3 but the index is 5'
```

**Impact:**
- Language marked as FAILED with runtime error
- Stack trace or error message included if available
- Other languages continue normally
- Integration test returns exit code 1

**When This Happens:**
- Unhandled exceptions or panics
- Array index out of bounds
- Division by zero
- Null pointer dereference
- Resource exhaustion (out of memory)

**How to Debug:**
```bash
# Run with verbose mode to see full error output
./scripts/test_integration.sh 1 --verbose

# Or run the implementation directly
cd solutions/rust/day01
cargo run -- ../../../challenges/day01/input.txt
```

### Timeout Behavior

**How Framework Handles:**
- Each language gets maximum execution time (default 60 seconds)
- Framework tracks process PIDs during execution
- If timeout exceeded, process is killed with SIGTERM, then SIGKILL
- Timeout is reported as a specific failure type
- Framework ensures no zombie processes remain
- Cleanup happens before moving to next language

**What You'll See:**
```
[ERROR] roc: Timeout exceeded (60 seconds) - killing process
[WARN] Process 12345 killed due to timeout
```

**Impact:**
- Language marked as FAILED with timeout reason
- Process forcibly terminated
- Other languages continue with full timeout window
- Integration test returns exit code 1

**When This Happens:**
- Infinite loop in your solution
- Algorithm with exponential time complexity
- Extremely large input file
- Deadlock in concurrent code
- Waiting on blocked I/O

**How to Resolve:**
```bash
# Increase timeout for legitimately slow solutions
./scripts/test_integration.sh 1 --timeout 120

# Or optimize your algorithm
# - Check for infinite loops
# - Improve time complexity
# - Add early termination conditions
# - Profile your code to find bottlenecks
```

### Malformed JSON Recovery

**How Framework Handles:**
- After each language runs, stdout is parsed as JSON
- JSON parser attempts to extract `part1` and `part2` keys
- Invalid JSON syntax triggers malformed JSON error
- Framework logs the malformed output for debugging
- Validation layer treats it as a failure for that language
- Framework continues with remaining languages

**What You'll See:**
```
[ERROR] carbon: Malformed JSON output
[ERROR] Output was: {part1: 123, part2: 456}
[ERROR] JSON must use quoted keys: {"part1": 123, "part2": 456}
```

**Impact:**
- Language marked as FAILED with JSON error
- Actual stdout output shown for debugging
- Other languages continue normally
- Cross-language validation excludes this language
- Integration test returns exit code 1

**Common Causes:**
```javascript
// Missing quotes on keys
{part1: 123, part2: 456}  // WRONG

// Trailing comma
{"part1": 123, "part2": 456,}  // WRONG

// Single quotes instead of double
{'part1': 123, 'part2': 456}  // WRONG

// Missing closing brace
{"part1": 123, "part2": 456  // WRONG

// Extra debug output
DEBUG: processing...
{"part1": 123, "part2": 456}  // WRONG (stdout must be ONLY JSON)
```

**How to Fix:**
```bash
# Check your output format
./scripts/test_integration.sh 1 --verbose

# Verify JSON is valid
echo '{"part1": 123, "part2": 456}' | jq .

# Make sure ONLY JSON goes to stdout
# - Remove all debug print statements
# - Redirect debug output to stderr
# - Use exact format: {"part1": value, "part2": value}
```

### Partial Implementation Handling (null values)

**How Framework Handles:**
- JSON parser explicitly supports `null` values
- `null` is treated as "not yet implemented" for that part
- Distinguished from numeric `0` which is a valid answer
- Cross-language validation handles null appropriately:
  - If all languages return null for a part, marked as "not implemented"
  - If some return null and others return values, noted as partial
  - Languages with null values excluded from agreement validation
- Markdown report clearly indicates null vs. numeric values

**What You'll See:**
```
[INFO] rust: Part 1 = 123, Part 2 = null (partial implementation)
[INFO] gleam: Part 1 = 123, Part 2 = 456
```

**Impact:**
- Partial implementations don't cause failures
- Allows incremental development (solve part1, then part2)
- Cross-language validation only compares implemented parts
- Exit code 0 if implemented parts agree across languages

**Correct Usage:**
```json
// Part 1 solved, Part 2 not started yet
{"part1": 42, "part2": null}

// Both parts not started (placeholder implementation)
{"part1": null, "part2": null}

// Both parts solved
{"part1": 12345, "part2": 67890}
```

**Important Distinctions:**
```json
// null means "not implemented" - CORRECT for unfinished work
{"part1": null, "part2": 456}

// 0 means "the answer is zero" - WRONG for unfinished work
{"part1": 0, "part2": 456}  // Only use 0 if zero is the actual answer!

// Missing key is ERROR - never omit keys
{"part1": 123}  // WRONG - must include part2 even if null
```

**TDD Workflow:**
```bash
# 1. Start with placeholder
echo '{"part1": null, "part2": null}' | cargo run

# 2. Implement part1, test it
./scripts/test_unit.sh 1

# 3. Update to return part1 answer
echo '{"part1": 12345, "part2": null}' | cargo run

# 4. Implement part2, test it
./scripts/test_unit.sh 1

# 5. Update to return both answers
echo '{"part1": 12345, "part2": 67890}' | cargo run

# 6. Run integration test
./scripts/test_integration.sh 1
```

### Exit Code Summary

The testing framework uses exit codes to communicate results:

**Exit Code 0 (Success):**
- All languages executed successfully
- All implemented parts agree across languages
- Partial implementations (null values) are acceptable
- No compilation or runtime errors

**Exit Code 1 (Failure):**
- One or more languages failed to execute
- Compilation errors occurred
- Runtime crashes or timeouts
- Malformed JSON output
- Cross-language answer divergence (disagreement)
- Any error that prevents proper validation

**Exit Code 2 (Language-Specific: Skipped):**
- Used internally by language runners
- Implementation not found (directory missing)
- Runner reports "not implemented"
- Not propagated to main script exit code

## Architecture

The testing framework consists of several layers:

1. **CLI Layer** (`test_integration.sh`, `test_unit.sh`)
   - Parses command-line arguments
   - Orchestrates test execution
   - Generates reports
   - Handles user-facing error messages

2. **Execution Layer** (`test_execution.sh`)
   - Launches tests in parallel using background processes
   - Manages process lifecycle (start, monitor, kill)
   - Enforces timeouts with process tracking
   - Captures stdout/stderr to temporary files
   - Collects exit codes for all processes

3. **Language Runners** (`runners/run_*.sh`)
   - Execute language-specific commands (build, run, test)
   - Capture stdout (for JSON) and stderr (for errors)
   - Return meaningful exit codes
   - Handle missing implementations gracefully

4. **Validation Layer** (`validate_answers.sh`)
   - Compares answers across languages
   - Identifies agreements and divergences
   - Handles null values (partial implementations)
   - Handles errors (malformed JSON, missing data)

5. **Reporting Layer** (`generate_report.sh`)
   - Generates markdown reports with all results
   - Formats validation results clearly
   - Provides summaries and error details
   - Highlights agreements and divergences

6. **Utility Layer** (`common.sh`, `json_utils.sh`, `test_discovery.sh`)
   - Logging functions with color-coded output
   - JSON parsing and validation
   - File discovery for input files
   - Shared error handling patterns

## Best Practices

1. **Always Use Sample Input First**
   - Test with `--sample` before using real input
   - Sample input is easier to debug
   - Validates your algorithm on known example

2. **Use Verbose Mode for Debugging**
   - Add `--verbose` to see detailed output
   - Helps identify JSON formatting issues
   - Shows full compiler/runtime errors

3. **Run Unit Tests Frequently**
   - Use `test_unit.sh` during development
   - Faster feedback loop than integration tests
   - No need for JSON output contract

4. **Check Reports After Integration Tests**
   - Review `test_results.md` for validation details
   - Look for divergences between languages
   - Verify JSON output format is correct

5. **Handle Null Values Correctly**
   - Use `null` for unimplemented parts
   - Don't use `0` or empty strings
   - Distinguish "not done" from "answer is zero"

6. **Optimize Slow Solutions**
   - Use custom timeouts as needed (`--timeout`)
   - Consider algorithmic improvements if hitting timeout
   - Profile code to find bottlenecks

7. **Follow JSON Contract Strictly**
   - Both `part1` and `part2` must be present
   - Only use integers, strings, or null values
   - Output ONLY JSON to stdout (no debug prints)

8. **Leverage Bash Best Practices**
   - All scripts use `set -eo pipefail` for safety
   - Absolute paths from PROJECT_ROOT
   - Proper cleanup in all scenarios
   - Compatible with bash 3.2+ (macOS default)

## Integration with Existing Scripts

The testing framework seamlessly integrates with existing project infrastructure:

### Leverages common.sh Utilities

All test scripts source `scripts/common.sh` for:
- `log_info`: Blue informational messages
- `log_success`: Green success messages
- `log_error`: Red error messages
- `log_warn`: Yellow warning messages
- `check_command_exists`: Verify toolchain availability
- Consistent color-coded terminal output

### Follows Installation Script Patterns

Test scripts follow the same patterns as installation scripts:
- Use of PROJECT_ROOT for absolute paths
- Bash 3.2+ compatibility (macOS)
- Strict error handling with `set -eo pipefail`
- Continue on error (don't fail fast)
- Summary reports at the end

### Compatible with Verification Scripts

Test framework complements `verify_installation.sh`:
- Similar structure for checking multiple languages
- Aggregates results from all languages
- Provides clear pass/fail reporting
- Uses same logging utilities

### Directory Structure Conventions

Follows existing project patterns:
- Scripts in `scripts/` directory
- Documentation in `docs/` directory
- Language implementations in `<language>/dayXX/`
- Shared resources in `challenges/` directory
