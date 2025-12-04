# Specification: Testing Framework Setup

## Goal
Create a cross-language validation system that runs tests across Rust, Roc, Gleam, Carbon, and Bosque in parallel, validates identical answers between implementations, and produces markdown reports showing differences and commonalities.

## User Stories
- As a developer, I want to run tests for a specific day number across all 5 languages simultaneously so that I can quickly validate that all implementations produce identical answers
- As a developer, I want separate unit test execution for TDD workflow so that I can iteratively develop and test individual functions without running full integration tests

## Specific Requirements

**Parallel Test Execution**
- Accept day number as CLI argument (e.g., `./test_runner.sh 1` for day 1)
- Launch all 5 language test runners simultaneously using background processes
- Wait for all language tests to complete before aggregating results
- Do not fail fast - run all languages even if some fail
- Capture stdout/stderr from each language's test runner
- Use process management to track completion status of all parallel jobs

**Standardized JSON Output Format**
- Each language implementation must output JSON to stdout in exact format: `{"part1": <answer>, "part2": <answer>}`
- Answer values can be integers, strings, or null if not yet implemented
- No additional metadata required (no timing, no language version)
- Parse JSON output from each language using standard JSON parser
- Handle cases where JSON is malformed or missing
- Extract part1 and part2 values for cross-language comparison

**Unit Test vs Integration Test Separation**
- Provide two distinct commands: `test_unit.sh <day>` and `test_integration.sh <day>`
- Unit tests run language-specific test frameworks without cross-language validation
- Integration tests run full solution and perform cross-language answer validation
- Unit test command executes: Rust `cargo test`, Gleam `gleam test`, Roc `roc test`, Carbon and Bosque equivalent
- Integration test command runs solution binaries and captures JSON output
- Report unit test failures with language-specific error messages
- Report integration test failures with answer mismatch details

**Test Data Discovery**
- Framework automatically discovers test inputs in `challenges/dayXX/` directory
- Look for `input.txt` (real puzzle input) and `input-sample.txt` (sample input)
- Do not require expected output files (Advent of Code provides manual submission only)
- Pass input file path to each language's implementation as command-line argument
- Each language reads input file and produces JSON output to stdout

**Cross-Language Answer Validation**
- After all 5 languages complete, parse JSON output from each
- Compare part1 values across all languages
- Compare part2 values across all languages
- Identify which languages agree (produce identical answers)
- Identify which languages diverge (produce different answers)
- Report both successful validations and mismatches

**Markdown Report Generation**
- Generate `test_results.md` in project root after each test run
- Include test run timestamp and day number
- Show section for each language with pass/fail status
- Display JSON output from each language
- Highlight commonalities (languages that agree on answers)
- Highlight differences (languages with divergent answers)
- Include error messages for languages that failed to run
- Keep report simple - no performance metrics, no historical data

**Language-Specific Test Execution**
- Rust: Execute `cargo test` for unit tests, `cargo run -- <input_path>` for integration
- Gleam: Execute `gleam test` for unit tests, `gleam run -- <input_path>` for integration
- Roc: Execute `roc test <file>` for unit tests, `roc run <file> <input_path>` for integration
- Carbon: Execute via Bazel test command for unit tests, compiled binary for integration
- Bosque: Execute via containerized test runner using bosque-wrapper.sh script
- Capture exit codes to determine pass/fail status
- Redirect stderr to separate error log for debugging

**Error Handling and Edge Cases**
- Handle missing language implementations gracefully (report as "not implemented")
- Handle compilation failures as test failures with compiler error output
- Handle runtime crashes with stack trace capture
- Handle timeout scenarios (default 60 second timeout per language)
- Handle malformed JSON output with clear error message
- Handle partial implementations (only part1 or part2 completed)
- Continue test execution even if some languages fail

**File Structure Conventions**
- Test runner scripts located in `scripts/` directory
- Each language's implementation in `<language>/dayXX/` directory
- Shared test inputs in `challenges/dayXX/` directory
- Test results markdown file written to project root
- Temporary files cleaned up after test run completes

**Command-Line Interface**
- Primary command: `./scripts/test_integration.sh <day_number>`
- Unit test command: `./scripts/test_unit.sh <day_number>`
- Optional flags: `--verbose` for detailed output, `--timeout <seconds>` for custom timeout
- Exit code 0 if all languages pass, exit code 1 if any failures
- Print summary to stdout during execution

## Visual Design
No visual assets provided.

## Existing Code to Leverage

**scripts/common.sh logging utilities**
- Reuse `log_info`, `log_success`, `log_error`, `log_warn` functions for consistent terminal output
- Reuse color codes for readable test status reporting
- Leverage `check_command_exists` to verify language toolchains are installed
- Use `cleanup_temp_dir` pattern for cleaning up test artifacts

**scripts/verify_installation.sh verification patterns**
- Follow similar structure for running multiple languages and aggregating results
- Adapt verification approach to test execution (parallel instead of sequential)
- Reuse pattern of tracking which languages succeed vs fail
- Apply similar report generation logic for markdown output
- Use bash array patterns for collecting results from multiple processes

**Installation script error handling patterns**
- Use `set -eo pipefail` for strict error handling in test runner
- Capture and preserve exit codes from background processes
- Implement similar timeout mechanisms as installation scripts
- Follow pattern of continuing on error rather than exiting early

**Project directory structure conventions**
- Follow existing pattern: `<language>/dayXX/` for language-specific implementations
- Use `challenges/dayXX/` for shared test data files
- Place scripts in `scripts/` directory with `.sh` extension
- Use absolute paths from PROJECT_ROOT variable to reference files

**Bash script best practices from existing codebase**
- Use bash 3.2+ compatible syntax (macOS default shell)
- Source common.sh for shared utilities
- Include usage documentation with `--help` flag
- Make scripts executable with proper shebang (`#!/bin/bash`)

## Out of Scope
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
