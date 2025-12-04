# Zero Crossing Algorithm Specification

## Overview

This document provides a complete mathematical specification for counting the number of times a dial crosses through position 0 during a rotation. This algorithm is the foundation for solving Advent of Code Day 1 Part 2 across all five programming languages.

## Problem Statement

Given:
- A circular dial with positions 0-99 (100 total positions)
- A current position (0-99)
- A rotation direction (Left or Right)
- A rotation amount (non-negative integer)

Calculate: The number of times the dial crosses through position 0 during the rotation movement.

## Key Concepts

### What Constitutes a Crossing?

A crossing occurs when the dial **passes through** position 0 during the rotation movement, not just when it ends at position 0. This is distinct from Part 1, which only counted when the dial stopped at position 0.

**Important Distinctions:**
- If the dial moves from position 95 to position 5 (going Right 10 clicks), it crosses 0 once during movement
- If the dial moves from position 10 to position 20 (going Right 10 clicks), it does NOT cross 0
- If the dial is already at position 0 and rotates away, we do NOT count the starting position as a crossing
- If the dial ends at position 0, we count that as a crossing (since it had to cross through 0 to get there)

### Rotation Mechanics

**Right Rotation (Clockwise):**
- Increases position value
- Movement: 0 → 1 → 2 → ... → 99 → 0 → 1 → ...
- Wraps from 99 to 0

**Left Rotation (Counterclockwise):**
- Decreases position value
- Movement: 0 → 99 → 98 → ... → 1 → 0 → 99 → ...
- Wraps from 0 to 99

## Mathematical Approach

### Core Algorithm Logic

The algorithm uses the **effective rotation amount** (the actual distance traveled) rather than the final wrapped position to determine crossings.

**Function Signature:**
```
count_zero_crossings(current_position: int, direction: Direction, amount: int) -> int
```

**Input Constraints:**
- `current_position`: Integer in range [0, 99]
- `direction`: Enumeration value (Left or Right)
- `amount`: Non-negative integer (can be >= 100)

**Output:**
- Integer count of zero crossings (>= 0)

### Algorithm for Right Rotations

For a Right (clockwise) rotation from `current_position` by `amount` clicks:

1. **Calculate complete circles:**
   ```
   complete_circles = amount / 100  (integer division)
   remainder = amount % 100
   ```

2. **Each complete circle crosses zero exactly once** (moving from 99 to 0)
   ```
   crossings_from_complete_circles = complete_circles
   ```

3. **Check if the remainder rotation crosses zero:**
   - The dial needs to move from `current_position` to reach or pass 0
   - Distance to reach 0 going right: `100 - current_position`
   - If `remainder >= (100 - current_position)`, then we cross zero during the remainder rotation
   ```
   if remainder >= (100 - current_position):
       crossings_from_remainder = 1
   else:
       crossings_from_remainder = 0
   ```

4. **Total crossings:**
   ```
   total = crossings_from_complete_circles + crossings_from_remainder
   ```

### Algorithm for Left Rotations

For a Left (counterclockwise) rotation from `current_position` by `amount` clicks:

1. **Calculate complete circles:**
   ```
   complete_circles = amount / 100  (integer division)
   remainder = amount % 100
   ```

2. **Each complete circle crosses zero exactly once** (moving from 1 to 0)
   ```
   crossings_from_complete_circles = complete_circles
   ```

3. **Check if the remainder rotation crosses zero:**
   - The dial needs to move from `current_position` to reach or pass 0
   - Distance to reach 0 going left: `current_position` (since we move from position to 0)
   - If `remainder >= current_position` and `current_position > 0`, then we cross zero during the remainder rotation
   ```
   if current_position > 0 and remainder >= current_position:
       crossings_from_remainder = 1
   else:
       crossings_from_remainder = 0
   ```

   **Special case:** If `current_position == 0`, we cannot cross zero going left with just a remainder (we'd need a complete circle)

4. **Total crossings:**
   ```
   total = crossings_from_complete_circles + crossings_from_remainder
   ```

## Pseudocode

```
function count_zero_crossings(current_position, direction, amount):
    if amount == 0:
        return 0

    complete_circles = amount / 100  // integer division
    remainder = amount % 100

    crossings = complete_circles  // Each complete circle crosses zero once

    if direction == Right:
        // Check if remainder crosses from current position to/past 0
        distance_to_zero = 100 - current_position
        if remainder >= distance_to_zero:
            crossings = crossings + 1

    else if direction == Left:
        // Check if remainder crosses from current position to/past 0
        distance_to_zero = current_position
        if current_position > 0 and remainder >= distance_to_zero:
            crossings = crossings + 1

    return crossings
```

## Edge Cases

### 1. Starting at Position 0

**Right Rotation from 0:**
- R10 from 0: Does NOT cross 0 (moves 0→1→...→10)
- R100 from 0: Crosses 0 once (completes full circle, returns to 0)
- R150 from 0: Crosses 0 twice (one complete circle + remainder of 50 which ends at 50, no crossing)

**Left Rotation from 0:**
- L10 from 0: Does NOT cross 0 (moves 0→99→98→...→90)
- L100 from 0: Crosses 0 once (completes full circle, returns to 0)
- L150 from 0: Crosses 0 twice (one complete circle + remainder of 50 which ends at 50, no crossing)

### 2. Ending at Position 0

**Examples:**
- R10 from 90: Ends at 0, crosses 0 once (counted by remainder logic)
- L10 from 10: Ends at 0, crosses 0 once (counted by remainder logic)

These are handled naturally by the remainder crossing logic.

### 3. Exact Multiples of 100

**R100 from any position:**
- complete_circles = 1, remainder = 0
- Crosses 0 exactly once (the complete circle)
- No additional crossing from remainder

**R200 from any position:**
- complete_circles = 2, remainder = 0
- Crosses 0 exactly twice (two complete circles)

### 4. Large Rotations

**R1000 from position 50:**
- complete_circles = 10, remainder = 0
- Crosses 0 exactly 10 times

**L200 from position 10:**
- complete_circles = 2, remainder = 0
- Crosses 0 exactly twice

**R1050 from position 30:**
- complete_circles = 10, remainder = 50
- Distance to zero going right = 100 - 30 = 70
- remainder (50) < distance (70), so no remainder crossing
- Total: 10 crossings

### 5. Zero-Distance Rotations

**R0 or L0 from any position:**
- amount = 0
- Return 0 immediately (no movement, no crossing)

## Manual Trace of Sample Input

Let's trace through the sample input from the problem statement to verify our algorithm produces the expected answer of 6.

**Sample Input:**
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

**Starting position:** 50

### Rotation 1: L68 from position 50
- complete_circles = 68 / 100 = 0
- remainder = 68 % 100 = 68
- Direction: Left
- distance_to_zero = 50
- remainder (68) >= distance_to_zero (50)? YES
- **Crossings: 0 + 1 = 1**
- New position: (50 - 68) % 100 = -18 % 100 = 82
- **Part 2 total: 1**
- Part 1: position == 0? NO

### Rotation 2: L30 from position 82
- complete_circles = 30 / 100 = 0
- remainder = 30 % 100 = 30
- Direction: Left
- distance_to_zero = 82
- remainder (30) >= distance_to_zero (82)? NO
- **Crossings: 0**
- New position: (82 - 30) % 100 = 52
- **Part 2 total: 1**
- Part 1: position == 0? NO

### Rotation 3: R48 from position 52
- complete_circles = 48 / 100 = 0
- remainder = 48 % 100 = 48
- Direction: Right
- distance_to_zero = 100 - 52 = 48
- remainder (48) >= distance_to_zero (48)? YES
- **Crossings: 0 + 1 = 1**
- New position: (52 + 48) % 100 = 0
- **Part 2 total: 2**
- Part 1: position == 0? YES (count = 1)

### Rotation 4: L5 from position 0
- complete_circles = 5 / 100 = 0
- remainder = 5 % 100 = 5
- Direction: Left
- distance_to_zero = 0
- current_position == 0, so no remainder crossing
- **Crossings: 0**
- New position: (0 - 5) % 100 = -5 % 100 = 95
- **Part 2 total: 2**
- Part 1: position == 0? NO

### Rotation 5: R60 from position 95
- complete_circles = 60 / 100 = 0
- remainder = 60 % 100 = 60
- Direction: Right
- distance_to_zero = 100 - 95 = 5
- remainder (60) >= distance_to_zero (5)? YES
- **Crossings: 0 + 1 = 1**
- New position: (95 + 60) % 100 = 55
- **Part 2 total: 3**
- Part 1: position == 0? NO

### Rotation 6: L55 from position 55
- complete_circles = 55 / 100 = 0
- remainder = 55 % 100 = 55
- Direction: Left
- distance_to_zero = 55
- remainder (55) >= distance_to_zero (55)? YES
- **Crossings: 0 + 1 = 1**
- New position: (55 - 55) % 100 = 0
- **Part 2 total: 4**
- Part 1: position == 0? YES (count = 2)

### Rotation 7: L1 from position 0
- complete_circles = 1 / 100 = 0
- remainder = 1 % 100 = 1
- Direction: Left
- distance_to_zero = 0
- current_position == 0, so no remainder crossing
- **Crossings: 0**
- New position: (0 - 1) % 100 = -1 % 100 = 99
- **Part 2 total: 4**
- Part 1: position == 0? NO

### Rotation 8: L99 from position 99
- complete_circles = 99 / 100 = 0
- remainder = 99 % 100 = 99
- Direction: Left
- distance_to_zero = 99
- remainder (99) >= distance_to_zero (99)? YES
- **Crossings: 0 + 1 = 1**
- New position: (99 - 99) % 100 = 0
- **Part 2 total: 5**
- Part 1: position == 0? YES (count = 3)

### Rotation 9: R14 from position 0
- complete_circles = 14 / 100 = 0
- remainder = 14 % 100 = 14
- Direction: Right
- distance_to_zero = 100 - 0 = 100
- remainder (14) >= distance_to_zero (100)? NO
- **Crossings: 0**
- New position: (0 + 14) % 100 = 14
- **Part 2 total: 5**
- Part 1: position == 0? NO

### Rotation 10: L82 from position 14
- complete_circles = 82 / 100 = 0
- remainder = 82 % 100 = 82
- Direction: Left
- distance_to_zero = 14
- remainder (82) >= distance_to_zero (14)? YES
- **Crossings: 0 + 1 = 1**
- New position: (14 - 82) % 100 = -68 % 100 = 32
- **Part 2 total: 6**
- Part 1: position == 0? NO

### Final Results
- **Part 1 (lands on 0): 3** ✓
- **Part 2 (crosses through 0): 6** ✓

The algorithm correctly produces the expected answer!

## Large Rotation Test Cases

### Test Case 1: R1000 from position 50
- complete_circles = 1000 / 100 = 10
- remainder = 1000 % 100 = 0
- Direction: Right
- Crossings from complete circles: 10
- Remainder is 0, so no additional crossing
- **Total crossings: 10** ✓
- Final position: (50 + 1000) % 100 = 50

### Test Case 2: L200 from position 10
- complete_circles = 200 / 100 = 2
- remainder = 200 % 100 = 0
- Direction: Left
- Crossings from complete circles: 2
- Remainder is 0, so no additional crossing
- **Total crossings: 2** ✓
- Final position: (10 - 200) % 100 = -190 % 100 = 10

### Test Case 3: R100 from position 0
- complete_circles = 100 / 100 = 1
- remainder = 100 % 100 = 0
- Direction: Right
- Crossings from complete circles: 1
- Remainder is 0, so no additional crossing
- **Total crossings: 1** ✓
- Final position: (0 + 100) % 100 = 0

## Implementation Notes for All Languages

### Language-Agnostic Considerations

1. **Integer Division:** Ensure your language performs integer division (floor division) for `amount / 100`
   - Most languages: `amount / 100` with integer types
   - Python: `amount // 100`
   - Some languages may need explicit conversion or floor function

2. **Modulo Operation:** Handle negative results correctly for Left rotations
   - Most languages' modulo with negative dividends: ensure result is in [0, 99]
   - May need: `((position - amount) % 100 + 100) % 100`

3. **Direction Handling:** Use pattern matching or conditional logic appropriate to your language
   - Rust: `match direction { Direction::Left => ..., Direction::Right => ... }`
   - Gleam: `case direction { Left -> ..., Right -> ... }`
   - Roc: `when direction is Left -> ..., Right -> ...`

4. **Zero Check:** For Left rotations, explicitly check `current_position > 0` before checking remainder crossing

### Testing Strategy

**Minimal Test Suite (2-8 tests recommended):**

1. **No crossing:** R10 from position 50 → 0 crossings
2. **Simple right crossing:** R10 from position 95 → 1 crossing
3. **Simple left crossing:** L10 from position 5 → 1 crossing
4. **Large rotation:** R1000 from position 50 → 10 crossings
5. **Exact multiple:** R100 from position 0 → 1 crossing
6. **Starting at zero (right):** R10 from position 0 → 0 crossings
7. **Starting at zero (left):** L10 from position 0 → 0 crossings
8. **End at zero:** L10 from position 10 → 1 crossing

## Algorithm Complexity

**Time Complexity:** O(1)
- All operations are constant time (division, modulo, comparison)
- No loops or iterations required

**Space Complexity:** O(1)
- Only stores a few integer variables
- No data structures needed

## Cross-Language Validation

All five language implementations (Rust, Gleam, Roc, Carbon, Bosque) must:

1. Use this exact algorithm logic (language idioms may vary)
2. Produce identical results for all test cases
3. Handle the division approach for rotations > 100
4. Correctly distinguish between Left and Right rotations
5. Return the same integer count for any given input

**Expected Outputs:**
- Sample input: `{"part1": 3, "part2": 6}`
- Real input: `{"part1": REDACTED, "part2": <TBD>}` (all languages must agree)

## Summary

This algorithm efficiently counts zero crossings during dial rotations by:

1. Breaking rotations into complete circles (each crosses zero once) and a remainder
2. Checking if the remainder rotation crosses zero based on direction and current position
3. Handling all edge cases (starting at zero, exact multiples, large rotations) correctly
4. Producing results in O(1) time and space

The manual trace confirms the algorithm produces the expected answer of 6 for the sample input, validating the mathematical approach.
