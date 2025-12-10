# Raw Idea: Day 6 Part 2 - Cephalopod Math (Right-to-Left Column Reading)

## Feature Description

Implement a solution for Advent of Code Day 6 Part 2. This involves:
- Reading math problems arranged in columns (right-to-left)
- Each number is in its own column with most significant digit at top, least significant at bottom
- Problems are separated by columns of spaces
- The operator (*, +) is at the bottom of each problem column
- Calculate each problem's result and sum them for the grand total

## Example

```
123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +
```

Reading right-to-left by columns:
- Rightmost: 4 + 431 + 623 = 1058
- Second: 175 * 581 * 32 = 3253600
- Third: 8 + 248 + 369 = 625
- Leftmost: 356 * 24 * 1 = 8544
- Grand total: 3263827

## Date Initiated
2025-12-09
