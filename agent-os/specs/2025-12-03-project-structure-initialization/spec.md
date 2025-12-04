# Specification: Project Structure Initialization

## Goal
Create a standardized, language-first directory structure for Advent of Code 2025 with pre-initialized project files for all 10 days across 5 languages (Rust, Gleam, Roc, Carbon, Bosque), supporting incremental setup and shared input file management.

## User Stories
- As a developer, I want all 10 day folders pre-created across all language directories so that I can immediately start coding any day's challenge
- As a developer, I want language-specific build configurations at the root level so that I can share dependencies and tooling across all days within each language
- As a developer, I want placeholder files with basic boilerplate so that I can focus on solving puzzles rather than setting up project structure

## Specific Requirements

**Language-First Directory Structure**
- Create top-level directories: rust/, gleam/, roc/, carbon/, bosque/
- Each language directory contains day01/ through day10/ subdirectories
- Create separate challenges/ directory at repository root for shared problem statements and input data
- Each challenges/dayXX/ folder contains input.txt and input-sample.txt (empty, manually populated)
- Structure allows shared build configuration at language root level
- Each language manages its own workspace or module structure

**Rust Project Initialization**
- Create rust/Cargo.toml workspace configuration that includes all day subdirectories as workspace members
- Each rust/dayXX/ folder initialized using cargo init pattern from existing hello/rust/cargo_test structure
- Each day contains src/main.rs with boilerplate for file reading and part 1/part 2 structure
- File reading paths reference ../../challenges/dayXX/ for input files
- Use Rust 2024 edition as shown in hello project

**Gleam Project Initialization**
- Create gleam/gleam.toml at root level based on hello/gleam/hello_gleam/gleam.toml pattern
- Each gleam/dayXX/ folder follows Gleam project structure with src/ directory
- Main source file follows naming convention (e.g., day01.gleam, day02.gleam)
- Include dependencies: gleam_stdlib and gleeunit for testing
- File reading paths reference ../../challenges/dayXX/ for input files
- Use gleam/io for output operations as shown in hello project

**Roc Project Initialization**
- Each roc/dayXX/ folder contains a main Roc file (dayXX.roc)
- Use platform configuration from hello/roc/hello.roc for basic CLI operations
- Include Stdout import for output operations
- File reading paths reference ../../challenges/dayXX/ for input files
- Boilerplate includes basic file reading and part 1/part 2 function stubs

**Carbon Project Initialization**
- Each carbon/dayXX/ folder contains main Carbon file (dayXX.carbon)
- Use package structure from hello/carbon/hello.carbon (package Sample api pattern)
- Main function returns i32 as shown in existing Carbon example
- File reading paths reference ../../challenges/dayXX/ for input files
- Include comments indicating Carbon's experimental status

**Bosque Project Initialization**
- Each bosque/dayXX/ folder contains main Bosque file (dayXX.bsq)
- Use namespace structure from hello/bosque/hello.bsq (namespace Main pattern)
- Main function structure follows existing Bosque conventions
- File reading paths reference ../../challenges/dayXX/ for input files
- Include README.md in bosque/ root noting experimental language status

**Shared Input File Management**
- Create challenges/day01/ through challenges/day10/ directories
- Each challenges/dayXX/ folder contains two empty files: input.txt and input-sample.txt
- Manual population of input files is acceptable (not automated)
- All language solution files reference the same shared challenges/ directory
- Relative path from language/dayXX/src to challenges/dayXX is ../../challenges/dayXX/

**Incremental Initialization Support**
- Check for existing directories before creating new ones
- Only create missing components to avoid overwriting existing work
- Support adding new languages later without disrupting existing solutions
- Verify language-specific tooling availability before initialization
- Skip initialization if day folder already exists with content

**Placeholder File Boilerplate**
- File reading logic appropriate to each language's idioms
- Part 1 and Part 2 function stubs or sections clearly marked
- Minimal comments following self-documenting code principles
- Example input file path hard-coded to reference challenges/ directory
- Main function that calls part 1 and part 2 solutions

**Manual Initialization Checklist Format**
- Provide step-by-step manual instructions rather than automated script
- Checklist organized by language for easy execution
- Each step includes specific commands to run and expected output
- Verification steps to confirm successful initialization
- Notes on which language tooling must be installed beforehand

## Visual Design

No visual assets provided.

## Existing Code to Leverage

**hello/rust/cargo_test/Cargo.toml and src/main.rs**
- Use Rust 2024 edition as package edition
- Follow simple Cargo.toml structure with package name, version, edition, and dependencies sections
- Main.rs follows standard Rust main function pattern with println! for output

**hello/gleam/hello_gleam/gleam.toml and src/hello_gleam.gleam**
- Use gleam_stdlib >= 0.44.0 dependency
- Include gleeunit >= 1.0.0 as dev-dependency for testing
- Import gleam/io for standard I/O operations
- Main function returns Nil with pub fn main() -> Nil signature

**hello/roc/hello.roc**
- Use roc-lang/basic-cli platform version 0.17.0 for file and console operations
- Import pf.Stdout for output operations
- Main uses effects with ! syntax (Stdout.line!)

**hello/carbon/hello.carbon**
- Package declaration uses "package Sample api;" pattern
- Main function signature: fn Main() -> i32
- String variables declared with var s: String syntax
- Return 0 for successful execution

**hello/bosque/hello.bsq**
- Namespace declaration: namespace Main;
- Public main function: public function main(): String
- Simple return statement for string output

## Out of Scope
- Automated script generation for project initialization
- Automatic fetching of problem statements from Advent of Code website
- Automatic fetching or population of actual input data (requires authentication)
- Automatic extraction or population of sample input data from problem descriptions
- Creating complex utility libraries or helper functions
- Setting up IDE configurations or editor-specific files
- Configuring continuous integration or testing pipelines
- Managing language version managers (rustup, asdf, etc.)
- Installing language tooling (cargo, gleam, roc, carbon, bosque compilers)
- Creating git hooks or pre-commit configurations
