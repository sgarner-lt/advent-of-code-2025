#!/bin/bash

# Ensure we run from the day10 directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pushd "$SCRIPT_DIR" >/dev/null || exit 1

# Ensure we pick up Homebrew libraries so coin_cbc/linker finds libCbcSolver
BREW_PREFIX="$(brew --prefix 2>/dev/null || echo /usr/local)"
export PATH="$BREW_PREFIX/bin:$PATH"
export PKG_CONFIG_PATH="$BREW_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"
export LIBRARY_PATH="$BREW_PREFIX/lib:$LIBRARY_PATH"
export DYLD_FALLBACK_LIBRARY_PATH="$BREW_PREFIX/lib:$DYLD_FALLBACK_LIBRARY_PATH"

# quick preflight for CBC native lib to avoid long linker error runs
if ! command -v cbc >/dev/null 2>&1 ; then
  echo "ERROR: 'cbc' not found in PATH. Install the Coin-OR CBC solver (Homebrew: brew tap coin-or-tools/coinor && brew install coin-or-tools/coinor/cbc) or ensure system library is available."
  popd >/dev/null || true
  exit 1
fi

export RUST_TEST_THREADS=1
export PER_MACHINE_TIMEOUT_SECS=600
export SAMPLER_OUT=/tmp/day10_sample.txt
export DAY10_INPUT=../../../challenges/day10/input.txt
export MACHINE_INDEX=1

# Run the greedy test that targets machine index 1
cargo test run_second_machine_greedy -- --nocapture --test-threads=1

# return to original dir
popd >/dev/null || true