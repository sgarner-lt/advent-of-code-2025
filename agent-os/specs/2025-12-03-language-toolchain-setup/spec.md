# Specification: Language Toolchain Setup

## Goal
Install and verify 5 language toolchains (Rust, Gleam, Roc, Carbon, Bosque) with build tools, testing frameworks, and development environment properly configured for Advent of Code 2025 problem solving on macOS.

## User Stories
- As a developer, I want to install all 5 language toolchains automatically so that I can quickly start solving problems without manual setup overhead
- As a learner, I want clear documentation per language so that I understand each language's ecosystem and best practices

## Specific Requirements

**Language Installation Scripts**
- Create 5 separate shell scripts (one per language) in a dedicated scripts or tools directory
- Use Homebrew when available for stable languages (Rust, Gleam)
- For experimental languages (Roc, Carbon, Bosque), clone to temporary directories and build from source as needed
- Each script should be idempotent and safe to run multiple times
- Scripts should check if language is already installed before attempting installation
- Use Mac-idiomatic installation patterns following each language's recommended approach
- Scripts should exit with clear error codes and messages if installation fails

**Version Requirements and Validation**
- Rust: Install version 1.83.0 or higher (stable channel via rustup)
- Gleam: Install version 1.13.0 or higher (stable via Homebrew)
- Roc: Install latest nightly build (no stable version exists, build from source)
- Carbon: Install experimental version from official repository
- Bosque: Install research version from official repository
- Each script must verify installation by running version check commands
- Version validation should fail script if minimum version requirements not met

**Hello World Verification Programs**
- Create permanent Hello World programs for each language in language-specific directories
- Programs should demonstrate basic compilation and execution functionality
- Each program should output a language-identifying message to stdout
- Programs should be simple, idiomatic examples showing basic syntax
- Verification tests should compile and run these programs as part of installation validation
- Store Hello World programs in organized directory structure (e.g., `hello/rust/`, `hello/gleam/`, etc.)

**Build Tool and Dependency Setup**
- Rust: Verify Cargo can create, build, test, and run a sample project
- Gleam: Verify gleam CLI can create, build, test, and run a sample project
- Roc: Verify roc CLI can compile and run a sample program
- Carbon: Verify carbon toolchain can compile and run a sample program
- Bosque: Verify bosque toolchain can compile and run a sample program
- Install standard library-level dependencies only (no problem-specific libraries)
- Validate package managers and dependency resolution work correctly

**Per-Language Documentation**
- Create markdown documentation for each language in language-specific folders or with language prefixes
- Documentation should explain installation process step-by-step for manual reference
- Include troubleshooting sections with common issues and solutions
- Document any experimental language limitations or workarounds discovered
- Explain build tool usage basics (how to compile, run, test)
- Include links to official language documentation and resources
- Document platform limitation (Mac-only) clearly in each guide

**VS Code and Language Server Setup**
- Provide VS Code configuration guidance for all 5 languages
- Document language server installation for each language (rust-analyzer, gleam LSP, etc.)
- Include recommended VS Code extensions per language
- Provide sample workspace settings if beneficial
- Document how to verify language server is working correctly
- Note which experimental languages may have limited or no language server support

**Directory Structure and Organization**
- Use language-specific folders to avoid cluttering root directory
- Organize installation scripts together in a dedicated location
- Keep Hello World programs separate from documentation
- Follow consistent naming conventions across all 5 languages
- Structure should support future addition of problem solutions per language
- Ensure documentation is easily discoverable and well-organized

**Troubleshooting and Error Handling**
- Scripts should provide clear error messages when installation fails
- Document known issues for experimental languages (Roc, Carbon, Bosque)
- Provide fallback strategies if Homebrew installation unavailable
- Include verification that prerequisites (Homebrew, Git, Xcode tools) are installed
- Document how to clean up failed installations and retry
- Aim to have all 5 languages working successfully, troubleshoot exhaustively before giving up

**Master Installation Script (Optional)**
- Consider creating a master script that runs all 5 language installation scripts sequentially
- Master script should continue on error but report which languages failed
- Provide summary at end showing which languages installed successfully
- Allow selective installation via flags (e.g., `--only-rust` or `--skip-carbon`)

**Standard Library Dependencies**
- Identify and document any stdlib-type dependencies worth installing upfront
- For Rust: Consider common crates like itertools if they qualify as stdlib-level
- For Gleam: Consider packages like simplifile if they qualify as stdlib-level
- Avoid installing problem-specific libraries at this stage
- Document how to add dependencies later when needed for specific problems

## Visual Design

No visual assets provided for this infrastructure setup specification.

## Existing Code to Leverage

**Homebrew Package Manager**
- Already installed and available on user's Mac system
- Use as preferred installation method for stable languages (Rust via rustup, Gleam)
- Verify Homebrew is accessible via `brew --version` before attempting installations
- Follow Homebrew best practices for package installation and updates

**Git and GitHub Access**
- Available for cloning experimental language repositories
- Use for installing Carbon and Bosque from their official repositories
- Clone to temporary directories to avoid cluttering project workspace
- Follow git best practices for version control operations

**Project Structure Pattern from agent-os**
- Follow existing agent-os directory organization patterns
- Use standards defined in agent-os/standards/ as reference
- Maintain consistency with project's documentation and organization conventions
- Apply DRY principle by creating reusable script functions where appropriate

## Out of Scope
- Benchmarking tools setup (deferred to separate phase)
- Sample problem validation against actual Advent of Code problems
- Problem-specific library installation (wait until specific days require them)
- Multi-platform support for Linux or Windows systems
- Advanced IDE configuration beyond basic language server setup
- CI/CD automation pipeline for running tests
- Performance profiling or optimization tools
- Docker containerization of language environments
- Automated version updates or upgrade scripts
- Integration with version managers beyond rustup
