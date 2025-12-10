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

3. **Test Cases to Include**:
   - Sample data from problem statement
   - Edge cases (empty input, single element, etc.)
   - Boundary values
   - Part 1 solution
   - Part 2 solution

4. Testing order
  1. Unit tests   
  2. Verify single languages's output using run language script.
  2. Sample input via integration test script.
  3. Real input via integration test script

5. Scripts 
   -  `./scripts/test_integration.sh` can run the sample input or the real input (CRITICAL: use timeout of 300 s to allow carbon to finish)
   - `./scripts/runners/run_<language>.sh` to run a single language solution

## Validation Strategy

1. **Before Submitting**:
   - Verify sample data produces correct output
   - Run solution on actual input
   - Check for reasonable output range
   - Validate answer format (integer, string, etc.)

2. **Common Issues to Check**:
   - Off-by-one errors
   - Integer overflow (use appropriate data types)
   - Floating point precision
   - Case sensitivity
   - Line ending handling

## Performance Testing

- Time your solution (should typically run in < 15 seconds, except carbon which is in a container and requires the 300 second timeout as seen below)
- Profile if optimization needed
- Test with edge cases that might cause timeouts
- **CRITICAL: Carbon solutions require 300-second timeout** for integration tests due to Bazel compilation in container:
  ```bash
  ./scripts/test_integration.sh 6 --timeout 300
  ```
