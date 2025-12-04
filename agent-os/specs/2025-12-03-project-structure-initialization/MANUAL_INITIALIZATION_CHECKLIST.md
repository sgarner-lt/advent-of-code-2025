# Manual Initialization Checklist
## Advent of Code 2025 - Project Structure Setup

This document provides step-by-step manual instructions for initializing the complete Advent of Code 2025 project structure across all 5 languages for all 10 days.

**IMPORTANT:** Advent of Code 2025 is a special 10-day event (days 1-10 only, not 25 days).

---

## Table of Contents

1. [Directory Structure Overview](#directory-structure-overview)
2. [Prerequisites](#prerequisites)
3. [Language-Agnostic Setup](#language-agnostic-setup)
4. [Rust Initialization](#rust-initialization)
5. [Gleam Initialization](#gleam-initialization)
6. [Roc Initialization](#roc-initialization)
7. [Carbon Initialization](#carbon-initialization)
8. [Bosque Initialization](#bosque-initialization)
9. [Verification](#verification)

---

## Directory Structure Overview

The project follows a language-first directory structure where each language has its own top-level directory containing day subdirectories:

```
advent-of-code-2025/
├── rust/
│   ├── Cargo.toml                 # Workspace configuration
│   ├── day01/
│   │   ├── Cargo.toml
│   │   └── src/
│   │       └── main.rs
│   ├── day02/
│   │   ├── Cargo.toml
│   │   └── src/
│   │       └── main.rs
│   ├── ... (day03 through day09)
│   └── day10/
│       ├── Cargo.toml
│       └── src/
│           └── main.rs
├── gleam/
│   ├── gleam.toml                 # Root configuration
│   ├── day01/
│   │   ├── gleam.toml
│   │   └── src/
│   │       └── day01.gleam
│   ├── day02/
│   │   ├── gleam.toml
│   │   └── src/
│   │       └── day02.gleam
│   ├── ... (day03 through day09)
│   └── day10/
│       ├── gleam.toml
│       └── src/
│           └── day10.gleam
├── roc/
│   ├── day01/
│   │   └── day01.roc
│   ├── day02/
│   │   └── day02.roc
│   ├── ... (day03 through day09)
│   └── day10/
│       └── day10.roc
├── carbon/
│   ├── day01/
│   │   └── day01.carbon
│   ├── day02/
│   │   └── day02.carbon
│   ├── ... (day03 through day09)
│   └── day10/
│       └── day10.carbon
├── bosque/
│   ├── README.md                  # Experimental language notes
│   ├── day01/
│   │   └── day01.bsq
│   ├── day02/
│   │   └── day02.bsq
│   ├── ... (day03 through day09)
│   └── day10/
│       └── day10.bsq
└── challenges/
    ├── day01/
    │   ├── input.txt              # Actual puzzle input (populate manually)
    │   └── input-sample.txt       # Sample input from problem statement
    ├── day02/
    │   ├── input.txt
    │   └── input-sample.txt
    ├── ... (day03 through day09)
    └── day10/
        ├── input.txt
        └── input-sample.txt
```

**Key Points:**
- Language-first structure: `rust/day01/`, NOT `day01/rust/`
- All 10 days pre-created: `day01/` through `day10/`
- Shared challenges directory at repository root
- Each language solution references: `../../challenges/dayXX/input.txt`

---

## Prerequisites

Before beginning, verify that all required language tooling is installed.

### Required Tooling

| Language | Tool | Minimum Version | Verification Command |
|----------|------|----------------|---------------------|
| Rust | cargo | Latest stable | `cargo --version` |
| Gleam | gleam | Latest stable | `gleam --version` |
| Roc | roc | Latest stable | `roc version` |
| Carbon | carbon | Experimental | `carbon --version` (may not exist) |
| Bosque | bosque | Experimental | `bosque --version` (may not exist) |

### Verification Steps

Run each verification command in your terminal:

```bash
# Verify Rust installation
cargo --version
# Expected output: cargo 1.x.x or higher

# Verify Gleam installation
gleam --version
# Expected output: gleam x.x.x or higher

# Verify Roc installation
roc version
# Expected output: roc x.x.x or higher

# Carbon and Bosque are experimental - tooling may be limited
carbon --version 2>/dev/null || echo "Carbon tooling not found (expected for experimental language)"
bosque --version 2>/dev/null || echo "Bosque tooling not found (expected for experimental language)"
```

### Installation Notes

- **Rust**: Install via [rustup.rs](https://rustup.rs/)
- **Gleam**: Install via package manager or from [gleam.run](https://gleam.run/)
- **Roc**: Install from [roc-lang.org](https://www.roc-lang.org/)
- **Carbon**: Experimental - see [github.com/carbon-language/carbon-lang](https://github.com/carbon-language/carbon-lang)
- **Bosque**: Experimental - see [github.com/microsoft/BosqueLanguage](https://github.com/microsoft/BosqueLanguage)

**NOTE:** Carbon and Bosque are experimental languages with limited tooling. You may need to adapt the initialization steps based on available tools.

---

## Language-Agnostic Setup

These steps create the shared challenges directory structure used by all languages.

### Step 1: Create Challenges Root Directory

```bash
# Navigate to repository root
cd /Users/sgarner/projects/sgarner-lt/advent-of-code-2025

# Create challenges directory
mkdir -p challenges
```

### Step 2: Create Day Subdirectories

Create all 10 day subdirectories:

```bash
# Create day01 through day10 directories
mkdir -p challenges/day01
mkdir -p challenges/day02
mkdir -p challenges/day03
mkdir -p challenges/day04
mkdir -p challenges/day05
mkdir -p challenges/day06
mkdir -p challenges/day07
mkdir -p challenges/day08
mkdir -p challenges/day09
mkdir -p challenges/day10
```

**Alternative using a loop (bash/zsh):**

```bash
for day in {01..10}; do
  mkdir -p challenges/day${day}
done
```

### Step 3: Create Empty Input Files

Create empty `input.txt` and `input-sample.txt` files in each day directory:

```bash
# For each day, create both input files
for day in {01..10}; do
  touch challenges/day${day}/input.txt
  touch challenges/day${day}/input-sample.txt
done
```

**Windows equivalent (PowerShell):**

```powershell
1..10 | ForEach-Object {
  $day = $_.ToString("00")
  New-Item -Path "challenges/day$day" -ItemType Directory -Force
  New-Item -Path "challenges/day$day/input.txt" -ItemType File -Force
  New-Item -Path "challenges/day$day/input-sample.txt" -ItemType File -Force
}
```

### Step 4: Verify Challenges Structure

```bash
# List the challenges directory structure
ls -la challenges/

# Verify all files exist
find challenges -type f | sort
```

**Expected output:**
```
challenges/day01/input-sample.txt
challenges/day01/input.txt
challenges/day02/input-sample.txt
challenges/day02/input.txt
...
challenges/day10/input-sample.txt
challenges/day10/input.txt
```

### Step 5: Manual Input Population

Input files must be populated manually from the Advent of Code website:

1. **Obtain Actual Input**:
   - Visit https://adventofcode.com/2025/day/1 (replace 1 with day number)
   - Log in with your account
   - Copy your personalized input
   - Paste into corresponding `challenges/dayXX/input.txt`

2. **Extract Sample Input**:
   - Read the problem description on the same page
   - Copy the example input shown in the problem
   - Paste into corresponding `challenges/dayXX/input-sample.txt`

3. **File Format**:
   - Plain text only
   - Preserve all whitespace, line breaks, and formatting exactly as shown
   - No automation is provided (requires authentication)

---

## Rust Initialization

Rust uses a workspace configuration to manage all 10 days as a single cohesive project.

### Step 1: Create Rust Root Directory

```bash
cd /Users/sgarner/projects/sgarner-lt/advent-of-code-2025
mkdir -p rust
```

### Step 2: Create Workspace Cargo.toml

Create `rust/Cargo.toml` with the following content:

```toml
[workspace]
resolver = "2"

members = [
    "day01",
    "day02",
    "day03",
    "day04",
    "day05",
    "day06",
    "day07",
    "day08",
    "day09",
    "day10",
]
```

**To create this file:**

```bash
cat > rust/Cargo.toml << 'EOF'
[workspace]
resolver = "2"

members = [
    "day01",
    "day02",
    "day03",
    "day04",
    "day05",
    "day06",
    "day07",
    "day08",
    "day09",
    "day10",
]
EOF
```

### Step 3: Initialize Day Subdirectories

Initialize each day as a binary crate using `cargo init`:

```bash
cd rust

# Initialize all 10 days
cargo init day01 --name day01
cargo init day02 --name day02
cargo init day03 --name day03
cargo init day04 --name day04
cargo init day05 --name day05
cargo init day06 --name day06
cargo init day07 --name day07
cargo init day08 --name day08
cargo init day09 --name day09
cargo init day10 --name day10
```

### Step 4: Update Each Day's Cargo.toml

For each day, update the `Cargo.toml` to use Rust 2024 edition.

**Example for day01** (`rust/day01/Cargo.toml`):

```toml
[package]
name = "day01"
version = "0.1.0"
edition = "2024"

[dependencies]
```

Repeat for all days (day01 through day10), changing only the package name.

**Automated update (bash/zsh):**

```bash
for day in {01..10}; do
  cat > rust/day${day}/Cargo.toml << EOF
[package]
name = "day${day}"
version = "0.1.0"
edition = "2024"

[dependencies]
EOF
done
```

### Step 5: Create Boilerplate main.rs

For each day, replace `src/main.rs` with the following boilerplate.

**Template** (`rust/dayXX/src/main.rs`):

```rust
use std::fs;

fn main() {
    let input = read_input("../../challenges/dayXX/input.txt");

    println!("Part 1: {}", part1(&input));
    println!("Part 2: {}", part2(&input));
}

fn read_input(path: &str) -> String {
    fs::read_to_string(path)
        .expect("Failed to read input file")
}

fn part1(input: &str) -> i32 {
    0
}

fn part2(input: &str) -> i32 {
    0
}
```

**Apply to all days:**

For each day (day01 through day10), copy the template and replace `XX` with the appropriate day number.

**Example commands:**

```bash
# Day 01
cat > rust/day01/src/main.rs << 'EOF'
use std::fs;

fn main() {
    let input = read_input("../../challenges/day01/input.txt");

    println!("Part 1: {}", part1(&input));
    println!("Part 2: {}", part2(&input));
}

fn read_input(path: &str) -> String {
    fs::read_to_string(path)
        .expect("Failed to read input file")
}

fn part1(input: &str) -> i32 {
    0
}

fn part2(input: &str) -> i32 {
    0
}
EOF

# Day 02
cat > rust/day02/src/main.rs << 'EOF'
use std::fs;

fn main() {
    let input = read_input("../../challenges/day02/input.txt");

    println!("Part 1: {}", part1(&input));
    println!("Part 2: {}", part2(&input));
}

fn read_input(path: &str) -> String {
    fs::read_to_string(path)
        .expect("Failed to read input file")
}

fn part1(input: &str) -> i32 {
    0
}

fn part2(input: &str) -> i32 {
    0
}
EOF

# Continue for day03 through day10...
```

**Automated approach for remaining days:**

```bash
for day in {03..10}; do
  cat > rust/day${day}/src/main.rs << EOF
use std::fs;

fn main() {
    let input = read_input("../../challenges/day${day}/input.txt");

    println!("Part 1: {}", part1(&input));
    println!("Part 2: {}", part2(&input));
}

fn read_input(path: &str) -> String {
    fs::read_to_string(path)
        .expect("Failed to read input file")
}

fn part1(input: &str) -> i32 {
    0
}

fn part2(input: &str) -> i32 {
    0
}
EOF
done
```

### Step 6: Verify Rust Setup

```bash
cd rust

# Check that all projects compile
cargo check --workspace

# Expected output: "Finished ..." with no errors

# Test individual day
cd day01
cargo run

# Expected: Program runs but outputs "Part 1: 0" and "Part 2: 0"
```

### Troubleshooting

- **Error: "failed to read input file"**: Input file doesn't exist or path is wrong. Verify challenges/dayXX/ structure.
- **Edition 2024 not found**: Update Rust to the latest version with `rustup update stable`
- **Workspace member not found**: Verify all day directories exist and are listed in workspace Cargo.toml

---

## Gleam Initialization

Gleam uses individual project configurations per day with standard dependencies.

### Step 1: Create Gleam Root Directory

```bash
cd /Users/sgarner/projects/sgarner-lt/advent-of-code-2025
mkdir -p gleam
```

### Step 2: Create Root gleam.toml

Create `gleam/gleam.toml` with shared dependencies. This serves as a reference configuration:

```toml
name = "advent_of_code_2025"
version = "1.0.0"

[dependencies]
gleam_stdlib = ">= 0.44.0 and < 2.0.0"

[dev-dependencies]
gleeunit = ">= 1.0.0 and < 2.0.0"
```

**To create this file:**

```bash
cat > gleam/gleam.toml << 'EOF'
name = "advent_of_code_2025"
version = "1.0.0"

[dependencies]
gleam_stdlib = ">= 0.44.0 and < 2.0.0"

[dev-dependencies]
gleeunit = ">= 1.0.0 and < 2.0.0"
EOF
```

### Step 3: Initialize Day Subdirectories

For each day, create the directory structure with src subdirectory:

```bash
cd gleam

# Create all day directories with src subdirectories
for day in {01..10}; do
  mkdir -p day${day}/src
done
```

### Step 4: Create Day-Specific gleam.toml

For each day, create a `gleam.toml` configuration file following the hello/gleam pattern.

**Template** (`gleam/dayXX/gleam.toml`):

```toml
name = "dayXX"
version = "1.0.0"

[dependencies]
gleam_stdlib = ">= 0.44.0 and < 2.0.0"

[dev-dependencies]
gleeunit = ">= 1.0.0 and < 2.0.0"
```

**Apply to all days:**

```bash
for day in {01..10}; do
  cat > gleam/day${day}/gleam.toml << EOF
name = "day${day}"
version = "1.0.0"

[dependencies]
gleam_stdlib = ">= 0.44.0 and < 2.0.0"

[dev-dependencies]
gleeunit = ">= 1.0.0 and < 2.0.0"
EOF
done
```

### Step 5: Create Boilerplate Source Files

For each day, create the main Gleam source file with boilerplate. Gleam does not have built-in file I/O in the standard library, so the boilerplate provides a Result-based structure ready for implementation.

**Template** (`gleam/dayXX/src/dayXX.gleam`):

```gleam
import gleam/io

pub fn main() -> Nil {
  let input_result = read_input("../../challenges/dayXX/input.txt")

  case input_result {
    Ok(content) -> {
      io.println("Part 1: " <> part1(content))
      io.println("Part 2: " <> part2(content))
    }
    Error(error_msg) -> io.println(error_msg)
  }
}

fn read_input(path: String) -> Result(String, String) {
  // Gleam file I/O requires external library or FFI
  // Common solutions:
  // 1. Use a file I/O library when available
  // 2. Implement via FFI to Erlang file system
  // 3. Accept input as function parameter in testing
  // For now, return error with instructions
  Error("File I/O not yet implemented - use test data or add file I/O library")
}

pub fn part1(input: String) -> String {
  "0"
}

pub fn part2(input: String) -> String {
  "0"
}
```

**Apply to all days:**

```bash
# Day 01
cat > gleam/day01/src/day01.gleam << 'EOF'
import gleam/io

pub fn main() -> Nil {
  let input_result = read_input("../../challenges/day01/input.txt")

  case input_result {
    Ok(content) -> {
      io.println("Part 1: " <> part1(content))
      io.println("Part 2: " <> part2(content))
    }
    Error(error_msg) -> io.println(error_msg)
  }
}

fn read_input(path: String) -> Result(String, String) {
  Error("File I/O not yet implemented - use test data or add file I/O library")
}

pub fn part1(input: String) -> String {
  "0"
}

pub fn part2(input: String) -> String {
  "0"
}
EOF

# Days 02-10 (automated)
for day in {02..10}; do
  cat > gleam/day${day}/src/day${day}.gleam << EOF
import gleam/io

pub fn main() -> Nil {
  let input_result = read_input("../../challenges/day${day}/input.txt")

  case input_result {
    Ok(content) -> {
      io.println("Part 1: " <> part1(content))
      io.println("Part 2: " <> part2(content))
    }
    Error(error_msg) -> io.println(error_msg)
  }
}

fn read_input(path: String) -> Result(String, String) {
  Error("File I/O not yet implemented - use test data or add file I/O library")
}

pub fn part1(input: String) -> String {
  "0"
}

pub fn part2(input: String) -> String {
  "0"
}
EOF
done
```

### Step 6: Verify Gleam Setup

```bash
cd gleam/day01

# Build the project
gleam build

# Expected output: "Compiled successfully"

# Run the project
gleam run

# Expected output: File I/O not yet implemented message or compiled output
```

**Building all days at once:**

```bash
cd gleam

# Test that all projects build
for day in {01..10}; do
  cd day${day}
  gleam build
  if [ $? -ne 0 ]; then
    echo "Build failed for day${day}"
    exit 1
  fi
  cd ..
done

echo "All Gleam projects built successfully"
```

### Step 7: File I/O Implementation Notes

Gleam's standard library does not include file I/O operations. To fully implement file reading:

**Option 1: Use Erlang FFI (if targeting Erlang)**

```gleam
@external(erlang, "file", "read_file")
fn read_file_erlang(path: String) -> Result(BitArray, String)

fn read_input(path: String) -> Result(String, String) {
  use bits <- result.try(read_file_erlang(path))
  case bit_array.to_string(bits) {
    Ok(content) -> Ok(content)
    Error(_) -> Error("Failed to decode file content")
  }
}
```

**Option 2: Use a file I/O library when available**
- Check Hex.pm for Gleam file I/O packages
- Add to dependencies in gleam.toml

**Option 3: Test-driven approach**
- Implement logic to accept input as function parameter
- Test with sample data directly
- Integrate file I/O once available

### Troubleshooting

- **gleam: command not found**: Install Gleam from [gleam.run](https://gleam.run/)
- **Dependency resolution errors**: Verify gleam_stdlib and gleeunit versions in gleam.toml
- **Build succeeds but main doesn't run**: Ensure main function returns Nil and uses io.println for output
- **File I/O not working**: This is expected. Add file I/O implementation when needed.

---

## Roc Initialization

Roc uses individual `.roc` files per day with platform declarations. No workspace concept needed.

### Step 1: Create Roc Root Directory

```bash
cd /Users/sgarner/projects/sgarner-lt/advent-of-code-2025
mkdir -p roc
```

### Step 2: Create Day Subdirectories

```bash
cd roc

# Create all 10 day directories
for day in {01..10}; do
  mkdir -p day${day}
done
```

### Step 3: Create Boilerplate Roc Files

For each day, create a `.roc` file with boilerplate.

**Template** (`roc/dayXX/dayXX.roc`):

```roc
app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.17.0/lZFLstMUCUvd5bjnnpYromZJXkQUrdhbva4xdBInicE.tar.br" }

import pf.Stdout
import pf.File
import pf.Path

main =
    inputPath = Path.fromStr "../../challenges/dayXX/input.txt"
    inputContent = File.readUtf8! inputPath

    result1 = part1 inputContent
    result2 = part2 inputContent

    Stdout.line! "Part 1: \(Num.toStr result1)"
    Stdout.line! "Part 2: \(Num.toStr result2)"

part1 : Str -> I32
part1 = \input ->
    0

part2 : Str -> I32
part2 = \input ->
    0
```

**Apply to all days:**

```bash
# Day 01
cat > roc/day01/day01.roc << 'EOF'
app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.17.0/lZFLstMUCUvd5bjnnpYromZJXkQUrdhbva4xdBInicE.tar.br" }

import pf.Stdout
import pf.File
import pf.Path

main =
    inputPath = Path.fromStr "../../challenges/day01/input.txt"
    inputContent = File.readUtf8! inputPath

    result1 = part1 inputContent
    result2 = part2 inputContent

    Stdout.line! "Part 1: \(Num.toStr result1)"
    Stdout.line! "Part 2: \(Num.toStr result2)"

part1 : Str -> I32
part1 = \input ->
    0

part2 : Str -> I32
part2 = \input ->
    0
EOF

# Days 02-10 (automated)
for day in {02..10}; do
  cat > roc/day${day}/day${day}.roc << EOF
app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.17.0/lZFLstMUCUvd5bjnnpYromZJXkQUrdhbva4xdBInicE.tar.br" }

import pf.Stdout
import pf.File
import pf.Path

main =
    inputPath = Path.fromStr "../../challenges/day${day}/input.txt"
    inputContent = File.readUtf8! inputPath

    result1 = part1 inputContent
    result2 = part2 inputContent

    Stdout.line! "Part 1: \(Num.toStr result1)"
    Stdout.line! "Part 2: \(Num.toStr result2)"

part1 : Str -> I32
part1 = \input ->
    0

part2 : Str -> I32
part2 = \input ->
    0
EOF
done
```

### Step 4: Verify Roc Setup

```bash
cd roc/day01

# Run day01
roc run day01.roc

# Expected: "Part 1: 0" and "Part 2: 0" or file read error
```

### Troubleshooting

- **roc: command not found**: Install Roc from [roc-lang.org](https://www.roc-lang.org/)
- **Platform download fails**: Check internet connection or update platform URL
- **File read errors**: Verify challenges/dayXX/ directory exists with input.txt

---

## Carbon Initialization

Carbon is an experimental language with limited tooling. These instructions provide a basic structure based on the hello/carbon example pattern.

**IMPORTANT:** Carbon is highly experimental. Tooling may be limited, unstable, or unavailable. Use these files as templates and pseudocode, with the understanding that the language and its API are subject to change.

### Step 1: Create Carbon Root Directory

```bash
cd /Users/sgarner/projects/sgarner-lt/advent-of-code-2025
mkdir -p carbon
```

**Note:** Carbon's tooling is experimental. If the carbon compiler is not available, you can still create these files as pseudocode templates for future use.

### Step 2: Create Day Subdirectories

```bash
cd carbon

# Create all 10 day directories
for day in {01..10}; do
  mkdir -p day${day}
done
```

### Step 3: Create Boilerplate Carbon Files

For each day, create a `.carbon` file with boilerplate. These files follow the pattern from hello/carbon/hello.carbon.

**Template** (`carbon/dayXX/dayXX.carbon`):

```carbon
// Carbon is an experimental successor to C++
// Language status: Experimental - tooling and features subject to change
// File I/O capabilities may not be fully implemented

package Sample api;

fn Main() -> i32 {
  // File reading logic - implementation depends on Carbon's evolving file I/O API
  // This is a placeholder for future implementation as Carbon's standard library matures
  // Example pattern when available: var input: String = ReadFile("../../challenges/dayXX/input.txt");

  var result1: i32 = Part1();
  var result2: i32 = Part2();

  // Output pattern (may need adjustment based on Carbon version)
  // Print("Part 1: ");
  // Print(result1);
  // Print("\nPart 2: ");
  // Print(result2);

  return 0;
}

fn Part1() -> i32 {
  return 0;
}

fn Part2() -> i32 {
  return 0;
}
```

**Apply to all days:**

```bash
# Day 01
cat > carbon/day01/day01.carbon << 'EOF'
// Carbon is an experimental successor to C++
// Language status: Experimental - tooling and features subject to change
// File I/O capabilities may not be fully implemented

package Sample api;

fn Main() -> i32 {
  // File reading logic - implementation depends on Carbon's evolving file I/O API
  // This is a placeholder for future implementation as Carbon's standard library matures
  // Example pattern when available: var input: String = ReadFile("../../challenges/day01/input.txt");

  var result1: i32 = Part1();
  var result2: i32 = Part2();

  // Output pattern (may need adjustment based on Carbon version)
  // Print("Part 1: ");
  // Print(result1);
  // Print("\nPart 2: ");
  // Print(result2);

  return 0;
}

fn Part1() -> i32 {
  return 0;
}

fn Part2() -> i32 {
  return 0;
}
EOF

# Days 02-10 (automated)
for day in {02..10}; do
  cat > carbon/day${day}/day${day}.carbon << EOF
// Carbon is an experimental successor to C++
// Language status: Experimental - tooling and features subject to change
// File I/O capabilities may not be fully implemented

package Sample api;

fn Main() -> i32 {
  // File reading logic - implementation depends on Carbon's evolving file I/O API
  // This is a placeholder for future implementation as Carbon's standard library matures
  // Example pattern when available: var input: String = ReadFile("../../challenges/day${day}/input.txt");

  var result1: i32 = Part1();
  var result2: i32 = Part2();

  // Output pattern (may need adjustment based on Carbon version)
  // Print("Part 1: ");
  // Print(result1);
  // Print("\nPart 2: ");
  // Print(result2);

  return 0;
}

fn Part1() -> i32 {
  return 0;
}

fn Part2() -> i32 {
  return 0;
}
EOF
done
```

### Step 4: File Path Examples

All Carbon files reference the shared challenges directory using relative paths:

```
../../challenges/dayXX/input.txt
```

Examples:
- Day 01: `../../challenges/day01/input.txt`
- Day 05: `../../challenges/day05/input.txt`
- Day 10: `../../challenges/day10/input.txt`

### Step 5: Verify Carbon Setup

```bash
cd carbon/day01

# Attempt to check syntax (if Carbon tooling is available)
carbon check day01.carbon 2>/dev/null || echo "Carbon tooling not available (expected for experimental language)"

# List the files to verify structure
ls -la ..
# Expected: day01.carbon through day10.carbon
```

### Troubleshooting and Fallback Plan

**No Carbon compiler available:**
- This is expected. Carbon is highly experimental and tooling is limited or not available.
- Use Carbon files as pseudocode templates and algorithm planning documents.

**Syntax errors when compiler becomes available:**
- Carbon syntax evolves as the language matures. Update based on latest documentation.
- Refer to hello/carbon/hello.carbon for current example patterns.

**File I/O not working:**
- Carbon's standard library is still developing. Full file I/O support may not be available.
- Options:
  1. Implement logic without file I/O and pass data as parameters
  2. Use hardcoded test data while developing
  3. Check Carbon documentation regularly for new I/O capabilities

**Recommended approach:**
- Solve challenges in other established languages first (Rust, Gleam, Roc)
- Return to Carbon implementation when tooling matures
- Monitor updates at [github.com/carbon-language/carbon-lang](https://github.com/carbon-language/carbon-lang)

---

## Bosque Initialization

Bosque is an experimental language from Microsoft Research with limited tooling.

### Step 1: Create Bosque Root Directory and README

```bash
cd /Users/sgarner/projects/sgarner-lt/advent-of-code-2025
mkdir -p bosque
```

Create a README noting experimental status:

```bash
cat > bosque/README.md << 'EOF'
# Bosque - Advent of Code 2025

Bosque is an experimental language from Microsoft Research focused on regularized programming.

## Status

Bosque is highly experimental with limited tooling and documentation. The language is a research project and may not have:
- Active compiler/interpreter releases
- File I/O capabilities
- Standard library for common operations

## Approach

Use these files as:
- Algorithm design templates
- Pseudocode for solution planning
- Port to Bosque when tooling becomes available

## Resources

- [GitHub Repository](https://github.com/microsoft/BosqueLanguage)
- [Language Documentation](https://github.com/microsoft/BosqueLanguage/tree/master/docs)
EOF
```

### Step 2: Create Day Subdirectories

```bash
cd bosque

# Create all 10 day directories
for day in {01..10}; do
  mkdir -p day${day}
done
```

### Step 3: Create Boilerplate Bosque Files

For each day, create a `.bsq` file with boilerplate.

**Template** (`bosque/dayXX/dayXX.bsq`):

```bosque
namespace Main;

// Bosque is an experimental research language
// File I/O and standard operations may not be available
// Use as pseudocode template until tooling matures

public function main(): String {
    // File reading - implementation depends on Bosque's I/O capabilities
    // let input = readFile("../../challenges/dayXX/input.txt");

    let result1 = part1();
    let result2 = part2();

    return "Part 1: 0, Part 2: 0";
}

function part1(): Int {
    return 0;
}

function part2(): Int {
    return 0;
}
```

**Apply to all days:**

```bash
# Day 01
cat > bosque/day01/day01.bsq << 'EOF'
namespace Main;

// Bosque is an experimental research language
// File I/O and standard operations may not be available
// Use as pseudocode template until tooling matures

public function main(): String {
    // File reading - implementation depends on Bosque's I/O capabilities
    // let input = readFile("../../challenges/day01/input.txt");

    let result1 = part1();
    let result2 = part2();

    return "Part 1: 0, Part 2: 0";
}

function part1(): Int {
    return 0;
}

function part2(): Int {
    return 0;
}
EOF

# Days 02-10 (automated)
for day in {02..10}; do
  cat > bosque/day${day}/day${day}.bsq << EOF
namespace Main;

// Bosque is an experimental research language
// File I/O and standard operations may not be available
// Use as pseudocode template until tooling matures

public function main(): String {
    // File reading - implementation depends on Bosque's I/O capabilities
    // let input = readFile("../../challenges/day${day}/input.txt");

    let result1 = part1();
    let result2 = part2();

    return "Part 1: 0, Part 2: 0";
}

function part1(): Int {
    return 0;
}

function part2(): Int {
    return 0;
}
EOF
done
```

### Step 4: Verify Bosque Setup

```bash
cd bosque

# List all created files
find . -name "*.bsq" | sort

# Expected: day01/day01.bsq through day10/day10.bsq
```

### Troubleshooting

- **No Bosque tooling**: This is expected. Bosque is a research language.
- **Cannot run files**: Use as templates and pseudocode until tooling is available.

**Fallback Plan:**
- Use Bosque files for algorithm planning
- Implement solutions in other languages first
- Check Microsoft Research updates: [github.com/microsoft/BosqueLanguage](https://github.com/microsoft/BosqueLanguage)

---

## Verification

After completing all initialization steps, verify the complete structure.

### Overall Structure Check

```bash
cd /Users/sgarner/projects/sgarner-lt/advent-of-code-2025

# Display complete directory tree
tree -L 3 -I 'target|build|.git'

# Alternative if tree is not installed:
find . -type d -maxdepth 3 | grep -E "(rust|gleam|roc|carbon|bosque|challenges)" | sort
```

**Expected structure includes:**
- `rust/` with day01-day10 subdirectories and Cargo.toml
- `gleam/` with day01-day10 subdirectories and gleam.toml
- `roc/` with day01-day10 subdirectories
- `carbon/` with day01-day10 subdirectories
- `bosque/` with day01-day10 subdirectories and README.md
- `challenges/` with day01-day10 subdirectories

### File Count Verification

```bash
# Count main source files (should be 50 total: 10 days * 5 languages)
find rust gleam roc carbon bosque -name "*.rs" -o -name "*.gleam" -o -name "*.roc" -o -name "*.carbon" -o -name "*.bsq" | wc -l

# Expected: 50

# Count input files (should be 20: 10 days * 2 files)
find challenges -name "*.txt" | wc -l

# Expected: 20
```

### Language-Specific Verification

**Rust:**
```bash
cd rust
cargo check --workspace
# Expected: All packages compile successfully
```

**Gleam:**
```bash
cd gleam/day01
gleam build
# Expected: Build succeeds
```

**Roc:**
```bash
cd roc/day01
roc check day01.roc
# Expected: No syntax errors
```

**Carbon and Bosque:**
```bash
# Verify files exist (may not be executable)
ls -la carbon/day01/day01.carbon
ls -la bosque/day01/day01.bsq
# Expected: Files exist
```

### Incremental Setup Support

To check if a day already exists before creating it:

```bash
# Check if rust/day01 exists
if [ -d "rust/day01" ]; then
  echo "rust/day01 already exists - skipping"
else
  echo "rust/day01 does not exist - safe to create"
fi
```

Apply this check pattern before creating any new day directories to avoid overwriting existing work.

---

## Summary Checklist

Use this checklist to track completion of all initialization steps:

### Language-Agnostic Setup
- [ ] Created challenges/ root directory
- [ ] Created challenges/day01/ through challenges/day10/ subdirectories
- [ ] Created empty input.txt files in all day directories
- [ ] Created empty input-sample.txt files in all day directories
- [ ] Verified challenges/ structure with ls/find

### Rust
- [ ] Created rust/ root directory
- [ ] Created rust/Cargo.toml workspace configuration
- [ ] Initialized rust/day01/ through rust/day10/ with cargo init
- [ ] Updated all Cargo.toml files to use edition = "2024"
- [ ] Created boilerplate main.rs in all day directories
- [ ] Verified compilation with cargo check --workspace

### Gleam
- [ ] Created gleam/ root directory
- [ ] Created gleam/gleam.toml with dependencies
- [ ] Created gleam/day01/ through gleam/day10/ subdirectories
- [ ] Created gleam.toml for each day
- [ ] Created boilerplate .gleam files in all day directories with Result-based structure
- [ ] Verified build with gleam build (tested on at least one day)
- [ ] Reviewed file I/O implementation notes for future setup

### Roc
- [ ] Created roc/ root directory
- [ ] Created roc/day01/ through roc/day10/ subdirectories
- [ ] Created boilerplate .roc files in all day directories
- [ ] Verified syntax with roc check (tested on at least one day)

### Carbon
- [ ] Created carbon/ root directory
- [ ] Created carbon/day01/ through carbon/day10/ subdirectories
- [ ] Created boilerplate .carbon files in all day directories
- [ ] Noted experimental status and tooling limitations
- [ ] Followed hello/carbon/hello.carbon pattern with package Sample api

### Bosque
- [ ] Created bosque/ root directory
- [ ] Created bosque/README.md noting experimental status
- [ ] Created bosque/day01/ through bosque/day10/ subdirectories
- [ ] Created boilerplate .bsq files in all day directories
- [ ] Noted experimental status and tooling limitations

### Final Verification
- [ ] Verified complete directory structure with tree or find
- [ ] Counted source files (expected: 50)
- [ ] Counted input files (expected: 20)
- [ ] Tested at least one working language (Rust recommended)
- [ ] Documented any deviations or issues

---

## Next Steps

After completing this initialization:

1. **Populate Input Files**: Visit Advent of Code 2025 and populate input files manually
2. **Begin Solving**: Start with any day in any language
3. **Test Solutions**: Run against sample input first, then actual input
4. **Iterate**: Solutions can be added incrementally as days unlock

**Happy coding! Good luck with Advent of Code 2025!**
