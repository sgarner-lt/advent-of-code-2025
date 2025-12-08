# Day 3 Analysis: Comparing 4 Language Implementations

## Overview

This analysis compares 4 language implementations (Rust, Gleam, Carbon, Bosque) for Advent of Code 2025 Day 3, which involves extracting maximum digit pairs and greedy k-digit selection from digit strings. Part 1 identifies the maximum 2-digit number by selecting any two positions from a digit string while maintaining order (e.g., "987" yields pairs 98, 97, 87 with maximum 98). Part 2 extracts the maximum 12-digit number using a greedy algorithm that selects the largest available digit at each position within a constrained search window. Unlike Day 1's numeric operations, Day 2's pattern detection, and Day 4's 2D grid traversal, Day 3 focuses heavily on string processing, character-to-integer conversion, combinatorial iteration patterns, and greedy selection algorithms - directly testing Phase 3 Learning Goals (string manipulation expressiveness).

**Note:** Gleam and Bosque only implement Part 1 (Part 2 returns null). Rust and Carbon provide complete solutions for both parts.

**Lines of Code Summary:**
- Gleam: 111 LOC (Part 1 only, most concise)
- Carbon: 163 LOC (complete, character-based I/O)
- Bosque: 266 LOC (Part 1 only, includes 8 tests)
- Rust: 286 LOC (complete with 18 comprehensive tests)

## Readability Comparison

**Winner: Gleam** - Most concise at 111 LOC with elegant tail recursion and functional composition for pair extraction.

**Rust** (286 LOC, including 18 tests) offers excellent clarity through nested loops and explicit character validation:
```rust
fn extract_pairs(line: &str) -> Vec<i32> {
    let mut pairs = Vec::new();
    let chars: Vec<char> = line.chars().collect();

    if chars.len() < 2 {
        return pairs;
    }

    for i in 0..chars.len() {
        for j in (i + 1)..chars.len() {
            let first_digit = chars[i];
            let second_digit = chars[j];

            if first_digit.is_ascii_digit() && second_digit.is_ascii_digit() {
                let pair_str = format!("{}{}", first_digit, second_digit);
                if let Ok(pair) = pair_str.parse::<i32>() {
                    pairs.push(pair);
                }
            }
        }
    }

    pairs
}
```

Rust's Part 2 greedy algorithm demonstrates clear window-based maximum selection:
```rust
fn extract_max_k_digits(line: &str, k: usize) -> Option<i64> {
    let chars: Vec<char> = line.chars().collect();
    let mut result = String::new();
    let mut current_pos = 0;

    // For each position in the k-digit result
    for i in 0..k {
        let remaining_digits = k - i;
        // Calculate search window: must leave enough digits to complete the k-digit number
        let search_end = chars.len() - remaining_digits + 1;

        // Find the maximum digit in the search window [current_pos, search_end)
        let mut max_digit = chars[current_pos];
        let mut max_pos = current_pos;

        for pos in current_pos..search_end {
            if chars[pos] > max_digit {
                max_digit = chars[pos];
                max_pos = pos;
            }
        }

        result.push(max_digit);
        current_pos = max_pos + 1;
    }

    result.parse::<i64>().ok()
}
```

**Gleam** (111 LOC) leverages tail recursion beautifully for combinatorial iteration:
```gleam
pub fn extract_pairs(line: String) -> List(Int) {
  let chars = string.to_graphemes(line)
  do_extract_pairs(chars, 0, [])
}

// Recursive helper to extract all pairs
fn do_extract_pairs(chars: List(String), i: Int, acc: List(Int)) -> List(Int) {
  case chars {
    [] -> acc
    [first, ..rest] -> {
      // Extract pairs starting at position i with all positions after it
      let new_pairs = extract_pairs_from_position(first, rest, i + 1, [])
      do_extract_pairs(rest, i + 1, list.append(acc, new_pairs))
    }
  }
}

// Extract all pairs starting from a given first digit with remaining digits
fn extract_pairs_from_position(
  first_digit: String,
  remaining: List(String),
  j: Int,
  acc: List(Int),
) -> List(Int) {
  case remaining {
    [] -> acc
    [second_digit, ..rest] -> {
      let pair_str = first_digit <> second_digit
      case int.parse(pair_str) {
        Ok(pair_value) -> {
          let new_acc = [pair_value, ..acc]
          extract_pairs_from_position(first_digit, rest, j + 1, new_acc)
        }
        Error(_) -> extract_pairs_from_position(first_digit, rest, j + 1, acc)
      }
    }
  }
}
```

**Carbon** (163 LOC) implements real string processing using character-based I/O with ASCII arithmetic:
```carbon
fn ProcessLine(part1_sum: i64*, part2_sum: i64*) -> bool {
  var digit_buffer: array(i32, 100);
  var len: i32 = 0;
  var c: i32 = ReadChar();

  // Read digits into buffer with ASCII conversion
  while (len < 100) {
    if (c == Core.EOF() or c == 0x0A or c == 0x0D) {
      break;
    }

    if (c >= 0x30 and c <= 0x39) {
      digit_buffer[len] = c - 0x30;  // ASCII to integer
      len = len + 1;
    }

    c = ReadChar();
  }

  // Part 1: Extract max 2-digit pair
  var max_pair: i64 = 0;
  if (len >= 2) {
    var i: i32 = 0;
    while (i < len) {
      var j: i32 = i + 1;
      while (j < len) {
        let first: i64 = digit_buffer[i] as i64;
        let second: i64 = digit_buffer[j] as i64;
        let pair: i64 = first * 10 + second;
        if (pair > max_pair) {
          max_pair = pair;
        }
        j = j + 1;
      }
      i = i + 1;
    }
  }
  *part1_sum += max_pair;

  // Part 2: Greedy 12-digit extraction
  var max_12_digit: i64 = 0;
  if (len >= 12) {
    var result: i64 = 0;
    var current_pos: i32 = 0;
    var pos_in_result: i32 = 0;

    while (pos_in_result < 12) {
      let remaining_digits: i32 = 12 - pos_in_result;
      let search_end: i32 = len - remaining_digits + 1;

      var max_digit: i32 = digit_buffer[current_pos];
      var max_pos: i32 = current_pos;
      var pos: i32 = current_pos;

      while (pos < search_end) {
        if (digit_buffer[pos] > max_digit) {
          max_digit = digit_buffer[pos];
          max_pos = pos;
        }
        pos = pos + 1;
      }

      result = result * 10 + (max_digit as i64);
      current_pos = max_pos + 1;
      pos_in_result = pos_in_result + 1;
    }
    max_12_digit = result;
  }
  *part2_sum += max_12_digit;

  return true;
}
```

**Bosque** (266 LOC) uses while loops with string APIs for character access:
```bosque
function extractPairs(line: String): List<Int> {
    var len = String::length(line);
    var pairs = List::create<Int>();

    if(len < 2i) {
        return pairs;
    }

    var i = 0i;
    // Nested loops to generate all pairs (i, j) where i < j
    while(i < len) {
        var j = i + 1i;
        while(j < len) {
            // Extract characters at positions i and j
            var firstDigit = String::substring(line, i, i + 1i);
            var secondDigit = String::substring(line, j, j + 1i);

            // Concatenate to form 2-digit number
            var pairStr = String::concat(firstDigit, secondDigit);
            var pairValue = String::parseInt(pairStr);

            if(pairValue != none) {
                pairs = List::add<Int>(pairs, pairValue);
            }

            j = j + 1i;
        }
        i = i + 1i;
    }

    return pairs;
}
```

**Readability Ranking:**
1. **Gleam** - Tail recursion elegantly expresses combinatorial iteration without nested loop boilerplate
2. **Rust** - Nested `for` loops make pair generation obvious; greedy window constraints crystal clear
3. **Carbon** - Character buffer approach works but ASCII arithmetic and manual JSON output add verbosity
4. **Bosque** - While loops with `String::substring` are functional but more verbose than Rust's direct indexing

## Correctness Evaluation

**Winner: Rust** - 18 automated unit tests covering pair extraction edge cases, greedy algorithm validation, and full integration testing.

All implementations correctly handle:
- Combinatorial pair generation with position constraints (i < j)
- Character-to-integer conversion and numeric parsing
- Maximum value selection from generated pairs
- Part 2 greedy algorithm window constraints (Rust and Carbon only)
- Edge cases (strings shorter than 2 characters, empty lines)

**Test Coverage:**
- **Rust**: 18 automated unit tests using `#[test]` framework - Part 1 (8 tests) + Part 2 (7 tests) + Integration (3 tests)
- **Carbon**: Real implementation with container-based testing
- **Bosque**: 8 test functions defined in source (Part 1 only)
- **Gleam**: Functional validation with Result types, but no explicit Part 2 tests due to incomplete implementation

Rust's Part 1 test coverage demonstrates comprehensive validation:
```rust
#[test]
fn test_extract_pairs_simple() {
    let pairs = extract_pairs("987");
    assert!(pairs.contains(&98)); // positions 0,1
    assert!(pairs.contains(&97)); // positions 0,2
    assert!(pairs.contains(&87)); // positions 1,2
}

#[test]
fn test_sample_input_line2() {
    // "811111111111119" → max = 89 (positions 0 and 14: '8' and '9')
    let line = "811111111111119";
    let pairs = extract_pairs(line);
    let max = find_max(&pairs);
    assert_eq!(max, Some(89));
}
```

Rust's Part 2 test coverage validates greedy algorithm correctness line-by-line:
```rust
#[test]
fn test_extract_max_k_digits_line3() {
    // "234234234234278" yields 434234234278
    // Remove 2, 3, 2 from start
    let line = "234234234234278";
    let result = extract_max_k_digits(line, 12);
    assert_eq!(result, Some(434234234278));
}

#[test]
fn test_solve_returns_tuple() {
    let input = "987654321111111\n811111111111119\n234234234234278\n818181911112111";
    let (part1, part2) = solve(input);
    assert_eq!(part1, 357);
    assert_eq!(part2, 3121910778619);
}
```

Bosque's tests validate basic pair extraction but lack Part 2 coverage:
```bosque
// Test 6: Process line from sample input (line 2)
// "811111111111119" - positions (0,14): '8' and '9' = 89
function test_processLineSample2(): Bool {
    var lineMax = processLine("811111111111119");
    _assert(lineMax == 89i);
    return true;
}

// Test 8: Sample input produces expected answer (357)
function test_sampleInputComplete(): Bool {
    var sample = "987654321111111\n811111111111119\n234234234234278\n818181911112111";
    var result = solve(sample);
    _assert(result.part1 == 357i);
    _assert(result.part2 == none);
    return true;
}
```

**Key Insight:** Rust's comprehensive test suite (18 tests) provides confidence in both algorithms. Bosque's 8 tests demonstrate algorithmic correctness for Part 1 despite experimental status. Gleam and Bosque's incomplete Part 2 implementations indicate either stdlib limitations or time constraints rather than algorithmic capability gaps.

## Complexity Analysis

**Most Concise: Gleam** (111 LOC) - Functional composition with tail recursion eliminates nested loop boilerplate for pair generation.

**Most Verbose: Rust** (286 LOC) - But this includes 18 comprehensive tests (~100 LOC). Without tests, Rust would be ~186 LOC, making it comparable to Carbon's 163 LOC.

**Lines of Code:**
1. Gleam: 111 (Part 1 only, functional style)
2. Carbon: 163 (complete with character I/O)
3. Bosque: 266 (Part 1 only, includes 8 tests)
4. Rust: 286 (complete with 18 tests)

**Important Context:** LOC is a weak metric compared to maintainability and algorithmic clarity. Rust's higher LOC includes comprehensive test coverage that adds significant value for correctness validation. Gleam's lower LOC is partly due to incomplete Part 2 implementation. Carbon's LOC includes manual JSON output formatting character-by-character.

**Abstraction Levels:**
- **Rust**: Imperative nested `for` loops with range syntax (`for i in 0..len`, `for j in (i+1)..len`)
- **Gleam**: Functional tail recursion with accumulator pattern (`do_extract_pairs`)
- **Carbon**: Imperative while loops with manual index tracking (`i = i + 1`)
- **Bosque**: Imperative while loops with explicit List API calls (`List::add`, `List::get`)

**Character-to-Integer Conversion Approaches:**
- **Rust**: `char.is_ascii_digit()` validation + `format!()` macro + `parse::<i32>()` - high-level, safe, idiomatic
- **Gleam**: `string.to_graphemes()` + `int.parse()` - functional, explicit, returns Result types
- **Carbon**: ASCII arithmetic `c - 0x30` - low-level, efficient, requires manual validation
- **Bosque**: `String::substring()` for single chars + `String::concat()` + `String::parseInt()` - verbose but explicit

**Algorithmic Complexity:**
- Part 1 pair generation: O(n^2) for all implementations (nested iteration over positions)
- Part 2 greedy selection: O(n*k) where k=12 (Rust and Carbon only)
- String concatenation overhead varies: Rust's `format!()` is optimized, Gleam's `<>` operator is functional, Carbon's manual accumulation is explicit

## Language Features

**NEW String Processing Features (Not Seen in Days 1-2-4):**

**Rust** leveraged:
- **Character validation**: `char.is_ascii_digit()` - type-safe digit checking without ASCII arithmetic
- **String formatting macro**: `format!("{}{}", first_digit, second_digit)` - concise pair string construction
- **Character type operations**: Direct `char > char` comparison in greedy algorithm (`chars[pos] > max_digit`)
- **64-bit integer parsing**: `result.parse::<i64>().ok()` - handles 12-digit numbers cleanly
- **Range syntax for nested loops**: `for j in (i + 1)..chars.len()` - expresses combinatorial constraint directly

**Gleam** leveraged:
- **Grapheme decomposition**: `string.to_graphemes()` - Unicode-aware character extraction
- **String concatenation operator**: `first_digit <> second_digit` - functional pipe-friendly syntax
- **Tail recursion for nested iteration**: `do_extract_pairs()` and `extract_pairs_from_position()` - eliminates mutable loop state
- **Result-based parsing**: `int.parse(pair_str)` returns `Result(Int, _)` - explicit error handling without exceptions
- **List append for accumulation**: `list.append(acc, new_pairs)` - functional collection building

**Carbon** leveraged:
- **Fixed-size digit buffer**: `array(i32, 100)` - avoids dynamic string allocation
- **ASCII arithmetic for conversion**: `c - 0x30` - direct character-to-integer transformation
- **Manual numeric accumulation**: `result * 10 + (max_digit as i64)` - explicit digit concatenation without string parsing
- **Character-based I/O**: `Core.ReadChar()` and `Core.PrintChar()` - low-level but functional
- **Pointer parameters for mutation**: `part1_sum: i64*` - enables stateful accumulation across line processing

**Bosque** leveraged:
- **String substring for single characters**: `String::substring(line, i, i + 1i)` - treats characters as strings
- **String concatenation**: `String::concat(firstDigit, secondDigit)` - functional pair formation
- **Integer parsing from strings**: `String::parseInt(pairStr)` - returns `Int?` (optional type)
- **List APIs for dynamic arrays**: `List::create`, `List::add`, `List::get`, `List::size` - functional collection operations
- **Optional type handling**: `if(pairValue != none)` - explicit null checks for parsing failures

**Key Insight - Combinatorial Iteration Patterns:**
- **Rust**: Nested `for` loops with range expressions (`(i+1)..len`) are most readable
- **Gleam**: Tail recursion with two helpers (`do_extract_pairs` + `extract_pairs_from_position`) elegantly avoids mutable state
- **Carbon**: While loops with manual index increment (`i = i + 1`) are most explicit but verbose
- **Bosque**: While loops with List APIs (`List::size`, `List::get`) work but require more ceremony

**Key Insight - Greedy Window Constraints:**
- **Rust**: `search_end = chars.len() - remaining_digits + 1` - clear constraint calculation
- **Carbon**: `search_end = len - remaining_digits + 1` - identical algorithm, identical clarity
- Neither Gleam nor Bosque implemented Part 2, indicating potential complexity or time constraints

## Clarity and Conciseness Evaluation

**Ranking:**
1. **Gleam** - Clearest functional expression of combinatorial iteration without mutable loop state
2. **Rust** - Excellent balance of clarity and explicitness; nested loops make algorithm obvious
3. **Carbon** - Character buffer approach works but ASCII arithmetic and manual accumulation add cognitive load
4. **Bosque** - String APIs functional but verbose (`String::substring` for single characters, explicit List operations)

**Sub-Rankings for Specific Patterns:**

**Character-to-Integer Conversion Winner: Rust**
- Rust: `char.is_ascii_digit() + format!() + parse::<i32>()` - highest level, most readable
- Gleam: `string.to_graphemes() + <> operator + int.parse()` - functional and clear
- Bosque: `String::substring() + String::concat() + String::parseInt()` - explicit but verbose
- Carbon: `c - 0x30` - lowest level, requires ASCII knowledge

**Combinatorial Iteration Winner: Gleam**
- Gleam: Tail recursion with two helpers eliminates nested loop boilerplate
- Rust: `for i in 0..len { for j in (i+1)..len }` - most readable imperative style
- Carbon: `while (i < len) { while (j < len) }` - explicit but boilerplate-heavy
- Bosque: Same as Carbon but with List API calls adding ceremony

**Greedy Algorithm Clarity Winner: Rust** (Carbon very close)
- Rust: Window constraint calculation and max finding are crystal clear
- Carbon: Identical algorithm structure with comparable clarity
- Gleam/Bosque: Not implemented

**String Building/Concatenation Winner: Rust**
- Rust: `format!("{}{}", first, second)` - most concise
- Gleam: `first <> second` - functional elegance
- Bosque: `String::concat(first, second)` - explicit function call
- Carbon: Manual numeric accumulation `first * 10 + second` - no string building needed

**Key Factors:**
- **Stdlib Support**: Rust and Gleam had complete string manipulation. Bosque had working string APIs. Carbon required character-level operations.
- **Syntax Clarity**: Gleam's tail recursion made functional iteration elegant. Rust's nested `for` loops made imperative iteration obvious.
- **Abstraction Level**: Rust operated on `char` types with stdlib methods. Carbon operated on ASCII values with arithmetic.

## Scalability Discussion

**Viable for Future String-Heavy Problems:**
- **Rust**: Fully viable - comprehensive string stdlib, `char` type operations, efficient parsing, excellent for text processing
- **Gleam**: Fully viable - functional string manipulation scales well, grapheme support for Unicode, tail recursion handles complex iteration

**Improved from Day 2:**
- **Carbon**: MORE viable than Day 2 suggested - character buffer approach worked well for Day 3's digit extraction, ASCII arithmetic sufficient for numeric strings. However, pure string pattern matching (Day 2 style) remains limited.

**Partially Viable:**
- **Bosque**: Working string APIs (`String::substring`, `String::concat`, `String::parseInt`) proved sufficient for Part 1's combinatorial iteration. Part 2 incompleteness may indicate:
  - Greedy algorithm complexity with while-loop iteration becomes tedious
  - Time constraints rather than capability gaps
  - Experimental status makes complex algorithms riskier to implement

**Language Maturity Impact on String Processing:**
- Day 3's character-level operations revealed **different stdlib requirements** than Day 2's pattern detection:
  - Day 2 required substring slicing and repetition checking
  - Day 3 required character iteration, digit extraction, and numeric parsing
- Rust and Gleam handled both with zero workarounds
- Carbon's character I/O approach worked better for Day 3 (digit extraction) than Day 2 (pattern detection)
- Bosque's string APIs proved functional but manual iteration is verbose

**Day 3 vs Day 2 String Processing Comparison:**
- **Day 2 (pattern repetition)**: Required string slicing (`substring`), repetition (`repeat`), equality checks
- **Day 3 (digit extraction)**: Required character iteration, combinatorial pair generation, numeric parsing
- **Carbon**: Day 2 required Python wrapper; Day 3 succeeded with character buffer + ASCII arithmetic
- **Bosque**: Day 2 worked with string APIs; Day 3 Part 1 worked similarly but Part 2 not implemented

**Future Considerations for String-Heavy Days:**
- Parsing problems (regex, tokenization) will favor Rust's comprehensive string stdlib
- Character-level operations (anagrams, frequency analysis) work well in Carbon's buffer approach
- Combinatorial string problems benefit from Gleam's tail recursion or Rust's nested loops
- Bosque's string APIs work but manual while-loop iteration becomes tedious for complex algorithms

## Lessons Learned

**Key Insights:**
1. **Combinatorial iteration has multiple viable patterns** - Rust's nested `for` loops, Gleam's tail recursion, and Carbon/Bosque's while loops all correctly generate (i,j) pairs where i < j, but readability differs significantly
2. **Character-to-integer conversion reveals stdlib maturity** - Rust's `char.is_ascii_digit()` + `format!()` + `parse()` is highest level; Carbon's `c - 0x30` is lowest level but sufficient for digit strings
3. **Greedy algorithms expose iterative complexity** - Part 2's window constraint logic (`search_end = len - remaining_digits + 1`) required careful index tracking; Rust and Carbon succeeded, Gleam/Bosque skipped
4. **Tail recursion elegantly expresses nested iteration** - Gleam's two-helper pattern (`do_extract_pairs` + `extract_pairs_from_position`) eliminates mutable loop state without sacrificing clarity
5. **String building vs numeric accumulation trade-offs** - Rust builds strings then parses; Carbon accumulates digits numerically without intermediate strings; both work, numeric is more efficient
6. **Test coverage matters more for algorithmic complexity** - Rust's 18 tests caught edge cases in greedy window logic; manual validation becomes impractical as algorithm complexity grows

**What Day 3 Revealed (Not Apparent in Days 1-2-4):**

**1. Combinatorial Iteration Expressiveness:**
- **Nested Loops (Rust)**: `for i in 0..len { for j in (i+1)..len }` - most readable for imperative programmers
- **Tail Recursion (Gleam)**: Two helpers with accumulators - most elegant for functional programmers
- **While Loops (Carbon/Bosque)**: Manual index tracking (`i = i + 1`) - most explicit but boilerplate-heavy
- **Key Insight**: Language paradigm (imperative vs functional) affects clarity more than syntax differences

**2. Character-to-Integer Conversion Ecosystem:**
- **High-Level (Rust)**: `char` type + validation methods + format macros + parsing - safest, most idiomatic
- **Mid-Level (Gleam)**: Grapheme iteration + functional concatenation + Result-based parsing - safe, functional
- **Stdlib-Level (Bosque)**: String APIs for characters + concatenation + parseInt - verbose but explicit
- **Low-Level (Carbon)**: ASCII arithmetic on integer values - efficient but requires numeric literacy

**3. Greedy Selection Algorithms with Constrained Windows:**
- **Window Constraint**: `search_end = len - remaining_digits + 1` ensures enough digits remain to complete k-digit number
- **Position Tracking**: After selecting digit at position `max_pos`, next search starts at `max_pos + 1`
- **Complexity**: Greedy algorithms require careful state management; Rust's imperative style and Carbon's while loops both succeeded
- **Functional Challenge**: Neither Gleam nor Bosque implemented Part 2 - greedy state tracking may be less natural in functional/experimental contexts

**4. String Indexing Approaches:**
- **Rust**: Direct character vector indexing (`chars[i]`) - fast, requires length validation
- **Gleam**: Grapheme list decomposition with pattern matching - safe, functional
- **Carbon**: Array buffer with ASCII integers - avoids string operations entirely
- **Bosque**: `String::substring(line, i, i+1)` - treats characters as single-char strings

**5. Large Integer Parsing (12-digit numbers):**
- **Rust**: `i64` with `parse::<i64>()` - stdlib handles large number parsing cleanly
- **Carbon**: Manual accumulation `result * 10 + digit` with `i64` - explicit numeric building
- **Gleam/Bosque**: Not tested due to incomplete Part 2

**Actionable Takeaways:**
1. **Choose iteration style based on problem**: Nested loops for combinatorial generation, tail recursion for functional purity, while loops for explicit control
2. **Prefer high-level char operations when available**: Rust's `char.is_ascii_digit()` beats ASCII arithmetic for readability
3. **Test greedy algorithms thoroughly**: Window constraint bugs are subtle; comprehensive test suites (Rust's 18 tests) provide confidence
4. **Consider numeric accumulation over string parsing**: Carbon's `result * 10 + digit` avoids string allocation overhead
5. **Tail recursion can replace nested loops elegantly**: Gleam's two-helper pattern demonstrates functional alternatives to imperative nested iteration
6. **String APIs enable algorithm correctness**: Bosque's working stdlib proved sufficient for Part 1 despite experimental status

**Recommendation for Future Days:**
Focus on **Rust** for comprehensive string processing (parsing, regex, complex text manipulation) and **Gleam** for functional string transformations. **Carbon** is viable for character-level operations (digit extraction, frequency counting) but limited for pattern matching. **Bosque** is viable for algorithm demonstration but manual iteration is tedious for complex problems.

**Revised Assessment:**
- **Rust**: Confirmed as primary language for all problem types
- **Gleam**: Confirmed as primary language for functional approaches
- **Carbon**: Upgraded viability for character-level string operations (Day 3) vs pattern matching limitations (Day 2)
- **Bosque**: Maintains "Viable with I/O wrapper" status; string APIs work but complex algorithms (greedy selection) become impractical with manual while-loop iteration
