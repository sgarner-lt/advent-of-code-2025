# Advent of Code File Handling Standards

## Purpose
This standard defines which files in the project are READ-ONLY and should NEVER be modified by agents, preventing accidental data loss and ensuring input file integrity.

## File Structure Overview

Each day's challenge has the following file structure:

```
challenges/dayXX/
├── input.txt                      # READ-ONLY - Real puzzle input
├── input-sample.txt               # READ-ONLY - Sample input from problem
├── input-sample-expected-output.txt  # READ-ONLY - Expected output for sample
└── problem-statement.txt          # READ-ONLY - Problem description
```

## Critical Rules

### 1. NEVER Modify Input Files

**The following files are READ-ONLY and must NEVER be modified:**

- ✋ **`challenges/dayXX/input.txt`** - Real puzzle input from user's Advent of Code account
- ✋ **`challenges/dayXX/input-sample.txt`** - Sample input from problem statement
- ✋ **`challenges/dayXX/input-sample-expected-output.txt`** - Expected output for validation
- ✋ **`challenges/dayXX/problem-statement.txt`** - Problem description reference

**Why this matters:**
- `input.txt` contains the user's personal puzzle input - if lost, cannot be recovered
- Sample files are reference data for validation - if corrupted, tests will fail
- These files are foundational to the entire project - modification breaks everything

### 2. File Purposes

#### `input.txt` (Real Puzzle Input)
- **Purpose:** Contains the actual puzzle input from the user's Advent of Code account
- **Source:** Downloaded by the user from adventofcode.com
- **Usage:** Used by integration tests with default mode (no `--sample` flag)
- **Protection:** MUST be in `.gitignore` (personal data, not shared publicly)
- **Status:** **READ-ONLY** - Agents must NEVER write to this file

#### `input-sample.txt` (Sample Input)
- **Purpose:** Contains the sample input from the problem statement
- **Source:** Copied from the Advent of Code problem description
- **Usage:** Used by integration tests with `--sample` flag
- **Usage:** Used to validate implementations work correctly before testing with real input
- **Status:** **READ-ONLY** - Agents must NEVER write to this file

#### `input-sample-expected-output.txt` (Expected Sample Output)
- **Purpose:** Contains the expected JSON output for the sample input
- **Format:** `{"part1": <value>, "part2": <value>}`
- **Source:** Values from the problem statement
- **Usage:** Validation and verification of sample output correctness
- **Status:** **READ-ONLY** - Agents must NEVER write to this file

#### `problem-statement.txt` (Problem Reference)
- **Purpose:** Optional reference copy of the problem description
- **Source:** Copied from Advent of Code website
- **Usage:** Quick reference during implementation
- **Status:** **READ-ONLY** - Agents must NEVER write to this file

### 3. Allowed File Operations

**Agents MAY:**
- ✅ **Read** any input file
- ✅ **Create** solution files in `solutions/` directories
- ✅ **Modify** solution files in `solutions/` directories
- ✅ **Create** test files in `solutions/*/test/` directories
- ✅ **Create** documentation in `agent-os/specs/` directories
- ✅ **Create** verification reports in `agent-os/specs/*/verifications/`

**Agents MUST NEVER:**
- ❌ **Write** to any file in `challenges/` directories
- ❌ **Modify** any file in `challenges/` directories
- ❌ **Delete** any file in `challenges/` directories
- ❌ **Move** any file in `challenges/` directories
- ❌ **Rename** any file in `challenges/` directories

### 4. Testing Workflows

**Using Sample Input:**
```bash
# Read sample input for testing
cat challenges/day04/input-sample.txt | ./scripts/run_rust.sh 4

# Run integration tests with sample input
./scripts/test_integration.sh 4 --sample
```

**Using Real Input:**
```bash
# Read real input for production run
cat challenges/day04/input.txt | ./scripts/run_rust.sh 4

# Run integration tests with real input (default)
./scripts/test_integration.sh 4
```

### 5. Validation Before Testing

**Before running tests, agents should:**

1. ✅ Verify input files exist and are readable
2. ✅ Confirm sample expected output file exists
3. ❌ NEVER attempt to "fix" or "update" input files
4. ❌ NEVER write expected outputs - these are reference data

### 6. Error Handling

**If an input file is missing or corrupted:**

❌ **WRONG - Don't try to fix it:**
```bash
# Bad - don't create or overwrite input files
echo "..." > challenges/day04/input.txt  # NEVER DO THIS
```

✅ **RIGHT - Report to the user:**
```
Error: Input file missing or corrupted
File: challenges/day04/input.txt
Action: User must restore from backup or re-download from adventofcode.com
Status: Cannot proceed with testing until file is restored
```

### 7. Implementation vs. Input

**Clear separation:**

- **Implementation files** (in `solutions/`): Agents can create and modify
- **Input files** (in `challenges/`): Agents can ONLY read
- **Test files** (in `solutions/*/test/`): Agents can create and modify
- **Documentation** (in `agent-os/`): Agents can create and modify

### 8. Pre-Flight Checks

**Before any test run, verify:**

```bash
# Check files exist (READ-ONLY check)
test -f challenges/day04/input.txt
test -f challenges/day04/input-sample.txt
test -f challenges/day04/input-sample-expected-output.txt

# Get checksums to detect corruption (but never "fix")
md5 challenges/day04/input-sample.txt
```

**Never attempt to:**
- Create missing input files
- Repair corrupted input files
- Update expected output files
- Normalize or reformat input files

### 9. Common Mistakes to Avoid

❌ **Mistake 1: Overwriting real input with sample data**
```bash
# BAD - This destroys the real input!
cp challenges/day04/input-sample.txt challenges/day04/input.txt
```

❌ **Mistake 2: Writing test output to input files**
```bash
# BAD - This overwrites the input!
./scripts/run_rust.sh 4 > challenges/day04/input.txt
```

❌ **Mistake 3: "Fixing" expected output**
```bash
# BAD - Expected output is reference data, not generated!
echo '{"part1": 13, "part2": 43}' > challenges/day04/input-sample-expected-output.txt
```

❌ **Mistake 4: Creating input files programmatically**
```bash
# BAD - Input files come from adventofcode.com, not agents!
generate_input > challenges/day04/input.txt
```

### 10. Recovery Procedure

**If an input file is accidentally modified:**

1. **Stop immediately** - Don't continue with implementation
2. **Notify the user** with specific file path and what happened
3. **Recommend recovery:**
   - Check git history: `git diff challenges/day04/input.txt`
   - Restore from git: `git checkout -- challenges/day04/input.txt`
   - Re-download from adventofcode.com if not in git
4. **Verify integrity** before continuing

## Rationale

- **Data integrity:** Input files are irreplaceable reference data
- **Test validity:** Corrupted inputs make all tests meaningless
- **User trust:** Agents must be safe and predictable
- **Debugging:** Original inputs needed to reproduce issues

## Enforcement

- All implementer agents must follow these rules
- Verifier agents should check file integrity before and after tests
- Any violation should be treated as a critical error
- User should be notified immediately of any file modification attempts

## Summary

**Golden Rule:** Agents READ from `challenges/`, they WRITE to `solutions/` and `agent-os/`.

If you're about to modify anything in `challenges/`, STOP and reconsider.
