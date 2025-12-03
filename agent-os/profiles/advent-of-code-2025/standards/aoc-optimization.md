# Advent of Code Optimization Standards

## When to Optimize

- Start with a working solution first
- Optimize only if:
  - Solution takes > 15 seconds
  - You get timeout errors
  - Part 2 scales up the problem significantly

## Common Optimization Techniques

### 1. Memoization / Caching
- Cache expensive function results
- Use dictionaries for O(1) lookups
- Consider LRU cache for recursive functions

### 2. Data Structure Selection
- Use sets for membership testing
- Use deques for efficient queue operations
- Consider heaps for priority queues
- Use appropriate data types (int vs float)

### 3. Algorithm Improvements
- Replace brute force with mathematical solutions
- Use binary search where applicable
- Consider dynamic programming for recursive problems
- Apply graph algorithms (Dijkstra, BFS, DFS) when appropriate

### 4. Early Termination
- Break loops when answer is found
- Use conditions to skip unnecessary iterations
- Prune search space in backtracking

### 5. Space vs Time Tradeoffs
- Sometimes using more memory speeds up computation
- Consider precomputing values
- Use lookup tables when appropriate

## Complexity Goals

- Aim for polynomial time or better
- Watch for nested loops over large datasets
- Be cautious of exponential algorithms

## Python-Specific Tips

- Use built-in functions (they're optimized in C)
- List comprehensions often faster than loops
- `collections` module has efficient data structures
- `itertools` for efficient iteration patterns
- Consider `numpy` for numerical operations on large datasets
