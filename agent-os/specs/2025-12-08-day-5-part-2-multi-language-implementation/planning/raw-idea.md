# Raw Idea

## Feature Description

Day 5 Part 2 — Implement Part 2 solution in all 4 languages with cross-language validation

## Context

This is part of an Advent of Code 2025 challenge project. The user is implementing solutions in 4 languages: Rust, Gleam, Carbon, and Bosque.

The Day 5 Part 2 problem is about processing ingredient ID ranges to determine how many ingredient IDs are considered "fresh". The problem statement involves:
- Reading fresh ingredient ID ranges from a database file
- Finding all unique ingredient IDs that fall within ANY of these ranges
- Counting the total number of fresh ingredient IDs

This builds on Day 5 Part 1 (which is already completed). The implementation needs to:
1. Parse input containing ingredient ID ranges (format: X-Y where X and Y are integers)
2. Generate all IDs covered by all ranges
3. Handle overlapping ranges correctly (avoid double-counting)
4. Implement the solution in all 4 languages (Rust, Gleam, Carbon, Bosque)
5. Validate that all 4 implementations produce identical results