# Spec Requirements: Day 01 Part 1 Multi-Language Implementation

## Initial Description

Implement Part 1 solution in all 5 languages with cross-language validation

## Context

- This is for Advent of Code 2025 Day 1 Part 1
- Need to implement the solution in all 5 languages (Bosque, Carbon, Gleam, Roc, Rust)
- Need cross-language validation to ensure all implementations produce the same results

## Problem Summary

Day 1 involves simulating a dial that rotates left (L) or right (R) by specified amounts. The dial has numbers 0-99 in a circular arrangement, starts at 50, and wraps around at boundaries. The solution must count how many times the dial points at 0 after any rotation in the sequence.

## Requirements Discussion

### First Round Questions

**Q1: Implementation Approach - Should all 5 languages be developed in parallel or sequentially?**

**Answer:** Parallel development across all 5 languages, followed by a comprehensive analysis phase that compares approaches, performance, and lessons learned.

**Q2: Testing Infrastructure - Should existing testing frameworks from Phase 0 be reused?**

**Answer:** Yes, reuse the existing cross-language validation system established in Phase 0. Run unit tests first within each language using native test frameworks, then validate cross-language consistency.

**Q3: Output Format - Should solutions output in a specific format?**

**Answer:** Each solution should output answers in JSON format:
```json
{
  "part1": <answer>,
  "part2": null
}
```
This allows the cross-language validator to parse and compare results programmatically. Part 2 will be null for now since only Part 1 is being implemented.

**Q4: Code Location - Where should implementations be placed?**

**Answer:** Use the existing structure established in Phase 0:
```
challenges/day01/
  rust/
  roc/
  gleam/
  carbon/
  bosque/
  input.txt (already exists)
```

**Q5: Language Requirements - All 5 languages must work?**

**Answer:** Yes, all 5 languages (Bosque, Carbon, Gleam, Roc, Rust) must successfully implement Part 1 and produce identical answers. If any experimental language has blocking issues, document the problem and implement workarounds.

**Q6: Exclusions - What should NOT be included in this implementation?**

**Answer:** Part 2 is explicitly out of scope for this spec. Only implement Part 1. Part 2 will be addressed in a separate spec after Part 1 is complete and validated.

### Follow-up Questions

**Follow-up 1: Sample Data Strategy - How should sample data and expected outputs be managed?**

**Answer:**
- Use `input-sample.txt` naming convention for sample data files
- Put the example from the problem statement (the L68, L30, R48... sequence) in `input-sample.txt`
- The expected answer for the sample is 3 (dial points at 0 three times)
- Unit tests should run first before using `input-sample.txt`
- Create `input-sample-expected-output.txt` containing "3" for validation purposes

### Existing Code to Reference

**Similar Features Identified:**

Based on the project structure established in Phase 0, reference the following for consistency:
- Testing infrastructure from Phase 0 (cross-language validation system)
- File I/O patterns from Phase 0 language setup
- Project structure conventions from tech-stack.md

No similar puzzle-solving features exist yet since this is the first day of implementation.

### Visual Assets

No visual assets provided.

## Requirements Summary

### Functional Requirements

**Core Functionality:**
- Parse rotation instructions from input file (format: direction + distance, e.g., "L68", "R48")
- Simulate a circular dial with numbers 0-99
- Track dial position starting at 50
- Handle left rotations (toward lower numbers with wraparound)
- Handle right rotations (toward higher numbers with wraparound)
- Count how many times the dial lands on 0 after each rotation
- Output the final count as the answer

**Algorithm Requirements:**
- Dial starts at position 50
- Left rotation: subtract distance with modulo 100 wraparound
- Right rotation: add distance with modulo 100 wraparound
- Count increments when position equals 0 after a rotation
- Process all rotations in sequence order

**Input/Output:**
- Read from `challenges/day01/input.txt` for actual puzzle input
- Read from `challenges/day01/input-sample.txt` for sample validation
- Output JSON format: `{"part1": <answer>, "part2": null}`

**Testing Requirements:**
- Write unit tests for rotation logic in each language
- Test wraparound behavior (both directions)
- Validate against sample input first (expected answer: 3)
- Run cross-language validation to ensure all 5 implementations agree
- Only proceed to real input after sample tests pass

### Sample Data Strategy

**File Structure:**
- `challenges/day01/input-sample.txt` - Contains the example sequence:
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
- `challenges/day01/input-sample-expected-output.txt` - Contains "3"

**Validation Workflow:**
1. Run unit tests in each language using native test frameworks
2. Run each implementation against `input-sample.txt`
3. Verify output matches expected value in `input-sample-expected-output.txt`
4. Run cross-language validator to ensure all 5 languages produce identical results
5. Only after all validations pass, run against `input.txt` for actual puzzle submission

### Reusability Opportunities

**Components to Reuse:**
- Cross-language validation system from Phase 0
- Test execution scripts from Phase 0
- File I/O patterns established during language setup
- Project structure conventions from `tech-stack.md`

**Testing Infrastructure:**
- Rust: `cargo test` with `#[test]` attributes
- Roc: `expect` statements inline
- Gleam: `gleeunit` testing framework
- Carbon: Custom test harness (as available)
- Bosque: Built-in assertions (as available)

**Backend Patterns:**
- Standard input file reading patterns
- Modular arithmetic for circular dial logic
- JSON output formatting

### Scope Boundaries

**In Scope:**
- Part 1 solution implementation in all 5 languages
- Unit tests for rotation logic
- Sample data validation
- Cross-language validation
- JSON output format
- Documentation of approach in each language

**Out of Scope:**
- Part 2 implementation (separate spec)
- Performance optimization beyond basic correctness
- Graphical visualization of dial rotations
- Alternative input formats
- Real-time interactive dial simulation
- Comparative performance benchmarking (will be done in separate analysis phase)

### Technical Considerations

**Language-Specific Details:**
- Rust: Use modulo operator for wraparound, leverage iterators for parsing
- Roc: Use pattern matching for direction parsing, functional transformations
- Gleam: Use list operations, case expressions for direction handling
- Carbon: Follow C++ style conventions, handle modulo carefully for negative values
- Bosque: Use algebraic operations, verification-oriented approach

**Integration Points:**
- All implementations must read from shared input files
- All implementations must output to stdout in JSON format
- Cross-language validator will parse JSON and compare `part1` values
- Test runner must invoke each language's native test framework

**Existing System Constraints:**
- Follow directory structure from Phase 0
- Use language-specific build tools (cargo, gleam, roc, etc.)
- Maintain isolation between language implementations
- Ensure all 5 languages can run independently

**Technology Preferences:**
- Follow conventions in `tech-stack.md` for each language
- Use native testing frameworks (no cross-language test frameworks)
- Prefer standard library solutions over external dependencies
- Keep implementations idiomatic to each language's paradigm

**Similar Code Patterns:**
- Reference Phase 0 setup for file I/O conventions
- Follow cross-language validation patterns from Phase 0
- Use consistent JSON output structure across all languages

### Development Workflow

**Implementation Sequence:**
1. Create sample input files (`input-sample.txt`, `input-sample-expected-output.txt`)
2. Implement solution in all 5 languages in parallel
3. Write unit tests for each implementation
4. Validate against sample input
5. Run cross-language validation
6. Execute against real input
7. Submit answer to Advent of Code
8. Document approach and lessons learned (separate analysis phase)

**Validation Gates:**
- Unit tests must pass before sample validation
- Sample validation must pass before real input
- All 5 languages must agree on answer before submission

**Success Criteria:**
- All 5 language implementations complete and functional
- All unit tests passing
- Sample input produces expected output (3)
- All languages produce identical answer for real input
- Answer successfully validates on Advent of Code website
- Code follows idiomatic patterns for each language
