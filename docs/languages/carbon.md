# Carbon Language Documentation

## Overview

Carbon is an experimental programming language being developed as a potential successor to C++. It is designed to have modern language features while maintaining interoperability with existing C++ code. Carbon is in early development and is not yet ready for production use.

**Status**: Experimental (pre-1.0)
**Official Website**: https://github.com/carbon-language/carbon-lang
**Platform Support**: macOS (via source build)

## Installation

### Prerequisites

Before installing Carbon, ensure you have:
- **Homebrew** package manager
- **Git** for cloning repositories
- **Xcode Command Line Tools** (`xcode-select --install`)

### Automated Installation

Use the provided installation script:

```bash
./scripts/install_carbon.sh
```

The script will:
1. Install required dependencies (Bazelisk, LLVM, Python 3.11)
2. Clone the Carbon language repository
3. Set up the build environment
4. Verify the installation

### Manual Installation

If you prefer to install manually:

1. **Install dependencies via Homebrew:**
   ```bash
   brew install bazelisk llvm python@3.11
   ```

2. **Add LLVM to your PATH:**
   ```bash
   export PATH="/usr/local/opt/llvm/bin:$PATH"
   ```
   Add this to your `~/.zshrc` or `~/.bashrc` to make it permanent.

3. **Clone the Carbon repository:**
   ```bash
   mkdir -p ~/.local/carbon
   cd ~/.local/carbon
   git clone https://github.com/carbon-language/carbon-lang.git
   ```

4. **Verify Bazel is working:**
   ```bash
   cd carbon-lang
   bazel version
   ```

### Post-Installation Configuration

After installation, you may want to add the LLVM tools to your shell profile:

```bash
echo 'export PATH="/usr/local/opt/llvm/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## Carbon Toolchain Basics

### Project Structure

Carbon is built using Bazel as its build system. The repository structure includes:
- `explorer/` - The Carbon language interpreter/explorer
- `toolchain/` - The Carbon compiler toolchain
- `docs/` - Language design documentation
- `testdata/` - Example Carbon programs

### Running Carbon Programs

Carbon provides several ways to run programs:

#### 1. Using the Explorer (Interpreter)

The explorer is the primary tool for running Carbon programs during development:

```bash
cd ~/.local/carbon/carbon-lang
bazel run //explorer -- /path/to/your/program.carbon
```

#### 2. Using the Compiler (Experimental)

The Carbon compiler is under active development:

```bash
cd ~/.local/carbon/carbon-lang
bazel run //toolchain/driver:carbon -- compile /path/to/your/program.carbon
```

### Basic Carbon Syntax

Carbon syntax is designed to be familiar to C++ developers while incorporating modern language features.

#### Hello World Example

```carbon
package Sample api;

fn Main() -> i32 {
  var s: String = "Hello from Carbon!";
  Print(s);
  return 0;
}
```

#### Key Syntax Elements

- **Package declaration**: `package Sample api;` - Defines the package
- **Function definition**: `fn FunctionName() -> ReturnType { ... }`
- **Variable declaration**: `var name: Type = value;`
- **Comments**: Use `//` for single-line comments
- **Return type**: Specified with `-> Type` after function parameters

### Common Operations

#### Declaring Variables

```carbon
var x: i32 = 42;          // Integer
var y: f64 = 3.14;        // Float
var s: String = "text";   // String
var b: bool = true;       // Boolean
```

#### Control Flow

```carbon
// If statement
if (condition) {
  // code
} else {
  // code
}

// While loop
while (condition) {
  // code
}
```

#### Functions

```carbon
fn Add(x: i32, y: i32) -> i32 {
  return x + y;
}
```

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

#### 1. Bazel Not Found

**Symptom**: `bazel: command not found`

**Solution**:
```bash
brew install bazelisk
# Or add Homebrew to PATH:
export PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"
```

#### 2. LLVM Clang Not Found

**Symptom**: Build errors mentioning missing LLVM or Clang

**Solution**:
```bash
brew install llvm
export PATH="/usr/local/opt/llvm/bin:$PATH"
```

#### 3. Python Version Issues

**Symptom**: Errors about Python version or missing Python

**Solution**:
```bash
brew install python@3.11
```

#### 4. Bazel Build Failures

**Symptom**: Bazel fails to build with various errors

**Solution**:
- Ensure Xcode Command Line Tools are installed: `xcode-select --install`
- Clear Bazel cache: `bazel clean --expunge`
- Update the Carbon repository: `cd ~/.local/carbon/carbon-lang && git pull`

#### 5. Slow Initial Build

**Symptom**: First Bazel build takes a very long time

**Explanation**: This is normal. Bazel downloads and compiles many dependencies on first run. Subsequent builds will be much faster due to caching.

### Getting Help

- **Official Repository**: https://github.com/carbon-language/carbon-lang
- **Discussion Forum**: https://github.com/carbon-language/carbon-lang/discussions
- **Design Documentation**: https://github.com/carbon-language/carbon-lang/tree/trunk/docs/design
- **Issue Tracker**: https://github.com/carbon-language/carbon-lang/issues

## Experimental Language Limitations

### Important Caveats

1. **Not Production Ready**: Carbon is experimental and should not be used for production code
2. **Breaking Changes**: The language syntax and semantics are subject to frequent breaking changes
3. **Limited Documentation**: Language documentation is evolving alongside the language design
4. **Incomplete Features**: Many planned features are not yet implemented
5. **Build Complexity**: Building from source requires significant disk space and time
6. **Limited Tooling**: IDE support, debuggers, and other development tools are minimal

### What Works

- Basic language exploration via the explorer tool
- Experimental compilation of simple programs
- Testing new language design proposals
- Learning about language design concepts

### What Doesn't Work Yet

- Production-grade compiler optimization
- Full standard library implementation
- Stable language specification
- Complete C++ interoperability
- Package management system
- Debugging tools

## Platform Limitations

**macOS Only**: This installation guide is designed for macOS. Carbon can also be built on Linux systems (particularly Ubuntu), but Windows support is limited to WSL.

## Learning Resources

### Official Documentation

- **Language Overview**: https://github.com/carbon-language/carbon-lang/blob/trunk/docs/project/README.md
- **Design Philosophy**: https://github.com/carbon-language/carbon-lang/blob/trunk/docs/project/goals.md
- **Syntax Examples**: https://github.com/carbon-language/carbon-lang/tree/trunk/explorer/testdata

### Community Resources

- **GitHub Discussions**: Engage with the Carbon community
- **Design Proposals**: Review language design discussions
- **Code Examples**: Browse the testdata directory for examples

## Next Steps

1. **Explore Examples**: Look through the `explorer/testdata/` directory in the Carbon repository
2. **Read Design Docs**: Understand the language design philosophy and goals
3. **Experiment**: Try writing simple programs with the explorer
4. **Follow Development**: Watch the GitHub repository for updates
5. **Provide Feedback**: Participate in design discussions if interested

## Version History

- **Current**: Experimental pre-release (no stable version)
- **Development**: Active ongoing development
- **Goal**: To eventually become a viable C++ successor

## Useful Commands Reference

```bash
# Clone/update Carbon repository
cd ~/.local/carbon/carbon-lang
git pull origin trunk

# Run a Carbon program with explorer
bazel run //explorer -- /path/to/program.carbon

# Query available build targets
bazel query //...

# Clean build cache
bazel clean

# Full clean (removes all build artifacts)
bazel clean --expunge

# Check Bazel version
bazel version

# Update Bazel
brew upgrade bazelisk
```

## Contributing to Carbon

If you're interested in contributing to Carbon language development:

1. Read the contribution guidelines in the repository
2. Join the design discussions
3. Review the open issues and design proposals
4. Test experimental features and report bugs
5. Provide feedback on language design decisions

Carbon is an open-source project welcoming community involvement in its development.
