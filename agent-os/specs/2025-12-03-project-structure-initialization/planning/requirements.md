# Spec Requirements: Project Structure Initialization

## Initial Description
Create standardized directory structure with dayXX/ folders containing language-specific subdirectories (rust/, roc/, gleam/, carbon/, bosque/) and shared input files.

## Requirements Discussion

### First Round Questions

**Q1:** I assume you want directories pre-created for all 10 days (day01/ through day10/) up front rather than creating them as each day's challenge is released. Is that correct?
**Answer:** Yes, pre-create all 10 day folders up front.

**Q2:** For the input files, I'm thinking these should be stored in a shared location since they're the same across all language implementations. Should we place them at the root of each dayXX/ folder (e.g., day01/input.txt, day01/input-sample.txt) or in a dedicated subdirectory like day01/inputs/?
**Answer:** Place input files at the root of each dayXX/ folder (e.g., day01/input.txt, day01/input-sample.txt).

**Q3:** I assume you want placeholder or template files created in each language subdirectory (like rust/day01/main.rs, gleam/day01/src/main.gleam) so you can immediately start coding. Should these contain basic boilerplate code (like reading input files, basic structure) or just be empty starter files?
**Answer:** Create placeholder files with minimal boilerplate - mainly file reading logic and structure for part 1 and part 2 solutions.

**Q4:** Regarding the directory organization, which structure makes more sense for your workflow:
   - Option A: day01/rust/, day01/gleam/, day01/roc/, etc. (day folders first, then languages)
   - Option B: rust/day01/, rust/day02/, gleam/day01/, gleam/day02/, etc. (language folders first, then days)

Option A keeps all solutions for a single day together. Option B keeps all solutions for a single language together, which might be better if you're working through multiple days in the same language consecutively.
**Answer:** Initial lean towards Option A (day folders first) for easier day-by-day comparison.

**Q5:** Should the script handle language-specific project initialization (like running cargo init for Rust, gleam new for Gleam) or just create the directory structure and placeholder files?
**Answer:** Yes, run language-specific initialization commands (cargo init, gleam new, etc.) to set up proper project structure with build files.

**Q6:** For the sample input files (input-sample.txt), should the script just create empty files, or should it attempt to fetch the actual sample data from the Advent of Code website (which would require authentication)?
**Answer:** Create empty files for now. Manual population is acceptable since samples need to be extracted from problem descriptions anyway.

**Q7:** Should this be a one-time initialization script, or should it support incremental usage (e.g., only creating structure for days that don't exist yet, allowing you to add new languages later)?
**Answer:** Support incremental usage - check for existing structure and only create missing components. Allow adding new languages later without disrupting existing work.

**Q8:** Are there any languages you definitely won't be attempting, or any other directories/files that should NOT be created as part of this initialization?
**Answer:** All five languages should be included (rust, roc, gleam, carbon, bosque). No exclusions at this time.

**Existing Code Reuse:**
Are there existing features in your codebase with similar patterns we should reference?
**Answer:** No similar existing features identified. This is a new project.

### Follow-up Questions

**Follow-up 1:** Regarding the directory structure (Question 4), I want to clarify an important technical consideration:

If we go with **Option A** (day01/rust/, day01/gleam/, etc.), each language's build system would need to be initialized per day. For example:
- day01/rust/ would have its own Cargo.toml
- day02/rust/ would have its own Cargo.toml
- This means 10 separate Rust projects (and 10 separate projects for each language)

If we go with **Option B** (rust/day01/, rust/day02/, etc.), you could have:
- A single rust/Cargo.toml at the root that manages all days as a workspace or modules
- Similarly for other languages
- Shared dependencies pulled once per language, not once per day

Given that Advent of Code solutions often reuse utility functions and dependencies across days, **Option B** might be more practical. Would you like to reconsider, or do you still prefer Option A for the comparison benefits?

**Answer:** Option B (language folders first) because project setup files for builds are typically language-specific. For example, you can pull dependencies in for all days in the rust/ folder contents. This allows shared build configuration (like Cargo.toml, gleam.toml) at the language root level that applies to all day subdirectories.

**Final Structure:**
```
/rust/
  /day01/
  /day02/
  ...
  /day10/
/gleam/
  /day01/
  /day02/
  ...
/roc/
  ...
/carbon/
  ...
/bosque/
  ...
/challenges/
  (for problem statements and input data files)
```

### Existing Code to Reference

No similar existing features identified for reference. This is a new project.

## Visual Assets

### Files Provided:
No visual assets provided.

## Requirements Summary

### Functional Requirements
- Create directory structure with language folders first (rust/, gleam/, roc/, carbon/, bosque/)
- Each language folder contains day01/ through day10/ subdirectories
- Create a separate /challenges/ directory for problem statements and input data files
- Pre-create all 10 day folders up front
- Place input files (input.txt, input-sample.txt) in /challenges/dayXX/ folders
- Create placeholder files in each language/day directory with minimal boilerplate code
  - Include file reading logic
  - Include structure for part 1 and part 2 solutions
- Run language-specific initialization commands (cargo init for Rust, gleam new for Gleam, etc.)
- Set up shared build configuration at language root level (Cargo.toml, gleam.toml, etc.)
- Support incremental usage: check for existing structure and only create missing components
- Allow adding new languages later without disrupting existing work
- Create empty input-sample.txt files (manual population acceptable)

### Reusability Opportunities
No existing code patterns identified for reuse. This is a greenfield project initialization.

### Scope Boundaries

**In Scope:**
- Creating standardized directory structure (language-first hierarchy)
- Pre-creating all 10 day folders
- Creating /challenges/ directory for shared input files
- Initializing language-specific project structures (cargo init, gleam new, etc.)
- Creating placeholder solution files with minimal boilerplate
- Setting up shared build configurations at language root level
- Supporting incremental initialization (checking for existing structure)
- Creating empty input and sample input files in /challenges/dayXX/

**Out of Scope:**
- Automatically fetching problem statements from Advent of Code website
- Automatically fetching or populating actual input data (requires authentication)
- Automatically fetching or populating sample input data from problem descriptions
- Creating complex boilerplate beyond basic file reading and part 1/2 structure
- Managing dependencies beyond language-specific defaults
- Creating utility function libraries (can be added manually as needed)

### Technical Considerations
- Language-specific initialization tools must be available in the environment
  - cargo for Rust
  - gleam CLI for Gleam
  - roc CLI for Roc
  - Appropriate tools for Carbon and Bosque
- Build configuration files (Cargo.toml, gleam.toml, etc.) should be set up at language root to manage all day subdirectories
- Script should be idempotent - safe to run multiple times without breaking existing work
- Must check for existing directories/files before creating to support incremental usage
- Consider workspace or module structure for languages that support it (e.g., Rust workspaces)
- Placeholder files should use language-appropriate naming conventions (main.rs, main.gleam, etc.)
- Input file paths in placeholder code should reference ../challenges/dayXX/ structure
