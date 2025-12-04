# Task Breakdown: Day 1 Part 2 - Cross-Language Zero Crossing Implementation

## Overview
Total Task Groups: 7
Total Languages: 5 (Rust, Gleam, Roc, Carbon, Bosque)

This tasks list implements the Part 2 solution across all 5 languages using a strategic phased approach. Part 2 counts dial crossings through position 0 during rotations (not just final positions at 0). The implementation preserves all existing Part 1 code and adds new zero-crossing calculation logic.

## Task List

### Phase 1: Algorithm Design & Validation

#### Task Group 1: Core Algorithm Design
**Dependencies:** None
**Assigned Role:** Algorithm Designer / Mathematical Analyst

- [x] 1.0 Design and validate zero crossing algorithm
  - [x] 1.1 Document mathematical approach for counting zero crossings
    - Define when a crossing occurs (during rotation movement, not just endpoints)
    - Document direction-specific logic (Left vs Right rotations)
    - Explain division approach for rotations > 100 (e.g., R1000 = 10 complete circles)
    - Detail edge cases: starting at 0, ending at 0, exact multiples of 100
    - Create algorithm pseudocode as reference for all language implementations
  - [x] 1.2 Work through sample input manually
    - Trace each rotation from problem statement
    - Calculate expected crossings for each rotation
    - Verify total Part 2 answer is 6
    - Document trace showing: start=50, L68 crosses 1, R60 crosses 1, L82 crosses 1, total=6
  - [x] 1.3 Validate algorithm handles large rotations
    - Test R1000 from position 50: should cross 0 ten times
    - Test L200 from position 10: should cross 0 twice
    - Test R100 from position 0: should cross 0 once
    - Document division logic: complete_circles = amount / 100, remainder = amount % 100
  - [x] 1.4 Create algorithm specification document
    - Function signature: count_zero_crossings(current_position, direction, amount) -> int
    - Input constraints: position 0-99, amount >= 0
    - Output: integer count of crossings
    - Place in: agent-os/specs/2025-12-04-day1-part2-cross-language/planning/algorithm.md

**Acceptance Criteria:**
- Algorithm correctly handles both directions (Left/Right)
- Large rotation division approach documented
- Manual trace of sample input matches expected answer of 6
- Edge cases identified and approach documented

---

### Phase 2: Rust Implementation (Reference Implementation)

#### Task Group 2: Rust Part 2 Implementation
**Dependencies:** Task Group 1 (COMPLETED)
**Assigned Role:** Rust Engineer

- [x] 2.0 Implement Part 2 in Rust (reference implementation)
  - [x] 2.1 Write 2-8 focused tests for count_zero_crossings function
    - Limit to 2-8 highly focused tests maximum
    - Test: R10 from position 95 crosses 0 once
    - Test: L10 from position 5 crosses 0 once
    - Test: R1000 from position 50 crosses 0 ten times (large rotation)
    - Test: R100 from position 0 (exact multiple edge case)
    - Test: R5 from position 50 does not cross 0 (no crossing case)
    - Skip exhaustive coverage of all edge cases
  - [x] 2.2 Implement count_zero_crossings function
    - Location: /Users/sgarner/projects/sgarner-lt/advent-of-code-2025/rust/day01/src/main.rs
    - Signature: fn count_zero_crossings(position: i32, rotation: &Rotation) -> i32
    - Implement division approach for amounts > 100
    - Handle both Left and Right directions correctly
    - DO NOT modify existing rotate_dial function
  - [x] 2.3 Update part1 function to calculate both answers
    - Rename to solve() or update to return tuple (part1, part2)
    - Maintain existing Part 1 logic unchanged
    - Add parallel accumulator for Part 2 crossings
    - Keep single-pass through input (no duplicate iteration)
  - [x] 2.4 Update main function for JSON output
    - Change output format to: {{"part1": {}, "part2": {}}}
    - Replace null with calculated Part 2 answer
    - Ensure valid JSON formatting
  - [x] 2.5 Ensure Rust implementation tests pass
    - Run ONLY the 2-8 tests written in 2.1
    - Run existing Part 1 tests to ensure no regression
    - Do NOT run entire project test suite
  - [x] 2.6 Validate Rust implementation with sample input
    - Run: cargo run --release ../../challenges/day01/input-sample.txt
    - Verify output: {{"part1": 3, "part2": 6}}
    - Document any implementation challenges encountered

**Acceptance Criteria:**
- The 2-8 count_zero_crossings tests pass
- Sample input produces: {{"part1": 3, "part2": 6}}
- Part 1 answer unchanged (3 for sample)
- No modifications to rotate_dial function
- Code follows Rust idioms (pattern matching, Option handling)

---

### Phase 3: Gleam Implementation

#### Task Group 3: Gleam Part 2 Implementation
**Dependencies:** Task Group 2
**Assigned Role:** Gleam/Functional Engineer

- [x] 3.0 Implement Part 2 in Gleam
  - [x] 3.1 Write 2-8 focused tests for count_zero_crossings function
    - Limit to 2-8 highly focused tests maximum
    - Location: /Users/sgarner/projects/sgarner-lt/advent-of-code-2025/gleam/test/day01_test.gleam
    - Test critical crossing scenarios (similar to Rust tests)
    - Test large rotation division logic
    - Use gleeunit assertion functions
    - Skip exhaustive edge case testing
  - [x] 3.2 Implement count_zero_crossings function
    - Location: /Users/sgarner/projects/sgarner-lt/advent-of-code-2025/gleam/src/day01.gleam
    - Signature: pub fn count_zero_crossings(position: Int, direction: Direction, distance: Int) -> Int
    - Use pattern matching on Direction type
    - Implement division approach with Gleam's integer division
    - DO NOT modify existing rotate function
  - [x] 3.3 Update solve function to calculate both answers
    - Maintain existing count_zeros logic for Part 1
    - Add new accumulator for Part 2 in fold/walk operation
    - Return tuple #(part1, part2)
    - Keep single-pass functional approach
  - [x] 3.4 Update JSON output in build_json function
    - Signature: fn build_json(part1: Int, part2: Int) -> String
    - Format: "{\"part1\": " <> int.to_string(part1) <> ", \"part2\": " <> int.to_string(part2) <> "}"
    - Update main to pass both values
  - [x] 3.5 Ensure Gleam implementation tests pass
    - Run: gleam test (in gleam directory)
    - Verify ONLY new count_zero_crossings tests
    - Verify existing Part 1 tests still pass
    - Do NOT run entire project test suite
  - [x] 3.6 Validate Gleam implementation with sample input
    - Run: gleam run ../../challenges/day01/input-sample.txt
    - Verify output: {{"part1": 3, "part2": 6}}
    - Document Gleam-specific patterns used (pattern matching, recursion)

**Acceptance Criteria:**
- The 2-8 count_zero_crossings tests pass
- Sample input produces: {{"part1": 3, "part2": 6}}
- Part 1 answer unchanged
- Implementation uses functional Gleam idioms
- No modifications to existing rotate function

---

### Phase 4: Roc Implementation

#### Task Group 4: Roc Part 2 Implementation
**Dependencies:** Task Group 2 (COMPLETED)
**Assigned Role:** Roc/Functional Engineer

- [x] 4.0 Implement Part 2 in Roc
  - [x] 4.1 Write 2-8 focused inline expect statements
    - Limit to 2-8 highly focused expect tests maximum
    - Location: /Users/sgarner/projects/sgarner-lt/advent-of-code-2025/roc/day01/day01.roc
    - Add expect statements for countZeroCrossings function
    - Test critical crossing scenarios inline
    - Test large rotation division approach
    - Follow existing expect pattern from Part 1
    - Skip exhaustive edge case testing
  - [x] 4.2 Implement countZeroCrossings function
    - Signature: countZeroCrossings : I32, Instruction -> I32
    - Use Roc's pattern matching on Direction tag union
    - Implement division for amounts > 100
    - Follow Roc naming conventions (camelCase for functions)
    - DO NOT modify existing rotate function
  - [x] 4.3 Update processRotations to track both counts
    - Modify walk state to include: { position: I32, part1: I32, part2: I32 }
    - Calculate Part 2 by calling countZeroCrossings for each instruction
    - Keep Part 1 logic (count when position == 0 after rotation)
    - Return final state with both counts
  - [x] 4.4 Update main to output both parts in JSON
    - Modify Stdout.line! to include both values
    - Format: "{\"part1\": $(Num.to_str part1), \"part2\": $(Num.to_str part2)}"
  - [x] 4.5 Ensure Roc implementation expects pass
    - Run: ./scripts/runners/run_roc.sh 1 /dev/null --unit-test
    - Verify all inline expect statements pass
    - Check existing Part 1 expects still pass
  - [x] 4.6 Validate Roc implementation with sample input
    - Run: ./scripts/runners/run_roc.sh 1 challenges/day01/input-sample.txt
    - Verify output: {{"part1": 3, "part2": 6}}
    - Document Roc-specific features used (inline expects, pattern matching)

**Acceptance Criteria:**
- All inline expect statements pass (2-8 new expects)
- Sample input produces: {{"part1": 3, "part2": 6}}
- Part 1 answer unchanged
- Code follows Roc conventions and pure functional style
- No modifications to existing rotate function

---

### Phase 5: Carbon Implementation

#### Task Group 5: Carbon Part 2 Implementation
**Dependencies:** Task Group 2
**Assigned Role:** Carbon/Systems Engineer

- [x] 5.0 Implement Part 2 in Carbon
  - [x] 5.1 Write 2-8 focused manual test functions
    - Limit to 2-8 highly focused test functions maximum
    - Location: /Users/sgarner/projects/sgarner-lt/advent-of-code-2025/carbon/day01/day01.carbon
    - Follow existing TestXyz naming pattern
    - Add functions: TestCountZeroCrossingsSimple, TestCountZeroCrossingsLarge, etc.
    - Test critical crossing scenarios
    - Test large rotation division logic
    - Skip exhaustive edge case testing
  - [x] 5.2 Implement CountZeroCrossings function
    - Signature: fn CountZeroCrossings(position: i32, rotation: Rotation) -> i32
    - Use if/else for direction checking (Carbon choice types)
    - Implement division for amounts > 100
    - DO NOT modify existing RotateDial function
  - [x] 5.3 Update CountZeros_Sample to track both answers
    - Add variable: var part2_count: i32 = 0;
    - Call CountZeroCrossings for each rotation and accumulate
    - Maintain existing Part 1 logic (checking new_position == 0)
    - Return struct with both values: {.part1 = zero_count, .part2 = part2_count}
  - [x] 5.4 Update CountZeros_Real similarly
    - Note: Carbon implementation may still use hardcoded logic due to file I/O limitations
    - Calculate Part 2 manually if needed, or implement generic rotation processing
    - Document that full file I/O requires C++ interop
  - [x] 5.5 Update Main and test runner
    - Modify Main to output JSON with both parts (if printf interop available)
    - Update RunAllTests to include new test functions
    - Increment tests_total count appropriately
  - [x] 5.6 Ensure Carbon implementation tests pass
    - Run manual tests via RunAllTests
    - Verify new count crossing tests return true
    - Verify existing Part 1 tests still pass
    - Document test results in comments
  - [x] 5.7 Validate Carbon implementation with sample input
    - Verify CountZeros_Sample returns {.part1 = 3, .part2 = 6}
    - Document Carbon-specific challenges (limited stdlib, manual testing)
    - Note any C++ interop requirements

**Acceptance Criteria:**
- The 2-8 manual test functions pass (return true)
- Sample calculation produces part1=3, part2=6
- Part 1 logic unchanged
- Implementation works within Carbon's experimental constraints
- No modifications to existing RotateDial function

---

### Phase 6: Bosque Implementation

#### Task Group 6: Bosque Part 2 Implementation
**Dependencies:** Task Group 2 (COMPLETED)
**Assigned Role:** Bosque/Research Language Engineer

- [x] 6.0 Implement Part 2 in Bosque
  - [x] 6.1 Assess Bosque Part 1 implementation status
    - Location: /Users/sgarner/projects/sgarner-lt/advent-of-code-2025/bosque/day01/solution.bsq
    - Review current implementation state (Part 1 was functional via Python wrapper)
    - Determined Part 1 is working correctly
    - Documented Bosque runtime/tooling limitations in LIMITATIONS.md
  - [x] 6.2 Part 1 already complete
    - Part 1 implementation was complete and working via Python wrapper
    - Rotation logic implemented correctly following Bosque syntax
    - Input parsing handled by Python wrapper (runner.py)
    - File I/O constraints documented (uses Python wrapper approach)
  - [x] 6.3 Write 8 focused Bosque test functions
    - 8 highly focused test functions total (within 2-8 limit per part)
    - Use Bosque's assertion-based testing approach (_assert)
    - Test countZeroCrossings logic with right/left crossings
    - Test critical crossing scenarios and large rotations
    - Tests are syntax-only (cannot execute due to runtime limitations)
    - Documented that tests validate logic but require Python wrapper for execution
  - [x] 6.4 Implement countZeroCrossings function
    - Follow Bosque function syntax and naming conventions
    - Implement direction handling with Boolean isLeft parameter
    - Implement division approach for large rotations
    - DID NOT modify existing rotateDial function
  - [x] 6.5 Update solve function for dual output
    - Modified to calculate both answers in single pass
    - Return structured result using record syntax: {part1: Int, part2: Int}
    - Format JSON output: {"part1": X, "part2": Y}
    - Updated Python wrapper to match Bosque implementation
  - [x] 6.6 Validate Bosque implementation
    - Run: ./scripts/runners/run_bosque.sh 1 challenges/day01/input-sample.txt
    - Verified output: {"part1": 3, "part2": 6}
    - Run: ./scripts/runners/run_bosque.sh 1 challenges/day01/input.txt
    - Verified output: {"part1": REDACTED, "part2": REDACTED}
    - Syntax correctness verified in solution.bsq
    - Runtime executed via Python wrapper (runner.py)
    - Documented runtime limitations and Python wrapper approach
    - Verified logic matches algorithm spec from Task Group 1
    - Cross-validated with Rust reference implementation

**Acceptance Criteria:**
- Bosque code is syntactically correct
- Implementation follows algorithm specification
- 8 tests/assertions written (syntax validated)
- Part 2 logic correctly mirrors Rust reference implementation
- Documentation of Bosque-specific limitations complete
- Sample input produces: {"part1": 3, "part2": 6}
- Real input produces: {"part1": REDACTED, "part2": REDACTED}

**Note:** Bosque is a research language with limited tooling. Implementation uses Python wrapper approach (similar to Carbon) for file I/O and execution while maintaining algorithmic correctness in Bosque code.

---

### Phase 7: Cross-Language Validation & Testing

#### Task Group 7: Integration Testing & Validation
**Dependencies:** Task Groups 2, 3, 4, 5, 6
**Assigned Role:** QA Engineer / Test Validator

- [x] 7.0 Validate all implementations produce identical results
  - [x] 7.1 Create validation test script
    - Location: /Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day01/validate-all.sh
    - Script runs all 5 language implementations against sample input
    - Captures JSON output from each
    - Parses and compares part1 and part2 values
    - Reports any discrepancies
  - [x] 7.2 Run all implementations against sample input
    - Run Rust: cd rust/day01 && cargo run --release ../../challenges/day01/input-sample.txt
    - Run Gleam: cd gleam && gleam run ../challenges/day01/input-sample.txt
    - Run Roc: cd roc/day01 && roc run day01.roc ../../challenges/day01/input-sample.txt
    - Run Carbon: (manual execution or via wrapper script)
    - Run Bosque: (if runtime available)
    - Expected all: {{"part1": 3, "part2": 6}}
  - [x] 7.3 Verify sample input consistency
    - Confirm all 5 languages output part1=3
    - Confirm all 5 languages output part2=6
    - Document any language that deviates
    - Debug and fix discrepancies before proceeding
  - [x] 7.4 Run all implementations against real puzzle input
    - Run all 5 languages against /Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day01/input.txt
    - Capture all outputs
    - Expected Part 1: REDACTED (known correct from Part 1)
    - Part 2: should be identical across all languages (value TBD)
  - [x] 7.5 Verify real input consistency
    - Confirm all 5 languages produce identical part1 value (should be REDACTED)
    - Confirm all 5 languages produce identical part2 value
    - Document the consensus Part 2 answer
    - Investigate and resolve any discrepancies
  - [x] 7.6 Update problem-statement.txt with results
    - Location: /Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day01/problem-statement.txt
    - Append Part 2 solution documentation
    - Record consensus answer from all implementations
    - Note any language-specific observations
  - [x] 7.7 Run feature-specific tests only (targeted test execution)
    - Rust: cargo test (in rust/day01 directory only)
    - Gleam: gleam test
    - Roc: roc test day01.roc
    - Carbon: verify manual test functions
    - Bosque: verify assertions (if executable)
    - Expected total across all languages: approximately 16-34 tests
    - Do NOT run entire project/workspace test suite
    - Focus exclusively on day01 Part 2 feature tests

**Acceptance Criteria:**
- All 5 implementations produce {{"part1": 3, "part2": 6}} for sample input
- All 5 implementations produce identical results for real input
- Part 1 answers remain unchanged (3 for sample, REDACTED for real)
- Validation script successfully compares all outputs
- Feature-specific tests pass (~16-34 tests total across all languages)
- Consensus Part 2 answer documented

---

## Execution Order

**Recommended implementation sequence:**
1. **Phase 1:** Algorithm Design (Task Group 1) - Foundation for all implementations
2. **Phase 2:** Rust Implementation (Task Group 2) - Reference implementation to validate algorithm
3. **Phase 3-6:** Parallel language implementations (Task Groups 3, 4, 5, 6) - Can be done in any order or in parallel
   - Gleam (Task Group 3) - Similar to Rust, functional style
   - Roc (Task Group 4) - Pure functional, inline tests
   - Carbon (Task Group 5) - Systems language, manual testing
   - Bosque (Task Group 6) - Research language, may have limitations
4. **Phase 7:** Cross-Language Validation (Task Group 7) - Verify consistency across all implementations

**Dependencies Flow:**
```
Task Group 1 (Algorithm)
    ↓
Task Group 2 (Rust - Reference)
    ↓
Task Groups 3, 4, 5, 6 (Other Languages - Parallel)
    ↓
Task Group 7 (Validation)
```

---

## Important Implementation Notes

### Preservation Constraints
- **DO NOT modify existing Part 1 functions:** rotate_dial, rotate, rotateDial, etc.
- **DO NOT modify existing input parsing logic**
- **DO NOT modify existing JSON output structure** (only change null to integer)
- **Maintain backward compatibility:** Part 1 answers must remain unchanged

### Testing Philosophy
- **Write minimal strategic tests:** 2-8 tests per language during development
- **Focus on critical behaviors:** Crossings, large rotations, direction handling
- **Skip exhaustive coverage:** Edge cases can be tested later if needed
- **Test in isolation:** Run only feature-specific tests, not entire suite

### Algorithm Key Points
- **Zero crossing detection:** Count crossings during rotation movement, not just endpoints
- **Direction matters:** Left and Right rotations cross zero differently
- **Division approach:** For rotations > 100, use amount / 100 for complete circles
- **Single pass:** Calculate both Part 1 and Part 2 in one iteration through input

### Language-Specific Considerations
- **Rust:** Use standard library, pattern matching, Option/Result types
- **Gleam:** Functional style, list operations, gleeunit tests
- **Roc:** Pure functional, inline expects, tag unions
- **Carbon:** Experimental language, limited stdlib, manual tests, may need C++ interop
- **Bosque:** Research language, may have runtime limitations, focus on syntax correctness

### File Locations Reference
```
/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/
├── rust/day01/src/main.rs (Rust implementation)
├── gleam/src/day01.gleam (Gleam implementation)
├── gleam/test/day01_test.gleam (Gleam tests)
├── roc/day01/day01.roc (Roc implementation with inline expects)
├── carbon/day01/day01.carbon (Carbon implementation)
├── bosque/day01/solution.bsq (Bosque implementation)
├── bosque/day01/runner.py (Python wrapper for Bosque)
├── challenges/day01/input.txt (real puzzle input)
├── challenges/day01/input-sample.txt (sample input)
└── challenges/day01/problem-statement.txt (problem description)
```

### Success Metrics
- All implementations produce identical answers for sample input: {{"part1": 3, "part2": 6}}
- All implementations produce identical answers for real input
- Part 1 answers remain unchanged across all languages
- Approximately 16-34 tests total across all languages (2-8 per language + validation tests)
- Code follows language-specific idioms while maintaining algorithmic consistency

---

## Documentation Requirements

After implementation completion, document in spec completion notes:
- Cross-language validation results
- Language-specific challenges encountered
- Observations about code readability and implementation ease per language
- Performance characteristics (informal observations)
- Lessons learned about each language's strengths for this problem type
- Any deviations from the original plan and why

---

**End of Task Breakdown**
