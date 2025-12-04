# Advent of Code 2025

A polyglot approach to [Advent of Code 2025](https://adventofcode.com/2025), solving problems in 4 different programming languages to learn and compare language paradigms, features, and ecosystems.

## Project Overview

This project explores solving Advent of Code 2025 puzzles using four diverse programming languages:

- **Rust** - Systems programming language focused on safety and performance
- **Gleam** - Type-safe functional language for the BEAM VM
- **Carbon** - Experimental successor to C++ (Google-backed)
- **Bosque** - Research language exploring regularized programming (Microsoft Research)

## Platform Support

**macOS only** - This project is designed and tested exclusively for macOS. Installation scripts and toolchain configurations assume macOS environment.

## Language Version Requirements

| Language | Version Requirement | Installation Method |
|----------|-------------------|---------------------|
| Rust     | 1.83.0 or higher  | Homebrew (rustup)   |
| Gleam    | 1.13.0 or higher  | Homebrew            |
| Carbon   | Experimental      | Build from source   |
| Bosque   | Research version  | Podman container    |

## Quick Start

### Prerequisites

Before installing language toolchains, ensure you have the following installed:

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Git
brew install git

# Install Xcode Command Line Tools
xcode-select --install
```

### Install All Languages

Use the master installation script to install all 4 language toolchains at once:

```bash
# Clone this repository
git clone <repository-url>
cd advent-of-code-2025

# Make scripts executable
chmod +x scripts/*.sh

# Install all languages
./scripts/install_all.sh
```

The installation script will:
- Verify prerequisites (Homebrew, Git, Xcode CLI)
- Install all 5 language toolchains sequentially
- Continue on error and track which languages succeed/fail
- Provide a summary report showing installation status

### Selective Installation

Install specific languages using command-line flags:

```bash
# Install only Rust and Gleam
./scripts/install_all.sh --only-rust --only-gleam

# Install all languages except Carbon
./scripts/install_all.sh --skip-carbon

# Install a single language
./scripts/install_rust.sh
./scripts/install_gleam.sh
./scripts/install_roc.sh
./scripts/install_carbon.sh
./scripts/install_bosque.sh
```

See `./scripts/install_all.sh --help` for complete flag documentation.

### Verify Installation

After installation, verify each language toolchain works:

```bash
# Rust
rustc --version
cargo --version

# Gleam
gleam --version

# Roc
roc version

# Carbon (verify repository cloned)
ls ~/.local/carbon/carbon-lang

# Bosque (verify container works)
bosque --help
```

### Test Hello World Programs

Each language has a hello world program in the `hello/` directory:

```bash
# Rust
cd hello/rust
rustc hello.rs && ./hello

# Gleam
cd hello/gleam
gleam run

# Roc
cd hello/roc
roc run hello.roc

# Carbon
cd hello/carbon
cd ~/.local/carbon/carbon-lang
bazel run //explorer -- ~/path/to/hello.carbon

# Bosque (containerized)
cd hello/bosque
bosque compile hello.bsq
node jsout/Main.mjs
```

## Project Structure

```
advent-of-code-2025/
├── scripts/              # Installation and testing scripts
│   ├── common.sh         # Shared utilities for all scripts
│   ├── install_all.sh    # Master installation script
│   ├── install_rust.sh
│   ├── install_gleam.sh
│   ├── install_roc.sh
│   ├── install_carbon.sh
│   ├── install_bosque.sh
│   ├── test_integration.sh  # Integration test runner
│   ├── test_unit.sh         # Unit test runner
│   └── runners/             # Language-specific test runners
│
├── hello/                # Hello world programs for each language
│   ├── rust/
│   ├── gleam/
│   ├── roc/
│   ├── carbon/
│   └── bosque/
│
├── challenges/           # Puzzle inputs and test data
│   └── dayXX/
│       ├── input.txt            # Real puzzle input
│       ├── input-sample.txt     # Sample input from problem
│       └── problem-statement.txt # Optional reference
│
├── rust/dayXX/           # Rust solutions
├── gleam/dayXX/          # Gleam solutions
├── roc/dayXX/            # Roc solutions
├── carbon/dayXX/         # Carbon solutions
├── bosque/dayXX/         # Bosque solutions
│
├── docs/                 # Documentation
│   ├── languages/        # Per-language guides
│   │   ├── rust.md
│   │   ├── gleam.md
│   │   ├── roc.md
│   │   ├── carbon.md
│   │   └── bosque.md
│   ├── testing-framework.md  # Testing framework documentation
│   └── vscode-setup.md       # VS Code configuration guide
│
├── docker/               # Container configurations
│   └── bosque/           # Bosque Dockerfile for macOS
│
└── README.md             # This file
```

## Testing

This project includes a comprehensive cross-language testing framework that validates solutions across all 5 languages.

### Run Integration Tests

Run integration tests for a specific day across all languages:

```bash
# Test day 1 with real input
./scripts/test_integration.sh 1

# Test day 1 with sample input
./scripts/test_integration.sh 1 --sample

# Test with verbose output for debugging
./scripts/test_integration.sh 1 --verbose

# Test with custom timeout (default 60 seconds)
./scripts/test_integration.sh 1 --timeout 120
```

Integration tests:
- Run all 5 languages in parallel
- Validate that implementations produce identical answers
- Generate a markdown report in `test_results.md`
- Exit with code 0 if all languages agree, code 1 if any diverge

### Run Unit Tests (TDD Workflow)

Run language-specific unit tests without cross-language validation:

```bash
# Run unit tests for day 1
./scripts/test_unit.sh 1

# Run with verbose output
./scripts/test_unit.sh 1 --verbose
```

Unit tests:
- Execute `cargo test`, `gleam test`, etc. for each language
- Provide faster feedback during development
- Don't require JSON output format
- Support test-driven development workflow

### Setting Up Test Data

Create test data for each day:

```bash
# Create directory for day 1
mkdir -p challenges/day01

# Add sample input (from problem statement)
echo "sample data here" > challenges/day01/input-sample.txt

# Add real input (from your Advent of Code account)
echo "real data here" > challenges/day01/input.txt
```

### JSON Output Format

All implementations must output results in JSON format to stdout:

```json
{"part1": 12345, "part2": 67890}
```

- Use integers, strings, or `null` for values
- Use `null` for parts not yet implemented
- See `docs/testing-framework.md` for language-specific examples

### Testing Examples

**Example 1: Test day 1 with sample input**
```bash
./scripts/test_integration.sh 1 --sample
```

**Example 2: Run unit tests during development**
```bash
# Write some code
vim rust/day03/src/lib.rs

# Run unit tests
./scripts/test_unit.sh 3

# Iterate
```

**Example 3: Debug with verbose mode**
```bash
./scripts/test_integration.sh 5 --verbose
```

**Example 4: Test slow solution with custom timeout**
```bash
./scripts/test_integration.sh 10 --timeout 120
```

**Example 5: Combine multiple options**
```bash
./scripts/test_integration.sh 7 --sample --verbose --timeout 30
```

### View Test Results

After running integration tests, check the generated report:

```bash
cat test_results.md
```

The report includes:
- Per-language test results with pass/fail status
- JSON output from each implementation
- Cross-language validation showing agreements/divergences
- Error messages for failed tests

### Testing Documentation

For comprehensive testing documentation, see:
- **[Testing Framework Guide](docs/testing-framework.md)** - Complete testing framework documentation
  - JSON output contract and examples
  - Command-line interface reference
  - Error handling and troubleshooting
  - Test data conventions
  - Architecture overview
  - Best practices

## Documentation

### Per-Language Guides

Comprehensive documentation for each language is available in `docs/languages/`:

- [Rust Language Guide](docs/languages/rust.md) - Installation, Cargo basics, rust-analyzer setup
- [Gleam Language Guide](docs/languages/gleam.md) - Installation, Gleam CLI, package management
- [Roc Language Guide](docs/languages/roc.md) - Installation, basic usage, experimental features
- [Carbon Language Guide](docs/languages/carbon.md) - Build from source, Bazel workflow
- [Bosque Language Guide](docs/languages/bosque.md) - Containerized setup via Podman

Each guide includes:
- Installation instructions (manual and automated)
- Basic usage and toolchain commands
- Troubleshooting for common issues
- Links to official documentation

### VS Code Setup

See [VS Code Setup Guide](docs/vscode-setup.md) for:
- Recommended extensions for all 5 languages
- Language server configuration
- Workspace settings
- Verification and troubleshooting

Language server support varies:
- **Rust**: Full LSP support via rust-analyzer (excellent)
- **Gleam**: Full LSP support via Gleam extension (good)
- **Roc**: Basic syntax highlighting only (no LSP)
- **Carbon**: No extension available (use C++ syntax)
- **Bosque**: No extension available (use TypeScript syntax)

## Language-Specific Notes

### Rust
- Installed via rustup (Rust toolchain manager)
- Uses Cargo for build management and dependencies
- Excellent IDE support with rust-analyzer
- Most mature and stable language in this project

### Gleam
- Runs on BEAM VM (same as Erlang/Elixir)
- Requires Erlang runtime (installed automatically)
- Full language server support
- Great for concurrent/distributed problems

### Roc
- Pre-1.0 experimental language
- Installed as nightly binary from GitHub
- Fast performance, unique memory model
- Limited IDE support

### Carbon
- Experimental C++ successor by Google
- Built from source using Bazel
- Requires significant build time (15-30 minutes)
- No language server or IDE support yet

### Bosque
- Microsoft Research language
- **Runs in Podman/Docker container on macOS**
- BosqueCore officially supports Linux only
- Container provides Ubuntu 24.04 with full Bosque toolchain
- Transparent file access via volume mounts

## Troubleshooting

### All installations fail

**Check prerequisites:**
```bash
# Verify Homebrew
brew --version

# Verify Git
git --version

# Verify Xcode Command Line Tools
xcode-select -p
```

If any are missing, install them using the Quick Start instructions above.

### Individual language installation fails

1. **Check the per-language documentation** in `docs/languages/<language>.md`
2. **Run the individual installation script** with verbose output
3. **Review error messages** carefully - they often indicate the specific issue
4. **Common issues:**
   - Missing prerequisites
   - Network connection problems
   - Insufficient disk space
   - PATH configuration issues

### Bosque installation fails

Bosque requires Podman (container runtime):

```bash
# Install Podman
brew install podman

# Initialize Podman machine
podman machine init

# Start Podman machine
podman machine start

# Retry Bosque installation
./scripts/install_bosque.sh
```

### Language command not found after installation

Add the installation directories to your PATH:

```bash
# For Rust/Cargo
source $HOME/.cargo/env

# For Roc
export PATH="$HOME/.local/bin:$PATH"

# For Bosque
export PATH="$HOME/.local/bin:$PATH"

# Make permanent by adding to ~/.zshrc or ~/.bashrc
```

### Carbon build fails

Carbon requires significant resources and time:

1. Ensure at least 10 GB free disk space
2. Allow 15-30 minutes for initial build
3. Verify all dependencies installed:
   - Bazelisk
   - LLVM
   - Python 3.11+
4. See [Carbon documentation](docs/languages/carbon.md) for details

### Test failures

If integration tests fail:

1. **Check JSON output format** - must be exact: `{"part1": value, "part2": value}`
2. **Run with verbose mode** - `./scripts/test_integration.sh 1 --verbose`
3. **Test with sample input first** - `./scripts/test_integration.sh 1 --sample`
4. **Verify unit tests pass** - `./scripts/test_unit.sh 1`
5. **See testing documentation** - `docs/testing-framework.md`

## Common Issues

### Issue: "command not found" after installation

**Solution:** Restart your terminal or source your shell configuration:
```bash
source ~/.zshrc  # or ~/.bashrc
```

### Issue: VS Code language server not working

**Solution:** See [VS Code Setup Guide](docs/vscode-setup.md) troubleshooting section.

### Issue: Bosque container won't start

**Solution:**
```bash
# Check Podman machine status
podman machine info

# Restart Podman machine
podman machine stop
podman machine start

# Rebuild Bosque container
podman rmi bosque-toolchain:latest
./scripts/install_bosque.sh
```

### Issue: Installation script permission denied

**Solution:**
```bash
# Make scripts executable
chmod +x scripts/*.sh

# Retry installation
./scripts/install_all.sh
```

### Issue: Tests timing out

**Solution:**
```bash
# Increase timeout
./scripts/test_integration.sh 1 --timeout 120

# Or optimize your algorithm
```

## Contributing

This is a personal learning project, but suggestions and improvements are welcome:

1. File issues for bugs or installation problems
2. Share alternative installation methods
3. Contribute language-specific tips and tricks
4. Improve documentation clarity

## Resources

### Official Language Documentation

- [Rust Documentation](https://doc.rust-lang.org/)
- [Gleam Language](https://gleam.run/)
- [Roc Language](https://www.roc-lang.org/)
- [Carbon Language](https://github.com/carbon-language/carbon-lang)
- [Bosque Language](https://github.com/BosqueLanguage/BosqueCore)

### Advent of Code

- [Advent of Code 2025](https://adventofcode.com/2025)
- [Advent of Code Subreddit](https://www.reddit.com/r/adventofcode/)

### Learning Resources

- [Rust Book](https://doc.rust-lang.org/book/)
- [Gleam Language Tour](https://tour.gleam.run/)
- [Roc Tutorial](https://www.roc-lang.org/tutorial)
- [Carbon Language Design](https://github.com/carbon-language/carbon-lang/tree/trunk/docs/design)

## License

This project is for educational purposes. Individual language implementations are subject to their respective licenses.

## Acknowledgments

- Eric Wastl for creating Advent of Code
- The Rust, Gleam, Roc, Carbon, and Bosque language communities
- Open source contributors to all language toolchains

---

**Last Updated:** 2025-12-03
**Platform:** macOS only
**Languages:** Rust, Gleam, Roc, Carbon, Bosque
