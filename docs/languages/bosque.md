# Bosque Language Guide

## Overview

Bosque is a research programming language developed by Microsoft Research that aims to provide a regularized programming model with improved tooling, compilation, and runtime support. It is designed to be easy to reason about for both humans and automated tools.

## macOS Support via Containerization

**BosqueCore (v1.0)** officially supports **Linux only** (Ubuntu 24 recommended). Native macOS installation fails due to C++ compilation errors in the `jsbrex-native` addon.

**Solution: Containerized Approach**

This project uses **Podman/Docker** to run Bosque in a Linux container, providing full functionality on macOS:
- Runs BosqueCore in Ubuntu 24.04 container
- Transparent file access to your working directory
- Simple command-line interface via wrapper script
- No performance penalty for typical use cases

## Installation

### Prerequisites

1. **Podman** (or Docker)
   - Check if installed: `podman --version`
   - Install via Homebrew: `brew install podman`
   - Initialize Podman machine: `podman machine init`
   - Start Podman machine: `podman machine start`

2. **Basic macOS tools**
   - Git (for cloning BosqueCore in container)
   - Homebrew (for Podman installation)

### Automated Installation

Run the installation script to build the Bosque container and set up the wrapper:

```bash
./scripts/install_bosque.sh
```

The script will:
1. Check that Podman is installed and running
2. Build a Docker image with BosqueCore on Ubuntu 24.04
3. Create a wrapper script for transparent command execution
4. Set up a `bosque` command in your PATH

**First-time build takes 5-10 minutes** (Node.js installation + BosqueCore compilation).

### Manual Installation

If you prefer manual setup:

1. **Build the container image:**
   ```bash
   cd docker/bosque
   podman build -t bosque-toolchain:latest .
   ```

2. **Create symbolic link to wrapper:**
   ```bash
   mkdir -p ~/.local/bin
   ln -s /path/to/scripts/bosque-wrapper.sh ~/.local/bin/bosque
   ```

3. **Add to PATH** (if not already):
   ```bash
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

## Usage

### Basic Commands

The `bosque` command works transparently with your local files:

```bash
# Compile a Bosque program
bosque compile hello.bsq

# The output is generated in your local directory
node jsout/Main.mjs
```

### How It Works

When you run `bosque <command>`:
1. The wrapper script invokes Podman
2. Podman starts an Ubuntu container with BosqueCore
3. Your current directory is mounted to `/workspace` in the container
4. Bosque processes your files and writes output to your local filesystem
5. Container stops automatically after command completes

**Key Benefits:**
- No manual container management needed
- Files stay on your local filesystem
- Commands work as if Bosque were installed natively
- Isolated environment prevents conflicts

## Hello World Example

Navigate to the hello world directory and run:

```bash
cd hello/bosque
bosque compile hello.bsq
node jsout/Main.mjs
```

Expected output:
```
Hello from Bosque!
```

## Bosque Language Basics

### Program Structure

Every Bosque program requires a `public function main()` entry point:

```bosque
namespace Main;

public function main(): String {
    return "Hello from Bosque!";
}
```

### Key Language Features

1. **Type Safety:** Strong static typing with type inference
2. **Immutability:** Emphasis on immutable data structures
3. **Regularized Programming Model:** Simplified control flow and state management
4. **No Undefined/Null by Default:** Explicit handling of optional values
5. **SMT-based verification:** Built-in symbolic testing capabilities

### Example Programs

**Simple Computation:**
```bosque
namespace Main;

public function main(): Int {
    let x = 5;
    let y = 10;
    return x + y;
}
```

**Working with Collections:**
```bosque
namespace Main;

public function main(): Int {
    let numbers = List<Int>{1, 2, 3, 4, 5};
    return numbers.sum();
}
```

## Container Details

### Dockerfile Location

The Bosque Dockerfile is located at:
```
docker/bosque/Dockerfile
```

### Container Specifications

- **Base Image:** Ubuntu 24.04
- **Node.js Version:** 22.x (latest LTS)
- **BosqueCore:** Latest from official repository
- **Additional Tools:** git, git-lfs, build-essential, clang

### Rebuild Container

To rebuild the container (e.g., to get latest BosqueCore updates):

```bash
# Remove old image
podman rmi bosque-toolchain:latest

# Rebuild
./scripts/install_bosque.sh
```

### Manual Container Usage

If you need to access the container directly:

```bash
# Interactive shell
podman run -it -v $(pwd):/workspace bosque-toolchain:latest bash

# Run specific command
podman run --rm -v $(pwd):/workspace bosque-toolchain:latest bosque compile myfile.bsq
```

## VS Code Integration

### Syntax Highlighting

Basic VS Code support exists through the [bosque-language-tools](https://github.com/BosqueLanguage/bosque-language-tools) extension.

**Features:**
- Syntax highlighting
- Brace matching
- Basic editor support

**Limitations:**
- No language server (no intellisense, go-to-definition, or real-time diagnostics)

### Installation

1. Open VS Code Extensions
2. Search for "Bosque"
3. Install the Bosque language extension

### VS Code Settings

Add to your `.vscode/settings.json`:

```json
{
  "files.associations": {
    "*.bsq": "bosque"
  }
}
```

## Troubleshooting

### Podman Not Installed

**Problem:** `bosque: command not found` and Podman is not installed

**Solution:**
```bash
# Install Podman
brew install podman

# Initialize and start
podman machine init
podman machine start

# Verify
podman --version
```

### Podman Machine Not Running

**Problem:** Error message about Podman machine not running

**Solution:**
```bash
# Start the machine
podman machine start

# Verify status
podman machine info
```

### Container Image Not Found

**Problem:** Error message about missing container image

**Solution:**
```bash
# Run installation script to build image
./scripts/install_bosque.sh

# Or build manually
cd docker/bosque
podman build -t bosque-toolchain:latest .
```

### File Permission Issues

**Problem:** Container cannot write to local filesystem

**Solution:**

The Podman mount uses the `:z` flag for SELinux compatibility. If issues persist:

```bash
# Check file permissions
ls -la

# Container runs as root by default - this is normal for Podman
# Files created by container will have your user ownership on macOS
```

### Slow Performance

**Problem:** Commands seem slower than expected

**Causes:**
- Container startup adds ~1-2 seconds per command
- First run may need to pull/initialize resources
- Podman machine may need more resources

**Solutions:**
```bash
# Increase Podman machine resources (if needed)
podman machine set --cpus 4 --memory 4096

# Keep Podman machine running between sessions
# (it's lightweight and starts automatically)
```

### Cannot Connect to Podman Socket

**Problem:** "Cannot connect to Podman. Is Podman running?"

**Solution:**
```bash
# Restart Podman machine
podman machine stop
podman machine start

# Verify
podman ps
```

## Advanced Topics

### Testing

Bosque includes SMT-based property checking:

```bash
# Run unit tests
bosque test <files>

# Symbolic testing
bosque apptest <files>
```

### Compilation Options

```bash
# Compile to JavaScript (default)
bosque compile <file.bsq>

# Run compiled output
node jsout/Main.mjs
```

### BosqueCore Version

Check the BosqueCore version in the container:

```bash
podman run --rm bosque-toolchain:latest node --version
podman run --rm bosque-toolchain:latest bosque --help
```

## Learning Resources

### Official Resources

- **BosqueCore Repository:** https://github.com/BosqueLanguage/BosqueCore
- **Language Specification:** Available in repository docs directory
- **Research Papers:** Search for "Bosque Programming Language" on Microsoft Research

### Community

- **GitHub Issues:** https://github.com/BosqueLanguage/BosqueCore/issues
- **GitHub Discussions:** Check the BosqueCore repository

### Example Code

- **Repository Examples:** Check the `test/` directory in BosqueCore
- **Local Hello World:** `hello/bosque/hello.bsq` in this project

## Comparison: Native vs. Container

### Native Installation (Linux Only)

**Pros:**
- Slightly faster execution (no container overhead)
- Direct access to BosqueCore tools

**Cons:**
- Only works on Linux (Ubuntu 24 recommended)
- Requires manual dependency management
- Build issues on other platforms

### Container Installation (Works on macOS)

**Pros:**
- Works on macOS (and Windows with Docker)
- Consistent environment across machines
- Isolated dependencies
- Easy updates (rebuild container)
- No host system pollution

**Cons:**
- ~1-2 second container startup overhead per command
- Requires Podman or Docker
- Slightly more complex setup initially

**Recommendation:** For macOS users, the containerized approach is the only practical option.

## Uninstalling

To remove Bosque:

```bash
# Remove container image
podman rmi bosque-toolchain:latest

# Remove wrapper symlink
rm ~/.local/bin/bosque

# Optionally remove Podman (if not needed for other projects)
brew uninstall podman
podman machine rm
```

## Future Outlook

**BosqueCore v1.0** has been released with a stable specification. The project roadmap includes:
- **Version 2.0:** Revised Small Model Verifier
- **AOT Compiler:** Ahead-of-time compilation support
- **Self-hosting:** Implementing more of Bosque in Bosque itself

**macOS Support:** Native support not currently planned. The containerized approach provides full functionality.

## Getting Help

### For Container Issues

1. Check Podman is running: `podman machine info`
2. Verify image exists: `podman images | grep bosque`
3. Check wrapper script: `cat ~/.local/bin/bosque`
4. Try rebuilding: `podman rmi bosque-toolchain:latest && ./scripts/install_bosque.sh`

### For Bosque Language Issues

1. Check BosqueCore GitHub issues: https://github.com/BosqueLanguage/BosqueCore/issues
2. Review language specification in repository
3. Open new issue with:
   - Bosque code sample
   - Expected vs. actual behavior
   - Container environment details

## Version Information

- **BosqueCore Version:** 1.0 (stable specification)
- **Container Base:** Ubuntu 24.04
- **Node.js Version:** 22.x (latest LTS)
- **Supported via Container:** macOS, Linux, Windows
- **Native Support:** Linux only

## Advent of Code File Naming Conventions

### Required File Structure

For Advent of Code solutions in this project, each implemented day **must** have:

```
solutions/bosque/dayXX/
├── solution.bsq         # ✅ REQUIRED - Algorithm in Bosque syntax
├── runner.py            # ✅ REQUIRED - Python wrapper for execution
└── test_runner.py       # ✅ REQUIRED - Unit tests (8 tests)
```

### Important Notes

1. **`solution.bsq` is required** - The test runner (`scripts/runners/run_bosque.sh`) specifically looks for a file named `solution.bsq` (not `dayXX.bsq`)

2. **Delete placeholder files** - If you see `dayXX.bsq` placeholder files, delete them after creating `solution.bsq`

3. **Python wrappers handle execution** - Due to BosqueCore's limited file I/O, the actual execution uses Python wrappers that implement the algorithm documented in `solution.bsq`

4. **Consistent across days** - All implemented days follow this exact structure for integration testing

### Why Python Wrappers?

BosqueCore v1.0 has limited standard library support for file I/O operations. The Python wrappers:
- Read input from stdin
- Implement the algorithm exactly as documented in `solution.bsq`
- Output consistent JSON format
- Enable cross-language integration testing

The `.bsq` files serve as **algorithm specification and documentation** while Python handles execution.

See [`solutions/bosque/README.md`](../../solutions/bosque/README.md) for detailed information.

## Quick Reference

```bash
# Install (first time)
./scripts/install_bosque.sh

# Compile a program
bosque compile file.bsq

# Run compiled output
node jsout/Main.mjs

# Run Advent of Code solution (via Python wrapper)
./scripts/runners/run_bosque.sh 4 challenges/day04/input.txt

# Test a specific day
./scripts/test_integration.sh 4

# Rebuild container
podman rmi bosque-toolchain:latest
./scripts/install_bosque.sh

# Start Podman machine
podman machine start

# Stop Podman machine
podman machine stop

# View Bosque help
bosque --help

# Access container directly
podman run -it -v $(pwd):/workspace bosque-toolchain:latest bash
```

## Summary

**Bosque on macOS: Fully Functional via Container**

The containerized approach provides:
- Full BosqueCore functionality on macOS
- Transparent file access
- Simple command-line interface
- Reliable, consistent environment
- No native build issues

This is the **recommended approach** for running Bosque on macOS and is suitable for Advent of Code 2025 problem solving.

---

**Installation Status:** Working via Podman/Docker container
**Last Updated:** December 3, 2025
**Platform:** macOS (via containerization), Linux (native)
