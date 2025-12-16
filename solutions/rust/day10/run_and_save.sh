#!/bin/bash
# ...existing environment conventions...
export RUST_TEST_THREADS=${RUST_TEST_THREADS:-1}
# default to a longer timeout so solver can finish; set QUICK=1 to force a short run (30s)
if [ "${QUICK:-0}" = "1" ]; then
  export PER_MACHINE_TIMEOUT_SECS=${PER_MACHINE_TIMEOUT_SECS:-30}
else
  export PER_MACHINE_TIMEOUT_SECS=${PER_MACHINE_TIMEOUT_SECS:-600}
fi
export DAY10_INPUT=${DAY10_INPUT:-../../../challenges/day10/input.txt}
export MACHINE_INDEX=${MACHINE_INDEX:-1}
export SAMPLER_OUT=${SAMPLER_OUT:-./tmp/day10_sampler.txt}
export SAMPLER_INTERVAL_SECS=${SAMPLER_INTERVAL_SECS:-2}

# ensure script runs with working dir = this script's directory (day10)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pushd "$SCRIPT_DIR" >/dev/null || exit 1

# ensure Homebrew lib paths are on search path so native link succeeds
BREW_PREFIX="$(brew --prefix 2>/dev/null || echo /usr/local)"
export PATH="$BREW_PREFIX/bin:$PATH"
export PKG_CONFIG_PATH="$BREW_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"
export LIBRARY_PATH="$BREW_PREFIX/lib:$LIBRARY_PATH"
export DYLD_FALLBACK_LIBRARY_PATH="$BREW_PREFIX/lib:$DYLD_FALLBACK_LIBRARY_PATH"

OUT=./tmp/day10_run_output.txt
TS=$(date -u +"%Y%m%dT%H%M%SZ")

# Overwrite previous outputs so each run starts fresh
: > "$OUT"
: > "$SAMPLER_OUT"

echo "=== RUN ${TS} MACHINE_INDEX=${MACHINE_INDEX} PER_MACHINE_TIMEOUT_SECS=${PER_MACHINE_TIMEOUT_SECS} ===" > "$OUT"

# 1) Build + run tests for the day10 crate only (now running from day10 folder)
echo "=== Building and running tests for day10 only ===" >> "$OUT"
cargo test -- --nocapture >> "$OUT" 2>&1 || echo "Some day10 tests failed (see output above)." >> "$OUT"

# 2) Run focused single-machine test for day10
echo "=== Running focused single-machine test (run_single_machine_from_input) ===" >> "$OUT"
cargo test run_single_machine_from_input -- --nocapture --test-threads=1 >> "$OUT" 2>&1 || echo "Focused test failed or was filtered; see output above." >> "$OUT"

echo "=== END ${TS} ===" >> "$OUT"
echo "Appended test output to $OUT"

# return to original dir
popd >/dev/null || true
