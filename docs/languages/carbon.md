# Carbon Language Documentation

## Overview

Carbon is an experimental programming language being developed as a potential successor to C++. It is designed to have modern language features while maintaining interoperability with existing C++ code. Carbon is in early development and is not yet ready for production use.

**Status**: Experimental (pre-1.0)
**Official Website**: https://github.com/carbon-language/carbon-lang
**Platform Support**: Docker/Podman container (cross-platform)

## Installation

### Prerequisites

This project uses a containerized approach for Carbon due to its complex build requirements:
- **Docker** or **Podman** (container runtime)
- **4GB+ RAM** allocated to container runtime
- **~5 hours** for initial container build (one-time, then cached)

### Container-Based Installation

The Carbon toolchain is built and run inside a Docker/Podman container to ensure consistent behavior across platforms.

#### Building the Container

The container is built automatically when running Carbon solutions. To build manually:

```bash
cd solutions/carbon
podman build -t carbon-aoc:day1 -f Dockerfile.minimal .
```

**Build specifications:**
- **Base image**: Ubuntu 22.04
- **Compiler**: Clang 19 (from LLVM repository)
- **Build system**: Bazel 8.3.1
- **Build time**: ~5 hours (8,133 compilation steps)
- **Container size**: ~2GB final image
- **Memory requirements**: 4GB RAM for Podman machine

#### Container Build Process

The Dockerfile performs these steps:
1. Install prerequisites (build-essential, git, python3, wget)
2. Add LLVM 19 repository and install Clang 19
3. Clone Carbon language repository (shallow clone)
4. Build Carbon toolchain with Bazel (`--jobs=2 --local_ram_resources=3500`)
5. Create wrapper script for easy `carbon` command access

### Resource Configuration

If you encounter memory issues during container builds:

```bash
# Stop and reconfigure Podman machine (macOS)
podman machine stop
podman machine set --memory 4096  # 4GB RAM
podman machine start
```

## Running Carbon Programs

### Using the Container

Carbon programs are compiled and run inside the container using Bazel:

```bash
# Run a Carbon solution
podman run --rm \
  -v $(pwd)/solutions/carbon/day01:/host:Z \
  -v $(pwd)/challenges/day01:/input:Z \
  carbon-aoc:day1 bash -c "
    mkdir -p /opt/carbon-lang/examples/aoc2025/day01 &&
    cp /host/day01_simple.carbon /opt/carbon-lang/examples/aoc2025/day01/ &&
    cd /opt/carbon-lang/examples/aoc2025/day01 &&
    echo 'load(\"//bazel/carbon_rules:defs.bzl\", \"carbon_binary\")

carbon_binary(
    name = \"day01\",
    srcs = [\"day01_simple.carbon\"],
)' > BUILD &&
    cd /opt/carbon-lang &&
    ./scripts/run_bazelisk.py build --jobs=2 --local_ram_resources=3500 //examples/aoc2025/day01:day01 &&
    ./bazel-bin/examples/aoc2025/day01/day01 < /input/input.txt
"
```

### Using the Runner Script

The project includes a wrapper script that handles container execution:

```bash
./scripts/runners/run_carbon.sh 1 challenges/day01/input.txt
```

The script:
1. Copies Carbon source files into the container
2. Creates a Bazel BUILD file
3. Compiles the Carbon program with Bazel
4. Runs the compiled binary with the provided input
5. Returns JSON output to stdout

## Carbon Language Basics

### Project Structure for Advent of Code

Each Carbon solution follows this structure:

```
solutions/carbon/day01/
├── day01_simple.carbon    # Main solution file
└── README.md             # Problem description
```

### Basic Carbon Syntax

Carbon syntax is designed to be familiar to C++ developers while incorporating modern language features.

#### Example: Day 1 Solution Structure

```carbon
// Import Core library for I/O
import Core library "io";

// Global variables (module-level)
var unread_char: i32 = 0;

// Function definitions
fn ReadChar() -> i32 {
  if (unread_char != 0) {
    var result: i32 = unread_char - 2;
    unread_char = 0;
    return result;
  }
  return Core.ReadChar();
}

// Class definitions
class Rotation {
  var is_left: bool;
  var distance: i32;
}

// Entry point
fn Run() {
  var position: i32 = 50;
  // ... solution logic ...

  // Output JSON
  Core.PrintChar('{');
  // ... print JSON output ...
}
```

#### Key Syntax Elements

- **Import statement**: `import Core library "io";` - Imports core library
- **Function definition**: `fn FunctionName(params) -> ReturnType { ... }`
- **Variable declaration**: `var name: Type = value;`
- **Class definition**: `class ClassName { var field: Type; }`
- **Comments**: Use `//` for single-line comments
- **Immutable parameters**: Function parameters cannot be reassigned

### Common Operations

#### Declaring Variables

```carbon
var x: i32 = 42;          // Integer
var y: f64 = 3.14;        // Float (limited support)
var b: bool = true;       // Boolean
var c: i32 = 0x41;        // Hex literal (character code)
```

#### Control Flow

```carbon
// If statement
if (condition) {
  // code
} else if (other_condition) {
  // code
} else {
  // code
}

// While loop
while (condition) {
  // code
}

// Break from loop
break;
```

#### Functions

```carbon
fn Add(x: i32, y: i32) -> i32 {
  return x + y;
}

// Function with pointer parameter (for output)
fn ReadInt(p: i32*) -> bool {
  *p = 42;  // Dereference to assign
  return true;
}
```

#### I/O Operations

```carbon
// Read a single character from stdin
var c: i32 = Core.ReadChar();

// Check for EOF
if (c == Core.EOF()) {
  return false;
}

// Print a single character
Core.PrintChar('A');
Core.PrintChar('\n');

// Print as u8 then cast to char for digits
Core.PrintChar(((digit + 0x30) as u8) as char);
```

### Carbon Limitations

Current limitations of Carbon (as of December 2025):

1. **No string type**: Must use character-by-character I/O
2. **No standard library**: Only Core library available
3. **No dynamic allocation**: Use fixed-size arrays
4. **No library imports**: Must inline all utility functions or use Bazel build system
5. **No trailing comments on some lines**: Comments cause compilation errors in certain contexts
6. **No enum equality**: Choice types don't auto-implement equality
7. **Immutable parameters**: Cannot reassign function parameters

## Development Environment

### VS Code Setup

Carbon language support for VS Code is limited as the language is experimental.

#### Available Extensions

As of now, there is no official Carbon extension for VS Code. However, you can:

1. **Use C++ syntax highlighting** as a temporary solution:
   - Associate `.carbon` files with C++ in VS Code settings
   - Add to your `settings.json`:
     ```json
     "files.associations": {
       "*.carbon": "cpp"
     }
     ```

2. **Check for community extensions**:
   - Search the VS Code marketplace for "Carbon language"
   - Monitor the Carbon GitHub repository for tooling updates

### Language Server

Carbon does not yet have a stable language server protocol (LSP) implementation. The project is focused on language design and core toolchain development first.

## Troubleshooting

### Common Issues

#### 1. Container Build Fails with OOM Error

**Symptom**: `Server terminated abruptly (error code: 14, error message: 'Socket closed')`

**Solution**:
```bash
# Increase Podman machine memory
podman machine stop
podman machine set --memory 4096  # or higher
podman machine start

# Rebuild with memory constraints
podman build -t carbon-aoc:day1 -f Dockerfile.minimal .
```

#### 2. Compilation Errors with Trailing Comments

**Symptom**: `error: trailing comments are not permitted`

**Solution**: Remove inline comments from certain statement types (if statements, assignments in some contexts).

#### 3. Cannot Copy Value of Type

**Symptom**: `error: cannot copy value of type 'Direction'`

**Solution**: Carbon's choice types (enums) don't automatically implement the `Copy` interface. Use bool flags instead of choice types, or implement explicit Copy.

#### 4. Cannot Assign to Function Parameter

**Symptom**: `error: expression is not assignable`

**Solution**: Function parameters are immutable in Carbon. Copy to a local variable first:
```carbon
fn PrintInt(n_val: i32) {
  var n: i32 = n_val;  // Copy to mutable variable
  n = -n;              // Now can modify
}
```

#### 5. Undefined Symbol at Link Time

**Symptom**: `ld.lld: error: undefined symbol: _CEOF.Core`

**Solution**: Must use Bazel build system instead of compiling/linking directly. Carbon requires runtime libraries that Bazel manages automatically.

### Performance Notes

- **Container build**: 5+ hours initially, cached afterward
- **Compilation time**: ~2-3 minutes per solution (with cached dependencies)
- **Runtime**: Fast (compiled to native code)
- **Memory usage**: 4GB recommended for build, <1GB for runtime

## Implementation Notes for Advent of Code

### Historical Context

Previous implementations (Days 1-4) used Python wrappers because:
- Carbon's toolchain was difficult to set up on macOS
- Limited I/O capabilities were uncertain
- Build process was complex and poorly documented

### Current Approach (Day 1+)

Real Carbon implementations are now used:
- Containerized build environment ensures consistency
- Direct I/O through Core library (`Core.ReadChar()`, `Core.PrintChar()`)
- Bazel build system handles all dependencies
- No Python wrappers needed

### Best Practices

1. **Single-file solutions**: Inline utility functions to avoid library complexity
2. **Character-based I/O**: Read/write one character at a time using hex codes
3. **Fixed-size buffers**: No dynamic allocation available
4. **Explicit state machines**: For parsing, track state manually
5. **JSON output**: Print JSON character-by-character
6. **Test in container**: Always test inside the container environment

## Additional Resources

- **Carbon Language GitHub**: https://github.com/carbon-language/carbon-lang
- **Carbon Design Docs**: https://github.com/carbon-language/carbon-lang/tree/trunk/docs/design
- **Carbon Advent 2024 Examples**: Examples in `/tmp/carbon-lang/examples/advent2024/` (inside container)
- **LLVM Documentation**: https://llvm.org/docs/

## Container Architecture

The Carbon container is built with:
- **OS**: Ubuntu 22.04 (Jammy)
- **Compiler**: Clang 19.1.7
- **Build Tool**: Bazelisk (auto-downloads Bazel 8.3.1)
- **Carbon Location**: `/opt/carbon-lang/`
- **Binary Path**: `/opt/carbon-lang/bazel-bin/toolchain/carbon`
- **Wrapper Script**: `/usr/local/bin/carbon` (convenience)

### Build Performance Tuning

The Dockerfile uses these optimizations:
- `--jobs=2`: Limit parallel compilation to prevent OOM
- `--local_ram_resources=3500`: Reserve 3.5GB for Bazel (out of 4GB total)
- Shallow git clone (`--depth 1`): Saves space and time
- Build caching: Subsequent builds reuse compiled artifacts

## Future Improvements

Potential improvements for Carbon integration:
- [ ] Pre-built container image hosted on Docker Hub
- [ ] Simplified runner script with better error messages
- [ ] Support for Carbon libraries (when available)
- [ ] Integration tests for all days
- [ ] Performance benchmarking vs other languages
