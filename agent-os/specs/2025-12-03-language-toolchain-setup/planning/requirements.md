# Spec Requirements: Language Toolchain Setup

## Initial Description
Language Toolchain Setup — Install and verify all 5 language toolchains (Rust 1.83.0+, Gleam 1.13.0+, Roc nightly, Carbon experimental, Bosque research) with build tools and testing frameworks working correctly

## Requirements Discussion

### First Round Questions

**Q1: Installation Method - Should we use a package manager (like Homebrew on Mac) or install from source? Should we create one installation script that handles all 5 languages, or separate scripts per language?**
**Answer:** Use whatever is idiomatic for Mac. Use Homebrew if available. One script per language preferred.

**Q2: Experimental Language Installation - For Carbon and Bosque (which are experimental/research languages), should we document the manual installation process if automated installation isn't possible, or is the goal to have fully automated installation for all 5?**
**Answer:** Document the process. Clone to tmp directory is fine. Create shell scripts for automation AND markdown per language to explain the process for others who want to reference this repo.

**Q3: Verification Tests - Should the "verify working correctly" step include running a simple test program (like "Hello, World!") in each language, or just checking version numbers?**
**Answer:** Hello world or `--version` checks depending on the language. These should be permanent fixtures.

**Q4: Platform Support - Should we support multiple platforms (Mac, Linux, Windows) or focus on Mac only given your environment?**
**Answer:** Mac-only, note this limitation in the README.

**Q5: Build Tool Validation - For languages like Rust (Cargo) and Gleam (gleam CLI), should we verify the build tools can create and compile a sample project, or just confirm they're installed?**
**Answer:** Compile and run a sample hello world to verify everything works correctly.

**Q6: Dependency Management - Should we install any common libraries/crates at this stage (like itertools for Rust, simplifile for Gleam), or wait until needed for specific problems?**
**Answer:** If it's stdlib-type dependencies, include them. Problem-specific libraries can wait until that day. Goal is to verify installation and basic functionality.

**Q7: Fallback Strategies - If one of the experimental languages (Carbon, Bosque, Roc) cannot be installed successfully, should we proceed with the other 4, or is successful installation of all 5 a hard requirement?**
**Answer:** Try to troubleshoot if something doesn't work. Unless exhausted all troubleshooting steps, aim to have all 5 languages working.

**Q8: Documentation Output - Should installation instructions go in the main project README, or in separate per-language documentation files?**
**Answer:** Language-specific folders or include language name in markdown filename. Avoid cluttering root directory with many files.

**Q9: Exclusions - Is there anything we should explicitly NOT include? For example: VS Code setup, language server configuration, benchmarking tools, sample problem validation?**
**Answer:** VS Code setup is fine to include. Language server setup is fine. Skip benchmarks. Tool setup to run hello world is fine. If doing hello world, can skip sample problem validation.

**Q10: Existing Code - Do you have any existing setup scripts, configuration files, or similar installation automation in your codebase that we should reference or build upon?**
**Answer:** All these languages are new to the user. Has Homebrew available. Wants idiomatic/best practices approach for each language to help learn the languages and ecosystems better.

### Existing Code to Reference

No similar existing features identified for reference. This is a greenfield setup for all 5 languages.

**Available Foundation:**
- Homebrew package manager is already installed on Mac
- Git and GitHub are available for repository operations

### Follow-up Questions

None required. The user provided comprehensive and clear answers to all questions.

## Visual Assets

### Files Provided:
No visual assets provided.

### Visual Insights:
Not applicable for this infrastructure setup spec.

## Requirements Summary

### Functional Requirements

**Language Installation:**
- Install 5 language toolchains: Rust 1.83.0+, Gleam 1.13.0+, Roc nightly, Carbon experimental, Bosque research
- Use Mac-idiomatic installation methods (prefer Homebrew when available)
- Create one installation script per language (5 scripts total)
- For experimental languages (Carbon, Bosque), support cloning to tmp directory if needed

**Verification:**
- Verify each language installation with version checks (`--version` or equivalent)
- Create and run a "Hello, World!" program in each language to validate compilation and execution
- These verification tests should be permanent fixtures in the repository

**Documentation:**
- Create markdown documentation per language explaining installation process
- Use language-specific folders or language names in filenames to avoid cluttering root directory
- Document that this is Mac-only setup with notes about platform limitations
- Include troubleshooting guidance for each language

**Build Tools and Testing Frameworks:**
- Validate build tools work correctly:
  - Rust: Cargo (build and test a sample project)
  - Gleam: gleam CLI (build and test a sample project)
  - Roc: roc CLI (compile and run a sample program)
  - Carbon: carbon CLI (compile and run a sample program)
  - Bosque: bosque CLI (compile and run a sample program)
- Install standard library-level dependencies if applicable:
  - Problem-specific libraries wait until needed

**Editor Setup (Optional but Included):**
- VS Code configuration guidance
- Language server setup instructions for each language:
  - rust-analyzer for Rust
  - gleam lsp for Gleam
  - Language servers for Roc/Carbon/Bosque as available

**Troubleshooting:**
- If installation fails, provide troubleshooting steps
- Aim for all 5 languages working successfully before considering spec complete
- Document any experimental language limitations or workarounds discovered

### Reusability Opportunities

Not applicable - this is a foundational setup with no existing similar features.

**New Patterns Established:**
- Per-language installation script pattern
- Per-language documentation structure
- Verification test pattern (version check + hello world)
- May inform future language-specific tooling setup

### Scope Boundaries

**In Scope:**
- Installation scripts for all 5 languages (Rust, Gleam, Roc, Carbon, Bosque)
- Version verification for each language
- "Hello, World!" compilation and execution tests for each language
- Build tool validation (Cargo, gleam CLI, roc CLI, etc.)
- Standard library-level dependencies installation
- Per-language markdown documentation explaining installation process
- VS Code setup guidance
- Language server configuration instructions
- Mac platform-specific installation (Homebrew preferred)
- Troubleshooting documentation for common issues

**Out of Scope:**
- Benchmarking tools setup (deferred to Phase 0, item 4 in roadmap)
- Sample problem validation (deferred to Phase 0, item 5 in roadmap)
- Problem-specific library installation (wait until specific days require them)
- Multi-platform support (Linux, Windows)
- Advanced IDE configuration beyond basic language server setup
- CI/CD automation setup
- Performance profiling tools

### Technical Considerations

**Platform:**
- Mac-only (macOS 14.6 / Darwin 24.6.0)
- Homebrew available and should be preferred installation method

**Version Requirements:**
- Rust: 1.83.0+ (stable channel)
- Gleam: 1.13.0+ (stable)
- Roc: Nightly builds (pre-0.1, no stable version exists)
- Carbon: Experimental (no stable version exists)
- Bosque: Research/experimental (no stable version exists)

**Experimental Language Risks:**
- Roc, Carbon, and Bosque may require building from source
- Documentation for experimental languages may be limited or outdated
- Installation processes may not be standardized
- May need to clone repositories to temporary directories

**Verification Strategy:**
- Version checks validate installation succeeded
- Hello World programs validate:
  - Compiler/interpreter works
  - Basic language syntax is functional
  - Output can be produced
  - File I/O may be tested depending on implementation

**Documentation Structure:**
- Use language-specific folders OR language names in filenames
- Avoid cluttering root directory
- Balance between automation (scripts) and explanation (markdown)
- Help future developers (or the user) understand installation process

**Best Practices Alignment:**
- Follow idiomatic installation patterns for each language
- Use each language's recommended tooling and package managers
- Document edge cases and workarounds for experimental languages
- Establish foundation for learning language ecosystems properly