# Carbon JSON Output Template

## Overview

This template provides a standard approach for outputting JSON results from Carbon Advent of Code solutions. Note that Carbon is experimental and its standard library is still in development.

## Important Notes

- Carbon is in experimental preview and APIs may change
- Standard library features are limited
- File I/O and string formatting capabilities are evolving
- These templates are based on Carbon's current capabilities and may need updates

## Basic Template for Integer Answers

```carbon
package Advent api;

import Core;

fn SolvePart1(input: String) -> i64 {
    // Your part 1 solution here
    return 12345;
}

fn SolvePart2(input: String) -> i64 {
    // Your part 2 solution here
    return 67890;
}

fn Main() -> i32 {
    var input: String = "";
    // Read input file (implementation depends on Carbon's I/O APIs)
    // This is a placeholder - adjust based on Carbon's actual file APIs

    var part1: i64 = SolvePart1(input);
    var part2: i64 = SolvePart2(input);

    // Output JSON to stdout
    Core.Print("{\"part1\": {0}, \"part2\": {1}}", part1, part2);

    return 0;
}
```

## Template with Null Values

```carbon
package Advent api;

import Core;

fn SolvePart1(input: String) -> i64 {
    return 12345;
}

fn Main() -> i32 {
    var input: String = "";

    var part1: i64 = SolvePart1(input);

    // Part 2 not yet implemented - output null
    Core.Print("{\"part1\": {0}, \"part2\": null}", part1);

    return 0;
}
```

## Template for String Answers

```carbon
package Advent api;

import Core;

fn SolvePart1(input: String) -> String {
    // Your part 1 solution here
    return "ANSWER";
}

fn SolvePart2(input: String) -> String {
    // Your part 2 solution here
    return "RESULT";
}

fn EscapeJsonString(s: String) -> String {
    // Escape quotes and backslashes for JSON
    // Implementation depends on Carbon's string APIs
    // This is a placeholder
    return s;
}

fn Main() -> i32 {
    var input: String = "";

    var part1: String = SolvePart1(input);
    var part2: String = SolvePart2(input);

    // For string answers, wrap in quotes
    Core.Print("{\"part1\": \"{0}\", \"part2\": \"{1}\"}", part1, part2);

    return 0;
}
```

## Template with Optional Type (If Available)

```carbon
package Advent api;

import Core;
import Option;  // If Carbon has an Optional type

fn SolvePart1(input: String) -> Option.Option(i64) {
    return Option.Some(12345);
}

fn SolvePart2(input: String) -> Option.Option(i64) {
    // Not yet implemented
    return Option.None();
}

fn FormatOptional(opt: Option.Option(i64)) -> String {
    if (opt.IsSome()) {
        return Core.Format("{0}", opt.Unwrap());
    } else {
        return "null";
    }
}

fn Main() -> i32 {
    var input: String = "";

    var part1: Option.Option(i64) = SolvePart1(input);
    var part2: Option.Option(i64) = SolvePart2(input);

    var part1Str: String = FormatOptional(part1);
    var part2Str: String = FormatOptional(part2);

    Core.Print("{\"part1\": {0}, \"part2\": {1}}", part1Str, part2Str);

    return 0;
}
```

## Building and Running

```bash
# Build with Bazel
cd carbon/dayXX
bazel build //:main

# Run the binary (path may vary)
bazel run //:main -- ../../challenges/dayXX/input.txt
```

Expected output:
```json
{"part1": 12345, "part2": 67890}
```

## Testing

```bash
# Run unit tests
cd carbon/dayXX
bazel test //...
```

## Current Limitations

As of Carbon's experimental preview:

1. **File I/O**: Carbon's file reading APIs are still being developed. The template shows placeholder code that will need to be updated when stable APIs are available.

2. **String Formatting**: Carbon's string formatting capabilities are evolving. The templates use basic `Core.Print` which may need adjustment.

3. **Standard Library**: Many common utilities are not yet available. You may need to implement custom string escaping and file handling.

4. **JSON Libraries**: Carbon does not yet have a JSON library. These templates use manual string formatting.

## Workarounds

Until Carbon's standard library matures, consider:

1. **Reading input via stdin** instead of file arguments
2. **Using simple string concatenation** instead of advanced formatting
3. **Hardcoding test input** temporarily during development
4. **Checking Carbon's documentation** for the latest available APIs

## Future Updates

As Carbon evolves:
- File I/O APIs will become available
- String manipulation will improve
- JSON libraries may be added to the ecosystem
- These templates will be updated to reflect new capabilities

## References

- Carbon Language Repository: https://github.com/carbon-language/carbon-lang
- Carbon Language Documentation: (evolving with the language)
- Bazel Build Documentation: https://bazel.build/
