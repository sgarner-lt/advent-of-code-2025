# Day 5 Analysis: Comparing 3 Language Implementations

## Overview

This analysis compares 3 language implementations (Rust, Gleam, Bosque) for Advent of Code 2025 Day 5, which involves checking ingredient freshness based on ID ranges. Part 1 determines how many available ingredient IDs fall within fresh ingredient ID ranges (range membership checking). Part 2 counts the total number of unique ingredient IDs across all fresh ranges by merging overlapping intervals. Unlike Day 1's numeric dial rotations, Day 2-3's string manipulation, and Day 4's 2D grid traversal, Day 5 focuses heavily on range representation, range overlap detection, set operations on ranges, and integer range iteration patterns - directly testing Phase 3 Learning Goals (range operation expressiveness and interval algorithm implementation). Only Rust provides a complete working solution; Gleam has a minimal stub, and Bosque provides algorithmic documentation with Python execution wrapper.

**Lines of Code Summary:**
- Gleam: 29 LOC (incomplete stub, both parts return "0")
- Bosque: 383 LOC in solution.bsq (algorithmic documentation) + 261 LOC Python runner with actual implementation
- Rust: 335 LOC (complete with 21 comprehensive tests)

**Important Context:** LOC reflects completeness, not quality. Rust is fully implemented with extensive tests. Gleam is a minimal stub indicating either complexity threshold or time constraints. Bosque documents the algorithm in detail but requires Python execution for actual runtime due to stdlib limitations.

## Readability Comparison

**Winner: Rust** - Only complete implementation with clear tuple-based range representation and explicit adaptive algorithm selection.

**Rust** (335 LOC, including 21 tests) offers excellent range operation clarity through simple tuple representation:
```rust
/// Parse a range line in format "start-end"
/// Returns Some((start, end)) if valid, None otherwise
fn parse_range(line: &str) -> Option<(i64, i64)> {
    let line = line.trim();
    if line.is_empty() {
        return None;
    }

    let parts: Vec<&str> = line.split('-').collect();
    if parts.len() != 2 {
        return None;
    }

    let start = parts[0].parse::<i64>().ok()?;
    let end = parts[1].parse::<i64>().ok()?;

    // Validate that start <= end
    if start > end {
        return None;
    }

    Some((start, end))
}

/// Check if an ID is fresh (falls within any of the given ranges)
/// Ranges are inclusive: range_start <= id <= range_end
fn is_fresh(id: i64, ranges: &[(i64, i64)]) -> bool {
    for &(start, end) in ranges {
        if id >= start && id <= end {
            return true;
        }
    }
    false
}
```

Rust's Part 2 algorithm demonstrates clear adaptive strategy selection:
```rust
/// Merge overlapping ranges and count unique IDs
/// For small ranges (< 100k IDs), uses HashSet for exact counting
/// For large ranges, merges intervals and counts mathematically
fn count_unique_ids(ranges: &[(i64, i64)]) -> i64 {
    if ranges.is_empty() {
        return 0;
    }

    // Calculate total potential IDs across all ranges
    let total_ids: i64 = ranges.iter().map(|(start, end)| end - start + 1).sum();

    // For small datasets (< 100k IDs total), use HashSet approach for simplicity
    if total_ids < 100_000 {
        let mut unique_ids = HashSet::new();
        for &(start, end) in ranges {
            for id in start..=end {
                unique_ids.insert(id);
            }
        }
        return unique_ids.len() as i64;
    }

    // For large datasets, merge overlapping intervals and count mathematically
    // Sort ranges by start position
    let mut sorted_ranges = ranges.to_vec();
    sorted_ranges.sort_by_key(|r| r.0);

    // Merge overlapping intervals
    let mut merged: Vec<(i64, i64)> = Vec::new();
    for &(start, end) in &sorted_ranges {
        if merged.is_empty() {
            merged.push((start, end));
        } else {
            let last_idx = merged.len() - 1;
            let (last_start, last_end) = merged[last_idx];

            // Check if current range overlaps or is adjacent to last merged range
            if start <= last_end + 1 {
                // Merge by extending the end if needed
                merged[last_idx] = (last_start, last_end.max(end));
            } else {
                // No overlap, add as new range
                merged.push((start, end));
            }
        }
    }

    // Count total unique IDs across merged ranges
    merged.iter().map(|(start, end)| end - start + 1).sum()
}
```

**Gleam** (29 LOC) provides only a minimal stub with no actual implementation:
```gleam
fn part1(input: String) -> String {
  // TODO: Implement Part 1 solution
  "0"
}

fn part2(input: String) -> String {
  // TODO: Implement Part 2 solution
  "0"
}
```

**Bosque** (383 LOC in solution.bsq) documents the algorithm with extensive inline comments but requires Python execution:
```bosque
// Parse a range string in format "start-end" to extract start and end values
// Arguments:
// - line: String in format "start-end" (e.g., "3-5" or "20362219004570-27230899748695")
//
// Returns: Option of tuple {start: Int, end: Int} or none if invalid
function parseRange(line: String): {start: Int, end: Int}? {
    // Trim whitespace
    var trimmed = String::trim(line);

    // Check for empty string
    if(String::length(trimmed) == 0i) {
        return none;
    }

    // Split by hyphen
    var parts = String::split(trimmed, "-");

    // Must have exactly 2 parts
    if(List::size<String>(parts) != 2i) {
        return none;
    }

    // Parse both parts as integers
    var startStr = String::trim(List::get<String>(parts, 0i));
    var endStr = String::trim(List::get<String>(parts, 1i));

    var start = String::parseInt(startStr);
    var end = String::parseInt(endStr);

    // Both must parse successfully
    if(start == none || end == none) {
        return none;
    }

    return {start: start, end: end};
}

// Check if an ingredient ID is fresh (falls within any of the given ranges)
// Ranges are inclusive: start <= id <= end
function isFresh(id: Int, ranges: List<{start: Int, end: Int}>): Bool {
    var i = 0i;

    while(i < List::size<{start: Int, end: Int}>(ranges)) {
        var range = List::get<{start: Int, end: Int}>(ranges, i);

        // Check if id falls within this range (inclusive)
        if(id >= range.start && id <= range.end) {
            return true;
        }

        i = i + 1i;
    }

    return false;
}
```

Bosque's Python runner (261 LOC) provides the actual executable implementation:
```python
def is_fresh(ingredient_id, ranges):
    """
    Check if an ingredient ID is fresh (falls within any of the given ranges)
    Ranges are inclusive: start <= id <= end

    Mirrors: function isFresh(id: Int, ranges: List<{start: Int, end: Int}>): Bool
    """
    for start, end in ranges:
        if start <= ingredient_id <= end:
            return True
    return False

def count_unique_ids(ranges):
    """
    Count unique ingredient IDs across all ranges
    Handles overlapping ranges by merging intervals

    Mirrors: function countUniqueIds(ranges: List<{start: Int, end: Int}>): Int
    """
    if not ranges:
        return 0

    # Sort ranges by start position
    sorted_ranges = sorted(ranges, key=lambda r: r[0])

    # Merge overlapping ranges
    merged = []
    current_start, current_end = sorted_ranges[0]

    for start, end in sorted_ranges[1:]:
        # Check if current range overlaps or is adjacent to the last merged range
        if start <= current_end + 1:
            # Merge by extending the end if needed
            current_end = max(current_end, end)
        else:
            # No overlap, save the current merged range and start a new one
            merged.append((current_start, current_end))
            current_start, current_end = start, end

    # Don't forget to add the last merged range
    merged.append((current_start, current_end))

    # Count total unique IDs across merged ranges
    total = 0
    for start, end in merged:
        count = end - start + 1
        total += count

    return total
```

**Readability Ranking:**
1. **Rust** - Clear tuple-based ranges, explicit adaptive algorithm, comprehensive inline documentation
2. **Bosque** - Extensive algorithmic documentation with record types, but Python wrapper adds complexity
3. **Gleam** - Cannot rank fairly due to incomplete implementation

**Key Observations:**
- **Range Representation**: Rust uses tuples `(i64, i64)`, Bosque uses record types `{start: Int, end: Int}`, Python wrapper uses tuples `(start, end)`
- **Tuple Destructuring**: Rust's `for &(start, end) in ranges` is most concise; Python's `for start, end in ranges` is equally clear
- **Boundary Checking**: All implementations use identical pattern `id >= start && id <= end` for inclusive range checking
- **Algorithm Selection**: Only Rust implements adaptive strategy (HashSet vs interval merging based on 100k threshold)

## Correctness Evaluation

**Winner: Rust** - 21 automated unit tests covering range parsing validation, membership checking, overlapping ranges, adjacent ranges, single-point ranges, empty inputs, and large dataset handling (1 million IDs).

All functional implementations correctly handle:
- Range parsing with validation (`start > end` check returns None/none)
- Inclusive range boundary checking (`start <= id <= end`)
- Part 1 linear scan algorithm for membership checking
- Part 2 interval merging algorithm with adjacency detection
- Large integer ranges (i64 for ranges spanning billions of IDs)

**Test Coverage:**
- **Rust**: 21 automated unit tests using `#[test]` framework
  - Part 1: 9 tests covering parsing, boundary conditions, overlapping ranges
  - Part 2: 10 tests covering single ranges, multiple ranges, overlaps, adjacency, large datasets
  - Integration: 2 tests covering sample input and empty inputs
- **Bosque**: 8 test function stubs defined in solution.bsq (mirrored by Python test suite)
- **Gleam**: No tests due to incomplete implementation

Rust's comprehensive test coverage demonstrates validation of critical edge cases:
```rust
#[test]
fn test_parse_range_invalid() {
    assert!(parse_range("5-3").is_none()); // start > end
    assert!(parse_range("abc").is_none()); // not a range
    assert!(parse_range("").is_none()); // empty
}

#[test]
fn test_is_fresh_at_boundaries() {
    let ranges = vec![(3, 5), (10, 14)];
    assert!(is_fresh(3, &ranges));  // Start of first range
    assert!(is_fresh(5, &ranges));  // End of first range
    assert!(is_fresh(10, &ranges)); // Start of second range
    assert!(is_fresh(14, &ranges)); // End of second range
    assert!(!is_fresh(2, &ranges)); // Just before first range
    assert!(!is_fresh(6, &ranges)); // Just after first range
    assert!(!is_fresh(9, &ranges)); // Between ranges
}

#[test]
fn test_count_unique_ids_large_ranges() {
    // Test with very large ranges that would be impractical to enumerate
    let ranges = vec![(1, 1_000_000), (500_000, 1_500_000)];
    let count = count_unique_ids(&ranges);
    // Range 1-1000000 has 1,000,000 IDs
    // Range 500000-1500000 overlaps from 500000-1000000 (500,001 IDs overlap)
    // So unique IDs = 1,000,000 + 500,000 = 1,500,000
    assert_eq!(count, 1_500_000);
}

#[test]
fn test_count_unique_ids_adjacent_ranges() {
    let ranges = vec![(3, 5), (6, 8)];
    let count = count_unique_ids(&ranges);
    assert_eq!(count, 6); // IDs: 3, 4, 5, 6, 7, 8
}
```

Bosque's test stubs document expected behavior even though execution requires Python:
```bosque
// Test 8: Sample input produces expected results (part1 = 3, part2 = 14)
function test_sampleInput(): Bool {
    var sample = "3-5\n10-14\n16-20\n12-18\n\n1\n5\n8\n11\n17\n32";
    var result = solve(sample);
    _assert(result.part1 == 3i);
    _assert(result.part2 == 14i);
    return true;
}
```

**Key Insight:** Rust's comprehensive testing (21 tests) catches subtle edge cases like adjacent ranges `(3, 5)` and `(6, 8)` which must be merged when `start <= last_end + 1` because they are contiguous. This adjacency detection (`+ 1` in the condition) is crucial for correct union counting.

## Complexity Analysis

**Most Concise: Gleam** (29 LOC) - But this is meaningless since it's an incomplete stub.

**Most Complete: Rust** (335 LOC) - Includes 21 comprehensive tests accounting for ~100 LOC. Without tests, Rust would be ~235 LOC.

**Lines of Code:**
1. Gleam: 29 (incomplete stub, cannot fairly compare)
2. Bosque Python runner: 261 (actual implementation)
3. Rust (without tests): ~235 (complete implementation)
4. Rust (with tests): 335 (production-quality)
5. Bosque solution.bsq: 383 (algorithmic documentation)

**Important Context:** LOC is a weak metric compared to completeness and maintainability. Rust's higher LOC includes:
- Adaptive algorithm selection (HashSet vs interval merging)
- Comprehensive test coverage validating correctness
- Large number handling with i64 type
- Extensive inline documentation

**Algorithmic Complexity:**
- **Part 1 (Range Membership)**: O(n * m) where n = number of IDs to check, m = number of ranges
  - Simple linear scan through ranges for each ID
  - No optimization needed since checking individual IDs

- **Part 2 (Unique ID Counting)**:
  - **Rust HashSet approach**: O(total_ids) where total_ids = sum of all range sizes
    - Used for small datasets (< 100k IDs)
    - Enumerates all IDs and inserts into HashSet for deduplication
    - Simple but memory-intensive for large ranges

  - **Rust interval merging approach**: O(r log r + r) where r = number of ranges
    - Used for large datasets (>= 100k IDs)
    - O(r log r) for sorting ranges by start position
    - O(r) for single-pass merge with adjacency checking
    - O(r) for counting unique IDs across merged ranges
    - Efficient for billion-element ranges without enumeration

  - **Bosque/Python approach**: O(r log r + r) interval merging only
    - Always uses interval merging regardless of dataset size
    - No adaptive threshold like Rust

**Abstraction Levels:**
- **Rust**: Direct tuple representation `(i64, i64)` with pattern matching destructuring `for &(start, end)`
- **Bosque**: Record types `{start: Int, end: Int}` with field access `.start`, `.end`
- **Python**: Native tuples `(start, end)` with unpacking `for start, end in ranges`

**Adaptive Algorithm Selection (Rust Only):**
```rust
let total_ids: i64 = ranges.iter().map(|(start, end)| end - start + 1).sum();

if total_ids < 100_000 {
    // HashSet approach: simple, memory-intensive
    let mut unique_ids = HashSet::new();
    for &(start, end) in ranges {
        for id in start..=end {
            unique_ids.insert(id);
        }
    }
    return unique_ids.len() as i64;
}

// Interval merging: complex, memory-efficient
// ... (merge algorithm)
```

This threshold-based selection demonstrates production-quality problem-solving: choose brute-force simplicity for small inputs, optimized algorithms for large inputs.

## Language Features

**NEW Range Operation Features (Not Seen in Days 1-4):**

**Rust** leveraged:
- **Tuple-based range representation**: `(i64, i64)` - simple, concise, no custom types needed
- **64-bit integer type for large ranges**: `i64` handles ranges spanning billions (e.g., `20362219004570-27230899748695`)
- **HashSet for deduplication**: `HashSet<i64>` enables simple enumerate-and-deduplicate strategy for small datasets
- **Inclusive range iteration**: `for id in start..=end` - note `..=` operator for inclusive end boundary
- **Sorting with closure**: `sorted_ranges.sort_by_key(|r| r.0)` - sort by first tuple element (start position)
- **Option type for parse validation**: `parse_range()` returns `Option<(i64, i64)>` with early return on validation failure
- **Pattern matching on slices**: `for &(start, end) in ranges` - dereferences tuple in pattern for borrowing

**Gleam** leveraged (from stub only):
- **Result type for file I/O error handling**: `Result(String, simplifile.FileError)`
- **Pattern matching on Result**: `case input { Ok(content) -> ... Error(_) -> ... }`
- **No evidence of range operation stdlib support** in the incomplete stub

**Bosque** leveraged:
- **Record types for range representation**: `{start: Int, end: Int}` - named fields more self-documenting than tuples
- **Optional return types**: `parseRange()` returns `{start: Int, end: Int}?` with `?` suffix indicating optionality
- **List operations**: `List::get<String>()`, `List::size<String>()`, `List::add<T>()` - functional collection APIs
- **String operations**: `String::split()`, `String::trim()`, `String::parseInt()` - working string stdlib for parsing
- **Integer literals with `i` suffix**: `0i`, `1i`, `2i` - explicit integer type annotation
- **While loops with manual index tracking**: `var i = 0i; while(i < size) { i = i + 1i; }` - no foreach iteration
- **Python interop pattern**: Bosque documents algorithm, Python wrapper executes due to stdlib/runtime limitations

**Python (Bosque runner) leveraged:**
- **Native tuple unpacking**: `for start, end in ranges` - cleaner than indexing
- **Lambda for sorting**: `sorted(ranges, key=lambda r: r[0])` - functional sorting without mutating
- **List comprehension would be idiomatic but not used**: Runner uses explicit loops for clarity

**Key Insight - Range Representation Idioms:**
- **Rust tuples** `(i64, i64)`: Most concise, leverages pattern matching, no ceremony
- **Bosque records** `{start: Int, end: Int}`: Most self-documenting, field names explicit
- **Python tuples** `(start, end)`: Most Pythonic, unpacking is clean

**Key Insight - No Built-in Range/Interval Types:**
None of the three languages used explicit Range or Interval types from stdlib. All implementations represented ranges as tuples or records with manual algorithms. This contrasts with languages like Ruby (which has built-in Range class with `cover?` method) or Python's range() function (which is limited to iteration, not set operations).

## Clarity and Conciseness Evaluation

**Ranking:**
1. **Rust** - Best balance of clarity, completeness, and explicitness; adaptive algorithm demonstrates production thinking
2. **Bosque (conceptual)** - Clear algorithmic documentation with record types, but split execution model adds friction
3. **Gleam** - Cannot rank due to incomplete implementation

**Sub-Rankings for Specific Patterns:**

**Range Representation Winner: Rust**
- Rust: `(i64, i64)` tuples - most concise while remaining clear
- Bosque: `{start: Int, end: Int}` records - most self-documenting but verbose
- Python: `(start, end)` tuples - equally concise as Rust

**Range Membership Checking Winner: Tie (Rust/Python)**
- Rust: `for &(start, end) in ranges { if id >= start && id <= end }` - pattern matching in loop
- Python: `for start, end in ranges: if start <= id <= end` - chained comparison is elegant
- Bosque: `while(i < size) { var range = List::get(...); if(id >= range.start && ...) }` - manual iteration is verbose

**Interval Merging Winner: Rust**
- Rust: In-place vector mutation with clear adjacency check `if start <= last_end + 1`
- Python: Accumulator pattern with `current_start, current_end` tracking - equally clear
- Bosque: Documents algorithm but List::add pattern doesn't allow in-place updates

**Algorithm Documentation Winner: Bosque**
- Bosque: 150+ lines of inline algorithmic documentation explaining every step
- Rust: Concise doc comments focusing on "why" rather than "what"
- Python: Docstrings explaining algorithm mirrors

**Adaptive Strategy Selection Winner: Rust (Only Implementation)**
```rust
// Explicit threshold with clear reasoning
let total_ids: i64 = ranges.iter().map(|(start, end)| end - start + 1).sum();

if total_ids < 100_000 {
    // Simple approach for small datasets
    // ... HashSet enumeration
} else {
    // Optimized approach for large datasets
    // ... interval merging
}
```

This demonstrates **algorithmic maturity**: choosing appropriate strategy based on input characteristics rather than one-size-fits-all solution.

**Key Factors:**
- **Completeness**: Only Rust provides working implementation; Bosque documents but requires Python; Gleam is incomplete
- **Abstraction Level**: Rust operates on direct tuples; Bosque on record types; Python on native tuples
- **Algorithm Sophistication**: Only Rust implements adaptive strategy selection

## Scalability Discussion

**Viable for Future Range/Interval Problems:**
- **Rust**: Fully viable - adaptive algorithms handle both small and large datasets efficiently; i64 handles billion-element ranges; interval merging avoids enumeration overhead

**First Incomplete Solution:**
- **Gleam**: Limited viability revealed - first incomplete solution across Days 1-5 indicates either:
  - Range operation complexity threshold exceeded functional approach
  - Stdlib gaps for interval algorithms
  - Time constraints prevented implementation
  - Problem didn't align with functional paradigm strengths

**Conceptual Viability Only:**
- **Bosque**: Partially viable - algorithm documentation works, but execution requires Python wrapper. For interval-heavy problems, the split model adds maintenance overhead and debugging friction.

**Range Operation Complexity Impact:**
- Day 5's range operations revealed **different algorithm requirements** than Days 1-4:
  - Day 1: Simple modulo arithmetic
  - Day 2: String pattern detection
  - Day 3: Combinatorial character iteration
  - Day 4: 2D grid spatial navigation
  - Day 5: Interval merging with adjacency detection, set operations on continuous ranges

- **Rust** handled range operations with zero workarounds:
  - Adaptive strategy for small vs large datasets
  - Mathematical counting without enumeration for billion-element ranges
  - Comprehensive testing including large dataset validation

- **Gleam's** first incomplete solution across 5 days may indicate:
  - Functional languages excel at transformations, not interval algorithms?
  - Stdlib gaps for sorting, merging, or large number handling?
  - Time investment decision (diminishing returns for complex problems)?

- **Bosque's** documentation-first approach works but:
  - Python wrapper handles actual range merging
  - Bosque stdlib lacks sorting functionality (noted in comments)
  - List::add doesn't support in-place updates for merging

**Future Considerations for Interval-Heavy Days:**
- **Parsing problems** (range unions, date intervals) favor Rust's adaptive algorithms
- **Scheduling problems** (time slot conflicts) require efficient interval merging
- **Memory-constrained problems** favor mathematical counting over enumeration
- Rust's threshold-based strategy selection (100k IDs) demonstrates production-quality optimization

**Day 5 vs Days 1-4 Complexity Progression:**
- **Day 1**: All languages succeeded (basic arithmetic)
- **Day 2**: All languages succeeded (string operations)
- **Day 3**: Bosque and Gleam skipped Part 2 (greedy algorithms)
- **Day 4**: All languages succeeded (2D grids)
- **Day 5**: Only Rust succeeded fully (interval algorithms)

**Pattern Observation**: As algorithmic complexity increases (greedy selection in Day 3, interval merging in Day 5), languages with comprehensive stdlib and testing frameworks (Rust) maintain momentum while experimental languages (Gleam, Bosque) hit viability limits.

## Lessons Learned

**Key Insights:**
1. **Adaptive algorithm selection is production-quality thinking** - Rust's threshold-based choice (HashSet vs interval merging at 100k IDs) demonstrates choosing appropriate strategy based on input characteristics rather than one-size-fits-all
2. **Interval merging requires careful adjacency checking** - The `start <= last_end + 1` condition is subtle: `+ 1` detects contiguous ranges like `(3, 5)` and `(6, 8)` which should merge into `(3, 8)`
3. **Mathematical counting beats enumeration for large ranges** - Rust counts billion-element ranges with `end - start + 1` arithmetic instead of enumerating billions of IDs
4. **Range representation idioms vary significantly** - Tuples `(i64, i64)` (Rust) vs records `{start: Int, end: Int}` (Bosque) both work; tuples are more concise, records are more self-documenting
5. **Comprehensive testing crucial for interval algorithms** - Rust's 21 tests caught edge cases like adjacent ranges, single-point ranges, overlapping ranges, and empty inputs
6. **Inclusive range boundaries require consistent `>=` and `<=` checks** - All implementations correctly use `id >= start && id <= end` pattern for inclusive boundary semantics

**What Day 5 Revealed (Not Apparent in Days 1-4):**

**1. Adaptive Algorithm Design:**
- **Rust** demonstrated threshold-based strategy selection for the first time:
  - Small datasets (< 100k IDs): Simple HashSet enumeration with deduplication
  - Large datasets (>= 100k IDs): Interval merging with mathematical counting
- **Key Learning**: Production code should choose algorithms based on input characteristics, not use one-size-fits-all approaches
- **Contrast with Days 1-4**: Previous days used single algorithm approaches; Day 5's dual strategy demonstrates optimization maturity

**2. Large Integer Range Handling:**
- **Rust's i64 type** efficiently handles ranges spanning billions (e.g., `20362219004570-27230899748695`)
- **Mathematical counting** `end - start + 1` avoids explicit enumeration for billion-element ranges
- **Memory efficiency**: Interval merging uses O(r) memory for r ranges, not O(n) for n IDs
- **Contrast with Days 1-4**: Previous days operated on small numeric ranges or string lengths; Day 5 introduced billion-scale ranges requiring algorithmic efficiency

**3. Interval Merging Algorithm:**
- **Sorting by start position**: `sorted_ranges.sort_by_key(|r| r.0)` enables single-pass merge
- **Adjacency detection**: `if start <= last_end + 1` catches both overlapping and contiguous ranges
- **Boundary extension**: `merged[last_idx] = (last_start, last_end.max(end))` extends merged range dynamically
- **Contrast with Days 1-4**: Day 4 had spatial adjacency in grids, but Day 5's 1D interval adjacency requires different checking logic

**4. Set Operations on Continuous Ranges:**
- **Enumerate-and-deduplicate** (HashSet): Simple but memory-intensive, iterates through all IDs
- **Merge-and-count** (interval merging): Complex but memory-efficient, counts without enumeration
- **Trade-off**: Simplicity vs efficiency depends on dataset size
- **Contrast with Days 1-4**: Previous days didn't require set operations on continuous ranges; Day 5 introduced union computation over overlapping intervals

**5. Gleam's First Incomplete Solution:**
- **Days 1-4**: Gleam successfully implemented all solutions (Day 1: 141 LOC, Day 2: 265 LOC, Day 3: 111 LOC Part 1 only, Day 4: 209 LOC)
- **Day 5**: Complete stub (29 LOC) indicates hitting complexity threshold
- **Possible reasons**:
  - Interval algorithms less natural in functional paradigm?
  - Stdlib lacks sorting or interval merging patterns?
  - Time constraints exceeded value for complex problems?
- **Key Learning**: Functional languages excel at transformations and pattern matching (Days 1-4 strengths) but may face friction with imperative-style interval algorithms (Day 5 challenge)

**6. Bosque's Documentation-First Approach:**
- **383 LOC** of algorithmic documentation with extensive inline comments explaining every step
- **Python wrapper** provides actual execution (261 LOC) mirroring Bosque design
- **Split model**: Bosque documents algorithm intent, Python executes due to stdlib limitations (no sorting, limited List APIs)
- **Contrast with Days 1-4**: Previous days' Bosque implementations also used Python wrappers, but Day 5's interval merging revealed **sorting** as a critical stdlib gap (noted in comments: "not implemented in Bosque - done in Python")

**7. Range Representation Without Built-in Types:**
- **No language used built-in Range/Interval types**: All implementations used tuples or records with manual algorithms
- **Tuple vs Record trade-off**:
  - Rust tuples `(i64, i64)`: Concise, pattern matching friendly, but indices are positional
  - Bosque records `{start: Int, end: Int}`: Self-documenting with named fields, but verbose
- **Contrast with Days 1-4**: Previous days used built-in types (integers, strings, lists/vectors); Day 5 required custom range representation revealing language design choices

**Actionable Takeaways:**
1. **Implement adaptive algorithms for scalable solutions**: Use simple approaches for small inputs, optimized algorithms for large inputs; choose strategy based on input size metrics
2. **Test interval algorithms thoroughly**: Edge cases like adjacent ranges `(3, 5)` and `(6, 8)`, single-point ranges `(5, 5)`, and overlapping ranges `(12, 18)` and `(16, 20)` require comprehensive validation
3. **Prefer mathematical counting over enumeration for large ranges**: `end - start + 1` arithmetic beats iterating billions of IDs
4. **Use tuples for concise range representation**: `(i64, i64)` is clear enough without ceremony of custom types or records
5. **Remember `+ 1` in adjacency checks**: `start <= last_end + 1` merges both overlapping and contiguous ranges
6. **Consider functional language trade-offs**: Gleam succeeded on transformation problems (Days 1-4) but struggled with interval algorithms (Day 5) - match language strengths to problem types

**Recommendation for Future Days:**
Focus on **Rust** for interval-heavy problems, scheduling algorithms, range queries, and problems requiring adaptive optimization strategies. **Gleam** remains viable for transformation problems, parsing, and functional composition tasks. **Bosque** is viable for algorithm documentation but requires Python execution wrapper, adding maintenance overhead for complex problems.

**Revised Assessment:** Day 5 confirmed Rust as the primary language for algorithmically complex problems requiring adaptive strategies, large number handling, and comprehensive testing. Gleam's incomplete solution indicates complexity threshold reached for interval algorithms in functional paradigm. Bosque's documentation-first approach works but Python dependency creates split execution model unsuitable for production use.
