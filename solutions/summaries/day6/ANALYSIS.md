# Day 6 Analysis: Trash Compactor Math Worksheet - Comparing 4 Language Implementations

## Overview

This analysis compares 4 language implementations (Rust, Python/Bosque, Gleam, Carbon) for Advent of Code 2025 Day 6, which involves parsing and evaluating a grid of vertical math problems. Part 1 transposes horizontal rows into vertical columns and evaluates each column as a separate math problem (multiplication or addition). Part 2 introduces a novel column-based digit extraction algorithm with operator-dependent patterns and right-to-left interpretation, forming new numbers from digit positions to calculate a transformed result. All implementations correctly solve both parts.

## Problem Summary

**Part 1**: Parse a grid of numbers and operators, transpose rows into columns, evaluate each vertical column as a math problem, and sum all results.

**Part 2**: Apply column-based digit extraction where:
- For multiplication columns: extract digits from RIGHT (position 0 = rightmost)
- For addition columns: extract digits from LEFT (position 0 = leftmost), then REVERSE the extracted numbers
- Form new numbers from extracted digits and evaluate with the original operator
- Sum all column results for the final answer

**Sample Input**:
```
123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +
```

**Part 1 Answer**: 4,277,556 (sum of: 123*45*6 + 328+64+98 + 51*387*215 + 64+23+314)

**Part 2 Answer**: 3,263,827 (column-based digit extraction creates new numbers)

## Part 2 Algorithm Walkthrough

Using the first multiplication column [123, 45, 6, *] as an example:

**Step 1**: Find max width = 3 (from "123")

**Step 2**: Extract digits at each position from RIGHT:
- Position 0 (rightmost): "3" from 123, "5" from 45, "6" from 6 → forms "356"
- Position 1: "2" from 123, "4" from 45 → forms "24"
- Position 2 (leftmost): "1" from 123 → forms "1"

**Step 3**: Apply operator: 356 * 24 * 1 = 8,544

For addition columns, extraction is from LEFT and then the numbers are REVERSED before evaluation.

## Readability Comparison

**Winner: Gleam** - Most concise at 341 LOC with elegant functional patterns and clear separation of concerns.

**Rust** (462 LOC, including 13 tests) demonstrates excellent clarity with comprehensive documentation:
```rust
/// Extract digits at a specific column position from a problem column
///
/// Part 2 uses operator-dependent digit extraction patterns:
/// - Multiplication (*): Extract from RIGHT (position 0 = rightmost digit)
///   Example: For numbers [123, 45, 6] at position 0: "3", "5", "6" -> "356"
/// - Addition (+): Extract from LEFT (position 0 = leftmost digit)
///   Example: For numbers [328, 64, 98] at position 0: "3", "6", "9" -> "369"
fn extract_column_digits(problem: &[String], column_position: usize, operation: char) -> String {
    let mut digits = String::new();
    let num_rows = problem.len().saturating_sub(1);

    for row_idx in 0..num_rows {
        let number = &problem[row_idx];
        let num_len = number.len();

        if operation == '*' {
            // Multiplication: extract from right
            if column_position < num_len {
                let char_index = num_len - 1 - column_position;
                if let Some(ch) = number.chars().nth(char_index) {
                    digits.push(ch);
                }
            }
        } else {
            // Addition: extract from left
            if column_position < num_len {
                if let Some(ch) = number.chars().nth(column_position) {
                    digits.push(ch);
                }
            }
        }
    }
    digits
}
```

**Python** (340 LOC) offers clear, readable implementation with comprehensive docstrings:
```python
def extract_column_digits(problem, column_position, operation):
    """
    Extract digits at a specific column position from a problem column.

    Part 2 uses operator-dependent digit extraction patterns:
    - Multiplication (*): Extract from RIGHT (position 0 = rightmost digit)
    - Addition (+): Extract from LEFT (position 0 = leftmost digit)

    The extracted digits are concatenated to form new numbers.
    """
    digits = ""
    num_rows = len(problem) - 1  # Exclude operator

    for row_idx in range(num_rows):
        number = problem[row_idx]
        num_len = len(number)

        if operation == '*':
            # Multiplication: extract from right
            if column_position < num_len:
                char_index = num_len - 1 - column_position
                digits += number[char_index]
        else:
            # Addition: extract from left
            if column_position < num_len:
                digits += number[column_position]

    return digits
```

**Gleam** (341 LOC) uses functional patterns with pipeline operators:
```gleam
fn extract_column_digits(
  problem: List(String),
  column_position: Int,
  operation: String,
) -> String {
  let num_rows = list.length(problem) - 1

  problem
  |> list.take(num_rows)
  |> list.filter_map(fn(number) {
    let num_len = string.length(number)
    case operation {
      "*" -> {
        // Multiplication: extract from right
        case column_position < num_len {
          True -> {
            let char_index = num_len - 1 - column_position
            case string.slice(number, char_index, 1) {
              "" -> Error(Nil)
              ch -> Ok(ch)
            }
          }
          False -> Error(Nil)
        }
      }
      _ -> {
        // Addition: extract from left
        case column_position < num_len {
          True -> {
            case string.slice(number, column_position, 1) {
              "" -> Error(Nil)
              ch -> Ok(ch)
            }
          }
          False -> Error(Nil)
        }
      }
    }
  })
  |> string.join("")
}
```

**Carbon** (460 LOC) implements digit extraction using low-level integer arithmetic:
```carbon
// Extract a single digit from a number at the given position
// For multiplication: position from RIGHT (0 = rightmost)
// For addition: position from LEFT (0 = leftmost)
fn ExtractDigitAtPosition(number: i64, position: i32, is_multiplication: bool) -> i32 {
  let num_digits: i32 = CountDigits(number);

  if (is_multiplication) {
    // Extract from RIGHT: position 0 = rightmost digit
    if (position >= num_digits) {
      return -1;
    }
    var temp: i64 = number;
    for (i: i32 in Core.Range(position)) {
      temp = temp / 10;
    }
    return ((temp % 10) as i32);
  } else {
    // Extract from LEFT: position 0 = leftmost digit
    var temp: i64 = number;
    var pow10: i64 = 1;
    for (i: i32 in Core.Range(num_digits - position - 1)) {
      pow10 = pow10 * 10;
    }
    return (((temp / pow10) % 10) as i32);
  }
}
```

## Correctness Evaluation

**Winner: Rust** - 13 automated unit tests covering both Part 1 and Part 2 functionality.

All implementations correctly handle:
- Input parsing with variable whitespace
- Column transposition for vertical problem identification
- Operator extraction and validation
- Part 1: Standard left-to-right evaluation
- Part 2: Operator-dependent digit extraction patterns
- Part 2: Reversal of addition column numbers
- Variable-width numbers (handling numbers of different lengths)

**Test Coverage**:
- **Rust**: 13 automated unit tests using `#[test]` framework
  - Tests for parse_input, identify_problems, extract_operation, calculate_problem
  - Part 2 tests for find_max_width, extract_column_digits (multiplication), extract_column_digits (addition), solve_part2
- **Python**: 7 focused tests in separate test file (test_python_day06_part2.py)
- **Gleam**: 5 tests in day06_test.gleam covering core Part 2 functions
- **Carbon**: 5 tests via test_day06.sh bash script

**Sample Input Validation**:
All languages produce: `{"part1": 4277556, "part2": 3263827}`

**Real Input Results**:
All languages agree: `{"part1": <redacted>, "part2": 9367469817774}`

## Complexity Analysis

**Most Concise: Gleam** (341 LOC) - Functional composition with clean separation of concerns.

**Most Verbose: Rust** (462 LOC) - Comprehensive with extensive inline documentation and 13 tests.

**Lines of Code**:
1. Python: 340 (clean imperative style with docstrings)
2. Gleam: 341 (functional style with Result types)
3. Carbon: 460 (low-level with manual digit manipulation)
4. Rust: 462 (comprehensive documentation + 13 tests)

**Abstraction Levels**:
- **Rust**: Imperative with string manipulation and char iteration
- **Python**: Imperative with clear procedural style
- **Gleam**: Functional with pipeline operators and Result types
- **Carbon**: Low-level with integer arithmetic and manual operations

**Key Algorithm Components**:
1. **Max width calculation**: All languages iterate through problems to find longest number
2. **Digit extraction**:
   - Rust/Python/Gleam: String-based character indexing
   - Carbon: Integer arithmetic with division and modulo
3. **Number formation**: All concatenate extracted single-digit strings
4. **Reversal for addition**: All use built-in reverse functions (Gleam: list.reverse, Rust: Vec::reverse, Python: list.reverse, Carbon: manual swap loop)

## Language Features

**Rust** leveraged:
- **String manipulation**: `chars().nth(index)` for character extraction
- **Comprehensive error handling**: Result type with checked arithmetic
- **Extensive documentation comments**: Triple-slash doc comments with examples
- **Pattern matching**: Used in calculate_problem for operation dispatch
- **Automated testing**: Full test suite with #[test] attribute
- **Overflow protection**: checked_mul() and checked_add() for safe arithmetic

**Python** leveraged:
- **Dynamic typing**: Simplified implementation without type annotations overhead
- **String slicing**: Direct character access with `string[index]`
- **List comprehensions**: Clean functional-style transformations
- **Comprehensive docstrings**: Multi-line docstrings with examples
- **stderr logging**: Debug output without affecting stdout JSON

**Gleam** leveraged:
- **Pipeline operators**: `|>` for clean functional composition
- **Result types**: Explicit error handling with Ok/Error
- **Pattern matching**: Comprehensive case expressions for all branches
- **list.filter_map**: Combines filtering and mapping in single operation
- **Immutability**: All data structures are immutable by default
- **Type safety**: Strong static typing with helpful compiler errors

**Carbon** leveraged:
- **Low-level control**: Direct integer arithmetic without string allocations
- **Manual operations**: Explicit digit extraction via division/modulo
- **Global arrays**: Storage for problems and extracted digits
- **Character-based I/O**: Core.ReadChar() and Core.PrintChar()
- **Explicit type conversions**: as i32, as i64 casts throughout

## Clarity and Conciseness Evaluation

**Ranking**:
1. **Gleam** - Clearest functional expression with type safety
2. **Python** - Most accessible with clean procedural style
3. **Rust** - Excellent balance of safety and clarity
4. **Carbon** - Functional but requires low-level thinking

**Algorithm Clarity Winners**:
- **Digit extraction logic**: Python's string slicing is most intuitive; Carbon's arithmetic is most educational
- **Operator-dependent patterns**: Rust's if/else with clear comments wins; Gleam's case expressions are elegant
- **Number reversal**: All implementations are equally clear (built-in reverse operations)
- **Error handling**: Gleam's Result types are most explicit; Rust's checked arithmetic is safest

**Key Factors**:
- **String vs integer operations**: String-based (Rust, Python, Gleam) more intuitive; integer-based (Carbon) more performant
- **Documentation style**: Rust's inline doc comments are comprehensive; Python's docstrings are accessible; Gleam/Carbon use minimal comments
- **Functional vs imperative**: Gleam's functional style is elegant; Python/Rust imperative is more familiar
- **Type safety**: Gleam and Rust enforce correctness at compile time; Python relies on runtime checks; Carbon requires explicit type management

## Scalability Discussion

**Viable for Complex Digit Manipulation**:
- **Rust**: Fully viable - string manipulation, comprehensive error handling, excellent for production
- **Python**: Fully viable - rapid prototyping, clear code, good for algorithm exploration
- **Gleam**: Fully viable - functional patterns scale well, type safety prevents errors
- **Carbon**: Viable with caveats - low-level control is powerful but requires more effort

**Performance Considerations**:
- **String-based approaches** (Rust, Python, Gleam): More memory allocations, clearer code
- **Integer-based approach** (Carbon): Fewer allocations, more efficient, less intuitive
- Day 6's problem size (4 rows, ~1000 columns) is small enough that approach doesn't matter

**Future Algorithm Scalability**:
- Rust's checked arithmetic scales to large numbers with overflow detection
- Python's arbitrary precision integers handle huge numbers natively
- Gleam's functional patterns compose well for complex transformations
- Carbon's low-level approach gives fine-grained control when needed

## Lessons Learned

**Key Insights from Day 6**:

1. **Operator-dependent algorithms require clear separation**: All languages benefited from if/else or case expressions to handle multiplication vs addition extraction patterns

2. **String-based digit extraction is more intuitive than integer arithmetic**: Rust, Python, and Gleam's character indexing approach is clearer than Carbon's division/modulo approach, though Carbon's is more efficient

3. **Reversal is a critical step for addition columns**: All implementations correctly reverse the extracted numbers for addition, implementing the "right-to-left reading" requirement

4. **Documentation of algorithm intent is crucial**: The counter-intuitive Part 2 algorithm required clear comments explaining the extraction direction and reversal logic

5. **Digit position indexing requires careful thought**:
   - Multiplication: position 0 = rightmost (reverse indexing)
   - Addition: position 0 = leftmost (forward indexing), then reverse the list
   - This asymmetry is the core complexity of Part 2

6. **Max width calculation drives iteration**: All languages correctly found the longest number to determine how many digit positions to process

**What Day 6 Revealed**:

- **String manipulation maturity**: Rust, Python, and Gleam have excellent string APIs; Carbon requires manual integer operations
- **Documentation importance**: Part 2's algorithm complexity necessitated extensive comments in all languages
- **Functional vs imperative trade-offs**: Gleam's pipeline operators produced elegant code; Rust/Python's loops are more explicit
- **Error handling approaches**: Gleam's Result types made errors explicit; Rust's checked arithmetic prevented overflows; Python's exceptions are simplest; Carbon's return values require discipline

**Actionable Takeaways**:

- Use string-based character extraction for clarity; resort to integer arithmetic only for performance-critical code
- Document operator-dependent logic explicitly with examples
- Test digit extraction at boundary positions (first, last, middle)
- Validate both directions of extraction (left-to-right and right-to-left)
- Use built-in reverse functions rather than manual reversal loops
- Consider max width calculation as a separate step to simplify iteration logic

**Recommendation for Future Days**:

Continue using **Rust** for production-quality implementations with safety guarantees, **Python** for rapid prototyping and algorithm exploration, **Gleam** for functional elegance and type safety, and **Carbon** for educational low-level implementations. Day 6 demonstrated that all four languages can handle complex algorithmic challenges effectively, with different trade-offs in clarity, safety, and performance.

**Revised Assessment**: Day 6 confirmed that operator-dependent patterns and digit manipulation are well-supported across all languages. String-based approaches (Rust, Python, Gleam) provide better clarity; integer-based approaches (Carbon) offer theoretical performance advantages at the cost of complexity.
