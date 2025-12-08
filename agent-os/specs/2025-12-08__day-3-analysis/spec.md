# Specification: Day 3 Analysis

## Goal
Create a comprehensive comparative analysis of Day 3 Advent of Code 2025 solutions across Rust, Gleam, Carbon, and Bosque, emphasizing string processing capabilities, character-to-integer conversion patterns, and greedy algorithm implementation approaches.

## User Stories
- As a developer learning language features, I want to see how different languages handle string manipulation patterns so that I can understand expressiveness differences
- As a technical evaluator, I want to compare combinatorial iteration and greedy selection algorithms across languages so that I can assess language viability for string-heavy problems

## Specific Requirements

**Follow Established Analysis Structure**
- Use exact same section structure as Day 1, Day 2, and Day 4 analyses: Overview, Readability Comparison, Correctness Evaluation, Complexity Analysis, Language Features, Clarity and Conciseness Evaluation, Scalability Discussion, Lessons Learned
- Maintain consistency with previous analysis tone, depth, and presentation style
- Reference findings from Days 1, 2, and 4 to provide comparative context
- Include lines of code metrics but prioritize maintainability/understanding over raw LOC counts

**Focus on Part 1 Pair Extraction Algorithm**
- Compare how each language extracts all possible 2-digit pairs by selecting any two positions while maintaining order
- Highlight nested loop patterns (Rust `for i..len { for j..(i+1)..len }`), tail recursion approaches (Gleam), and while-loop iteration (Carbon, Bosque)
- Analyze character-to-integer conversion methods: Rust's `char.is_ascii_digit()` and string parsing, Gleam's `string.to_graphemes()` and `int.parse()`, Carbon's ASCII arithmetic with `c - 0x30`, Bosque's `String::substring()` and `String::parseInt()`
- Compare combinatorial generation of all (i,j) pairs where i < j across language paradigms
- Evaluate code clarity for the nested iteration pattern and pair value accumulation

**Focus on Part 2 Greedy K-Digit Extraction Algorithm**
- Compare greedy maximum extraction algorithms: Rust's window-based approach with search_end calculation, Carbon's similar imperative implementation
- Highlight how each language handles the constraint: for position i, search window is [current_pos, len - remaining_digits + 1)
- Note that Gleam solution only implements Part 1 (Part 2 returns null)
- Note that Bosque solution only implements Part 1 (Part 2 returns none)
- Analyze numeric parsing for large 12-digit numbers: Rust's i64, Carbon's i64, and the stdlib support required
- Evaluate algorithm clarity in expressing greedy selection logic

**Highlight NEW String Processing Features**
- Character-to-integer conversion patterns not seen in Days 1-2-4: Rust's `char.is_ascii_digit()`, Carbon's ASCII arithmetic (`c - 0x30`), Bosque's `String::substring()` with single characters
- Combinatorial iteration approaches: nested loops vs tail recursion vs while-loop patterns for generating all position pairs
- Greedy selection algorithms: window-based maximum finding with dynamic search range constraints
- String slicing and concatenation for pair formation: Rust's `format!()`, Gleam's `<>` operator, Bosque's `String::concat()`
- Character buffer management: Carbon's fixed array of integers for digit storage vs dynamic string approaches

**Include "What Day 3 Revealed" Subsection**
- Emphasize combinatorial iteration patterns for pair generation: how languages express nested position selection
- Greedy selection algorithms with constrained search windows: comparing imperative vs functional approaches
- Character-to-integer conversion ecosystem: stdlib support for digit extraction and numeric parsing from strings
- String indexing and character access: direct indexing vs substring methods vs grapheme iteration
- Large integer parsing: i64 support for 12-digit numbers and numeric accumulation patterns

**Evaluate Language Viability Updates**
- Assess whether Carbon's character I/O was sufficient for Day 3's string-heavy processing: character buffer with digit extraction, ASCII arithmetic, manual numeric accumulation
- Evaluate whether Bosque's string APIs were adequate: `String::substring()`, `String::concat()`, `String::parseInt()`, `String::trim()`, `String::split()`
- Compare against Day 2's string manipulation requirements (pattern detection) vs Day 3's character-level operations
- Determine if Carbon's approach is viable for future string problems or if limitations are blocking
- Assess if Bosque's incomplete Part 2 indicates stdlib gaps or just implementation incompleteness

**Provide LOC Metrics with Context**
- Include lines of code counts: Rust (286 LOC including 18 tests), Gleam (111 LOC, Part 1 only), Carbon (163 LOC), Bosque (266 LOC, Part 1 only)
- Emphasize that LOC is a weak metric compared to maintainability, clarity, and algorithm expressiveness
- Note that Rust's higher LOC includes comprehensive test coverage which adds value
- Highlight that Gleam's conciseness is partly due to incomplete Part 2 implementation
- Contextualize Bosque's LOC relative to its working string stdlib despite experimental status

**Compare Readability Patterns**
- Rank languages by readability of pair extraction algorithm: clarity of nested iteration, character access, and pair accumulation
- Evaluate greedy algorithm readability: how obvious is the window constraint logic and maximum selection pattern
- Compare code snippet clarity for the core algorithms: nested loops vs tail recursion vs while-loop patterns
- Assess how well each language's syntax expresses the algorithmic intent for combinatorial iteration

**Analyze Correctness and Testing**
- Document test coverage: Rust's 18 automated unit tests, Carbon's container-based testing, Bosque's 8 test functions
- Compare test approaches for pair extraction: testing specific position combinations, expected maximums, complete input validation
- Evaluate Part 2 test coverage for greedy algorithm: line-by-line validation of maximum k-digit extraction
- Highlight that Gleam and Bosque lack Part 2 tests due to incomplete implementations

**Assess Complexity and Abstraction**
- Compare algorithmic complexity expression: imperative nested loops vs functional tail recursion
- Evaluate abstraction levels for character processing: direct ASCII manipulation vs stdlib string methods
- Analyze how each language handles the combinatorial explosion of pair generation (O(n^2) pairs)
- Compare greedy algorithm abstraction: explicit window calculations vs implicit functional transformations

## Visual Design
No visual assets provided.

## Existing Code to Leverage

**Day 1, Day 2, and Day 4 Analysis Structure**
- Reuse the exact 8-section structure: Overview, Readability Comparison, Correctness Evaluation, Complexity Analysis, Language Features, Clarity and Conciseness Evaluation, Scalability Discussion, Lessons Learned
- Follow the pattern of including code snippets for algorithm comparison with explanatory context
- Maintain the "Winner: [Language]" ranking style for each evaluation category
- Include LOC tables and abstraction level comparisons as demonstrated in prior analyses

**Day 2 String Manipulation Patterns**
- Reference Day 2's string slicing for pattern detection as comparison baseline
- Contrast Day 2's pattern repetition checking with Day 3's character-level pair extraction
- Compare Day 2's substring operations with Day 3's character-to-integer conversion needs
- Leverage Day 2's viability assessment methodology for evaluating Carbon and Bosque string handling

**Day 4 Iterative Algorithm Patterns**
- Reference Day 4's nested loop patterns for 2D grid traversal as comparison to Day 3's pair generation loops
- Compare Day 4's bounds checking (signed arithmetic for coordinates) with Day 3's position constraints (search window calculations)
- Contrast Day 4's directional iteration with Day 3's combinatorial position selection
- Use Day 4's "What Day 4 Revealed" subsection as template for Day 3's unique insights

**Rust Day 3 Implementation**
- Extract code snippets from `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/rust/day03/src/main.rs`
- Highlight `extract_pairs()` function with nested for loops and character validation
- Feature `extract_max_k_digits()` function with greedy window-based maximum selection
- Showcase test coverage: 18 unit tests demonstrating edge case handling
- Note 286 LOC including comprehensive documentation and test suite

**Gleam Day 3 Implementation**
- Extract code snippets from `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/gleam/day03/src/day03.gleam`
- Highlight `do_extract_pairs()` tail-recursive pattern with accumulator
- Feature `extract_pairs_from_position()` recursive helper for inner loop logic
- Note Part 2 incomplete (returns null in JSON output)
- Emphasize functional composition with `list.fold` for sum accumulation
- Note 111 LOC with clean functional style but incomplete feature set

**Carbon Day 3 Implementation**
- Extract code snippets from `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/carbon/day03/day03_simple.carbon`
- Highlight `ProcessLine()` function combining both Part 1 and Part 2 logic
- Feature character buffer approach: `array(i32, 100)` for digit storage with ASCII conversion `c - 0x30`
- Showcase greedy algorithm implementation with while loops and window calculations
- Note manual JSON output with character-by-character `Core.PrintChar()` calls
- Emphasize 163 LOC with complete Part 1 and Part 2 implementations using only character I/O

**Bosque Day 3 Implementation**
- Extract code snippets from `/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/solutions/bosque/day03/solution.bsq`
- Highlight `extractPairs()` function with while-loop nested iteration and `String::substring()` for character access
- Feature `String::concat()` for pair formation and `String::parseInt()` for numeric conversion
- Note Part 2 incomplete (returns none in result record)
- Showcase 8 test functions with explicit validation logic
- Emphasize 266 LOC with working string APIs but incomplete implementation

## Out of Scope
- Creating new analysis structure that deviates from Days 1-2-4 template
- Implementing or modifying Day 3 solutions code
- Performance benchmarking or runtime profiling unless documented in solution code
- Visual diagrams or flowcharts (plain code snippets and markdown only)
- Completing Gleam or Bosque Part 2 implementations during analysis
- Heavy emphasis on LOC as primary quality metric
- Analysis of other Advent of Code days beyond Days 1-4 for context
- Detailed algorithm complexity proofs beyond Big-O notation observations
- Comparison with languages not in the core set (Rust, Gleam, Carbon, Bosque)
- File I/O implementation details beyond what impacts algorithm clarity
