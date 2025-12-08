# Day 2 Analysis: Comparing 4 Language Implementations

## Overview

This analysis compares 4 language implementations (Rust, Gleam, Carbon, Bosque) for Advent of Code 2025 Day 2, which involves detecting invalid product IDs through pattern repetition. Part 1 identifies IDs where the string splits exactly in half with both halves identical (e.g., "11", "1212", "123123"). Part 2 extends this to detect any pattern repeated 2 or more times (e.g., "111", "565656", "2121212121"). Unlike Day 1's numeric dial rotations, Day 2 focuses heavily on string manipulation, pattern detection, and range iteration - directly testing Phase 2 Learning Goals (iteration, conditionals, collection manipulation). All implementations correctly solve both parts.

## Readability Comparison

**Winner: Gleam** - Most concise at 265 LOC with elegant functional patterns and crystal-clear string manipulation.

**Rust** (503 LOC, including extensive tests) offers excellent pattern detection clarity:
```rust
fn is_invalid_id(number_str: &str) -> bool {
    let len = number_str.len();

    if len % 2 != 0 {
        return false;
    }

    let half = len / 2;
    let first_half = &number_str[..half];
    let second_half = &number_str[half..];

    first_half == second_half
}
```

**Gleam** (265 LOC) leverages functional composition beautifully:
```gleam
pub fn is_invalid_id(number_str: String) -> Bool {
  let len = string.length(number_str)

  case len % 2 {
    0 -> {
      let half = len / 2
      let first_half = string.slice(number_str, 0, half)
      let second_half = string.slice(number_str, half, half)

      first_half == second_half
    }
    _ -> False
  }
}
```

**Carbon** (225 LOC) implements real string pattern detection using character-based I/O with manual digit extraction. **Bosque** (456 LOC) uses while loops for pattern checking but has working string APIs (`String::substring`, `String::concat`):
```bosque
function isInvalidId(numberStr: String): Bool {
    var len = String::length(numberStr);

    if(len % 2i != 0i) {
        return false;
    }

    var half = len / 2i;
    var firstHalf = String::substring(numberStr, 0i, half);
    var secondHalf = String::substring(numberStr, half, len);

    return firstHalf == secondHalf;
}
```

## Correctness Evaluation

**Winner: Rust** - 24 automated unit tests covering pattern detection, range processing, and full integration.

All implementations correctly handle:
- String splitting and comparison
- Pattern repetition detection (Part 2)
- Range iteration and accumulation
- Edge cases (odd lengths, single digits, complex patterns)

**Test Coverage:**
- **Rust**: 24 automated unit tests using `#[test]` framework
- **Carbon**: Real implementation with container-based testing
- **Bosque**: 26 test functions defined in source
- **Gleam**: Result types for error handling, functional validation

Rust's Part 2 algorithm demonstrates clarity:
```rust
fn is_invalid_id_part2(number_str: &str) -> bool {
    let len = number_str.len();

    for pattern_length in 1..=(len / 2) {
        if len % pattern_length != 0 {
            continue;
        }

        let pattern = &number_str[..pattern_length];
        let repetitions = len / pattern_length;
        let expected = pattern.repeat(repetitions);

        if expected == number_str {
            return true;
        }
    }

    false
}
```

Gleam uses tail recursion elegantly:
```gleam
fn check_pattern_length(number_str: String, len: Int, pattern_length: Int) -> Bool {
  case pattern_length > len / 2 {
    True -> False
    False -> {
      case len % pattern_length == 0 {
        True -> {
          let pattern = string.slice(number_str, 0, pattern_length)
          let repetitions = len / pattern_length
          let expected = string.repeat(pattern, repetitions)

          case expected == number_str {
            True -> True
            False -> check_pattern_length(number_str, len, pattern_length + 1)
          }
        }
        False -> check_pattern_length(number_str, len, pattern_length + 1)
      }
    }
  }
}
```

## Complexity Analysis

**Most Concise: Gleam** (265 LOC) - Functional composition eliminates boilerplate for iteration and accumulation.

**Most Verbose: Rust** (503 LOC) - But this includes 24 comprehensive tests. Without tests, Rust would be ~220 LOC, making it competitive with Gleam.

**Lines of Code:**
1. Carbon: 225 (real implementation with character I/O)
2. Gleam: 265 (most concise including tests)
3. Bosque: 456 (working string APIs + test suite)
4. Rust: 503 (comprehensive implementation + 24 tests)

**Abstraction Levels:**
- **Rust**: Imperative with `for` loops and range iteration (`start..=end`)
- **Gleam**: Functional with tail recursion and `list.fold` for accumulation
- **Carbon**: Character-by-character parsing with manual digit extraction
- **Bosque**: Imperative with while loops and working string operations

Gleam's range processing shows functional elegance:
```gleam
pub fn solve_both_parts(input: String) -> Result(#(Int, Int), String) {
  case parse_ranges(input) {
    Ok(ranges) -> {
      let part1_sum = list.fold(ranges, 0, fn(acc, range) {
        let #(start, end) = range
        acc + process_range(start, end)
      })

      let part2_sum = list.fold(ranges, 0, fn(acc, range) {
        let #(start, end) = range
        acc + process_range_part2(start, end)
      })

      Ok(#(part1_sum, part2_sum))
    }
    Error(err) -> Error(err)
  }
}
```

## Language Features

**Rust** leveraged:
- String slicing (`&number_str[..half]`)
- Range iteration with inclusive end (`for num in start..=end`)
- String repeat method (`pattern.repeat(repetitions)`)
- Comprehensive test framework (`#[cfg(test)]`)

**Gleam** leveraged:
- Tail recursion for pattern length checking (`check_pattern_length`)
- `list.fold` for range accumulation (functional composition)
- `string.slice` and `string.repeat` for pattern manipulation
- Tuple destructuring (`let #(start, end) = range`)
- Result types for error propagation

**Carbon** leveraged:
- Algorithm structure demonstration despite stdlib limitations
- While loops for iteration patterns
- Python wrapper for actual string operations
- Manual test framework structure

**Bosque** leveraged:
- Record types for structured returns (`{part1: Int, part2: Int}`)
- Working string stdlib (`String::substring`, `String::concat`)
- While loops for iteration
- Try-catch for experimental API fallbacks

## Clarity and Conciseness Evaluation

**Ranking:**
1. **Gleam** - Clearest expression of pattern detection with tail recursion and functional composition
2. **Rust** - Excellent balance of clarity and explicitness; `for` loops make iteration obvious
3. **Bosque** - Working string APIs enable clear algorithm implementation
4. **Carbon** - Algorithm intent buried under Python wrapper requirements

**Pattern Elegance Winners:**
- **String Slicing**: Rust's `&str[..half]` syntax is most concise, but Gleam's `string.slice(str, start, length)` is most explicit
- **Iteration Patterns**: Rust's `for num in start..=end` is clearest; Gleam's tail recursion is most elegant but less obvious
- **Conditional Logic**: Gleam's `case` pattern matching is most expressive; Rust's `if/match` combination is most familiar
- **Collection Manipulation**: Gleam's `list.fold` wins for functional elegance; Rust's imperative accumulation is more straightforward

**Key Factors:**
- **Stdlib Support**: Rust and Gleam had complete string manipulation. Bosque had working APIs. Carbon required Python wrapper.
- **Syntax Clarity**: Gleam's pattern matching made data flow obvious. Rust's imperative style made algorithm steps explicit.
- **Boilerplate**: Carbon required extensive documentation explaining workarounds. Bosque needed manual loop iteration.

## Scalability Discussion

**Viable for Future Days:**
- **Rust**: Fully viable - comprehensive stdlib, excellent for string-heavy problems
- **Gleam**: Fully viable - functional style scales well, complete string manipulation support

**Improved from Day 1:**
- **Bosque**: Working string APIs (`String::substring`, `String::concat`) make it MORE viable than Day 1 suggested. Still needs Python wrapper for I/O, but algorithm implementation is clean.

**Limited Viability:**
- **Carbon**: Critical limitations blocking - no native string operations makes pattern detection impractical without Python wrapper

**Language Maturity Impact on String Problems:**
- Rust and Gleam handled Day 2's string manipulation with zero workarounds
- Bosque's string stdlib proved functional enough for pattern detection (improvement over Day 1 assessment)
- Carbon's lack of string slicing forced complete delegation to Python wrapper
- As AoC problems get more complex (parsing, regex patterns, string transformations), stdlib completeness becomes critical

**Day 2 vs Day 1 Comparison:**
- Day 1 (numeric operations): All languages could handle basic integer arithmetic
- Day 2 (string manipulation): Clear winners emerged based on string stdlib maturity
- Carbon's limitations more apparent with strings than with numbers
- Bosque surprised with functional string APIs despite experimental status

## Lessons Learned

**Key Insights:**
1. **String stdlib maturity matters more than numeric operations** - Carbon could handle Day 1's arithmetic but completely failed at Day 2's string manipulation without Python wrapper
2. **Bosque more capable than expected** - Working string APIs (`String::substring`, `String::concat`, `String::length`) make it viable for string problems, contradicting Day 1's limited viability assessment
3. **Functional vs imperative both excel** - Gleam's tail recursion and Rust's `for` loops were equally clear; choice is preference, not capability
4. **Test framework value increases with complexity** - Rust's 24 automated tests caught edge cases; manual testing becomes impractical as problem complexity grows
5. **Pattern detection requires string slicing** - Languages without substring operations (Carbon) cannot implement pattern matching algorithms natively

**Actionable Takeaways:**
- Prioritize languages with mature string stdlib for text-heavy AoC problems
- Tail recursion (Gleam) vs imperative loops (Rust) are both readable for iteration
- Carbon's experimental status makes it unsuitable for string manipulation problems
- Bosque's verification-oriented design includes functional string operations - more viable than Day 1 suggested
- `list.fold` pattern (Gleam) vs manual accumulation (Rust) both work well; functional composition scales better for complex transformations

**Recommendation for Future Days:**
Focus on **Rust** and **Gleam** as primary languages. **Bosque** is viable for algorithm demonstration despite I/O limitations (working string APIs are sufficient). **Carbon** should be deprioritized for any problems requiring string manipulation until native string stdlib matures.

**Revised Assessment:** Bosque upgraded from "Limited Viability" to "Viable with I/O wrapper" based on functional string manipulation capabilities demonstrated in Day 2.
