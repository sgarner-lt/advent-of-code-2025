# Runner Scripts - Critical Documentation

## CRITICAL: Always Use Runner Scripts

**DO NOT** run languages directly (e.g., `cargo run`, `gleam run`, `roc run`). Languages are NOT guaranteed to be on the system PATH.

**ALWAYS** use the standardized runner scripts in `scripts/runners/`:

```bash
./scripts/runners/run_rust.sh <day> <input_path> [--unit-test]
./scripts/runners/run_gleam.sh <day> <input_path> [--unit-test]
./scripts/runners/run_roc.sh <day> <input_path> [--unit-test]
./scripts/runners/run_carbon.sh <day> <input_path> [--unit-test]
./scripts/runners/run_bosque.sh <day> <input_path> [--unit-test]
```

## Why Runner Scripts Are Required

1. **Languages may not be on PATH** - Roc, Carbon, Bosque require specific installation locations
2. **Consistent interface** - All scripts use the same command-line API
3. **Error handling** - Scripts provide proper JSON output even on errors
4. **Directory navigation** - Scripts handle language-specific project structures
5. **Timeout support** - Built-in timeout handling for long-running tests

## Examples

### Run integration tests
```bash
./scripts/runners/run_rust.sh 1 challenges/day01/input.txt
./scripts/runners/run_gleam.sh 1 challenges/day01/input-sample.txt
./scripts/runners/run_roc.sh 1 challenges/day01/input.txt
```

### Run unit tests only
```bash
./scripts/runners/run_rust.sh 1 /dev/null --unit-test
./scripts/runners/run_gleam.sh 1 /dev/null --unit-test
./scripts/runners/run_roc.sh 1 /dev/null --unit-test
```

## For Implementers

When implementing features:
- ✅ Use runner scripts for all testing and validation
- ❌ Do NOT use direct commands like `cargo run`, `gleam run`
- ✅ Document using runner script syntax in implementation notes
- ✅ Verify scripts work from project root directory

## Troubleshooting

If a runner script fails:
1. Check the language is installed: `which cargo`, `which gleam`, etc.
2. Verify the script is executable: `chmod +x scripts/runners/run_*.sh`
3. Check the error output - scripts provide detailed error messages
4. For Roc: Verify `~/.local/bin/roc` exists
5. For Carbon: Verify Podman/Docker is running and `carbon-aoc:day1` image exists: `podman images | grep carbon-aoc`
6. For Bosque: Verify Podman is running: `podman machine info`
