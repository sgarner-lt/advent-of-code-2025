# Spec Requirements: Day 5 Part 1 Multi-Language AOC Solution

## Initial Description

Implement Day 5 Part 1 solution across all 4 languages (Rust, Gleam, Carbon, Bosque) following the established patterns from Days 1-4. The problem involves parsing a cafeteria inventory database to determine which available ingredient IDs fall within fresh ingredient ID ranges.

## Requirements Discussion

### First Round Questions

**Q1:** Should we follow the exact same pattern established in Days 1-4?
**Answer:** YES - Follow the exact same pattern established in Days 1-4.

**Q2:** How should we parse the input file structure with two groups separated by blank line?
**Answer:** NO on the initial assumption. We need to parse 2 groups of IDs:
- Fresh ingredient ID ranges (e.g., "20362219004570-27230899748695")
- Available ingredient IDs (single numbers)
- Then determine which available ingredients fall within the fresh ranges.

**Q3:** What range checking algorithm should we use?
**Answer:** Don't worry about optimization now. If we over-optimize, we may make Part 2 harder.

**Q4:** What JSON output format should we use?
**Answer:** YES - Follow established pattern with no additional debug info.

**Q5:** Should we use sample input for testing first?
**Answer:** YES - Use sample input for integration test before running real input.

**Q6:** What is the complete testing workflow?
**Answer:** More detailed workflow:
- Unit tests for everything in problem statements that has expected output
- Sample integration test (int test .sh file)
- Real integration test via existing sh files (follow testing framework from other days)

**Q7:** Are there any special performance requirements?
**Answer:** No special instructions. User has added the actual input to challenges/day05/input.txt.

**Q8:** Should we create an analysis document?
**Answer:** There will be another separate spec for the analysis document.

**Q9:** How should we handle code reuse from other days?
**Answer:** Copy JSON and input parsing from other days into this day and adjust as needed. Follow testing framework patterns from other days. Figure them out yourself by exploring the codebase.

**Q10:** Are there visual assets to guide development?
**Answer:** None provided.

### Existing Code to Reference

**Similar Features Identified:**
- Feature: Day 1 implementations - Path: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/{rust,gleam,carbon,bosque}/day01/`
- Components to potentially reuse: JSON output formatting, input parsing from stdin, test runner patterns
- Backend logic to reference: Parse-process-output pattern from all previous day implementations
- Testing framework: `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/scripts/test_execution.sh` and language-specific runners in `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/scripts/runners/`

### Follow-up Questions

No follow-up questions needed - requirements are clear and comprehensive.

## Visual Assets

### Files Provided:
No visual assets provided.

### Visual Insights:
Not applicable.

## Requirements Summary

### Problem Statement Summary

From `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day05/problem-statement.txt`:

The Elves' new inventory management system uses ingredient IDs. The database consists of:
1. A list of fresh ingredient ID ranges (e.g., "3-5" means IDs 3, 4, and 5 are fresh)
2. A blank line separator
3. A list of available ingredient IDs (single numbers)

Fresh ID ranges are inclusive and can overlap. An ingredient ID is fresh if it falls into ANY range.

**Task:** Determine how many of the available ingredient IDs are fresh.

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

**Sample Expected Output:**
```json
{"part1": 3, "part2": null}
```

In the sample:
- ID 1: spoiled (not in any range)
- ID 5: fresh (in range 3-5)
- ID 8: spoiled
- ID 11: fresh (in range 10-14)
- ID 17: fresh (in ranges 16-20 and 12-18)
- ID 32: spoiled

Result: 3 fresh ingredients

### Functional Requirements

**Input Parsing:**
- Read from stdin
- Parse two groups separated by a blank line:
  - Group 1: Fresh ingredient ID ranges (format: "start-end")
  - Group 2: Available ingredient IDs (single numbers)
- Handle large numbers (ranges can be very large based on problem statement example)

**Core Algorithm:**
- Store fresh ingredient ranges
- For each available ingredient ID, check if it falls within any fresh range
- Count how many available ingredients are fresh
- Do not over-optimize - keep logic simple and maintainable for Part 2

**Output:**
- JSON format: `{"part1": <count>, "part2": null}`
- Output to stdout
- Follow exact format from previous days

**Testing Requirements:**
1. Unit tests for:
   - Range parsing (e.g., "3-5" → range 3 to 5)
   - ID parsing
   - Range checking (ID in range)
   - Sample input validation (expected output: part1=3)
2. Sample integration test:
   - Use `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day05/input-sample.txt`
   - Validate against `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day05/input-sample-expected-output.txt`
3. Full integration test:
   - Use `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day05/input.txt`
   - Run via existing test framework (`scripts/test_execution.sh` and language runners)

### Implementation Requirements for All 4 Languages

**Directory Structure (per language):**
```
solutions/{language}/day05/
├── [main source file(s)]
├── [test file(s)]
└── [any language-specific config/build files]
```

**Language-Specific Patterns:**

1. **Rust** (`solutions/rust/day05/`):
   - Main file: `src/main.rs`
   - Read stdin, parse input, solve, output JSON
   - Include unit tests using `#[cfg(test)]`
   - Use Cargo for building

2. **Gleam** (`solutions/gleam/day05/`):
   - Main file: `src/day05.gleam`
   - Test file: `test/day05_test.gleam`
   - Follow Gleam project structure
   - Use gleam test framework

3. **Carbon** (`solutions/carbon/day05/`):
   - Main file: `day05.carbon` or `day05_simple.carbon`
   - Test file: Python-based tests (e.g., `test_carbon_day05.py`)
   - May include runner.py wrapper if needed
   - Use Bazel BUILD file if needed

4. **Bosque** (`solutions/bosque/day05/`):
   - Main file: `solution.bsq`
   - Test file: Python-based tests via `runner.py`
   - Follow established Bosque patterns from day01

**Common Patterns Across All Languages:**
- Read input from stdin
- Output JSON to stdout: `{"part1": <result>, "part2": null}`
- Handle errors gracefully
- Exit with code 0 on success, non-zero on failure

### Reusability Opportunities

**From Day 1 implementations:**
- JSON output formatting pattern
- Stdin reading approach
- Test file structure and naming
- Runner script integration

**From testing framework:**
- Use existing `scripts/runners/run_{language}.sh` scripts
- Follow `scripts/test_execution.sh` parallel execution pattern
- Unit test naming conventions
- Integration test workflow

**Specific files to reference:**
- `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/rust/day01/src/main.rs` - JSON output, stdin parsing
- `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/carbon/day01/test_carbon_day01.py` - Python-based unit test structure
- `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/carbon/day01/runner.py` - Algorithm implementation pattern
- `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/bosque/day01/runner.py` - Bosque runner wrapper
- All day01 implementations for consistent patterns

### Scope Boundaries

**In Scope:**
- Implement Part 1 solution in all 4 languages (Rust, Gleam, Carbon, Bosque)
- Parse fresh ingredient ID ranges
- Parse available ingredient IDs
- Determine which available IDs are fresh
- Count fresh ingredients
- Output JSON with part1 result
- Create unit tests for all testable components
- Create sample integration test
- Integrate with existing test framework

**Out of Scope:**
- Part 2 implementation (separate spec will be created)
- Analysis document (separate spec will be created)
- Performance optimization beyond simple/readable code
- Overlapping range consolidation (not required, just check each available ID)
- Visual output or debugging information
- Modifications to existing test framework or runner scripts

### Technical Considerations

**Input Handling:**
- Must handle large ID numbers (based on problem statement example showing IDs in the billions)
- Use appropriate integer types (i64/Int64 equivalent in all languages)
- Ranges are inclusive (both start and end are included)

**Algorithm Approach:**
- Simple nested loop is acceptable: for each available ID, check against all ranges
- No need for range merging or optimization
- Keep code readable for future Part 2 modifications

**Testing Strategy:**
1. Unit tests validate individual functions (parsing, range checking)
2. Sample integration validates against known output (part1=3)
3. Full integration runs real input through existing test framework
4. All tests should be runnable via language-specific test commands

**Integration Points:**
- Must work with existing runner scripts in `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/scripts/runners/`
- Must be discoverable by test framework
- Must follow day numbering convention (day05)
- Must output valid JSON that can be parsed by test framework

**Error Handling:**
- Invalid input format should be handled gracefully
- Output `{"part1": null, "part2": null}` on errors
- Log errors to stderr, not stdout
- Exit with non-zero code on failure
