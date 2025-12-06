# Specification: Day 4 Part 1 - Paper Roll Accessibility

## Goal
Implement a solution in all four languages (Rust, Gleam, Carbon, Bosque) that identifies which paper rolls can be accessed by forklifts based on the rule that a roll is accessible if it has fewer than four rolls in the eight adjacent positions.

## User Stories
- As a solver, I want to parse a grid of paper roll locations and identify accessible rolls so that I can determine which rolls forklifts can reach
- As a validator, I want all four language implementations to produce identical results so that I can verify correctness across implementations

## Specific Requirements

**Grid Parsing and Input Handling**
- Read input from stdin containing a grid where '@' represents a paper roll and '.' represents an empty space
- Parse each line of input into a 2D grid structure appropriate for each language
- Handle variable grid sizes without hardcoding dimensions
- Trim or skip empty lines in the input

**Adjacency Checking Logic**
- For each cell in the grid, check all 8 adjacent positions (N, S, E, W, NE, NW, SE, SW)
- Count how many of the 8 adjacent positions contain paper rolls ('@')
- Handle edge cases where cells are on the grid boundary (fewer than 8 neighbors)
- A roll is accessible if it has fewer than 4 adjacent rolls (count < 4)

**Accessible Roll Identification**
- Iterate through all grid positions containing '@'
- Apply the accessibility rule: count adjacent '@' symbols and check if count < 4
- Track which positions meet the accessibility criteria
- Count the total number of accessible rolls

**Output Format Requirements**
- Output JSON with structure: `{"count": N, "additional-info": {"grid": "..."}}`
- The count field contains the integer number of accessible paper rolls
- The grid visualization uses 'x' to mark accessible rolls, '@' for inaccessible rolls, and '.' for empty spaces
- Grid lines are separated by '\n' characters within the JSON string
- Ensure valid JSON output for cross-language validation

**Cross-Language Consistency**
- All four implementations must use identical algorithms for adjacency counting
- Output format must be consistent across all languages to enable automated validation
- Use language-appropriate idioms while maintaining algorithmic equivalence

**Sample Input Validation**
- Verify implementation against provided sample input expecting 13 accessible rolls
- Sample grid is 10x10 with specific pattern of '@' and '.' characters
- Expected accessible positions match the problem statement visualization

**Error Handling**
- Handle malformed input gracefully without crashing
- Validate that input contains only valid characters ('@' and '.')
- Return appropriate error indicators if input is invalid

**Testing Requirements**
- Unit tests verifying adjacency counting logic for edge cells, corner cells, and interior cells
- Integration tests comparing output against sample input expected output
- Cross-language validation tests ensuring all implementations agree

## Visual Design

No visual mockups provided for this spec.

## Existing Code to Leverage

**Day 1-3 Multi-Language Runner Pattern - `solutions/{language}/day0X/runner.py` or `src/main.rs`**
- Use stdin input reading pattern established in previous days
- Follow JSON output format convention with part1 and part2 fields (part2 will be null for this spec)
- Maintain consistent file structure under `solutions/{language}/day04/`
- Apply same error handling and exit code conventions

**Day 3 Rust Implementation - `solutions/rust/day03/src/main.rs`**
- Reuse pattern of reading stdin into a string buffer
- Apply solve function structure that processes input and returns result tuple
- Use similar unit test structure with #[cfg(test)] module
- Follow pattern of parsing input lines and processing each line

**Day 3 Carbon/Bosque Python Wrappers - `solutions/{carbon|bosque}/day03/runner.py`**
- Continue using Python wrapper pattern for Carbon and Bosque implementations
- Maintain JSON output formatting with json.dumps()
- Follow stdin reading with sys.stdin.read() pattern
- Apply similar error handling with try-except blocks

**Validation Framework - `scripts/validate_answers.sh`**
- Extend existing cross-language validation to support Day 4
- Reuse JSON parsing and comparison logic for verifying agreement across languages
- Apply same validation reporting format showing which languages agree/diverge

**Test Runner Pattern from Previous Days**
- Follow established pattern of creating test output directories
- Use consistent naming: `{language}_stdout.txt`, `{language}_stderr.txt`, `{language}_exit_code.txt`
- Enable validation framework to automatically compare outputs

## Out of Scope
- Day 4 Part 2 implementation (separate spec will be created)
- Performance optimizations beyond straightforward implementations
- GUI or interactive grid visualization
- Real-time or streaming input processing
- Parallel or concurrent processing of grid cells
- Support for grids larger than memory can hold
- Custom input file handling (only stdin is required)
- Alternative accessibility rules or thresholds beyond "fewer than 4"
- Support for additional characters beyond '@' and '.'
- Weighted adjacency or distance-based calculations
