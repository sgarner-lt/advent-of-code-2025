# Spec Requirements: Day 3 Part 1

## Initial Description
Day 3 Part 1 — Implement Part 1 solution in all 4 languages with cross-language validation

This is for an Advent of Code 2025 challenge (10-day event). The project involves implementing each day's puzzle in 4 languages: Rust, Gleam, Carbon, and Bosque. Phase 3 learning goals focus on string processing or pattern matching and comparing expressiveness across languages.

## Requirements Discussion

### First Round Questions

**Q1:** What is the algorithm approach for parsing and processing the input?
**Answer:** Confirmed - parse each line, find all consecutive 2-digit pairs, select maximum from each line, sum them up

**Q2:** What input/output format should be maintained?
**Answer:** Yes, maintain same JSON format: `{"part1": <answer>, "part2": null}`

**Q3:** Should the implementation focus on string processing capabilities?
**Answer:** Yes, exploit idiomatic/best practices for each language's string manipulation capabilities

**Q4:** What testing strategy should be employed?
**Answer:** Create unit tests for anything in the problem statement with examples and inputs. Follow same testing conventions as previous days (inline tests in Rust with `#[test]`, separate test files in Gleam)

**Q5:** What edge cases should be handled?
**Answer:** Only handle what's in the actual input files:
- `challenges/day03/input-sample.txt` (4 lines, expected answer: 357)
- `challenges/day03/input.txt` (200 lines, real puzzle input)
- Ignore theoretical edge cases not present in these files

**Q6:** Should performance considerations be included?
**Answer:** Focus on idiomatic code, scope out performance benchmarking

**Q7:** How should cross-language validation be performed?
**Answer:** Run `./scripts/test_integration.sh 3` to compare all solutions for day 3

**Q8:** Should Part 2 be prepared for in advance?
**Answer:** No future-proofing - implement only what's needed for Part 1

**Q9:** Can existing code be reused from previous days?
**Answer:** Each day should be isolated. Can look at past days (Day 1, Day 2) for examples but must duplicate code into Day 3, not link/reuse directly

**Q10:** Are there visual assets to guide development?
**Answer:** None provided

### Existing Code to Reference

**Similar Features Identified:**
- Day 1 solutions (all 4 languages) - Path: `challenges/day01/`
- Day 2 solutions (all 4 languages) - Path: `challenges/day02/`
- Testing patterns to reference from previous days
- JSON output format patterns from previous days

**Note:** Each day should be isolated, so code should be duplicated into Day 3 rather than directly linked or reused.

### Additional Context Provided

**Sample Input Details:**
- Location: `challenges/day03/input-sample.txt`
- Content: 4 lines
  - Line 1: "987654321111111"
  - Line 2: "811111111111119"
  - Line 3: "234234234234278"
  - Line 4: "818181911112111"
- Expected output: 357

**Calculation Breakdown:**
- Line 1: Maximum consecutive 2-digit pair = 98
- Line 2: Maximum consecutive 2-digit pair = 89
- Line 3: Maximum consecutive 2-digit pair = 78
- Line 4: Maximum consecutive 2-digit pair = 92
- Sum: 98 + 89 + 78 + 92 = 357

**Real Input Details:**
- Location: `challenges/day03/input.txt`
- Content: 200 lines of digit strings

## Visual Assets

### Files Provided:
No visual assets provided.

### Visual Insights:
N/A - No visual assets were submitted for this specification.

## Requirements Summary

### Functional Requirements
- Parse input files line by line
- For each line, extract all consecutive 2-digit pairs from the string
- Find the maximum value among all pairs in that line
- Sum the maximum values from all lines
- Output result in JSON format: `{"part1": <answer>, "part2": null}`
- Implement solution in all 4 languages: Rust, Gleam, Carbon, and Bosque
- Use idiomatic string processing approaches for each language
- Create unit tests for examples and inputs provided in problem statement
- Validate that all 4 language implementations produce identical results

### Reusability Opportunities
- Reference Day 1 and Day 2 implementations for structural patterns
- Reference existing testing conventions (Rust: inline `#[test]`, Gleam: separate test files)
- Reference JSON output formatting from previous days
- Note: Code should be duplicated into Day 3, not linked/reused directly

### Scope Boundaries

**In Scope:**
- Part 1 solution only
- Processing sample input (4 lines, expected answer: 357)
- Processing real input (200 lines)
- Unit tests for problem statement examples
- Cross-language validation via `./scripts/test_integration.sh 3`
- Idiomatic string manipulation for each language
- JSON output format matching previous days

**Out of Scope:**
- Part 2 solution (no future-proofing)
- Performance benchmarking
- Theoretical edge cases not present in actual input files
- Direct code reuse/linking between days (must duplicate)

### Technical Considerations

**Input Files:**
- Sample: `challenges/day03/input-sample.txt` (4 lines)
- Real: `challenges/day03/input.txt` (200 lines)

**Algorithm:**
1. Read input file line by line
2. For each line of digit characters:
   - Extract all consecutive 2-digit pairs (e.g., "987" yields "98" and "87")
   - Convert pairs to integers
   - Find maximum value among pairs
3. Sum all maximum values
4. Return JSON: `{"part1": <sum>, "part2": null}`

**Testing Strategy:**
- Unit tests following language conventions:
  - Rust: Inline tests with `#[test]` attribute
  - Gleam: Separate test files
  - Carbon: Follow project conventions
  - Bosque: Follow project conventions
- Test sample input expecting output: 357
- Integration validation: Run `./scripts/test_integration.sh 3` to ensure all languages produce identical results

**Language-Specific Focus:**
- Exploit idiomatic string processing capabilities
- Focus on expressiveness and best practices over performance
- Use language-native string manipulation features
- Demonstrate each language's strengths in string processing/pattern matching

**Cross-Language Validation:**
- All 4 implementations must produce identical results
- Use integration test script to verify consistency
- Script command: `./scripts/test_integration.sh 3`

**Execution Scripts:**
- **CRITICAL:** Use `run_<language>.sh` scripts to run individual language solutions
- Available scripts:
  - `./scripts/runners/run_rust.sh`
  - `./scripts/runners/run_gleam.sh`
  - `./scripts/runners/run_carbon.sh`
  - `./scripts/runners/run_bosque.sh`
- These scripts standardize execution across all languages
- Integration test script uses these runners internally

**Code Organization:**
- Isolate Day 3 code from previous days
- May reference Day 1 and Day 2 for patterns but must duplicate code
- Maintain consistent structure across all language implementations
