# Rust Language Guide

## Overview

Rust is a systems programming language focused on safety, concurrency, and performance. This guide covers installation, basic usage, and development environment setup for Advent of Code 2025 on macOS.

**Version Requirement:** Rust 1.83.0 or higher
**Installed Version:** 1.91.1
**Platform:** macOS only

## Quick Start

```bash
# Install Rust using the installation script
./scripts/install_rust.sh

# Source the cargo environment (if just installed)
source $HOME/.cargo/env

# Compile and run the hello world example
cd hello/rust
rustc hello.rs
./hello
```

## Manual Installation

If you prefer to install Rust manually:

### Step 1: Install rustup via Homebrew

```bash
# Install rustup-init
brew install rustup-init

# Run rustup-init to install Rust
rustup-init -y --default-toolchain stable
```

### Step 2: Configure Your Shell

Add Cargo's bin directory to your PATH by sourcing the environment file:

```bash
# For zsh (default on macOS)
source $HOME/.cargo/env

# Or add to your shell profile (~/.zshrc)
echo 'source $HOME/.cargo/env' >> ~/.zshrc
```

### Step 3: Verify Installation

```bash
# Check rustc version
rustc --version

# Check cargo version
cargo --version

# View installed toolchains
rustup show
```

## Rust Toolchain Basics

### rustup - The Rust Installer

`rustup` manages Rust installations, including multiple toolchains and cross-compilation targets.

**Common rustup commands:**

```bash
# Update Rust to the latest stable version
rustup update stable

# Show installed toolchains and active toolchain
rustup show

# Install nightly toolchain (for experimental features)
rustup install nightly

# Switch default toolchain
rustup default stable

# Install additional components
rustup component add clippy rustfmt

# View help
rustup help
```

### rustc - The Rust Compiler

`rustc` is the Rust compiler that converts `.rs` source files to executable binaries.

**Basic rustc usage:**

```bash
# Compile a single file
rustc hello.rs

# Compile with optimizations
rustc -O hello.rs

# Compile with debug symbols
rustc -g hello.rs

# Check syntax without producing executable
rustc --explain E0308  # Get detailed error explanations
```

### Cargo - The Rust Build Tool and Package Manager

Cargo is Rust's build system and package manager. It handles:
- Creating new projects
- Building code
- Running tests
- Managing dependencies
- Publishing packages

**Common Cargo commands:**

```bash
# Create a new binary project
cargo new my_project

# Create a new library project
cargo new my_lib --lib

# Build the project
cargo build

# Build with optimizations (release mode)
cargo build --release

# Run the project
cargo run

# Run with arguments
cargo run -- arg1 arg2

# Run tests
cargo test

# Run a specific test
cargo test test_name

# Check code without building (fast)
cargo check

# Format code according to Rust style guidelines
cargo fmt

# Lint code with clippy (install first: rustup component add clippy)
cargo clippy

# Update dependencies
cargo update

# Clean build artifacts
cargo clean

# View project documentation
cargo doc --open
```

## Adding Dependencies

Dependencies are managed in `Cargo.toml`:

```toml
[package]
name = "my_project"
version = "0.1.0"
edition = "2021"

[dependencies]
# Add dependencies here
# Example for common crates:
# itertools = "0.12"
# regex = "1.10"
```

After adding dependencies, run `cargo build` to download and compile them.

**Popular crates for Advent of Code:**
- `itertools` - Extended iterator methods
- `regex` - Regular expressions
- `nom` - Parser combinators
- `rayon` - Data parallelism

## Standard Library

Rust has a comprehensive standard library (`std`) that includes:
- Collections: `Vec`, `HashMap`, `HashSet`, `BTreeMap`, etc.
- Iterators: Powerful lazy iteration with methods like `map`, `filter`, `fold`
- String handling: `String`, `&str`, and various manipulation methods
- File I/O: `std::fs` for file operations
- Error handling: `Result`, `Option` types

**No additional stdlib-level dependencies are required for basic Advent of Code problems.**

## Project Structure

A typical Cargo project structure:

```
my_project/
├── Cargo.toml          # Project manifest and dependencies
├── Cargo.lock          # Locked dependency versions (generated)
├── src/
│   ├── main.rs         # Entry point for binary projects
│   └── lib.rs          # Entry point for library projects (if --lib)
├── tests/              # Integration tests
└── target/             # Build output (generated)
```

## Idiomatic Rust Patterns

### Basic Syntax

```rust
// Function definition
fn add(a: i32, b: i32) -> i32 {
    a + b  // No semicolon for return value
}

// Main entry point
fn main() {
    let result = add(5, 3);
    println!("Result: {}", result);
}
```

### Variables and Mutability

```rust
// Immutable by default
let x = 5;

// Mutable variable
let mut y = 10;
y += 5;

// Type annotations when needed
let z: i32 = 15;
```

### Error Handling

```rust
use std::fs;
use std::io;

// Result type for functions that can fail
fn read_file(path: &str) -> Result<String, io::Error> {
    fs::read_to_string(path)
}

// Using Result in main
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let content = read_file("input.txt")?;
    println!("{}", content);
    Ok(())
}
```

### Iterators (Common in Advent of Code)

```rust
fn main() {
    let numbers = vec![1, 2, 3, 4, 5];

    // Chaining iterator methods
    let sum: i32 = numbers
        .iter()
        .filter(|&&x| x % 2 == 0)
        .map(|&x| x * 2)
        .sum();

    println!("Sum: {}", sum);
}
```

## VS Code Setup

### Recommended Extensions

1. **rust-analyzer** (Primary extension)
   - Extension ID: `rust-lang.rust-analyzer`
   - Provides intelligent code completion, go-to-definition, refactoring, and more
   - Install from VS Code marketplace

2. **CodeLLDB** (Optional, for debugging)
   - Extension ID: `vadimcn.vscode-lldb`
   - Provides native debugging support

### Installing rust-analyzer

The rust-analyzer extension will automatically download and install the language server when you first open a Rust file.

**Manual verification:**

```bash
# Check if rust-analyzer is available
which rust-analyzer

# If not installed, install via rustup
rustup component add rust-analyzer
```

### VS Code Settings

Add to your `.vscode/settings.json`:

```json
{
    "rust-analyzer.check.command": "clippy",
    "rust-analyzer.cargo.features": "all",
    "rust-analyzer.inlayHints.enable": true,
    "editor.formatOnSave": true,
    "[rust]": {
        "editor.defaultFormatter": "rust-lang.rust-analyzer"
    }
}
```

### Verifying Language Server

To verify rust-analyzer is working:

1. Open a `.rs` file in VS Code
2. You should see syntax highlighting
3. Hover over variables or functions - you should see type information
4. Start typing - you should get intelligent completions
5. Look for the rust-analyzer status in the bottom right of VS Code

## Troubleshooting

### Issue: rustc or cargo command not found

**Solution:**

```bash
# Source the cargo environment
source $HOME/.cargo/env

# Or restart your terminal to pick up PATH changes

# If problem persists, check your shell profile
echo 'source $HOME/.cargo/env' >> ~/.zshrc
```

### Issue: Permission denied when running rustup-init

**Solution:**

Ensure you have proper permissions and try reinstalling:

```bash
# Uninstall rustup
rustup self uninstall

# Reinstall via Homebrew
brew reinstall rustup-init
rustup-init -y
```

### Issue: Cargo build fails with linker errors

**Solution:**

Ensure Xcode Command Line Tools are installed:

```bash
xcode-select --install
```

### Issue: rust-analyzer not working in VS Code

**Solution:**

1. Ensure rust-analyzer extension is installed
2. Check output panel (View > Output > rust-analyzer)
3. Restart VS Code
4. If still not working, reinstall the extension
5. Verify rustc is in PATH: `which rustc`

### Issue: Slow compilation times

**Solution:**

- Use `cargo check` instead of `cargo build` for quick syntax checking
- Build in release mode only when needed: `cargo build --release`
- Consider using `sccache` for caching compiled dependencies
- Add incremental compilation to `Cargo.toml`:

```toml
[profile.dev]
incremental = true
```

### Issue: Version mismatch or outdated Rust

**Solution:**

```bash
# Update to latest stable version
rustup update stable

# Verify version
rustc --version
```

## Learning Resources

### Official Documentation

- [The Rust Programming Language Book](https://doc.rust-lang.org/book/) - Comprehensive introduction
- [Rust by Example](https://doc.rust-lang.org/rust-by-example/) - Learn by example
- [Rust Standard Library Documentation](https://doc.rust-lang.org/std/) - API reference
- [Cargo Book](https://doc.rust-lang.org/cargo/) - Complete Cargo guide
- [Rustlings](https://github.com/rust-lang/rustlings) - Small exercises to learn Rust

### Community Resources

- [Rust Users Forum](https://users.rust-lang.org/) - Ask questions and share knowledge
- [Rust Discord](https://discord.gg/rust-lang) - Real-time chat with community
- [r/rust](https://www.reddit.com/r/rust/) - Reddit community
- [This Week in Rust](https://this-week-in-rust.org/) - Weekly newsletter

### Advent of Code Specific

- [Rust Advent of Code Template](https://github.com/fspoettel/advent-of-code-rust) - Project template
- [AoC Subreddit](https://www.reddit.com/r/adventofcode/) - Solutions and discussions

## Platform Limitations

This installation guide is designed for **macOS only**. Installation steps may differ significantly on Linux or Windows platforms.

## Next Steps

1. Work through the examples in the `hello/rust/` directory
2. Read the Rust Book (linked above) to learn the fundamentals
3. Start solving Advent of Code problems!
4. Explore the standard library documentation
5. Join the Rust community for help and discussion

## Additional Tools

### Useful Cargo Plugins

```bash
# Install cargo-watch for auto-rebuilding on file changes
cargo install cargo-watch

# Use with: cargo watch -x run

# Install cargo-edit for easier dependency management
cargo install cargo-edit

# Use with: cargo add itertools
```

### Benchmarking

```bash
# Rust has built-in benchmarking support (nightly only)
rustup install nightly

# Or use criterion crate for stable benchmarking
# Add to Cargo.toml:
# [dev-dependencies]
# criterion = "0.5"
```

---

**Installation Status:** Rust 1.91.1 installed and verified successfully
**Last Updated:** 2025-12-03
