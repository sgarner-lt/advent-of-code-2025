# Roc JSON Output Template

## Overview

This template provides a standard approach for outputting JSON results from Roc Advent of Code solutions using string formatting with the `Str` module.

## Basic Template for Integer Answers

```roc
app "advent-solution"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.8.1/x8URkvfyi9I0QhmVG98roKBUs_AZRkLFwFJVJ3942YA.tar.br" }
    imports [
        pf.Stdout,
        pf.Stderr,
        pf.Task.{ Task },
        pf.File,
        pf.Path,
        pf.Arg,
    ]
    provides [main] to pf

solvePart1 : Str -> Result I64 [NotImplemented]
solvePart1 = \input ->
    # Your part 1 solution here
    Ok 12345

solvePart2 : Str -> Result I64 [NotImplemented]
solvePart2 = \input ->
    # Your part 2 solution here
    Err NotImplemented  # Return Err if not yet implemented

formatAnswer : Result I64 [NotImplemented], Result I64 [NotImplemented] -> Str
formatAnswer = \part1Result, part2Result ->
    part1Str =
        when part1Result is
            Ok value -> Num.toStr value
            Err NotImplemented -> "null"

    part2Str =
        when part2Result is
            Ok value -> Num.toStr value
            Err NotImplemented -> "null"

    "{\"part1\": \(part1Str), \"part2\": \(part2Str)}"

main : Task {} []
main =
    args <- Arg.list |> Task.await

    when List.get args 1 is
        Ok inputPath ->
            path = Path.fromStr inputPath
            input <- File.readUtf8 path
                |> Task.onErr \_ ->
                    Stderr.line "Failed to read input file"
                    |> Task.await \_ -> Task.err (Exit 1 "")
                |> Task.await

            part1 = solvePart1 input
            part2 = solvePart2 input

            json = formatAnswer part1 part2
            Stdout.line json

        Err _ ->
            Stderr.line "Usage: roc run solution.roc <input_file>"
            |> Task.await \_ -> Task.err (Exit 1 "")
```

## Template for String Answers

```roc
app "advent-solution"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.8.1/x8URkvfyi9I0QhmVG98roKBUs_AZRkLFwFJVJ3942YA.tar.br" }
    imports [
        pf.Stdout,
        pf.Stderr,
        pf.Task.{ Task },
        pf.File,
        pf.Path,
        pf.Arg,
    ]
    provides [main] to pf

solvePart1 : Str -> Result Str [NotImplemented]
solvePart1 = \input ->
    # Your part 1 solution here
    Ok "ANSWER"

solvePart2 : Str -> Result Str [NotImplemented]
solvePart2 = \input ->
    # Your part 2 solution here
    Err NotImplemented

escapeJsonString : Str -> Str
escapeJsonString = \str ->
    # Simple escaping for quotes and backslashes
    str
    |> Str.replaceEach "\\" "\\\\"
    |> Str.replaceEach "\"" "\\\""
    |> Str.replaceEach "\n" "\\n"

formatAnswer : Result Str [NotImplemented], Result Str [NotImplemented] -> Str
formatAnswer = \part1Result, part2Result ->
    part1Str =
        when part1Result is
            Ok value -> "\"\(escapeJsonString value)\""
            Err NotImplemented -> "null"

    part2Str =
        when part2Result is
            Ok value -> "\"\(escapeJsonString value)\""
            Err NotImplemented -> "null"

    "{\"part1\": \(part1Str), \"part2\": \(part2Str)}"

main : Task {} []
main =
    args <- Arg.list |> Task.await

    when List.get args 1 is
        Ok inputPath ->
            path = Path.fromStr inputPath
            input <- File.readUtf8 path
                |> Task.onErr \_ ->
                    Stderr.line "Failed to read input file"
                    |> Task.await \_ -> Task.err (Exit 1 "")
                |> Task.await

            part1 = solvePart1 input
            part2 = solvePart2 input

            json = formatAnswer part1 part2
            Stdout.line json

        Err _ ->
            Stderr.line "Usage: roc run solution.roc <input_file>"
            |> Task.await \_ -> Task.err (Exit 1 "")
```

## Simplified Template (Without Command Line Args)

```roc
app "advent-solution"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.8.1/x8URkvfyi9I0QhmVG98roKBUs_AZRkLFwFJVJ3942YA.tar.br" }
    imports [pf.Stdout]
    provides [main] to pf

solvePart1 : I64
solvePart1 = 12345

solvePart2 : I64
solvePart2 = 67890

main =
    part1 = Num.toStr solvePart1
    part2 = Num.toStr solvePart2
    json = "{\"part1\": \(part1), \"part2\": \(part2)}"
    Stdout.line json
```

## Template with Null Values

```roc
app "advent-solution"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.8.1/x8URkvfyi9I0QhmVG98roKBUs_AZRkLFwFJVJ3942YA.tar.br" }
    imports [pf.Stdout]
    provides [main] to pf

main =
    # Part 1 implemented, part 2 not yet
    part1 = Num.toStr 12345
    json = "{\"part1\": \(part1), \"part2\": null}"
    Stdout.line json
```

## Running the Solution

```bash
# Run directly with Roc
cd roc/dayXX
${HOME}/.local/bin/roc run solution.roc ../../challenges/dayXX/input.txt
```

Expected output:
```json
{"part1": 12345, "part2": 67890}
```

## Testing

```bash
# Run unit tests (if defined in the file)
${HOME}/.local/bin/roc test solution.roc

# Run with sample input
${HOME}/.local/bin/roc run solution.roc ../../challenges/dayXX/input-sample.txt
```

## Notes

- Roc does not have a built-in JSON library, so we use string interpolation
- Use `Result` type to represent optional values (Ok for implemented, Err for not)
- Use string interpolation `\(variable)` to insert values into JSON strings
- For string answers, escape special characters: `\"`, `\\`, `\n`
- Always output to stdout using `Stdout.line`
- Output errors to stderr using `Stderr.line`
- Read input files using `File.readUtf8` with `Path.fromStr`
- The basic-cli package provides Task-based IO operations
- Keep JSON compact (no pretty-printing or extra whitespace)
