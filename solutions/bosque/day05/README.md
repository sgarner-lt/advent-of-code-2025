# Bosque Day 05 - Cafeteria Ingredient Freshness

## Problem Summary

Determine how many available ingredient IDs fall within fresh ingredient ID ranges.

**Input Format:**
- Group 1: Fresh ingredient ID ranges (format: "start-end")
- Blank line separator
- Group 2: Available ingredient IDs (single numbers)

**Algorithm:**
1. Parse fresh ingredient ranges from Group 1
2. Parse available ingredient IDs from Group 2
3. For each available ID, check if it falls within any fresh range (inclusive)
4. Count the number of fresh ingredients

## Implementation Details

### Bosque Implementation (`solution.bsq`)

The Bosque file contains the complete algorithm with proper type signatures:

- `parseRange(line: String): {start: Int, end: Int}?` - Parse range format "start-end"
- `parseId(line: String): Int?` - Parse single ID
- `isFresh(id: Int, ranges: List<{start: Int, end: Int}>): Bool` - Check if ID is fresh
- `solve(input: String): {part1: Int, part2: Int?}` - Main solution function

### Python Wrapper (`runner.py`)

Since Bosque lacks I/O support, the Python wrapper:
- Reads input from stdin
- Mirrors all Bosque functions
- Outputs JSON format: `{"part1": <count>, "part2": null}`

### Unit Tests (`test_bosque_day05.py`)

8 comprehensive tests covering:
- Range parsing (simple and large numbers)
- ID parsing
- Freshness checking (in range, outside range, multiple ranges, boundaries)
- Integration test with sample input

## Running the Solution

```bash
# Run with sample input
cat /Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day05/input-sample.txt | python3 runner.py

# Run unit tests
python3 test_bosque_day05.py
```

## Expected Results

**Sample Input:**
```
3-5
10-14
16-20
12-18

1
5
8
11
17
32
```

**Expected Output:**
```json
{"part1": 3, "part2": null}
```

**Explanation:**
- ID 1: spoiled (not in any range)
- ID 5: fresh (in range 3-5)
- ID 8: spoiled
- ID 11: fresh (in range 10-14)
- ID 17: fresh (in ranges 16-20 and 12-18)
- ID 32: spoiled

Result: 3 fresh ingredients

## Algorithm Complexity

- Time: O(n * m) where n = number of available IDs, m = number of ranges
- Space: O(n + m) for storing ranges and IDs
- Simple nested loop approach (not optimized for Part 2 extensibility)
