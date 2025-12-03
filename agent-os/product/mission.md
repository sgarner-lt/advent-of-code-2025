# Product Mission

## Pitch
Advent of Code 2025 Multi-Language Learning Project is a structured learning environment that helps developers master five distinct programming languages (Rust, Roc, Gleam, Carbon, and Bosque) by solving 10 days of coding challenges in parallel, providing hands-on comparison of language paradigms, performance characteristics, and problem-solving approaches.

## Users

### Primary User
- **Solo Developer (You)**: Learning and practicing with 5 different programming languages simultaneously through daily challenges

### User Persona
**Multi-Language Learner** (Experienced Developer)
- **Role:** Software developer seeking to expand language expertise
- **Context:** Committed to daily coding practice during December 2025
- **Pain Points:**
  - Difficult to gain real-world experience with multiple languages simultaneously
  - Hard to compare language paradigms and trade-offs without side-by-side implementation
  - Need structured, incremental challenges to build proficiency
  - Lack of motivation for consistent practice with experimental languages
- **Goals:**
  - Achieve functional proficiency in 5 different programming languages
  - Understand when to choose each language for specific problem types
  - Complete all 10 Advent of Code 2025 challenges successfully
  - Build a portfolio of cross-language solutions

## The Problem

### Limited Comparative Language Experience
Most developers learn languages in isolation, making it difficult to understand the fundamental differences in paradigms, performance trade-offs, and ergonomics between languages. Without structured, parallel implementation of identical problems, it's nearly impossible to develop intuition for when to use Rust's ownership model versus Gleam's actor concurrency or Roc's functional purity.

**Our Solution:** By implementing each Advent of Code challenge across 5 languages simultaneously, you gain immediate, hands-on comparison of how different paradigms approach the same problem. This creates muscle memory and intuition that theoretical study cannot provide.

### Lack of Motivation for Experimental Languages
Languages like Carbon, Bosque, and even Roc lack production ecosystems, making it hard to justify learning them without a concrete project. Developers often abandon experimental languages after initial exploration due to lack of practical application.

**Our Solution:** Advent of Code 2025 provides 10 self-contained, progressively challenging problems that don't require production infrastructure. Each challenge is small enough to be tractable in experimental languages, while complex enough to reveal their unique strengths and limitations.

## Differentiators

### Parallel Multi-Language Implementation
Unlike traditional learning approaches where you solve a problem once and move on, this project requires solving each challenge in 5 languages before proceeding. This forces deep engagement with each language's idioms and reveals subtle differences in expressiveness and performance.

### Cross-Language Validation Framework
Every solution is validated not just for correctness, but for consistency across all 5 implementations. If Rust returns answer X, all other languages must return X too. This builds confidence and catches language-specific bugs early.

### Structured Progression with Real Constraints
Advent of Code challenges increase in difficulty daily, providing natural scaffolding for learning. Early problems teach syntax and basics; later problems force you to learn each language's advanced features like concurrency, optimization, and complex data structures.

### Experimental Language Focus
While most learning projects stick to mainstream languages, this project intentionally includes Carbon (C++ successor), Bosque (verification-focused), and Roc (functional + fast compilation). This is a rare opportunity to gain hands-on experience with the future of programming languages.

## Learning Objectives

### Primary Goals
- **Language Proficiency:** Achieve functional competency in Rust, Roc, Gleam, Carbon, and Bosque
- **Paradigm Understanding:** Internalize differences between systems programming (Rust, Carbon), functional programming (Roc, Gleam), and verification-oriented programming (Bosque)
- **Problem-Solving Skills:** Complete all 10 Advent of Code 2025 challenges successfully
- **Performance Intuition:** Develop instincts for when each language excels and struggles

### Secondary Goals
- **Tooling Mastery:** Learn build tools, package managers, and testing frameworks for 5 ecosystems
- **Code Quality:** Write idiomatic code in each language, not just "get it working"
- **Documentation:** Maintain clear notes on lessons learned and language trade-offs
- **Community Engagement:** Share solutions and insights with the Advent of Code community

## Key Features

### Core Problem-Solving Features
- **Daily Challenge Solutions (Days 1-10):** Each day's puzzle solved completely in all 5 languages, with both Part 1 and Part 2 implementations
- **Multi-Language Project Structure:** Organized directory layout with language-specific subdirectories for each day, shared input files, and consistent conventions
- **Cross-Language Validation:** Automated verification that all 5 implementations produce identical answers for both sample and real puzzle inputs

### Development Infrastructure Features
- **Language-Specific Solver Agents:** Dedicated agents (rust-solver, roc-solver, gleam-solver, carbon-solver, bosque-solver) that understand each language's idioms and best practices
- **Testing Framework:** Unified testing approach that validates against sample data first, then real input, with native test frameworks for each language
- **Performance Benchmarking:** Tools to measure and compare execution time across all 5 languages for each challenge

### Learning and Analysis Features
- **Language Comparison Notes:** Documentation of how each language approached the problem differently, including code structure, readability, and ease of implementation
- **Performance Analysis:** Side-by-side comparison of runtime, memory usage, and compilation time across languages
- **Idiom Learning:** Examples of language-specific patterns and best practices discovered through solving each challenge
- **Progressive Complexity:** Problems naturally increase in difficulty from Day 1 (simple parsing) to Day 10 (more complex algorithms), providing scaffolded learning

### Workflow Coordination Features
- **Day-Specific Workflows:** Structured processes (day01.md through day10.md) that coordinate problem analysis, parallel implementation, testing, and validation
- **Problem Analysis Command:** Analyze puzzle requirements, identify algorithm needs, and plan approach before coding
- **Solution Testing Command:** Run all tests across all languages and validate answer consistency
- **Language-Agnostic Planning:** Break down problems into algorithm steps before implementation, ensuring consistent logic across languages
