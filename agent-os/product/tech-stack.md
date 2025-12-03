# Tech Stack - Advent of Code 2025

This project uses **5 programming languages in parallel** to solve each Advent of Code challenge. Each language offers unique strengths and paradigms for problem-solving.

## Programming Languages

### Primary Languages
All solutions are implemented in parallel across these 5 languages:

1. **Rust** - Systems programming language
   - **Version:** 1.83.0+ (stable channel)
   - **Build Tool:** Cargo
   - **Package Manager:** Cargo
   - **Testing Framework:** Built-in `cargo test`
   - **Key Features:** Memory safety, zero-cost abstractions, fearless concurrency
   - **Best For:** Performance-critical algorithms, systems-level operations
   - **Paradigm:** Systems programming with functional influences, ownership-based memory management

2. **Roc** - Functional programming language
   - **Version:** Nightly builds (pre-0.1, no GA version yet)
   - **Build Tool:** roc CLI
   - **Testing Framework:** Built-in `expect` statements
   - **Key Features:** Functional paradigm, strong type inference, fast compilation
   - **Best For:** Functional transformations, immutable data structures
   - **Paradigm:** Pure functional programming with emphasis on simplicity
   - **Note:** Currently alpha/nightly releases only. First numbered release (0.1.0) expected in 2026.

3. **Gleam** - Type-safe functional language for the BEAM VM
   - **Version:** 1.13.0+ (stable)
   - **Build Tool:** gleam CLI
   - **Package Manager:** gleam add
   - **Testing Framework:** gleeunit
   - **Key Features:** Type safety, BEAM concurrency, friendly compiler errors
   - **Best For:** Type-safe solutions, concurrent processing
   - **Paradigm:** Functional programming on Erlang VM with strong static typing

4. **Carbon** - Experimental successor to C++
   - **Version:** Experimental (no GA version yet)
   - **Build Tool:** carbon CLI
   - **Testing Framework:** Custom test harness
   - **Key Features:** Modern C++ interop, memory safety, performance
   - **Best For:** C++-style performance with modern safety
   - **Paradigm:** Systems programming with modern language design
   - **Note:** Still in experimental development. No stable release available.

5. **Bosque** - Research language focused on regularized programming
   - **Version:** Research/experimental (no GA version yet)
   - **Build Tool:** bosque CLI
   - **Testing Framework:** Built-in assertions
   - **Key Features:** Algebraic operations, verification-oriented design, no null/undefined
   - **Best For:** Verifiable correctness, algebraic transformations
   - **Paradigm:** Regularized programming for easier verification and reasoning
   - **Note:** Research language from Microsoft Research. No stable release available.

## Development Tools

### Version Control
- **Git** for source control
- **GitHub** for repository hosting
- Branch strategy: Main branch for stable solutions, feature branches for experimentation

### Text Editors / IDEs
- **VS Code** with language-specific extensions
  - rust-analyzer for Rust
  - Gleam extension for Gleam
  - Language-specific syntax highlighting for Roc, Carbon, Bosque
- **RustRover / IntelliJ** for Rust (optional)
- **Vim/Neovim** with language servers

### Language Servers (LSP)
- **rust-analyzer** for Rust (mature, excellent tooling)
- **roc-ls** for Roc (if available, may be experimental)
- **gleam lsp** for Gleam (built into gleam CLI)
- Language servers for Carbon/Bosque as available (likely limited)

### Build and Test Automation
- **Makefiles** or shell scripts for running all 5 languages in parallel
- **CI/CD:** GitHub Actions for automated testing (optional)
- **Benchmarking:** Language-specific benchmarking tools (cargo bench, custom scripts)

## Project Structure Convention

Each day follows this standardized structure:
```
dayXX/
  ├── rust/           # Rust implementation
  │   ├── Cargo.toml
  │   └── src/
  │       └── main.rs
  ├── roc/            # Roc implementation
  │   └── main.roc
  ├── gleam/          # Gleam implementation
  │   ├── gleam.toml
  │   └── src/
  │       └── day_xx.gleam
  ├── carbon/         # Carbon implementation
  │   └── solution.carbon
  ├── bosque/         # Bosque implementation
  │   └── solution.bsq
  ├── input.txt       # Puzzle input (shared across all languages)
  ├── sample.txt      # Sample data from problem description (shared)
  └── README.md       # Problem notes, algorithm approach, lessons learned
```

### Key Conventions
- **Shared input files:** All 5 languages read from the same `input.txt` and `sample.txt`
- **Consistent naming:** Each day uses `dayXX/` format (e.g., `day01/`, `day02/`)
- **Language isolation:** Each language has its own subdirectory with native project structure
- **Cross-language validation:** Answers must match exactly across all implementations

## Testing Strategy

### Testing Workflow
1. **Sample Data First:** All implementations validate against provided examples from problem description
2. **Cross-Language Validation:** Verify all 5 languages produce identical answers for sample input
3. **Real Input Testing:** Run against actual puzzle input once sample tests pass
4. **Final Validation:** Confirm all 5 languages agree on final answer before submitting to Advent of Code
5. **Unit Tests:** Each language uses its native testing framework for internal functions

### Test Frameworks by Language
- **Rust:** `cargo test` with `#[test]` attributes and `assert_eq!` macros
- **Roc:** `expect` statements inline with code for property testing
- **Gleam:** `gleeunit` with test functions and assertion helpers
- **Carbon:** Custom test harness with assertions (as tooling allows)
- **Bosque:** Built-in assertions and verification (as tooling allows)

### Validation Requirements
- Solutions must pass sample tests before running real input
- All 5 languages must produce identical answers for both Part 1 and Part 2
- If answers diverge, debug and fix before moving to next day
- Document any language-specific edge cases or quirks discovered

## Performance Targets

### Execution Time Goals
- Solutions should complete in **< 15 seconds** for typical inputs
- Optimize only when necessary (after getting correct answer)
- Compare execution times across languages for learning
- Document particularly fast or slow implementations with explanations

### Performance Comparison Metrics
- **Compilation Time:** How long to build each solution
- **Execution Time:** Runtime for both Part 1 and Part 2
- **Memory Usage:** Peak memory consumption (if measurable)
- **Code Complexity:** Lines of code, cyclomatic complexity (subjective)

### Optimization Strategy
1. **Correctness First:** Get the right answer in all 5 languages
2. **Profile Second:** Identify bottlenecks only if solution is too slow
3. **Language-Specific Optimizations:** Use each language's strengths (Rust SIMD, Gleam concurrency, etc.)
4. **Document Trade-offs:** Note when optimization hurts readability

## Dependencies

### Rust Crates (common)
```toml
[dependencies]
itertools = "0.13"      # Iterator utilities for combinatorics, grouping
regex = "1.11"          # Regular expressions for parsing
rayon = "1.10"          # Parallel processing (if needed for optimization)
rustc-hash = "2.0"      # Fast hashing (FxHashMap, FxHashSet)
```

### Gleam Packages (common)
```toml
[dependencies]
gleam_stdlib = "~> 0.34"   # Standard library functions
simplifile = "~> 2.0"      # File I/O operations
gleeunit = "~> 1.0"        # Testing framework
gleam_list = "~> 1.4"      # List manipulation utilities
```

### Roc Libraries
- **Standard library** (built-in): `Str`, `List`, `Dict`, `Set` modules
- **File I/O platform:** Basic or CLI platform for reading input files
- **Minimal external dependencies:** Roc ecosystem is still immature

### Carbon Dependencies
- **Standard libraries** as available in experimental builds
- **Minimal external dependencies:** Language is too experimental for rich ecosystem
- **C++ interop** if needed for complex algorithms (fallback option)

### Bosque Dependencies
- **Standard libraries** as available in research builds
- **Minimal external dependencies:** Research language with limited ecosystem
- **Focus on built-in verification** rather than external libraries

## Language Maturity Assessment

### Production-Ready Languages
- **Rust:** Fully mature, stable, excellent tooling and ecosystem
- **Gleam:** Stable, growing ecosystem, production-ready for BEAM workloads

### Experimental/Research Languages
- **Roc:** Pre-1.0, nightly builds, syntax may change, limited libraries
- **Carbon:** Experimental, unstable, minimal tooling, expect breaking changes
- **Bosque:** Research language, very limited tooling, may lack basic features

### Risk Mitigation
- **Fallback Strategy:** If experimental language is blocked, document the issue and implement a workaround or partial solution
- **Community Support:** Leverage language Discord/forums for help with experimental tooling
- **Flexible Problem-Solving:** Some days may be easier in certain languages; learn from the differences

## Installation Requirements

### Required Toolchains
Before starting, ensure all 5 languages are installed and working:

```bash
# Rust
rustc --version  # Should be 1.83.0 or higher
cargo --version

# Gleam
gleam --version  # Should be 1.13.0 or higher

# Roc
roc version      # Nightly build (any recent version)

# Carbon
carbon --version # Experimental build (any available version)

# Bosque
bosque --version # Research build (any available version)
```

### Development Environment Setup
1. Install all 5 language toolchains
2. Configure editor with language servers and syntax highlighting
3. Verify each language can compile a "Hello, World!" program
4. Test file I/O in each language (reading a text file)
5. Run Phase 0 validation with a practice problem

## Notes

- **Experimental Languages:** Carbon and Bosque are experimental/research languages. Syntax and features may change or be missing.
- **Installation Challenges:** Experimental languages may require building from source or using Docker containers.
- **Documentation:** Refer to official docs for each language as they evolve. Expect limited or outdated documentation for experimental languages.
- **Community:** Leverage language-specific communities (Discord, Zulip, GitHub Discussions) for support, especially with experimental toolchains.
- **Learning Curve:** Expect slower progress in experimental languages due to limited tooling, documentation, and libraries.
