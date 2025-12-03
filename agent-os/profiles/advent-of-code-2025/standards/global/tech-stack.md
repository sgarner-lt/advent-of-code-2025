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

2. **Roc** - Functional programming language
   - **Version:** Nightly builds (pre-0.1, no GA version yet)
   - **Build Tool:** roc CLI
   - **Testing Framework:** Built-in `expect` statements
   - **Key Features:** Functional paradigm, strong type inference, fast compilation
   - **Best For:** Functional transformations, immutable data structures
   - **Note:** Currently alpha/nightly releases only. First numbered release (0.1.0) expected in 2026.

3. **Gleam** - Type-safe functional language for the BEAM VM
   - **Version:** 1.13.0+ (stable)
   - **Build Tool:** gleam CLI
   - **Package Manager:** gleam add
   - **Testing Framework:** gleeunit
   - **Key Features:** Type safety, BEAM concurrency, friendly compiler errors
   - **Best For:** Type-safe solutions, concurrent processing

4. **Carbon** - Experimental successor to C++
   - **Version:** Experimental (no GA version yet)
   - **Build Tool:** carbon CLI
   - **Testing Framework:** Custom test harness
   - **Key Features:** Modern C++ interop, memory safety, performance
   - **Best For:** C++-style performance with modern safety
   - **Note:** Still in experimental development. No stable release available.

5. **Bosque** - Research language focused on regularized programming
   - **Version:** Research/experimental (no GA version yet)
   - **Build Tool:** bosque CLI
   - **Testing Framework:** Built-in assertions
   - **Key Features:** Algebraic operations, verification-oriented design, no null/undefined
   - **Best For:** Verifiable correctness, algebraic transformations
   - **Note:** Research language from Microsoft Research. No stable release available.

## Development Tools

### Version Control
- **Git** for source control
- **GitHub** for repository hosting

### Text Editors / IDEs
- **VS Code** with language-specific extensions
- **RustRover / IntelliJ** for Rust (optional)
- **Vim/Neovim** with language servers

### Language Servers (LSP)
- **rust-analyzer** for Rust
- **roc-ls** for Roc (if available)
- **gleam lsp** for Gleam
- Language servers for Carbon/Bosque as available

## Project Structure Convention

Each day follows this structure:
```
dayXX/
  ├── rust/           # Rust implementation
  │   ├── Cargo.toml
  │   └── src/
  ├── roc/            # Roc implementation
  │   └── main.roc
  ├── gleam/          # Gleam implementation
  │   ├── gleam.toml
  │   └── src/
  ├── carbon/         # Carbon implementation
  │   └── solution.carbon
  ├── bosque/         # Bosque implementation
  │   └── solution.bsq
  ├── input.txt       # Puzzle input (shared)
  ├── sample.txt      # Sample data (shared)
  └── README.md       # Problem notes
```

## Testing Strategy

- **Sample Data First:** All implementations validate against provided examples
- **Cross-Language Validation:** Verify all 5 languages produce identical answers
- **Performance Comparison:** Benchmark solutions across languages
- **Unit Tests:** Each language uses its native testing framework

## Performance Targets

- Solutions should complete in < 15 seconds for typical inputs
- Optimize only when necessary (after getting correct answer)
- Compare execution times across languages for learning

## Dependencies

### Rust Crates (common)
- `itertools` - Iterator utilities
- `regex` - Regular expressions
- `rayon` - Parallel processing (if needed)
- `rustc-hash` - Fast hashing (if needed)

### Gleam Packages (common)
- `gleam_stdlib` - Standard library
- `simplifile` - File I/O
- `gleeunit` - Testing

### Roc Libraries
- Standard library (built-in)
- Platform for file I/O

### Carbon/Bosque
- Standard libraries as available
- Minimal external dependencies

## Notes

- **Experimental Languages:** Carbon and Bosque are experimental/research languages. Syntax may change.
- **Installation:** Ensure all 5 language toolchains are installed before starting
- **Documentation:** Refer to official docs for each language as they evolve
