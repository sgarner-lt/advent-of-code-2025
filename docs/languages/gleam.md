# Gleam Language Setup Guide

## Overview

Gleam is a friendly language for building type-safe, scalable systems that compiles to Erlang and JavaScript. This guide covers installation, basic usage, and troubleshooting for Gleam on macOS.

**Platform:** macOS only (via Homebrew)

## Version Requirements

- **Gleam:** 1.13.0 or higher
- **Erlang/OTP:** 24.0 or higher (installed automatically as dependency)

## Automated Installation

The easiest way to install Gleam is using the provided installation script:

```bash
./scripts/install_gleam.sh
```

The script will:
- Check if Gleam is already installed (idempotent)
- Install Gleam via Homebrew
- Install Erlang runtime (required dependency)
- Verify installation and version requirements
- Provide clear error messages on failure

## Manual Installation

If you prefer to install Gleam manually:

### Prerequisites

Ensure Homebrew is installed:
```bash
brew --version
```

If not installed, get it from: https://brew.sh

### Install Gleam

```bash
brew install gleam
```

This will automatically install Erlang as a dependency.

### Verify Installation

```bash
gleam --version
```

Expected output: `gleam 1.13.0` or higher

### Verify Erlang

```bash
erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell
```

## Gleam CLI Basics

### Create a New Project

```bash
gleam new my_project
cd my_project
```

This creates a new Gleam project with the following structure:
```
my_project/
├── gleam.toml          # Project configuration
├── README.md
├── src/
│   └── my_project.gleam  # Main source file
└── test/
    └── my_project_test.gleam  # Test file
```

### Build Project

Compile your Gleam project:
```bash
gleam build
```

This compiles all `.gleam` files in the `src/` directory to Erlang bytecode.

### Run Project

Execute the main function:
```bash
gleam run
```

### Run Tests

Execute all tests in the `test/` directory:
```bash
gleam test
```

Tests use the `gleeunit` test framework automatically.

### Add Dependencies

Dependencies are managed in `gleam.toml`. To add a package:

1. Add to `[dependencies]` section in `gleam.toml`:
```toml
[dependencies]
gleam_stdlib = ">= 0.44.0 and < 2.0.0"
gleam_json = ">= 1.0.0 and < 2.0.0"
```

2. Run build to download and compile:
```bash
gleam build
```

### Format Code

Gleam includes a built-in formatter:
```bash
gleam format
```

### Check Code

Run type checker and linter without building:
```bash
gleam check
```

### Generate Documentation

Generate HTML documentation from your code:
```bash
gleam docs build
```

Documentation will be in `build/docs/`.

## Hello World Example

The hello world program is located at:
```
hello/gleam/hello_gleam/src/hello_gleam.gleam
```

```gleam
import gleam/io

pub fn main() -> Nil {
  io.println("Hello from Gleam!")
}
```

Run it with:
```bash
cd hello/gleam/hello_gleam
gleam run
```

## Standard Library

Gleam comes with a comprehensive standard library (`gleam_stdlib`) that includes:

- **gleam/io** - Input/output operations
- **gleam/list** - List operations
- **gleam/string** - String manipulation
- **gleam/result** - Result type for error handling
- **gleam/option** - Optional values
- **gleam/int** - Integer operations
- **gleam/float** - Floating point operations
- **gleam/dict** - Dictionary/map data structure
- **gleam/set** - Set data structure

Full documentation: https://hexdocs.pm/gleam_stdlib/

### Useful Community Packages

These packages extend the standard library:

- **simplifile** - Simple file system operations
- **gleam_json** - JSON encoding/decoding
- **gleam_http** - HTTP types and utilities
- **gleam_erlang** - Erlang interop utilities

Browse packages at: https://packages.gleam.run/

## VS Code Setup

### Recommended Extension

**Gleam Language Server**
- Extension ID: `gleam.gleam`
- Install from VS Code marketplace: Search for "Gleam"

### Features

The Gleam language server provides:
- Syntax highlighting
- Code completion
- Go to definition
- Error diagnostics
- Inline documentation
- Code formatting
- Hover information

### Verify Language Server

1. Open a `.gleam` file in VS Code
2. Check bottom-right status bar for "Gleam" indicator
3. Hover over code - should see type information
4. Press `Ctrl+Space` - should see completions

### Configuration

Add to `.vscode/settings.json`:
```json
{
  "gleam.path": "/usr/local/bin/gleam",
  "[gleam]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "gleam.gleam"
  }
}
```

## Language Basics

### Type System

Gleam is statically typed with type inference:
```gleam
// Type annotations are optional but helpful
pub fn add(a: Int, b: Int) -> Int {
  a + b
}

// Types are inferred
pub fn double(x) {
  x * 2
}
```

### Data Types

```gleam
// Basic types
let number: Int = 42
let decimal: Float = 3.14
let text: String = "hello"
let flag: Bool = True

// Lists (homogeneous)
let numbers = [1, 2, 3, 4]

// Tuples
let pair = #(1, "hello")

// Custom types
pub type User {
  User(name: String, age: Int)
}
```

### Pattern Matching

```gleam
pub fn describe(result: Result(Int, String)) -> String {
  case result {
    Ok(value) -> "Got: " <> int.to_string(value)
    Error(msg) -> "Error: " <> msg
  }
}
```

### Pipelines

Gleam's pipe operator chains function calls:
```gleam
import gleam/string
import gleam/list

pub fn process(text: String) -> String {
  text
  |> string.trim
  |> string.lowercase
  |> string.split(on: " ")
  |> list.length
  |> int.to_string
}
```

## Compiling to Erlang

Gleam compiles to Erlang bytecode and runs on the BEAM VM. Compiled files are in:
```
build/dev/erlang/my_project/
```

You can run Gleam code with Erlang tools:
```bash
erl -pa build/dev/erlang/*/ebin -eval 'my_project:main()' -noshell -s init stop
```

## Troubleshooting

### Gleam Command Not Found

**Problem:** `gleam: command not found` after installation

**Solution:**
1. Verify Homebrew installation: `brew list gleam`
2. Check PATH includes Homebrew bin:
   ```bash
   echo $PATH | grep /usr/local/bin
   ```
3. Add to PATH if missing (add to `~/.zshrc` or `~/.bashrc`):
   ```bash
   export PATH="/usr/local/bin:$PATH"
   ```
4. Reload shell: `source ~/.zshrc`

### Erlang Not Found

**Problem:** Gleam installed but Erlang missing

**Solution:**
```bash
brew install erlang
```

Verify:
```bash
erl -version
```

### Package Download Failures

**Problem:** `gleam build` fails to download packages

**Solution:**
1. Check internet connection
2. Try clearing package cache:
   ```bash
   rm -rf build/.packages
   gleam build
   ```
3. Check package name/version in `gleam.toml`
4. Search for package: https://packages.gleam.run/

### Build Errors

**Problem:** Type errors or compilation failures

**Solution:**
1. Read error message carefully - Gleam has excellent error messages
2. Check syntax and types
3. Run formatter: `gleam format`
4. Run type checker: `gleam check`
5. Clean and rebuild:
   ```bash
   rm -rf build
   gleam build
   ```

### VS Code Language Server Not Working

**Problem:** No syntax highlighting or completions

**Solution:**
1. Verify extension installed: Check Extensions panel
2. Reload VS Code: `Cmd+Shift+P` -> "Reload Window"
3. Check Gleam path in settings
4. Check Output panel: View -> Output -> Select "Gleam Language Server"
5. Reinstall extension if needed

### Version Too Old

**Problem:** Gleam version below 1.13.0

**Solution:**
```bash
brew upgrade gleam
gleam --version
```

### Permission Denied

**Problem:** Cannot execute Gleam commands

**Solution:**
```bash
# Fix Homebrew permissions
sudo chown -R $(whoami) /usr/local/bin /usr/local/share
brew doctor
```

## Learning Resources

### Official Documentation

- **Gleam Website:** https://gleam.run/
- **Language Tour:** https://tour.gleam.run/
- **Documentation:** https://gleam.run/documentation/
- **Standard Library:** https://hexdocs.pm/gleam_stdlib/
- **Package Repository:** https://packages.gleam.run/

### Community

- **Discord:** https://discord.gg/Fm8Pwmy
- **GitHub:** https://github.com/gleam-lang/gleam
- **Forum:** https://github.com/gleam-lang/gleam/discussions

### Tutorials

- **Getting Started:** https://gleam.run/getting-started/
- **Exercism Track:** https://exercism.org/tracks/gleam
- **Awesome Gleam:** https://github.com/gleam-lang/awesome-gleam

### Books

- **Gleam Language Guide:** https://gleam.run/book/
- **Erlang Interop Guide:** https://gleam.run/writing-gleam/gleam-with-erlang/

## Common Patterns

### Error Handling

```gleam
import gleam/result

pub fn safe_divide(a: Int, b: Int) -> Result(Int, String) {
  case b {
    0 -> Error("Division by zero")
    _ -> Ok(a / b)
  }
}

pub fn use_division() {
  safe_divide(10, 2)
  |> result.map(fn(x) { x * 2 })
  |> result.unwrap(or: 0)
}
```

### Working with Lists

```gleam
import gleam/list
import gleam/int

pub fn sum_evens(numbers: List(Int)) -> Int {
  numbers
  |> list.filter(fn(n) { n % 2 == 0 })
  |> list.fold(from: 0, with: int.add)
}
```

### Custom Types with Methods

```gleam
pub type Point {
  Point(x: Int, y: Int)
}

pub fn distance_from_origin(point: Point) -> Float {
  let Point(x, y) = point
  let x_squared = int.to_float(x * x)
  let y_squared = int.to_float(y * y)
  float.square_root(x_squared +. y_squared)
}
```

## Platform Limitations

This setup is designed for **macOS only** using Homebrew. For other platforms:

- **Linux:** Use official installation guide or build from source
- **Windows:** Use WSL or build from source
- **BSD:** Build from source

See: https://gleam.run/getting-started/installing/

## Next Steps

1. Complete the Language Tour: https://tour.gleam.run/
2. Try Exercism exercises: https://exercism.org/tracks/gleam
3. Build a small project to learn the ecosystem
4. Join the community Discord for help
5. Read through standard library documentation

## Notes

- Gleam is production-ready and stable (v1.0+)
- Excellent error messages help learning
- Type system catches many bugs at compile time
- BEAM VM provides excellent concurrency and fault tolerance
- Growing ecosystem with active development
- Great for functional programming learners
