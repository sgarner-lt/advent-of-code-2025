# Advent of Code Testing Standards

## Critical File Handling

⚠️ **IMPORTANT:** Before writing any tests, read the file handling standard:
- See: `agent-os/profiles/advent-of-code-2025/standards/aoc-file-handling.md`
- **All files in `challenges/` are READ-ONLY**
- Never modify `input.txt`, `input-sample.txt`, or `input-sample-expected-output.txt`

## Test-Driven Approach

1. **Sample Data First**:
   - Always implement and verify sample data from problem description
   - Sample inputs are in `challenges/dayXX/input-sample.txt` (READ-ONLY)
   - Expected outputs are in `challenges/dayXX/input-sample-expected-output.txt` (READ-ONLY)
   - Document expected outputs clearly in test code

2. **Project Structure**:
   ```
   challenges/dayXX/              # READ-ONLY input files
     input.txt                    # Real puzzle input
     input-sample.txt             # Sample from problem
     input-sample-expected-output.txt  # Expected output
     problem-statement.txt # Raw problem statement from aoc website
     *.png # Supporting images if there are any (if empty assume none)

   solutions/<language>/dayXX/    # Your implementation (can modify)
     src/
     tests/
   ```

3. **Test Scope Per Language**:
   - Write **2-8 focused tests** per language (not exhaustive test suites)
   - Focus on critical behaviors:
     - Grid/input parsing
     - Core algorithm logic
     - Boundary checking
     - Sample input validation
   - Skip exhaustive edge case coverage at initial implementation stage
   - Target: ~8 tests per language × 4 languages = ~32 tests total

4. **Test Cases to Include**:
   - Sample data from problem statement (MUST match expected output)
   - Edge cases (empty input, single element, boundary conditions)
   - Core algorithm behavior (the main logic being tested)
   - Part 1 solution validation
   - Part 2 solution validation (when applicable)

5. **Testing Order**:
   1. Unit tests (2-8 focused tests per language)
   2. Verify single language's output using runner script
   3. Sample input via integration test script (`--sample` flag)
   4. Real input via integration test script
   5. Cross-language validation (all 4 languages must agree)

6. **Testing Scripts**:
   - **Integration tests**: `./scripts/test_integration.sh <day> [--sample] [--timeout 300]`
     - Use `--sample` for sample input validation
     - Use `--timeout 300` (required for Carbon's containerized Bazel compilation)
     - Without `--sample`, runs real puzzle input
   - **Single language runners**: `./scripts/runners/run_<language>.sh <day> <input_file>`
     - Test individual language implementations
     - Useful for debugging before full integration tests
   - **Unit tests**: `./scripts/test_unit.sh <day>` (runs all language-specific unit tests)

## Experimental Language Support

**Carbon and Bosque**: These experimental/research languages have limited tooling. Follow these patterns:

1. **Testing Approach**:
   - Write the algorithm in the target language (`.carbon` or `.bsq` file)
   - Create Python test harness (`test_<language>_dayXX.py`) for unit tests
   - Create Python runner (`runner.py`) for I/O and integration testing
   - This pattern allows validation while native tooling matures

2. **Carbon Specifics**:
   - Requires 300-second timeout for containerized Bazel compilation
   - Runner script prioritizes Python wrapper when available
   - Falls back to containerized compilation if no Python wrapper exists

3. **Bosque Specifics**:
   - Limited standard library support
   - Python wrapper handles I/O operations
   - Algorithm implementation mirrors Bosque syntax in Python

4. **File Structure for Experimental Languages**:
   ```
   solutions/<language>/dayXX/
     dayXX.<ext>              # Algorithm in target language
     runner.py                # Python wrapper for execution
     test_<language>_dayXX.py # Python-based unit tests
   ```

## Cross-Language Validation

**CRITICAL**: All 4 language implementations (Rust, Gleam, Carbon, Bosque) must produce identical outputs:

1. **Agreement Checks**:
   - Sample input: All languages must agree on expected output
   - Real input: All languages must produce identical answer
   - Format: All must output JSON: `{"part1": value, "part2": null}`

2. **Validation Process**:
   - Implement and validate Rust first (reference implementation)
   - Port to Gleam and cross-validate
   - Port to Carbon and cross-validate with Rust/Gleam
   - Port to Bosque and cross-validate with all three
   - Run integration tests to confirm all agree

3. **Troubleshooting Disagreements**:
   - Compare algorithm logic step-by-step
   - Verify boundary checking and edge cases
   - Check data type handling (integer overflow, etc.)
   - Review state tracking structures
   - Validate with sample input first before real input

## Validation Strategy

1. **Before Submitting**:
   - Verify sample data produces correct output (all languages)
   - Run solution on actual input (all languages)
   - Confirm cross-language agreement
   - Check for reasonable output range
   - Validate answer format (integer, string, etc.)

2. **Common Issues to Check**:
   - Off-by-one errors
   - Integer overflow (use appropriate data types)
   - Floating point precision
   - Case sensitivity
   - Line ending handling
   - Language-specific data structure behaviors

## Performance Testing

- Time your solution (should typically run in < 15 seconds, except carbon which is in a container and requires the 300 second timeout as seen below)
- Profile if optimization needed
- Test with edge cases that might cause timeouts
- **CRITICAL: Carbon solutions require 300-second timeout** for integration tests due to Bazel compilation in container:
  ```bash
  ./scripts/test_integration.sh 6 --timeout 300
  ```

## Test Count Expectations

For a typical day's implementation across all 4 languages:

- **Rust**: 8 focused unit tests
- **Gleam**: 8 focused unit tests
- **Carbon**: 8-9 focused tests (via Python test harness)
- **Bosque**: 8 focused tests (via Python test harness)
- **Total**: ~32-33 tests across all languages
- **Integration tests**: 2 (sample input + real input)

## Solution Summary

After completing all implementations, create a solution summary at `solutions/summaries/dayXX.md` including:

1. **Final Answers**:
   - Sample input answer
   - Real input answer (validated on AoC website)

2. **Algorithm Approach**:
   - High-level description
   - Key data structures
   - State transition rules
   - Time/space complexity

3. **Cross-Language Implementation**:
   - Brief notes per language
   - Performance characteristics
   - Any language-specific challenges

4. **Testing Summary**:
   - Total test count
   - Integration test results
   - Cross-language validation status

5. **Challenges & Solutions**:
   - Interesting bugs encountered
   - Edge cases discovered
   - Optimization insights
