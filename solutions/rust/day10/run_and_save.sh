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



OUT=./tmp/day10_run_output.txt
TS=$(date -u +"%Y%m%dT%H%M%SZ")

# Overwrite previous outputs so each run starts fresh
: > "$OUT"
: > "$SAMPLER_OUT"

echo "=== RUN ${TS} MACHINE_INDEX=${MACHINE_INDEX} PER_MACHINE_TIMEOUT_SECS=${PER_MACHINE_TIMEOUT_SECS} ===" > "$OUT"
# Run the sampler-enabled packed BIDI test so it writes progress to SAMPLER_OUT while running.
# Use single-overwrite redirection so OUT is the fresh output of this run.
cargo test run_single_machine_from_input -- --nocapture --test-threads=1 > "$OUT" 2>&1
echo "=== END ${TS} ===" >> "$OUT"
echo "Appended test output to $OUT"
