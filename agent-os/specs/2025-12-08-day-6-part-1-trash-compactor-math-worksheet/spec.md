# Specification: Day 6 Part 1 - Trash Compactor Math Worksheet

## Goal
Parse vertical math worksheets from horizontal row input and calculate the grand total by solving each problem and summing the results.

## User Stories
- As a solver, I want to read cephalopod math worksheets from stdin so that I can process the problems
- As a solver, I want to identify vertical problems from horizontal columns so that I can solve each problem independently

## Specific Requirements

**Parse Input from Stdin**
- Read all input from stdin line-by-line
- Split each line on one or more whitespace characters to create array of strings
- Build 2D array structure (array of arrays) representing rows and columns
- Trim whitespace from number strings before parsing
- Ignore alignment variations (left/right) within columns

**Identify Vertical Problems**
- Detect problem boundaries by analyzing column positions across all rows
- Each vertical column represents one problem (numbers stacked vertically)
- Last row contains operation symbols (* or +) at the start of each problem column
- Handle varying column widths and spacing between problems

**Parse Numbers and Operations**
- Extract numbers from each column (all rows except last)
- Parse trimmed strings to 64-bit integers (i64 in Rust, Int in Gleam)
- Identify operation symbol from last row of each column
- Validate only * (multiplication) and + (addition) operations exist

**Calculate Problem Answers**
- For multiplication: multiply all numbers in the column together
- For addition: sum all numbers in the column together
- Check for integer overflow using 64-bit integer types
- Calculate sequentially through numbers in each column

**Sum Grand Total**
- Add all individual problem answers together
- Return single grand total as final result
- Use 64-bit integers to handle large intermediate values

**Output JSON Format**
- Print JSON to stdout: `{"part1": <grand_total>, "part2": null}`
- On error: print `{"part1": null, "part2": null}` and exit with code 1
- Write error messages to stderr (not stdout)
- Exit with code 0 on success

**Cross-Language Implementation**
- Implement identical logic in Rust, Gleam, Carbon, and Bosque
- Follow language-specific idioms from `docs/languages/*.md`
- Ensure all 4 implementations produce identical results
- Use language-native 64-bit integer types with overflow checking

**Error Handling**
- Handle stdin read failures gracefully
- Validate numeric parsing (non-numeric values should error)
- Detect missing operation symbols
- Use stderr for error messages, not stdout
- Exit with code 1 on any error condition

**Unit Testing**
- Test parsing line splitting and whitespace handling
- Test column detection and vertical problem identification
- Test number extraction with various alignments
- Test operation symbol detection
- Test calculation logic for both * and + operations
- Test grand total summation

**Integration Testing**
- Validate sample input produces expected output: 4277556
- Run `scripts/test_integration.sh 6 --sample` for sample validation
- Run `scripts/test_integration.sh 6` for real input validation
- Verify all 4 languages produce identical results

## Visual Design
No visual assets provided.

## Existing Code to Leverage

**Day 5 stdin reading and JSON output (solutions/rust/day05/src/main.rs)**
- Use `std::io::stdin().read_to_string(&mut input)` pattern for reading stdin
- Use JSON output format: `println!("{{\"part1\": {}, \"part2\": {}}}", part1, part2)`
- Use `eprintln!` for error messages to stderr
- Use `std::process::exit(1)` for error exit codes
- Wrap solve logic in Result type for error handling

**Day 1 stdin reading pattern (solutions/rust/day01/src/main.rs)**
- Alternative stdin reading approach with `.expect()` for simpler error handling
- Line-by-line processing with `input.lines()` iterator
- Trimming and validation pattern for each line

**Day 3 string parsing and iteration (solutions/rust/day03/src/main.rs)**
- Character iteration with `.chars().collect()` for position-based access
- String validation with `.is_ascii_digit()` checks
- Nested loops for processing 2D positional data
- Vec collection building for intermediate results

**Day 5 Gleam file reading (solutions/gleam/day05/src/day05.gleam)**
- Use `simplifile.read()` for reading input files in Gleam
- Result type pattern: `case result { Ok(content) -> ..., Error(_) -> ... }`
- String processing with Gleam's standard library

**Testing integration script (scripts/test_integration.sh)**
- Use `--sample` flag for sample input testing
- Validates JSON output format across all languages
- Compares results between implementations
- Provides clear pass/fail reporting

## Out of Scope
- Day 6 Part 2 implementation (separate specification)
- Arbitrary precision arithmetic (use 64-bit integers only)
- Operations beyond multiplication (*) and addition (+)
- Interactive or GUI components
- Input sources other than stdin
- Input files beyond challenges/day06/input.txt and input-sample.txt
- Performance optimization beyond baseline correctness
- Parallel processing or concurrency
- Custom parsing libraries (use language-native string splitting)
- Visual debugging or tracing output
