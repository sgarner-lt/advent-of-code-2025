#!/usr/bin/env python3
"""
Cross-language validation for Day 4 Part 1

This script validates that all four language implementations
(Rust, Gleam, Carbon, Bosque) produce identical results.
"""

import json
import subprocess
import sys
from pathlib import Path


def run_rust_solution(input_file):
    """Run Rust solution"""
    rust_binary = "solutions/rust/target/release/day04"
    with open(input_file, 'r') as f:
        result = subprocess.run(
            [rust_binary],
            stdin=f,
            capture_output=True,
            text=True
        )
    if result.returncode != 0:
        print(f"Rust error: {result.stderr}", file=sys.stderr)
        return None
    return json.loads(result.stdout)


def run_gleam_solution(input_file):
    """Run Gleam solution"""
    # Gleam reads from file, not stdin, so we need to temporarily set the path
    # For now, we'll use the actual input file
    result = subprocess.run(
        ["gleam", "run", "-m", "day04"],
        cwd="solutions/gleam",
        capture_output=True,
        text=True
    )
    if result.returncode != 0:
        print(f"Gleam error: {result.stderr}", file=sys.stderr)
        return None
    return json.loads(result.stdout)


def run_carbon_solution(input_file):
    """Run Carbon solution (Python wrapper)"""
    with open(input_file, 'r') as f:
        result = subprocess.run(
            ["python3", "solutions/carbon/day04/runner.py"],
            stdin=f,
            capture_output=True,
            text=True
        )
    if result.returncode != 0:
        print(f"Carbon error: {result.stderr}", file=sys.stderr)
        return None
    return json.loads(result.stdout)


def run_bosque_solution(input_file):
    """Run Bosque solution (Python wrapper)"""
    with open(input_file, 'r') as f:
        result = subprocess.run(
            ["python3", "solutions/bosque/day04/runner.py"],
            stdin=f,
            capture_output=True,
            text=True
        )
    if result.returncode != 0:
        print(f"Bosque error: {result.stderr}", file=sys.stderr)
        return None
    return json.loads(result.stdout)


def compare_results(results):
    """Compare results from all implementations"""
    if not all(results.values()):
        print("ERROR: Not all implementations returned results")
        return False

    # Compare part1 counts
    counts = {lang: result.get('part1') for lang, result in results.items()}
    if len(set(counts.values())) != 1:
        print("ERROR: Part1 counts differ across implementations:")
        for lang, count in counts.items():
            print(f"  {lang}: {count}")
        return False

    # Compare grid visualizations
    grids = {lang: result.get('additional-info', {}).get('grid') for lang, result in results.items()}
    if len(set(grids.values())) != 1:
        print("ERROR: Grid visualizations differ across implementations")
        for lang, grid in grids.items():
            print(f"  {lang}: {grid[:50]}...")
        return False

    print(f"SUCCESS: All implementations agree on count = {counts['rust']}")
    return True


def validate_sample_input():
    """Validate against sample input (expected: 13)"""
    input_file = "challenges/day04/input-sample.txt"

    print("Running cross-language validation for Day 4 Part 1...")
    print(f"Input: {input_file}")
    print()

    results = {}

    print("Running Rust implementation...")
    results['rust'] = run_rust_solution(input_file)

    print("Running Gleam implementation...")
    results['gleam'] = run_gleam_solution(input_file)

    print("Running Carbon implementation...")
    results['carbon'] = run_carbon_solution(input_file)

    print("Running Bosque implementation...")
    results['bosque'] = run_bosque_solution(input_file)

    print()
    print("Comparing results...")

    if compare_results(results):
        # Verify sample expected output
        expected_count = 13
        actual_count = results['rust']['part1']
        if actual_count == expected_count:
            print(f"PASS: Sample input validation successful (count = {expected_count})")
            return True
        else:
            print(f"FAIL: Expected count {expected_count}, got {actual_count}")
            return False

    return False


def main():
    """Main entry point"""
    success = validate_sample_input()
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
