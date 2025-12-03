# Advent of Code Testing Standards

## Test-Driven Approach

1. **Sample Data First**:
   - Always implement and verify sample data from problem description
   - Keep sample inputs in separate test files
   - Document expected outputs clearly

2. **Test Structure**:
   ```
   tests/
     day01_test.py (or similar)
     sample_inputs/
       day01_sample.txt
     actual_inputs/
       day01.txt
   ```

3. **Test Cases to Include**:
   - Sample data from problem statement
   - Edge cases (empty input, single element, etc.)
   - Boundary values
   - Part 1 solution
   - Part 2 solution

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

- Time your solution (should typically run in < 15 seconds)
- Profile if optimization needed
- Test with edge cases that might cause timeouts
