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

**Carbon** (169 LOC) implements real rotation logic using character-based I/O with `Core.ReadChar()` and `Core.PrintChar()`. **Bosque** (302 LOC) uses boolean-based direction (`isLeft: Bool`) which simplifies type handling but reduces clarity.

## Correctness Evaluation

**Winner: Rust** - 16 automated unit tests with comprehensive edge case coverage.

All implementations correctly handle:
- Circular wraparound (modulo arithmetic)
- Negative position handling (left rotations)
- Zero crossing detection for Part 2

**Test Coverage:**
- **Rust**: 16 automated unit tests using `#[test]` framework
- **Carbon**: Real implementation with container-based testing
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

**Most Verbose: Bosque** (302 LOC) - Verification-oriented design adds overhead.

**Lines of Code:**
1. Gleam: 141 (most concise)
2. Carbon: 169 (real implementation with character I/O)
3. Rust: 264 (comprehensive but clean with tests)
4. Bosque: 302 (verification-oriented overhead)

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
- Character-based I/O with `Core.ReadChar()` and `Core.PrintChar()`
- Fixed-size arrays for data storage
- Manual integer parsing from character input
- Manual JSON output formatting character-by-character
- Containerized Bazel build system

**Bosque** leveraged:
- Verification-oriented design
- Record types for structured returns (`{part1: Int, part2: Int}`)
- Boolean simplicity (`isLeft: Bool` vs enum)
- Try-catch fallback for experimental APIs

## Clarity and Conciseness Evaluation

**Ranking:**
1. **Gleam** - Cleanest expression of the algorithm with minimal boilerplate
2. **Rust** - Excellent balance of clarity, type safety, and explicitness
3. **Carbon** - Real character-based I/O implementation works but adds verbosity
4. **Bosque** - Functional approach clear but boolean direction less explicit than enums

**Key Factors:**
- **Stdlib Support**: Rust and Gleam had complete I/O, string parsing, and testing. Carbon has Core library I/O but requires manual operations. Bosque required workarounds.
- **Syntax Clarity**: Gleam's pipe operators and pattern matching made data flow obvious. Rust's enums made intent explicit.
- **Boilerplate**: Carbon requires character-by-character I/O and manual JSON formatting. Bosque needed try-catch fallbacks.

## Scalability Discussion

**Viable for Future Days:**
- **Rust**: Fully viable - comprehensive stdlib, mature tooling, excellent for complex problems
- **Gleam**: Fully viable - functional style scales well, complete stdlib support
- **Carbon**: Viable but verbose - character-based I/O works, requires manual implementation of operations

**Limited Viability:**
- **Bosque**: Runtime constraints and stdlib gaps create friction - verification-oriented design is interesting but immature ecosystem limits practicality

**Language Maturity Matters:**
- Rust and Gleam solved Day 1 cleanly with zero workarounds
- Carbon uses character-based I/O which works but requires more code
- Bosque required Python wrapper scripts for file reading
- As AoC problems increase in complexity (Days 10-25), stdlib completeness becomes critical

**Sustainability Concerns:**
- Character-by-character I/O (Carbon) adds development time
- Manual JSON formatting increases boilerplate
- Python wrappers (Bosque) add maintenance overhead and debugging friction

## Lessons Learned

**Key Insights:**
1. **Stdlib maturity matters more than syntax** - Carbon's Core library works but requires manual implementation
2. **Roc removal was correct** - Too experimental/unstable to maintain across 25 days
3. **Functional vs imperative is preference** - Both Rust (imperative) and Gleam (functional) were excellent
4. **Testing frameworks are essential** - Rust's integrated tests caught edge cases
5. **Character I/O works but adds verbosity** - Carbon's real implementation requires more manual code than Rust/Gleam
6. **Python wrappers add friction** - Bosque needs wrappers, making it a 2-language solution

**Actionable Takeaways:**
- Prioritize languages with mature stdlib and tooling for multi-day projects
- Experimental languages are learning opportunities but not production-ready
- File I/O, string parsing, and testing support are non-negotiable for AoC
- Small LOC difference (141 vs 264) matters less than maintainability and clarity

**Recommendation for Future Days:**
Focus on **Rust** and **Gleam** for remaining days. **Carbon** has real implementations but adds development time due to character I/O. **Bosque** requires Python wrappers which add friction.
