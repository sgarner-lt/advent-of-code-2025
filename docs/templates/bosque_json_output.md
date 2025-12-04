# Bosque JSON Output Template

## Overview

This template provides a standard approach for outputting JSON results from Bosque Advent of Code solutions using string construction and formatting.

## Important Notes

- Bosque is experimental and under active development
- Standard library features are limited
- These templates are based on Bosque's current capabilities
- Bosque runs in a containerized environment via Podman

## Basic Template for Integer Answers

```bosque
namespace Advent;

entrypoint function solvePart1(input: String): Int {
    // Your part 1 solution here
    return 12345i;
}

entrypoint function solvePart2(input: String): Int {
    // Your part 2 solution here
    return 67890i;
}

entrypoint function main(): Int {
    // Read input (implementation depends on Bosque's I/O capabilities)
    let input = "";  // Placeholder

    let part1 = solvePart1(input);
    let part2 = solvePart2(input);

    // Construct JSON string
    let json = String::concat("{\"part1\": ",
                String::concat(Int::toString(part1),
                String::concat(", \"part2\": ",
                String::concat(Int::toString(part2), "}"))));

    _println(json);

    return 0i;
}
```

## Template with String Formatting

```bosque
namespace Advent;

entrypoint function solvePart1(input: String): Int {
    return 12345i;
}

entrypoint function solvePart2(input: String): Int {
    return 67890i;
}

entrypoint function formatJson(part1: Int, part2: Int): String {
    // Use string interpolation if available
    let json = "{\"part1\": " + Int::toString(part1) +
               ", \"part2\": " + Int::toString(part2) + "}";
    return json;
}

entrypoint function main(): Int {
    let input = "";

    let part1 = solvePart1(input);
    let part2 = solvePart2(input);

    let json = formatJson(part1, part2);
    _println(json);

    return 0i;
}
```

## Template with Null Values

```bosque
namespace Advent;

entrypoint function solvePart1(input: String): Int? {
    // Return Some for implemented
    return 12345i;
}

entrypoint function solvePart2(input: String): Int? {
    // Return none for not implemented
    return none;
}

entrypoint function formatOptional(opt: Int?): String {
    if (opt == none) {
        return "null";
    } else {
        return Int::toString(opt);
    }
}

entrypoint function main(): Int {
    let input = "";

    let part1 = solvePart1(input);
    let part2 = solvePart2(input);

    let part1Str = formatOptional(part1);
    let part2Str = formatOptional(part2);

    let json = "{\"part1\": " + part1Str +
               ", \"part2\": " + part2Str + "}";

    _println(json);

    return 0i;
}
```

## Template for String Answers

```bosque
namespace Advent;

entrypoint function solvePart1(input: String): String {
    return "ANSWER";
}

entrypoint function solvePart2(input: String): String {
    return "RESULT";
}

entrypoint function escapeJsonString(s: String): String {
    // Escape quotes and backslashes
    // Implementation depends on Bosque's string APIs
    let escaped = String::replace(s, "\\", "\\\\");
    escaped = String::replace(escaped, "\"", "\\\"");
    return escaped;
}

entrypoint function main(): Int {
    let input = "";

    let part1 = solvePart1(input);
    let part2 = solvePart2(input);

    // Wrap strings in quotes
    let json = "{\"part1\": \"" + escapeJsonString(part1) +
               "\", \"part2\": \"" + escapeJsonString(part2) + "\"}";

    _println(json);

    return 0i;
}
```

## Template with Result Type

```bosque
namespace Advent;

entrypoint function solvePart1(input: String): Result<Int, String> {
    // Return Ok for success, Err for not implemented
    return ok(12345i);
}

entrypoint function solvePart2(input: String): Result<Int, String> {
    // Not yet implemented
    return err("Not implemented");
}

entrypoint function formatResult(result: Result<Int, String>): String {
    if (Result::isOk(result)) {
        return Int::toString(Result::unwrap(result));
    } else {
        return "null";
    }
}

entrypoint function main(): Int {
    let input = "";

    let part1 = solvePart1(input);
    let part2 = solvePart2(input);

    let part1Str = formatResult(part1);
    let part2Str = formatResult(part2);

    let json = "{\"part1\": " + part1Str +
               ", \"part2\": " + part2Str + "}";

    _println(json);

    return 0i;
}
```

## Running the Solution

Bosque runs in a containerized environment using the wrapper script:

```bash
# Run via wrapper script
cd solutions/bosque/dayXX
${HOME}/.local/bin/bosque run solution.bsq < ../../../challenges/dayXX/input.txt
```

Or using the project's Bosque wrapper:

```bash
./scripts/bosque-wrapper.sh run solutions/bosque/dayXX/solution.bsq challenges/dayXX/input.txt
```

Expected output:
```json
{"part1": 12345, "part2": 67890}
```

## Testing

```bash
# Run unit tests (if supported)
${HOME}/.local/bin/bosque test solution.bsq

# Test with sample input
${HOME}/.local/bin/bosque run solution.bsq < ../../challenges/dayXX/input-sample.txt
```

## Current Limitations

As of Bosque's experimental status:

1. **File I/O**: Bosque's file reading capabilities are limited. Input is typically read from stdin or hardcoded.

2. **String Operations**: String manipulation APIs may be limited. Manual concatenation may be necessary.

3. **JSON Libraries**: Bosque does not have a JSON library. Manual string construction is required.

4. **Container Environment**: Bosque runs via Podman container, which adds complexity to file access.

## Workarounds

1. **Use stdin for input**: Redirect input files when running
   ```bash
   bosque run solution.bsq < input.txt
   ```

2. **Simple string concatenation**: Build JSON strings manually without libraries

3. **Wrapper script**: Use the project's `bosque-wrapper.sh` for consistent execution

4. **Test with small inputs**: Hardcode test cases initially, then adapt for file input

## Container Considerations

When running in Podman container:
- File paths are mapped from host to container
- Stdout/stderr are properly captured
- Resource limits may apply
- Ensure wrapper script handles file mounting correctly

## Notes

- Bosque emphasizes correctness and formal verification
- Type system is strict - use appropriate type annotations
- Use `_println` for output to stdout
- Return proper status codes (0 for success)
- Container adds latency - expect slower execution than native
- Check Bosque documentation for latest language features

## References

- Bosque Language Repository: https://github.com/microsoft/BosqueLanguage
- Podman Documentation: https://podman.io/
- Project Bosque Wrapper: `scripts/bosque-wrapper.sh`
