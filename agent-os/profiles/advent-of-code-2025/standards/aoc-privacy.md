# Advent of Code Privacy and Answer Protection

## Purpose
This standard ensures that real puzzle answers are not hardcoded or documented in the repository, allowing the code to be shared publicly without spoiling solutions for others.

## Rules

### 1. No Real Answers in Documentation
**Never** include actual puzzle answers in:
- README files
- Specification documents
- Implementation notes
- Verification reports
- Code comments
- Test expectations (except for sample inputs)

### 2. Allowed Answer References
**Sample inputs only:**
- Sample input answers from the problem statement are acceptable
- These are publicly available and help verify correctness
- Example: "Sample input produces `{"part1": 3, "part2": 6}`" ✅

### 3. Real Answer Placeholders
When documenting real puzzle results, use:
- `"REDACTED"` for actual values
- `"XXX"` or `"YYY"` as placeholders
- Generic descriptions like "expected real answer"
- Example: "Real input produces `{"part1": REDACTED, "part2": REDACTED}`" ✅

### 4. Code Implementation
**Calculated values are acceptable:**
- Code that *calculates* answers is fine
- Hardcoded test expectations for sample data only
- Real input should be read from file and processed, not hardcoded

**NOT acceptable - Hardcoding Real Answers:**
```rust
// ❌ BAD - Don't hardcode real answers in code
fn solve_real() -> (i32, i32) {
    return (1234, 5678); // NEVER do this
}

// ❌ BAD - Don't hardcode in tests either
fn test_real_input() {
    assert_eq!(solve("input.txt"), (1234, 5678));
}

// ❌ BAD - Don't return placeholder zeros either
fn solve_real() -> (i32, i32) {
    // TODO: implement
    return (0, 0); // This is lazy - implement the algorithm!
}
```

**Acceptable - Must Actually Calculate:**
```rust
// ✅ GOOD - Actually parse input and calculate
fn solve_real(input_data: &str) -> (i32, i32) {
    let instructions = parse_input(input_data);
    let part1 = calculate_part1(&instructions);
    let part2 = calculate_part2(&instructions);
    (part1, part2)
}

// ✅ GOOD - For languages without file I/O, hardcode the INPUT (not the answer)
fn solve_real() -> (i32, i32) {
    // If file I/O unavailable, hardcode the INPUT itself
    let hardcoded_input = "L123\nR456\n..."; // Input data, not answer
    parse_and_solve(hardcoded_input) // Calculate from there
}

// ✅ GOOD - Verify structure only in tests
fn test_real_input() {
    let result = solve("input.txt");
    assert!(result.0 > 0); // Verify it calculated something
    assert!(result.1 > 0);
}
```

**Key Rule:** Always CALCULATE the answer. If your language lacks file I/O:
- Hardcode the INPUT data (rotation instructions) ✅
- Parse and process that input ✅
- Let the algorithm calculate the answer ✅
- NEVER hardcode the final answer itself ❌

### 5. Verification Reports
When creating verification reports:
- Document that all implementations produce **identical** results
- Confirm results match sample expectations
- Use "REDACTED" for real puzzle answers
- State pass/fail without revealing actual values

Example:
```
✅ All 5 languages produce identical results:
- Sample: {"part1": 3, "part2": 6}
- Real: {"part1": REDACTED, "part2": REDACTED}
```

### 6. Git Commits
- Review diffs before committing
- Ensure no real answers leaked into docs
- Real `input.txt` files are in `.gitignore` (personal puzzle input)

## Rationale
- **Respect the community:** Don't spoil puzzles for others
- **Shareable code:** Repository can be public without giving away answers
- **Focus on learning:** Code demonstrates techniques, not just solutions
- **AoC guidelines:** Aligns with Advent of Code's request not to share answers publicly

## Exceptions
None - this is a strict policy for all Advent of Code work.

## Enforcement
- Implementer agents must follow these rules
- Verifier agents should check for leaked answers
- Code reviews should flag any real answer exposure
