# Manual Trace Verification for Sample Input

## Purpose
This document verifies the expected output for the sample input by manually tracing through the dial rotation sequence.

## Sample Input
```
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
```

## Expected Output
The dial should land on position 0 exactly **3 times** during the sequence.

## Manual Trace

**Starting Position:** 50
**Dial Range:** 0-99 (circular)

### Step-by-Step Trace

1. **L68**: 50 - 68 = -18
   Wraparound: ((-18 % 100) + 100) % 100 = 82
   **Position = 82**

2. **L30**: 82 - 30 = 52
   **Position = 52**

3. **R48**: 52 + 48 = 100
   Wraparound: 100 % 100 = 0
   **Position = 0** (COUNT = 1)

4. **L5**: 0 - 5 = -5
   Wraparound: ((-5 % 100) + 100) % 100 = 95
   **Position = 95**

5. **R60**: 95 + 60 = 155
   Wraparound: 155 % 100 = 55
   **Position = 55**

6. **L55**: 55 - 55 = 0
   **Position = 0** (COUNT = 2)

7. **L1**: 0 - 1 = -1
   Wraparound: ((-1 % 100) + 100) % 100 = 99
   **Position = 99**

8. **L99**: 99 - 99 = 0
   **Position = 0** (COUNT = 3)

9. **R14**: 0 + 14 = 14
   **Position = 14**

10. **L82**: 14 - 82 = -68
    Wraparound: ((-68 % 100) + 100) % 100 = 32
    **Position = 32**

## Summary

**Position Sequence:** 50 → 82 → 52 → 0 → 95 → 55 → 0 → 99 → 0 → 14 → 32

**Zero Count:** 3 (positions after instructions 3, 6, and 8)

**Final Position:** 32

## Verification Result

The manual trace confirms that the dial lands on position 0 exactly **3 times**, which matches the expected output in `challenges/day01/input-sample-expected-output.txt`.

This trace matches the example given in the problem statement, validating our understanding of the algorithm:
- Left rotations subtract the distance (with wraparound for negative results)
- Right rotations add the distance (with wraparound for values >= 100)
- The count increments only when the position equals 0 after a rotation
