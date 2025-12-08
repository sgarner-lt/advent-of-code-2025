# Carbon Implementation Guide

## Problem: Python Wrappers Were Being Created

During Days 1-4 development, AI agents created Python wrapper files (`runner.py`, `test_runner.py`) with stub Carbon files, rather than implementing real Carbon code. This required manual migration work to replace wrappers with real Carbon implementations.

## Root Cause

The agent-os documentation (specifically `carbon-solver.md`) contained:
1. **Outdated project structure** showing Python files as expected
2. **Hypothetical Carbon syntax** that doesn't exist yet (future syntax from design docs)
3. **No explicit warnings** against Python wrappers
4. **No working examples** of real Carbon code

## Solution: Updated Documentation

### Updated Files

1. **[agent-os/profiles/advent-of-code-2025/agents/carbon-solver.md](agents/carbon-solver.md)**
   - ⚠️ **CRITICAL WARNING**: "DO NOT create Python wrapper files"
   - Real Carbon syntax examples (character I/O, arrays, functions)
   - Reference implementations from Days 1-4
   - Explicit containerized approach
   - Carbon limitations with specific error messages
   - Working code patterns that compile

2. **[docs/languages/carbon.md](../../../docs/languages/carbon.md)**
   - Added trailing comment restriction
   - Added nested array parameter limitation
   - Expanded troubleshooting with examples
   - Updated limitations list

## Key Changes to Prevent Future Python Wrappers

### 1. Explicit Warning at Top of File

```markdown
## ⚠️ CRITICAL: No Python Wrappers

**DO NOT create Python wrapper files (`runner.py`, `test_runner.py`).**
```

### 2. Corrected Project Structure

**BEFORE (Encouraged Python):**
```
solutions/carbon/dayXX/
  ├── dayXX.carbon
  ├── runner.py           # ❌ WRONG
  └── test_runner.py      # ❌ WRONG
```

**AFTER (Real Carbon):**
```
solutions/carbon/dayXX/
  ├── dayXX_simple.carbon  # ✅ REAL Carbon code
  └── README.md
```

### 3. Real Carbon Syntax Examples

Replaced hypothetical syntax with working code:

**BEFORE (Doesn't work):**
```carbon
// Hypothetical syntax from design docs
fn ParseInput(input: String) -> Vector(Int) {
  var result: Vector(Int) = Vector.New();
  return result;
}
```

**AFTER (Actually works):**
```carbon
// Real Carbon character I/O
import Core library "io";

fn ParseInput() {
  var ch: i32 = Core.ReadChar();
  if (ch == Core.EOF()) {
    return false;
  }
  Core.PrintChar(ch);
}
```

### 4. Reference Implementations

Added explicit pointers to working examples:
- `solutions/carbon/day01/day01_simple.carbon` - Navigation
- `solutions/carbon/day02/day02_simple.carbon` - Safe reports
- `solutions/carbon/day03/day03_simple.carbon` - Digit extraction
- `solutions/carbon/day04/day04_simple.carbon` - Grid processing

### 5. Critical Carbon Syntax Rules

Documented specific rules discovered during Days 1-4:

```markdown
1. **No trailing comments**: Comments MUST be on their own line
2. **No nested array parameters**: Use global variables
3. **No string type**: Use character-by-character I/O
4. **Immutable parameters**: Copy to local variable first
```

Each rule includes:
- Error message you'll see
- INCORRECT example that fails
- CORRECT example that works

## Testing the Improvements

### Before (Would Create Python Wrappers)

Agent sees:
- "Solutions in `dayXX/carbon/solution.carbon`"
- Hypothetical `Vector(Int)`, `String` types
- No warnings about Python

Result: Creates `runner.py` because Carbon syntax seems impossible

### After (Creates Real Carbon)

Agent sees:
- **⚠️ "DO NOT create Python wrapper files"**
- Working character I/O examples
- Reference to 4 existing implementations
- Containerized approach explained

Result: Copies patterns from day01-04, writes real Carbon code

## Migration History

### Days 1-4 Python Wrapper Pattern
All initially implemented as:
- `runner.py` - Python script with algorithm
- `dayXX.carbon` - Stub file with comments only
- Real work done in Python

### Days 1-4 Carbon Migration (Completed)
All migrated to:
- `dayXX_simple.carbon` - Pure Carbon implementation
- Character-based I/O using Core library
- Containerized Bazel build
- Cross-language validation passing

### Deleted Files
- All `runner.py` files
- All `test_runner.py` files
- All stub `dayXX.carbon` files
- Only `dayXX_simple.carbon` remains

## Verification

Run this to check for any remaining Python wrappers:

```bash
# Should find NO Python files in carbon directories
find solutions/carbon -name "runner.py" -o -name "test_runner.py"
```

All Carbon implementations should:
1. Be in `dayXX_simple.carbon` files
2. Import `Core library "io"`
3. Use `Core.ReadChar()` and `Core.PrintChar()`
4. Compile in the container with Bazel
5. Pass integration tests

## For Future Days

When implementing new days:

1. **Read the updated carbon-solver.md first**
2. **Copy patterns from existing days** (don't invent syntax)
3. **Never create Python files** in carbon directories
4. **Reference Days 1-4** for all code patterns
5. **Test in container** before considering it complete

The documentation now explicitly prevents the Python wrapper pattern and guides agents toward real Carbon implementations.
