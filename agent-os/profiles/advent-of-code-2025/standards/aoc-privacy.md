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
- Real input should be read from file, not hardcoded

**NOT acceptable:**
```rust
// ❌ BAD - Don't hardcode real answers
fn test_real_input() {
    assert_eq!(solve("input.txt"), (1234, 5678));
}
```

**Acceptable:**
```rust
// ✅ GOOD - Calculate and verify structure only
fn test_real_input() {
    let result = solve("input.txt");
    assert!(result.0 > 0); // Verify it calculated something
    assert!(result.1 > 0);
}
```

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
