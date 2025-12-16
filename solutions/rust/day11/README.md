**Overview**

- **Goal**: Count directed paths from `svr` to `out` that visit both `dac` and `fft`.

**Approach**
- **Parse Input**: Read the input lines and build an index-based directed graph so node names are stored once and adjacency lists contain numeric indices. See [src/main.rs](src/main.rs) for the parser.
- **Include outputs-only nodes**: The parser ensures nodes that only appear as outputs (e.g. `out`) are included in the index map before building edges.
- **SCC check**: The code contains a small Tarjan-based analyzer used from the unit tests to check for strongly connected components. The real input is a DAG (all SCC sizes = 1), so counting paths with memoization over (node, flags) is correct.
- **Counting with flags**: Use memoized dynamic programming over state `(node, flags)` where `flags` is a 2-bit mask: bit0 = saw `dac`, bit1 = saw `fft`. This avoids enumerating all paths and runs quickly on DAGs.
- **Breakdown**: There's also a vectorized DP that returns counts for each final flag state (none / dac-only / fft-only / both) using `u128` to avoid overflow on large but finite path counts.

**Result (Part 2)**
- **Paths visiting both `dac` and `fft`**: 525,518,050,323,600
- **Breakdown (real input)**: none = 291,072,456,594,314,801; dac_only = 6,525,470,900,765,405; fft_only = 23,440,895,524,652,592; both = 525,518,050,323,600

**Files**
- **Code**: Main implementation is in [src/main.rs](src/main.rs).
- **Tests**: Unit tests (including SCC analysis and the memoized breakdown test) are embedded in the test module inside [src/main.rs](src/main.rs).

**Run / Test**
- **Run the program (release)**: `cargo run --release -- r`  — prints Part 2 using the memoized DP.
- **Run sample**: `cargo run --release -- s`  — runs with the sample input.
- **Run tests**: `cargo test`  — runs unit tests (SCC analysis, sample checks, breakdown printouts).

**Notes & Next Steps**
- **Correctness**: Because the real input is a DAG, memoization over `(node, flags)` is exact and not affected by cycles.
- **Scalability**: The algorithm runs in O(N * 4 + E * 4) time for states where N is node count and E is edge count (constant factor 4 for the flag states). For larger inputs where path counts exceed `u128`, switch the vectorized counter to `num::BigUint`.
- **If you want**: I can (a) add a `--breakdown` CLI flag to print the four counts from `main`, (b) switch counts to BigUint, or (c) produce a CSV report file.

If you want any of those follow-ups, tell me which and I'll add it.
