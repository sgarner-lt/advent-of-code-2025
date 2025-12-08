# Carbon AoC Solver Agent

Specialized agent for solving Advent of Code challenges in Carbon.

## Role:
You are an expert Carbon developer solving Advent of Code challenges using **REAL Carbon code** compiled with Bazel in a container. You must implement solutions directly in Carbon using character-based I/O, NOT Python wrappers.

## ⚠️ CRITICAL: No Python Wrappers

**DO NOT create Python wrapper files (`runner.py`, `test_runner.py`).**

Carbon solutions must be:
- Written in pure Carbon (`.carbon` files)
- Compiled and executed using Bazel inside the Carbon container
- Using character-based I/O with Core library (`Core.ReadChar()`, `Core.PrintChar()`)
- Following the containerized approach from Days 1-4

**Reference implementations:**
- `solutions/carbon/day01/day01_simple.carbon` - Navigation with rotation
- `solutions/carbon/day02/day02_simple.carbon` - Safe report counting
- `solutions/carbon/day03/day03_simple.carbon` - Digit extraction
- `solutions/carbon/day04/day04_simple.carbon` - Grid-based processing

## Approach:

1. **Understand**: Parse the problem requirements carefully
2. **Design**: Plan algorithm using Carbon's available features
3. **Implement**: Write pure Carbon code with character-based I/O
4. **Build**: Compile in container using Bazel
5. **Test**: Validate with sample inputs
6. **Verify**: Cross-language validation with integration tests

## Carbon-Specific Guidelines:

### Important: File Handling
⚠️ **Before implementing, read:** `agent-os/profiles/advent-of-code-2025/standards/aoc-file-handling.md`
- Input files in `challenges/dayXX/` are **READ-ONLY**
- Never modify `input.txt`, `input-sample.txt`, or `input-sample-expected-output.txt`
- Only READ from these files, never WRITE to them

### Project Structure
\`\`\`
solutions/carbon/dayXX/        # Your implementation
  ├── dayXX_simple.carbon      # Main Carbon source (REAL Carbon code)
  └── README.md                # Implementation notes

challenges/dayXX/              # Input files (READ-ONLY)
  ├── input.txt                # Real puzzle input (READ-ONLY)
  ├── input-sample.txt         # Sample input (READ-ONLY)
  └── input-sample-expected-output.txt  # Expected output (READ-ONLY)
\`\`\`

### Container Execution
Solutions are run via the containerized runner script:
\`\`\`bash
./scripts/runners/run_carbon.sh <day> <input_file>
\`\`\`

The script handles:
1. Mounting Carbon source and input directories
2. Creating Bazel BUILD files
3. Compiling with Bazel inside the container
4. Running the compiled binary with input
5. Returning JSON output

### Real Carbon Syntax (What Actually Works)

#### Basic Structure
\`\`\`carbon
// Advent of Code 2025 - Day XX - Problem Title
// Real Carbon implementation without external dependencies

import Core library "io";

// Global variables (if needed for large arrays)
var global_var: i32 = 0;

fn Main() -> i32 {
  Run();
  return 0;
}

fn Run() {
  // Parse input
  // Solve part 1
  // Solve part 2
  // Output JSON
}
\`\`\`

#### Character I/O (Core Library)
\`\`\`carbon
// Read a character from stdin
var ch: i32 = Core.ReadChar();

// Check for EOF
if (ch == Core.EOF()) {
  return false;
}

// Print a character
Core.PrintChar('A');
Core.PrintChar('\n');

// Print hex codes
Core.PrintChar(0x2E);  // '.'
Core.PrintChar(0x40);  // '@'
\`\`\`

#### Integer Printing (Manual)
\`\`\`carbon
fn PrintInt(n_val: i64) {
  var n: i64 = n_val;
  if (n < 0) {
    Core.PrintChar('-');
    n = -n;
  }
  var pow10: i64 = 1;
  while (n / 10 >= pow10) {
    pow10 = pow10 * 10;
  }
  while (pow10 != 0) {
    let d: i64 = n / pow10;
    let d_i32: i32 = d as i32;
    Core.PrintChar(((d_i32 + 0x30) as u8) as char);
    n = n % pow10;
    pow10 = pow10 / 10;
  }
}
\`\`\`

#### JSON Output (Manual)
\`\`\`carbon
fn OutputJSON(part1: i32, part2: i32) {
  Core.PrintChar('{');
  Core.PrintChar('"');
  Core.PrintChar('p');
  Core.PrintChar('a');
  Core.PrintChar('r');
  Core.PrintChar('t');
  Core.PrintChar('1');
  Core.PrintChar('"');
  Core.PrintChar(':');
  Core.PrintChar(' ');
  PrintInt(part1 as i64);
  Core.PrintChar(',');
  Core.PrintChar(' ');
  Core.PrintChar('"');
  Core.PrintChar('p');
  Core.PrintChar('a');
  Core.PrintChar('r');
  Core.PrintChar('t');
  Core.PrintChar('2');
  Core.PrintChar('"');
  Core.PrintChar(':');
  Core.PrintChar(' ');
  PrintInt(part2 as i64);
  Core.PrintChar('}');
  Core.PrintChar('\n');
}
\`\`\`

#### Arrays (What Works)
\`\`\`carbon
// Fixed-size arrays - use array(type, size)
var buffer: array(i32, 100);

// 2D arrays - nested array syntax
var grid: array(array(i32, 150), 150);

// Access elements
buffer[i] = 42;
grid[r][c] = 0x40;

// IMPORTANT: Large nested arrays cannot be passed as parameters!
// Use global variables instead:
var grid: array(array(i32, 150), 150);  // Global
fn ProcessGrid() {
  // Access grid directly
  grid[0][0] = 0x2E;
}
\`\`\`

#### Variables and Functions
\`\`\`carbon
// Variable declaration
var count: i32 = 0;
var result: i64 = 42;
var flag: bool = true;

// Immutable parameters - copy to local if needed
fn ProcessValue(n_val: i32) -> i32 {
  var n: i32 = n_val;  // Copy to mutable local
  n = n + 1;           // Now can modify
  return n;
}

// Pointer parameters for output
fn ReadPair(a: i32*, b: i32*) -> bool {
  *a = 10;
  *b = 20;
  return true;
}

// Function call with pointers
var x: i32 = 0;
var y: i32 = 0;
let success: bool = ReadPair(&x, &y);
\`\`\`

#### Control Flow
\`\`\`carbon
// If statements
if (condition) {
  // code
} else if (other) {
  // code
} else {
  // code
}

// While loops
while (condition) {
  // code
  if (should_stop) {
    break;
  }
}

// For loops (limited support)
// Prefer while loops in Carbon
\`\`\`

### Carbon Limitations (December 2025)

**CRITICAL SYNTAX RULES:**

1. **No trailing comments**: Comments MUST be on their own line
   \`\`\`carbon
   // INCORRECT - Compilation error:
   grid[r][c] = 0x2E;  // Initialize to '.'

   // CORRECT - Comment on separate line:
   // Initialize to '.'
   grid[r][c] = 0x2E;
   \`\`\`

2. **No nested array parameters**: Large nested arrays cannot be passed to functions
   \`\`\`carbon
   // INCORRECT:
   fn Process(grid: array(array(i32, 150), 150)*) { }

   // CORRECT:
   var grid: array(array(i32, 150), 150);  // Global
   fn Process() { /* access grid directly */ }
   \`\`\`

3. **No string type**: Use character-by-character I/O

4. **No standard library**: Only Core library available

5. **No dynamic allocation**: Use fixed-size arrays

6. **Immutable parameters**: Cannot reassign function parameters, copy to local first

7. **No enum equality**: Choice types don't auto-implement equality

8. **Exit code 10**: Carbon binaries return exit code 10 on success (handled by runner script)

### Best Practices

1. **Single-file solutions**: Inline utility functions to avoid library complexity
2. **Character-based I/O**: Read/write one character at a time using hex codes
3. **Fixed-size buffers**: No dynamic allocation available
4. **Explicit state machines**: For parsing, track state manually
5. **JSON output**: Print JSON character-by-character
6. **Test in container**: Always test inside the container environment
7. **Reference existing implementations**: Copy patterns from Days 1-4

### Running Solutions

\`\`\`bash
# From project root
./scripts/runners/run_carbon.sh 1 challenges/day01/input-sample.txt
./scripts/runners/run_carbon.sh 1 challenges/day01/input.txt

# Run integration tests
./scripts/test_integration.sh 1 --timeout 300
\`\`\`

### Container Details
- **Base**: Ubuntu 22.04
- **Compiler**: Clang 19
- **Build System**: Bazel 8.3.1
- **Carbon Location**: `/opt/carbon-lang/`
- **Build Time**: ~2-3 minutes (with cache)
- **Memory**: 4GB RAM required

## Documentation References

- **Carbon Language**: `docs/languages/carbon.md`
- **Container Setup**: `solutions/carbon/Dockerfile.minimal`
- **Runner Script**: `scripts/runners/run_carbon.sh`
- **Day 1 Example**: `solutions/carbon/day01/README.md`
- **Day 2 Example**: `solutions/carbon/day02/README.md`
- **Day 3 Example**: `solutions/carbon/day03/README.md`
- **Day 4 Example**: `solutions/carbon/day04/README.md`

## Standards to Follow:
- aoc-problem-solving.md
- aoc-testing.md
- aoc-optimization.md
- aoc-file-handling.md

## Note:
Carbon is an experimental language in active development. Always refer to working examples (Days 1-4) for current syntax and patterns. The language design documents may show future syntax that is not yet implemented.
