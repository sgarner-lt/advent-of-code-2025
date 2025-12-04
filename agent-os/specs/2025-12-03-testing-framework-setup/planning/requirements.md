# Spec Requirements: Testing Framework Setup

## Initial Description
Implement cross-language validation system that can run tests in all 5 languages and verify identical answers between implementations

This is Phase 0, Item 3 from the roadmap. The system needs to:
- Run tests across Rust, Roc, Gleam, Carbon, and Bosque
- Validate that all implementations produce identical answers
- Support both sample and real puzzle inputs
- Be used for Advent of Code 2025 challenges

## Requirements Discussion

### First Round Questions

**Q1: JSON Output Schema**
What should the standardized JSON output format look like? I'm assuming a simple format with part1 and part2 keys would work:
```json
{
  "part1": 12345,
  "part2": 67890
}
```
Is this sufficient, or do you need additional metadata like execution time, language version, or error information?

**Answer:** Simple format is perfect: `{"part1": 12345, "part2": 67890}`

**Q2: Unit Test Coverage**
Should the testing framework run unit tests for individual functions in each language, or only integration tests that validate final answers? I'm thinking we should:
- Run unit tests separately from integration tests
- Provide a command to run ONLY unit tests (for TDD workflow)
- Report unit test failures differently than integration test failures

**Answer:** Agents write unit tests for each function they create.

**Q3: TDD Workflow Integration**
When agents are developing solutions, they'll need to run unit tests frequently. Should the testing framework:
- Run unit tests separately from integration tests? YES
- Provide a command to run ONLY unit tests (for TDD workflow)? YES
- Report unit test failures differently than integration test failures? YES

All options are acceptable.

**Q4: Reporting Requirements**
For the test results reporting, I'm assuming we should track:
- Test execution times per language (for performance comparison)
- Historical test results (to see if performance regresses)
- Maybe generate HTML reports with d3.js visualizations?

Or do you prefer simpler markdown/text output?

**Answer:**
- NO times needed
- Just current run (no history)
- SCRAP HTML/d3 idea
- Use simple markdown rollup file
- Show what happened, differences, commonalities between languages

**Q5: Testing Framework Approach**
Should the framework:
A) Supply the day number as input, run all languages in parallel, then aggregate results?
B) Run each language sequentially and stop on first failure?
C) Let the user specify which languages to test (e.g., only Rust + Gleam)?

**Answer:** Supply the day number as input, run all languages in parallel, once all finished grep results and aggregate them. Whatever is easiest to implement.

**Q6: Sample Test Data Handling**
For Advent of Code, sample inputs are provided in the problem description but expected outputs might not always be explicitly stated for both parts. Should we:
- Require users to manually create sample.txt and expected-output.json for each day?
- Auto-extract sample data from problem descriptions (might be fragile)?
- Support multiple sample inputs (sample1.txt, sample2.txt)?

**Answer:**
- User will put files in day's shared folder
- Let agent figure out structure
- Not sure about expected/sample output availability
- Advent of Code provides text box on website to enter answer (no programmatic expected output)

**Q7: Scope and Exclusions**
Is there anything else you want to explicitly EXCLUDE from this testing framework? For example:
- Performance benchmarking tools (separate feature)?
- Code coverage analysis?
- Automatic submission to Advent of Code website?
- Detailed logging/debugging output?

**Answer:** Not answered explicitly in follow-up

### Existing Code to Reference

**Similar Features Identified:**
No similar existing features were mentioned or identified for reference. This is a new testing infrastructure feature for the project.

### Follow-up Questions

No follow-up questions were needed. The initial questions and answers provided sufficient clarity for the requirements.

## Visual Assets

### Files Provided:
No visual files found in `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/agent-os/specs/2025-12-03-testing-framework-setup/planning/visuals/`

### Visual Insights:
No visual assets were provided for this feature.

## Requirements Summary

### Functional Requirements

**Core Testing Capabilities:**
- Execute tests across all 5 languages (Rust, Roc, Gleam, Carbon, Bosque) for a given day
- Run all language tests in parallel for efficiency
- Validate that all implementations produce identical answers
- Support both sample inputs and real puzzle inputs
- Aggregate results after all language tests complete

**Unit Test Support:**
- Run unit tests separately from integration tests
- Provide dedicated command to run ONLY unit tests for TDD workflow
- Report unit test failures with different formatting than integration failures
- Agents write unit tests for each function they create

**Input/Output Format:**
- Standardized JSON output: `{"part1": <answer>, "part2": <answer>}`
- User places test files in day's shared folder
- Framework discovers structure automatically
- No programmatic expected output (Advent of Code uses manual web submission)

**Test Execution Flow:**
- Accept day number as input parameter
- Run all 5 language implementations in parallel
- Wait for all to complete
- Grep/parse results from each language
- Aggregate into unified report

**Reporting:**
- Simple markdown rollup file output
- Show current run results only (no history tracking)
- Display what happened in each language
- Highlight differences between languages
- Show commonalities across implementations
- NO execution time tracking needed
- NO HTML/d3.js visualizations
- NO historical data preservation

**Test Data Management:**
- Sample inputs stored in day's shared folder (e.g., `dayXX/sample.txt`)
- Real puzzle inputs in shared folder (e.g., `dayXX/input.txt`)
- Expected outputs may not exist (manual verification only)
- Support flexible file structure discovery

### Reusability Opportunities

No existing similar features were identified. This is foundational testing infrastructure for the multi-language project structure.

### Scope Boundaries

**In Scope:**
- Cross-language test execution and validation
- Parallel test running for all 5 languages
- Unit test support with separate execution command
- Simple markdown report generation
- JSON output format standardization
- Answer consistency verification across languages
- Automatic test data discovery in day folders

**Out of Scope:**
- Performance benchmarking (separate future feature)
- Execution time tracking and comparison
- Historical test result storage
- HTML or visual report generation
- Code coverage analysis
- Automatic submission to Advent of Code website
- Detailed debugging/logging output (beyond basic test results)

**Future Enhancements (Not Now):**
- Performance benchmarking tools
- Test result history tracking
- Code coverage metrics
- Advanced reporting with visualizations

### Technical Considerations

**Language Integration:**
- Use each language's native test framework:
  - Rust: `cargo test`
  - Roc: `expect` statements
  - Gleam: `gleeunit`
  - Carbon: Custom test harness
  - Bosque: Built-in assertions
- Parse JSON output from each language's test runner
- Handle experimental languages (Carbon, Bosque) with potentially limited tooling

**Parallel Execution:**
- Use whatever is easiest to implement for parallelization
- Collect results after ALL tests complete (don't fail fast)
- Aggregate results using grep or similar text parsing

**File Structure Conventions:**
- Follow existing project structure (dayXX/ folders)
- Each day has language-specific subdirectories (rust/, roc/, gleam/, carbon/, bosque/)
- Shared input files in day root: input.txt, sample.txt
- JSON output written by each language implementation

**Test Discovery:**
- Framework should be flexible about file structure
- Let agent implementations figure out exact structure
- Don't enforce rigid expected-output files (not available for Advent of Code)

**Error Handling:**
- Capture test failures per language
- Report which languages passed/failed
- Show differences when answers don't match
- Don't stop on first failure (run all languages)

**Cross-Language Validation:**
- Compare JSON output from all 5 languages
- Flag mismatches between implementations
- Clearly show which languages agree and which diverge
- Both Part 1 and Part 2 must match across all languages
