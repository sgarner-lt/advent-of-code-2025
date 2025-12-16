#!/bin/bash

export RUST_TEST_THREADS=1
export PER_MACHINE_TIMEOUT_SECS=600
export SAMPLER_OUT=/tmp/day10_sample.txt
export DAY10_INPUT=../../../challenges/day10/input.txt
export MACHINE_INDEX=1

# Run the greedy test that targets machine index 1
cargo test run_second_machine_greedy -- --nocapture --test-threads=1