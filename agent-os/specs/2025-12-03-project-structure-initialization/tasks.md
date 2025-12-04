# Task Breakdown: Project Structure Initialization

## Overview
Total Task Groups: 7
Feature Size: XS (Manual checklist creation, not automation)
Total Days: 10 (Advent of Code 2025 is a special 10-day event)

## Task List

### Documentation & Planning

#### Task Group 1: Manual Checklist Creation
**Dependencies:** None

- [x] 1.0 Create comprehensive manual initialization checklist
  - [x] 1.1 Document directory structure overview
    - List complete tree structure showing all 5 languages
    - Show all 10 day subdirectories per language (day01/ through day10/)
    - Document shared challenges/ directory structure
    - Include visual tree diagram for reference
  - [x] 1.2 Document prerequisite requirements
    - List all required language tooling (cargo, gleam, roc, carbon, bosque)
    - Specify minimum versions where applicable
    - Include installation verification commands
    - Note that this is for Advent of Code 2025 (10 days, not 25)
  - [x] 1.3 Create language-agnostic setup steps
    - Step-by-step directory creation commands
    - Commands for creating challenges/ directory structure
    - Commands for creating empty input.txt and input-sample.txt files
    - Verification steps to confirm directory structure
  - [x] 1.4 Create language-specific initialization sections
    - Separate section for each language (Rust, Gleam, Roc, Carbon, Bosque)
    - Step-by-step commands for each language
    - Expected output for verification
    - Troubleshooting notes for common issues

**Acceptance Criteria:**
- Complete manual checklist document exists
- Prerequisites clearly documented
- Structure supports incremental execution
- Each step is actionable and verifiable

### Rust Initialization

#### Task Group 2: Rust Project Setup Documentation
**Dependencies:** Task Group 1

- [x] 2.0 Document Rust manual initialization steps
  - [x] 2.1 Create rust/ root directory setup instructions
    - Command to create rust/ directory
    - Instructions for creating workspace Cargo.toml
    - Workspace configuration including all 10 days as members
    - Use Rust 2024 edition as specified
  - [x] 2.2 Document day subdirectory creation (day01/ through day10/)
    - cargo init command for each day directory
    - Expected directory structure after initialization
    - Verification command (cargo check in each day)
  - [x] 2.3 Create boilerplate template for src/main.rs
    - File reading logic using std::fs
    - Part 1 function stub with clear comments
    - Part 2 function stub with clear comments
    - Main function that calls both parts
    - File path examples: "../../challenges/dayXX/input.txt"
  - [x] 2.4 Document Cargo.toml configuration per day
    - Package name pattern (e.g., "day01", "day02")
    - Version: "0.1.0"
    - Edition: "2024"
    - Empty dependencies section for future additions
  - [x] 2.5 Create verification steps
    - Command to build all Rust projects
    - Expected success output
    - How to test file reading with sample input

**Acceptance Criteria:**
- Clear step-by-step Rust initialization instructions
- Boilerplate template provided for copy-paste
- Workspace configuration documented
- All 10 days covered (day01 through day10)
- Verification steps included

### Gleam Initialization

#### Task Group 3: Gleam Project Setup Documentation
**Dependencies:** Task Group 1

- [x] 3.0 Document Gleam manual initialization steps
  - [x] 3.1 Create gleam/ root directory setup instructions
    - Command to create gleam/ directory
    - Instructions for creating root gleam.toml
    - Dependencies: gleam_stdlib >= 0.44.0
    - Dev dependencies: gleeunit >= 1.0.0
  - [x] 3.2 Document day subdirectory creation (day01/ through day10/)
    - gleam new command pattern for each day
    - Expected directory structure (src/ subdirectory)
    - File naming convention (day01.gleam, day02.gleam, etc.)
  - [x] 3.3 Create boilerplate template for dayXX.gleam
    - Import gleam/io for output
    - File reading logic appropriate to Gleam
    - Part 1 function stub (pub fn part1() -> Result)
    - Part 2 function stub (pub fn part2() -> Result)
    - Main function signature: pub fn main() -> Nil
    - File path examples: "../../challenges/dayXX/input.txt"
  - [x] 3.4 Document gleam.toml configuration
    - Project name pattern
    - Version configuration
    - Dependency specifications
    - Reference hello/gleam/hello_gleam/gleam.toml pattern
  - [x] 3.5 Create verification steps
    - Command to build all Gleam projects
    - gleam run command for testing
    - Expected success output

**Acceptance Criteria:**
- Clear step-by-step Gleam initialization instructions
- Boilerplate template provided for copy-paste
- All 10 days covered (day01 through day10)
- Dependencies properly documented
- Verification steps included

### Roc Initialization

#### Task Group 4: Roc Project Setup Documentation
**Dependencies:** Task Group 1

- [x] 4.0 Document Roc manual initialization steps
  - [x] 4.1 Create roc/ root directory setup instructions
    - Command to create roc/ directory
    - Note about project structure (no workspace concept like Rust)
  - [x] 4.2 Document day subdirectory creation (day01/ through day10/)
    - Manual directory creation commands
    - File naming convention (day01.roc, day02.roc, etc.)
  - [x] 4.3 Create boilerplate template for dayXX.roc
    - Platform declaration: roc-lang/basic-cli version 0.17.0
    - Import pf.Stdout for output operations
    - File reading logic using Roc idioms
    - Part 1 function stub
    - Part 2 function stub
    - Main function with effects (! syntax)
    - File path examples: "../../challenges/dayXX/input.txt"
    - Reference hello/roc/hello.roc pattern
  - [x] 4.4 Create verification steps
    - roc run command for each day
    - Expected success output
    - How to verify file reading functionality

**Acceptance Criteria:**
- Clear step-by-step Roc initialization instructions
- Boilerplate template provided for copy-paste
- All 10 days covered (day01 through day10)
- Platform configuration documented
- Verification steps included

### Carbon Initialization

#### Task Group 5: Carbon Project Setup Documentation
**Dependencies:** Task Group 1

- [ ] 5.0 Document Carbon manual initialization steps
  - [ ] 5.1 Create carbon/ root directory setup instructions
    - Command to create carbon/ directory
    - Note about Carbon's experimental status
    - Warning about potential tooling limitations
  - [ ] 5.2 Document day subdirectory creation (day01/ through day10/)
    - Manual directory creation commands
    - File naming convention (day01.carbon, day02.carbon, etc.)
  - [ ] 5.3 Create boilerplate template for dayXX.carbon
    - Package declaration: "package Sample api;"
    - Main function signature: fn Main() -> i32
    - File reading logic (if available in Carbon)
    - Part 1 function stub
    - Part 2 function stub
    - Return 0 for success
    - File path examples: "../../challenges/dayXX/input.txt"
    - Include comment about experimental language status
    - Reference hello/carbon/hello.carbon pattern
  - [ ] 5.4 Create verification steps
    - Carbon compiler commands (if available)
    - Expected behavior
    - Fallback plan if tooling is limited

**Acceptance Criteria:**
- Clear step-by-step Carbon initialization instructions
- Boilerplate template provided for copy-paste
- All 10 days covered (day01 through day10)
- Experimental status clearly noted
- Verification steps (or alternatives) included

### Bosque Initialization

#### Task Group 6: Bosque Project Setup Documentation
**Dependencies:** Task Group 1

- [ ] 6.0 Document Bosque manual initialization steps
  - [ ] 6.1 Create bosque/ root directory setup instructions
    - Command to create bosque/ directory
    - Create README.md noting experimental language status
    - Note about Bosque tooling availability
  - [ ] 6.2 Document day subdirectory creation (day01/ through day10/)
    - Manual directory creation commands
    - File naming convention (day01.bsq, day02.bsq, etc.)
  - [ ] 6.3 Create boilerplate template for dayXX.bsq
    - Namespace declaration: namespace Main;
    - Public main function: public function main(): String
    - File reading logic (if available in Bosque)
    - Part 1 function stub
    - Part 2 function stub
    - Return statement for output
    - File path examples: "../../challenges/dayXX/input.txt"
    - Reference hello/bosque/hello.bsq pattern
  - [ ] 6.4 Create verification steps
    - Bosque compiler/interpreter commands (if available)
    - Expected behavior
    - Fallback plan if tooling is limited

**Acceptance Criteria:**
- Clear step-by-step Bosque initialization instructions
- Boilerplate template provided for copy-paste
- All 10 days covered (day01 through day10)
- Experimental status clearly noted in README
- Verification steps (or alternatives) included

### Shared Resources

#### Task Group 7: Challenges Directory Setup Documentation
**Dependencies:** Task Group 1

- [ ] 7.0 Document challenges/ directory manual setup
  - [ ] 7.1 Create challenges/ root directory instructions
    - Command to create challenges/ directory at repository root
    - Purpose explanation (shared input files across languages)
  - [ ] 7.2 Document day subdirectory creation (day01/ through day10/)
    - Commands to create challenges/day01/ through challenges/day10/
    - Explain structure for easy navigation
  - [ ] 7.3 Create empty input file setup instructions
    - Command to create empty input.txt in each day folder
    - Command to create empty input-sample.txt in each day folder
    - touch command examples for Unix/Linux/Mac
    - Windows equivalent commands
  - [ ] 7.4 Document manual population workflow
    - How to obtain actual input (Advent of Code website login)
    - How to extract sample input from problem descriptions
    - File format expectations (plain text)
    - Note that automation is out of scope
  - [ ] 7.5 Create verification steps
    - Command to list all challenges/dayXX/ directories
    - Command to verify both files exist in each directory
    - Expected directory tree output

**Acceptance Criteria:**
- Clear step-by-step challenges/ directory instructions
- All 10 days covered (day01 through day10)
- Both input.txt and input-sample.txt documented
- Manual population workflow explained
- Verification steps included

## Execution Order

Recommended documentation creation sequence:
1. Documentation & Planning (Task Group 1) - Creates master checklist framework
2. Rust Initialization (Task Group 2) - Most familiar language, good starting point
3. Gleam Initialization (Task Group 3) - Established tooling
4. Roc Initialization (Task Group 4) - Established tooling
5. Carbon Initialization (Task Group 5) - Experimental, may need workarounds
6. Bosque Initialization (Task Group 6) - Experimental, may need workarounds
7. Shared Resources (Task Group 7) - Common across all languages

## Important Notes

- **This is NOT automation**: Create manual checklists, not scripts
- **10 days only**: Advent of Code 2025 is a special 10-day event (not 25 days)
- **Language-first structure**: rust/day01/, not day01/rust/
- **Shared challenges/**: Input files shared across all language implementations
- **Incremental support**: Checklist should support checking for existing structure
- **Experimental languages**: Carbon and Bosque may have limited tooling
- **Reference existing patterns**: Use hello/ directory examples as templates
- **Self-documenting**: Minimal comments, focus on clear code structure
- **File paths**: All solution files reference ../../challenges/dayXX/ for inputs
- **Verification critical**: Each task group includes verification steps
