# Task Breakdown: Testing Framework Setup

## Overview
Total Tasks: 47 sub-tasks organized into 5 major task groups

This breakdown implements a cross-language testing framework that runs tests in parallel across Rust, Roc, Gleam, Carbon, and Bosque, validates identical answers between implementations, and produces markdown reports.

## Task List

### Core Test Infrastructure

#### Task Group 1: JSON Output Standardization
**Dependencies:** None

- [x] 1.0 Standardize JSON output across all languages
  - [x] 1.1 Write 2-8 focused tests for JSON parsing and validation
    - Test valid JSON format: `{"part1": 123, "part2": 456}`
    - Test null values: `{"part1": null, "part2": 789}`
    - Test malformed JSON handling
    - Test missing keys handling
    - Limit to critical parsing behaviors only
  - [x] 1.2 Create JSON output utilities in `scripts/json_utils.sh`
    - Function: `parse_json_answer(json_string, part_number)` - extract part1/part2 values
    - Function: `validate_json_format(json_string)` - check format validity
    - Function: `is_json_malformed(json_string)` - detect parsing errors
    - Reuse pattern from: `scripts/common.sh` logging utilities
  - [x] 1.3 Document JSON output contract in `docs/testing-framework.md`
    - Required format: `{"part1": <value>, "part2": <value>}`
    - Supported value types: integers, strings, null
    - No additional metadata required
    - Include examples for each language
  - [x] 1.4 Create language-specific JSON output templates
    - Rust: JSON serialization using serde_json
    - Gleam: JSON encoding using gleam/json library
    - Roc: JSON string formatting using Str module
    - Carbon: JSON output using standard library (TBD - experimental)
    - Bosque: JSON string construction
  - [x] 1.5 Ensure JSON utility tests pass
    - Run ONLY the 2-8 tests written in 1.1
    - Verify parsing functions handle all test cases
    - Do NOT run entire test suite

**Acceptance Criteria:**
- All 2-8 JSON utility tests pass
- JSON parsing functions handle valid, null, and malformed input
- Documentation clearly specifies contract
- Language templates provide clear implementation guidance

#### Task Group 2: Parallel Test Execution Engine
**Dependencies:** Task Group 1

- [x] 2.0 Build parallel test execution system
  - [x] 2.1 Write 2-8 focused tests for parallel execution logic
    - Test launching 5 background processes
    - Test waiting for all processes to complete
    - Test capturing exit codes from each process
    - Test timeout handling (60 second default)
    - Limit to critical execution behaviors only
  - [x] 2.2 Create test execution framework in `scripts/test_execution.sh`
    - Function: `run_language_test(language, day_number, input_path)` - execute single language
    - Function: `run_all_tests_parallel(day_number)` - launch all 5 languages in background
    - Function: `wait_for_all_tests()` - wait for completion, capture exit codes
    - Function: `kill_on_timeout(pid, timeout_seconds)` - enforce timeout
    - Reuse pattern from: `scripts/verify_installation.sh` verification approach
  - [x] 2.3 Implement process management utilities
    - Track PIDs for all background processes
    - Capture stdout to temporary files per language
    - Capture stderr to separate error logs per language
    - Store exit codes in associative array (bash 3.2+ compatible approach)
    - Clean up temp files after aggregation
  - [x] 2.4 Add timeout enforcement mechanism
    - Default timeout: 60 seconds per language
    - Override via `--timeout <seconds>` flag
    - Kill process if timeout exceeded
    - Report timeout as test failure
  - [x] 2.5 Implement "no fail-fast" behavior
    - Continue running all languages even if some fail
    - Do not exit early on first failure
    - Collect all results before reporting
  - [x] 2.6 Ensure parallel execution tests pass
    - Run ONLY the 2-8 tests written in 2.1
    - Verify all 5 processes launch and complete
    - Verify timeout enforcement works
    - Do NOT run entire test suite

**Acceptance Criteria:**
- All 2-8 parallel execution tests pass
- Framework launches 5 language tests simultaneously
- All tests complete before aggregation begins
- Timeout enforcement prevents hanging tests
- Exit codes captured correctly for all languages

#### Task Group 3: Language-Specific Test Runners
**Dependencies:** Task Groups 1-2

- [x] 3.0 Implement per-language test execution
  - [x] 3.1 Write 2-8 focused tests for language runners
    - Test Rust unit test execution: `cargo test`
    - Test Gleam unit test execution: `gleam test`
    - Test integration test with input file passing
    - Test capturing JSON output from stdout
    - Test error handling for compilation failures
    - Limit to critical runner behaviors only
  - [x] 3.2 Create Rust test runner in `scripts/runners/run_rust.sh`
    - Unit test command: `cd rust/dayXX && cargo test`
    - Integration test command: `cd rust/dayXX && cargo run -- <input_path>`
    - Parse JSON from stdout
    - Capture stderr to error log
    - Return exit code
  - [x] 3.3 Create Gleam test runner in `scripts/runners/run_gleam.sh`
    - Unit test command: `cd gleam/dayXX && gleam test`
    - Integration test command: `cd gleam/dayXX && gleam run -- <input_path>`
    - Parse JSON from stdout
    - Capture stderr to error log
    - Return exit code
  - [x] 3.4 Create Roc test runner in `scripts/runners/run_roc.sh`
    - Unit test command: `cd roc/dayXX && ${HOME}/.local/bin/roc test solution.roc`
    - Integration test command: `cd roc/dayXX && ${HOME}/.local/bin/roc run solution.roc <input_path>`
    - Parse JSON from stdout
    - Capture stderr to error log
    - Handle known platform version issues gracefully
  - [x] 3.5 Create Carbon test runner in `scripts/runners/run_carbon.sh`
    - Unit test command: `cd carbon/dayXX && bazel test //...`
    - Integration test command: `cd carbon/dayXX && bazel run //:main -- <input_path>`
    - Parse JSON from stdout
    - Capture stderr to error log
    - Document Bazel build requirements
  - [x] 3.6 Create Bosque test runner in `scripts/runners/run_bosque.sh`
    - Unit test command: `cd bosque/dayXX && ${HOME}/.local/bin/bosque test solution.bsq`
    - Integration test command: `cd bosque/dayXX && ${HOME}/.local/bin/bosque run solution.bsq <input_path>`
    - Parse JSON from stdout via container
    - Capture stderr to error log
    - Use containerized execution via Podman
  - [x] 3.7 Create test runner directory structure
    - Create `scripts/runners/` directory
    - Make all runner scripts executable
    - Add sourcing of `scripts/common.sh` for logging
    - Follow bash 3.2+ compatibility (macOS default)
  - [x] 3.8 Ensure language runner tests pass
    - Run ONLY the 2-8 tests written in 3.1
    - Verify critical runner commands work
    - Verify JSON capture from stdout
    - Do NOT run entire test suite

**Acceptance Criteria:**
- All 2-8 language runner tests pass
- All 5 languages have functional unit and integration test runners
- JSON output correctly captured from stdout
- Error messages captured to stderr logs
- Scripts follow bash 3.2+ compatibility standards

### Test Discovery and Validation

#### Task Group 4: Test Data Discovery and Cross-Language Validation
**Dependencies:** Task Groups 1-3 (COMPLETED)

- [x] 4.0 Implement test discovery and answer validation
  - [x] 4.1 Write 2-8 focused tests for discovery and validation
    - Test discovering input.txt in challenges/dayXX/
    - Test discovering input-sample.txt
    - Test handling missing input files
    - Test cross-language answer comparison (all match)
    - Test cross-language answer comparison (divergence)
    - Test handling partial implementations (null values)
    - Limit to critical validation behaviors only
  - [x] 4.2 Create test discovery logic in `scripts/test_discovery.sh`
    - Function: `discover_test_inputs(day_number)` - find input files
    - Function: `get_input_path(day_number, input_type)` - return path to input.txt or input-sample.txt
    - Function: `validate_input_exists(input_path)` - check file exists
    - Search in: `challenges/dayXX/` directory
    - Support: input.txt (real puzzle) and input-sample.txt (sample)
  - [x] 4.3 Create cross-language validation logic in `scripts/validate_answers.sh`
    - Function: `compare_all_answers(day_number)` - compare JSON outputs across all 5 languages
    - Function: `check_part_agreement(part_number)` - identify which languages agree
    - Function: `find_divergences(part_number)` - identify mismatched answers
    - Function: `handle_null_values()` - treat null as "not yet implemented"
    - Parse JSON output from all 5 languages
    - Compare part1 values across all implementations
    - Compare part2 values across all implementations
  - [x] 4.4 Implement validation result tracking
    - Track which languages agree on part1
    - Track which languages agree on part2
    - Track which languages have divergent answers
    - Track which languages failed to run
    - Track which languages have partial implementations (null values)
  - [x] 4.5 Handle edge cases gracefully
    - Missing language implementation: report as "not implemented"
    - Compilation failure: report as failure with compiler error
    - Runtime crash: capture stack trace
    - Malformed JSON: report with clear error message
    - Timeout: report as timeout failure
    - Partial implementation: distinguish null from 0
  - [x] 4.6 Ensure discovery and validation tests pass
    - Run ONLY the 2-8 tests written in 4.1
    - Verify test input discovery works
    - Verify answer comparison logic works
    - Do NOT run entire test suite

**Acceptance Criteria:**
- All 2-8 discovery and validation tests pass
- Framework discovers test inputs in challenges/dayXX/
- Cross-language validation correctly identifies agreements and divergences
- Edge cases handled gracefully without crashing
- Null values distinguished from numeric zero

### User Interface and Reporting

#### Task Group 5: Command-Line Interface and Markdown Reporting
**Dependencies:** Task Groups 1-4 (COMPLETED)

- [x] 5.0 Build CLI and reporting system
  - [x] 5.1 Write 2-8 focused tests for CLI and reporting
    - Test CLI argument parsing for day number
    - Test `--verbose` flag functionality
    - Test `--timeout` flag with custom value
    - Test markdown report generation with all sections
    - Test report showing commonalities across languages
    - Test report showing differences/divergences
    - Limit to critical CLI and reporting behaviors only
  - [x] 5.2 Create main integration test script: `scripts/test_integration.sh`
    - Usage: `./scripts/test_integration.sh <day_number> [--verbose] [--timeout <seconds>]`
    - Accept day number as required argument
    - Parse optional flags: --verbose, --timeout
    - Call test discovery to find input files
    - Run all 5 languages in parallel via test_execution.sh
    - Aggregate results from all languages
    - Generate markdown report
    - Exit code 0 if all pass, 1 if any failures
    - Print summary to stdout during execution
  - [x] 5.3 Create unit test script: `scripts/test_unit.sh`
    - Usage: `./scripts/test_unit.sh <day_number> [--verbose]`
    - Accept day number as required argument
    - Run ONLY unit tests (not integration tests)
    - Execute language-specific test commands (cargo test, gleam test, etc.)
    - Report unit test failures per language
    - Do NOT perform cross-language validation
    - Exit code 0 if all unit tests pass
  - [x] 5.4 Implement markdown report generator in `scripts/generate_report.sh`
    - Output file: `test_results.md` in project root
    - Include test run timestamp
    - Include day number tested
    - Section per language with pass/fail status
    - Display JSON output from each language
    - Highlight commonalities: "Languages with matching part1: Rust, Gleam, Roc"
    - Highlight differences: "Divergent part2 answers: Carbon (123), Bosque (456)"
    - Include error messages for failed languages
    - NO performance metrics or timing data
    - NO historical data or trending
  - [x] 5.5 Add usage documentation and help text
    - `--help` flag shows usage information
    - Include examples: `./scripts/test_integration.sh 1` for day 1
    - Document flags: --verbose, --timeout
    - Add help text to both test_integration.sh and test_unit.sh
  - [x] 5.6 Implement verbose output mode
    - Default: show only summary output
    - `--verbose` flag: show detailed output from all commands
    - Print language runner commands being executed
    - Show JSON parsing steps
    - Display validation comparison details
  - [x] 5.7 Create comprehensive usage examples
    - Example 1: Test day 1 with sample input
    - Example 2: Test day 5 with real input and verbose output
    - Example 3: Run only unit tests for day 3
    - Example 4: Test with custom timeout of 120 seconds
    - Document in `docs/testing-framework.md`
  - [x] 5.8 Ensure CLI and reporting tests pass
    - Run ONLY the 2-8 tests written in 5.1
    - Verify CLI parsing works correctly
    - Verify markdown report generates properly
    - Do NOT run entire test suite

**Acceptance Criteria:**
- All 2-8 CLI and reporting tests pass
- Integration test script accepts day number and runs all languages
- Unit test script runs language-specific tests without validation
- Markdown report includes all required sections
- Help text and usage examples are clear and accurate
- Verbose mode provides detailed debugging output

### Integration and Documentation

#### Task Group 6: End-to-End Testing and Documentation
**Dependencies:** Task Groups 1-5

- [x] 6.0 Complete end-to-end testing and documentation
  - [x] 6.1 Write up to 10 additional strategic tests for end-to-end workflows
    - Test full integration: run test_integration.sh with sample input
    - Test unit test workflow: run test_unit.sh for TDD iteration
    - Test error recovery: handle missing implementations gracefully
    - Test report accuracy: verify markdown shows correct comparisons
    - Test parallel execution: ensure all 5 languages complete
    - Test timeout handling: verify processes killed on timeout
    - Test JSON validation: cross-language answer agreement
    - Test divergence detection: identify mismatched answers
    - Maximum 10 tests to cover critical gaps
    - Focus on end-to-end workflows, not unit test gaps
  - [x] 6.2 Test with real Advent of Code day structure
    - Create test data in `challenges/day01/`
    - Place sample input in `input-sample.txt`
    - Place real input in `input.txt`
    - Run integration test: `./scripts/test_integration.sh 1`
    - Verify all 5 languages execute
    - Verify markdown report generates correctly
  - [x] 6.3 Validate TDD workflow with unit tests
    - Run unit tests only: `./scripts/test_unit.sh 1`
    - Verify no cross-language validation occurs
    - Verify language-specific test frameworks execute
    - Verify unit test failures reported clearly
    - Confirm workflow matches agent TDD requirements
  - [x] 6.4 Create comprehensive documentation in `docs/testing-framework.md`
    - Architecture overview: parallel execution, JSON validation, reporting
    - Usage guide: how to run integration tests and unit tests
    - JSON output contract: required format and examples
    - Language runner details: commands for each language
    - Troubleshooting guide: common errors and solutions
    - File structure conventions: where to place test data
    - Integration with existing scripts: leverages common.sh utilities
  - [x] 6.5 Document test data conventions
    - Input files go in `challenges/dayXX/` directory
    - Real puzzle input: `input.txt`
    - Sample puzzle input: `input-sample.txt`
    - Problem statement: `problem-statement.txt` (optional reference)
    - No expected output files (Advent of Code uses manual submission)
  - [x] 6.6 Create script usage examples in README
    - Add testing section to main README.md
    - Example: Running integration tests for day 1
    - Example: Running unit tests during development
    - Example: Using verbose mode for debugging
    - Example: Setting custom timeout for slow solutions
    - Link to detailed docs/testing-framework.md
  - [x] 6.7 Add error handling documentation
    - Document how framework handles missing implementations
    - Explain compilation failure reporting
    - Describe runtime crash handling
    - Detail timeout behavior
    - Explain malformed JSON recovery
    - Clarify partial implementation handling (null values)
  - [x] 6.8 Verify all scripts follow bash best practices
    - Use `set -eo pipefail` for strict error handling
    - Source `scripts/common.sh` for logging utilities
    - Use absolute paths from PROJECT_ROOT variable
    - Make scripts executable with proper shebang
    - Follow bash 3.2+ compatibility (macOS default)
    - Apply existing error handling patterns from installation scripts
  - [x] 6.9 Test idempotency and cleanup
    - Verify temp files cleaned up after test runs
    - Verify scripts can be run multiple times safely
    - Verify markdown report overwrites cleanly
    - Check no leftover processes after timeout
    - Ensure cleanup happens even on failure
  - [x] 6.10 Run feature-specific tests only
    - Run tests from Task Groups 1-5 (approximately 10-40 tests)
    - Run the up to 10 additional tests from 6.1
    - Expected total: approximately 20-50 tests maximum
    - Verify all critical workflows pass
    - Do NOT run entire application test suite

**Acceptance Criteria:**
- All feature-specific tests pass (approximately 20-50 tests total)
- Full integration test workflow works end-to-end
- Unit test workflow supports TDD development
- Documentation is comprehensive and clear
- Scripts follow bash best practices and project conventions
- Cleanup and idempotency verified

## Execution Order

Recommended implementation sequence:

1. **Task Group 1: JSON Output Standardization** - Establish the contract that all languages must follow
2. **Task Group 2: Parallel Test Execution Engine** - Build the core parallel execution infrastructure
3. **Task Group 3: Language-Specific Test Runners** - Implement runners for all 5 languages
4. **Task Group 4: Test Data Discovery and Cross-Language Validation** - Add intelligence for finding inputs and comparing answers
5. **Task Group 5: Command-Line Interface and Markdown Reporting** - Create user-facing commands and reports
6. **Task Group 6: End-to-End Testing and Documentation** - Validate complete workflows and document thoroughly

## Key Implementation Notes

### Leveraging Existing Code Patterns

**From scripts/common.sh:**
- Reuse `log_info`, `log_success`, `log_error`, `log_warn` for consistent terminal output
- Use `check_command_exists` to verify language toolchains before running tests
- Apply `cleanup_temp_dir` pattern for cleaning test artifacts
- Follow color code conventions for readable status reporting

**From scripts/verify_installation.sh:**
- Adapt verification approach: run multiple languages and aggregate results
- Use bash array patterns for collecting results from multiple processes
- Apply similar report generation logic for markdown output
- Follow pattern of continuing on error rather than failing fast

**From existing installation scripts:**
- Use `set -eo pipefail` for strict error handling
- Capture and preserve exit codes from background processes
- Implement timeout mechanisms similar to installation scripts
- Use PROJECT_ROOT variable for absolute path references

### Testing Philosophy Alignment

Per agent-os/standards/testing/test-writing.md:
- Write minimal tests during development (2-8 per task group)
- Test only core user flows and critical paths
- Defer edge case testing to dedicated phases
- Focus on behavior, not implementation
- Add maximum 10 additional tests in final integration phase

### Error Handling Alignment

Per agent-os/standards/global/error-handling.md:
- Provide clear, actionable error messages
- Fail fast and explicitly during validation
- Implement graceful degradation when languages fail
- Clean up resources (temp files, processes) in all scenarios
- No retry strategies needed (tests are deterministic)

### Bash Compatibility

All scripts must be compatible with bash 3.2+ (macOS default):
- Avoid bash 4+ features (associative arrays require workarounds)
- Use portable command syntax
- Test on macOS before marking tasks complete
- Follow existing project bash patterns

### File Structure

```
scripts/
  common.sh                  (existing - reuse)
  json_utils.sh              (new - Task Group 1)
  test_execution.sh          (new - Task Group 2)
  test_discovery.sh          (new - Task Group 4)
  validate_answers.sh        (new - Task Group 4)
  generate_report.sh         (new - Task Group 5)
  test_integration.sh        (new - main integration script)
  test_unit.sh              (new - main unit test script)
  runners/
    run_rust.sh             (new - Task Group 3)
    run_gleam.sh            (new - Task Group 3)
    run_roc.sh              (new - Task Group 3)
    run_carbon.sh           (new - Task Group 3)
    run_bosque.sh           (new - Task Group 3)

challenges/
  dayXX/
    input.txt               (real puzzle input)
    input-sample.txt        (sample puzzle input)
    problem-statement.txt   (optional reference)

<language>/
  dayXX/
    (language-specific implementation structure)

docs/
  testing-framework.md      (new - comprehensive documentation)

test_results.md            (generated report in project root)
```

## Out of Scope (Explicitly Excluded)

- Performance benchmarking or execution time tracking
- Historical test result storage or trending analysis
- HTML report generation or visualizations (d3.js, charts)
- Code coverage analysis
- Automatic submission to Advent of Code website
- Detailed debugging output beyond basic error messages
- Test result database or persistence layer
- CI/CD integration (GitHub Actions, etc.)
- Email notifications or Slack integration for test results
- Comparison of algorithm efficiency or memory usage
