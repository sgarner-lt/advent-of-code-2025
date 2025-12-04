# Day 1 Analysis: Comparing 4 Language Implementations

## Overview

This analysis compares 4 language implementations (Rust, Gleam, Carbon, Bosque) for Advent of Code 2025 Day 1, which involves simulating dial rotations on a circular 0-99 dial. Part 1 counts when the dial lands on position 0, Part 2 counts every crossing through position 0 during rotation. All implementations correctly solve both parts.

**Note:** Roc was originally included but removed due to instability and experimental nature.

## Readability Comparison

**Winner: Gleam** - Most concise at 141 LOC with clean functional style and pipe operators.

**Rust** (264 LOC) offers excellent clarity through strongly-typed enums and structs:
```rust
enum Direction { Left, Right }

struct Rotation {
    direction: Direction,
    distance: i32,
}

fn rotate_dial(position: i32, rotation: &Rotation) -> i32 {
    let new_position = match rotation.direction {
        Direction::Left => position - rotation.distance,
        Direction::Right => position + rotation.distance,
    };
    ((new_position % 100) + 100) % 100
}
```

**Gleam** (141 LOC) leverages functional idioms beautifully:
```gleam
pub type Direction {
  Left
  Right
}

pub fn rotate(position: Int, direction: Direction, distance: Int) -> Int {
  case direction {
    Left -> modulo(position - distance, 100)
    Right -> modulo(position + distance, 100)
  }
}
```

**Carbon** (523 LOC) is verbose due to experimental stdlib limitations, requiring extensive inline documentation and hardcoded input. **Bosque** (302 LOC) uses boolean-based direction (`isLeft: Bool`) which simplifies type handling but reduces clarity.

## Correctness Evaluation

**Winner: Rust** - 16 automated unit tests with comprehensive edge case coverage.

All implementations correctly handle:
- Circular wraparound (modulo arithmetic)
- Negative position handling (left rotations)
- Zero crossing detection for Part 2

**Test Coverage:**
- **Rust**: 16 automated unit tests using `#[test]` framework
- **Carbon**: 16 manual test functions with `RunAllTests()` wrapper
- **Bosque**: 16 test functions (manual execution)
- **Gleam**: Fewer explicit tests, relies on Result types for error handling

The negative modulo handling is critical. Rust's approach:
```rust
((new_position % 100) + 100) % 100
```

Gleam implements a custom helper:
```gleam
fn modulo(value: Int, divisor: Int) -> Int {
  let remainder = value % divisor
  case remainder < 0 {
    True -> remainder + divisor
    False -> remainder
  }
}
```

## Complexity Analysis

**Most Concise: Gleam** (141 LOC) - Functional composition reduces boilerplate significantly.

**Most Verbose: Carbon** (523 LOC) - Stdlib limitations forced:
- Hardcoded sample input (no file I/O)
- Manual test framework (no testing stdlib)
- Extensive inline documentation to explain workarounds
- Python wrapper required for actual execution

**Lines of Code:**
1. Gleam: 141 (most concise)
2. Rust: 264 (comprehensive but clean)
3. Bosque: 302 (verification-oriented overhead)
4. Carbon: 523 (experimental language overhead)

**Abstraction Levels:**
- **Rust & Carbon**: Struct/class-based with enums/choice types
- **Gleam & Bosque**: Functional with pattern matching and tail recursion

## Language Features

**Rust** leveraged:
- Derived traits (`#[derive(Debug, PartialEq)]`)
- Pattern matching on enums
- Ownership/borrowing (`&Rotation` references)
- Integrated test framework (`#[cfg(test)]`)

**Gleam** leveraged:
- Pipe operators for functional composition
- Tail recursion with accumulators (`do_count_zeros`)
- Result type for error handling
- Tuple pattern matching for instruction parsing

**Carbon** leveraged:
- Choice types (enum-like)
- Inline documentation (compensating for experimental state)
- C++ interop capability (mentioned but not used here)
- Manual testing functions with structured test runner

**Bosque** leveraged:
- Verification-oriented design
- Record types for structured returns (`{part1: Int, part2: Int}`)
- Boolean simplicity (`isLeft: Bool` vs enum)
- Try-catch fallback for experimental APIs

## Clarity and Conciseness Evaluation

**Ranking:**
1. **Gleam** - Cleanest expression of the algorithm with minimal boilerplate
2. **Rust** - Excellent balance of clarity, type safety, and explicitness
3. **Bosque** - Functional approach clear but boolean direction less explicit than enums
4. **Carbon** - Algorithm clarity buried under experimental language workarounds

**Key Factors:**
- **Stdlib Support**: Rust and Gleam had complete I/O, string parsing, and testing. Carbon and Bosque required significant workarounds.
- **Syntax Clarity**: Gleam's pipe operators and pattern matching made data flow obvious. Rust's enums made intent explicit.
- **Boilerplate**: Carbon required Python wrapper + hardcoded input. Bosque needed try-catch fallbacks.

## Scalability Discussion

**Viable for Future Days:**
- **Rust**: Fully viable - comprehensive stdlib, mature tooling, excellent for complex problems
- **Gleam**: Fully viable - functional style scales well, complete stdlib support

**Limited Viability:**
- **Carbon**: Experimental limitations are blocking - no file I/O or string stdlib makes daily puzzle solving impractical without Python wrappers
- **Bosque**: Runtime constraints and stdlib gaps create friction - verification-oriented design is interesting but immature ecosystem limits practicality

**Language Maturity Matters:**
- Rust and Gleam solved Day 1 cleanly with zero workarounds
- Carbon and Bosque both required Python wrapper scripts for file reading
- As AoC problems increase in complexity (Days 10-25), stdlib completeness becomes critical

**Sustainability Concerns:**
- Python wrappers add maintenance overhead and debugging friction
- Hardcoded input (Carbon) is impractical for 25 days of puzzles
- Manual testing frameworks don't scale to larger test suites

## Lessons Learned

**Key Insights:**
1. **Stdlib maturity matters more than syntax** - Carbon's syntax is fine, but lack of file I/O made it impractical
2. **Roc removal was correct** - Too experimental/unstable to maintain across 25 days
3. **Functional vs imperative is preference** - Both Rust (imperative) and Gleam (functional) were excellent
4. **Testing frameworks are essential** - Rust's integrated tests caught edge cases; manual testing in Carbon/Bosque is tedious
5. **Python wrappers add friction** - Carbon and Bosque both needed wrappers, making them 2-language solutions instead of 1

**Actionable Takeaways:**
- Prioritize languages with mature stdlib and tooling for multi-day projects
- Experimental languages are learning opportunities but not production-ready
- File I/O, string parsing, and testing support are non-negotiable for AoC
- Small LOC difference (141 vs 264) matters less than maintainability and clarity

**Recommendation for Future Days:**
Focus on **Rust** and **Gleam** for remaining days. Carbon and Bosque demonstrated interesting language features but practical limitations make them unsuitable for daily puzzle solving without significant infrastructure investment.
