# day10 — solver overview

Summary
- Solves the "minimal button presses" problem for a list of machines.
- Two complementary solvers:
  - Exact branch-and-bound DFS (`solve_counts_exact`) — complete search, node/time limits supported.
  - MILP via good_lp + Coin‑OR CBC (`solve_with_good_lp`) — fast in many cases; uses conservative per-variable upper bounds to help CBC.

Problem / input
- Each line: indicator pattern like `[.#..]`, several wiring schematics `(i,j,...)`, and a goal vector `{g1,g2,...}`.
- Goal: choose non-negative integer counts for each schematic so that, for every row r, the sum of counts of schematics covering r equals goal[r]; minimize total presses.

Notable implementation details
- DFS solver builds column→rows coverage, computes per-column ub (min goal over covered rows), uses greedy initial UB and a simple lower bound for pruning.
- ILP solver creates integer variables x_j with upper bounds ub_j = min(goal[r] for rows covered by schema j), equality constraints A x = goal, objective minimize sum(x_j). If ILP fails (infeasible / timeout / solver error), code falls back to DFS.

Build & prerequisites
- Rust (stable).
- Native CBC solver required for coin_cbc:
  - macOS (Homebrew):
    - brew tap coin-or-tools/coinor
    - brew install coin-or-tools/coinor/cbc
  - Debian/Ubuntu:
    - sudo apt-get install coinor-cbc
- After installing CBC:
  - cargo clean
  - cargo build -v

Run & tests
- From crate dir (solutions/rust/day10):
  - Run unit tests: cargo test -- --nocapture
  - Run long/ignored real-input test: cargo test real_input_run -- --ignored --nocapture
  - Script that sets brew paths + records output: ./run_and_save.sh (writes ./tmp/day10_run_output.txt)
- Run main for a single machine:
  - MACHINE_INDEX=3 PER_MACHINE_TIMEOUT_SECS=600 cargo run --release

Environment / tuning
- PER_MACHINE_TIMEOUT_SECS — seconds per-machine timeout (default 600).
- PER_MACHINE_NODE_LIMIT — node limit for DFS (default 200_000_000).
- MACHINE_INDEX — focus main on a single machine.
- RESULTS_OUT — append JSON results to this path.

Troubleshooting
- Linker cannot find libCbcSolver after brew install:
  - export PKG_CONFIG_PATH="$(brew --prefix)/lib/pkgconfig"
  - export LIBRARY_PATH="$(brew --prefix)/lib"
  - export DYLD_FALLBACK_LIBRARY_PATH="$(brew --prefix)/lib"
  - cargo clean && cargo build -v
- If ILP returns None for a machine, try increasing PER_MACHINE_TIMEOUT_SECS or rely on DFS fallback.
- For deeper ILP diagnostics I can add LP export + an option to shell out to the `cbc` binary with verbose logging and time limits.

Where to look
- src/main.rs — parsing, greedy, DFS, ILP glue, tests.
- run_and_save.sh / run_test.sh — helper scripts to run tests with correct env for Homebrew-installed libs.

License / notes
- Small cleanup applied to reduce warnings; remaining non-critical warnings can be fixed on request.
