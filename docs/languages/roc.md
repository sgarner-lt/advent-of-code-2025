# Roc Language Setup Guide

## Overview

Roc is a functional programming language designed for building reliable software. It is currently in active development (pre-1.0) and considered experimental. This guide covers installation on macOS.

**Platform Support:** macOS only (as per project requirements)
**Current Status:** Pre-release nightly builds
**Official Site:** https://www.roc-lang.org/

## Installation

### Automated Installation

The easiest way to install Roc is using the provided installation script:

```bash
./scripts/install_roc.sh
```

This script will:
1. Check if Roc is already installed (idempotent)
2. Attempt Homebrew installation (if available)
3. Fall back to downloading the latest nightly build from GitHub
4. Install the binary to `~/.local/bin/roc`
5. Verify the installation

### Manual Installation

#### Option 1: Download Pre-built Binary

1. Visit the [Roc GitHub Releases](https://github.com/roc-lang/roc/releases) page
2. Download the latest release for your architecture:
   - Apple Silicon: `roc-macos_apple_silicon-[version].tar.gz`
   - Intel (x86_64): `roc-macos_x86_64-[version].tar.gz`

3. Extract the archive:
```bash
tar -xzf roc-macos_x86_64-alpha4-rolling.tar.gz
```

4. Move the binary to a directory in your PATH:
```bash
mkdir -p ~/.local/bin
cp roc ~/.local/bin/roc
chmod +x ~/.local/bin/roc
```

5. Remove macOS quarantine attribute (if needed):
```bash
xattr -d com.apple.quarantine ~/.local/bin/roc
```

6. Add `~/.local/bin` to your PATH (add to `~/.zshrc` or `~/.bash_profile`):
```bash
export PATH="$PATH:$HOME/.local/bin"
```

7. Verify installation:
```bash
roc version
```

#### Option 2: Build from Source

For building from source, follow the [official building guide](https://github.com/roc-lang/roc/blob/main/BUILDING_FROM_SOURCE.md).

## Basic Usage

### Running a Roc Program

To run a Roc program directly:
```bash
roc hello.roc
```

### Compiling a Roc Program

To compile to a native executable:
```bash
roc build hello.roc
```

This produces an executable in the current directory.

### Getting Help

```bash
roc help          # General help
roc version       # Display version information
```

## Hello World Example

Create a file `hello.roc`:

```roc
app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.17.0/lZFLstMUCUvd5bjnnpYromZJXkQUrdhbva4xdBInicE.tar.br" }

import pf.Stdout

main =
    Stdout.line! "Hello from Roc!"
```

Run it:
```bash
roc hello.roc
```

Expected output:
```
Hello from Roc!
```

## VS Code Setup

### Recommended Extensions

1. **Roc Language Server**
   - Extension: Search for "Roc" in VS Code marketplace
   - Note: Language server support may be limited as Roc is experimental

### VS Code Settings

Add to your `.vscode/settings.json`:

```json
{
    "files.associations": {
        "*.roc": "roc"
    }
}
```

## Troubleshooting

### macOS Quarantine Warning

If you get a security warning when running Roc:

```bash
xattr -d com.apple.quarantine ~/.local/bin/roc
```

### PATH Not Set

If `roc` command is not found, ensure `~/.local/bin` is in your PATH:

```bash
# Check current PATH
echo $PATH

# Add to ~/.zshrc (for zsh) or ~/.bash_profile (for bash)
export PATH="$PATH:$HOME/.local/bin"

# Reload your shell configuration
source ~/.zshrc  # or source ~/.bash_profile
```

### Performance on macOS

Roc runs slower on macOS compared to Linux and Windows. This is a known limitation and is documented by the Roc team. For Advent of Code problems, this should not be a significant issue.

### Platform Issues

Roc's platform system is still evolving. If you encounter issues with the basic-cli platform:

1. Check for updated platform URLs at [basic-cli releases](https://github.com/roc-lang/basic-cli/releases)
2. Update the platform URL in your Roc program
3. Ensure you have internet connectivity for platform downloads

### Build Failures

If compilation fails:

1. Verify you have the latest nightly build:
   ```bash
   roc version
   ```

2. Check the [Roc Zulip community](https://roc.zulipchat.com/) for known issues
3. Try a simpler program to isolate the issue
4. Check that all platform dependencies are accessible

## Known Limitations

- **Experimental Status:** Roc is pre-1.0 and actively evolving. APIs may change.
- **macOS Performance:** Compiler runs slower on macOS than on Linux/Windows
- **Limited Tooling:** IDE support and debugging tools are still maturing
- **Breaking Changes:** Nightly builds may introduce breaking changes
- **Platform Dependencies:** Programs depend on platform URLs that may change

## Learning Resources

- **Official Tutorial:** https://www.roc-lang.org/tutorial
- **Documentation:** https://www.roc-lang.org/docs
- **Examples:** https://github.com/roc-lang/examples
- **Community Chat:** https://roc.zulipchat.com/
- **GitHub Repository:** https://github.com/roc-lang/roc

## Version Information

To check your installed version:
```bash
roc version
```

Example output:
```
roc nightly pre-release, built from commit d73ea109 on Tue Sep  9 09:25:53 UTC 2025
```

## Uninstallation

To remove Roc:

```bash
rm ~/.local/bin/roc
```

If you want to clean up downloaded platforms:
```bash
rm -rf ~/.cache/roc
```

## Notes for Advent of Code

- Roc's functional nature makes it well-suited for algorithmic problems
- The language emphasizes reliability and clear error messages
- String and list manipulation are straightforward
- Pattern matching is powerful for parsing input
- The experimental status means you may need to adapt to language changes

## Additional Information

- **Installation Script Location:** `scripts/install_roc.sh`
- **Example Location:** `hello/roc/hello.roc`
- **Platform:** macOS only
- **Architecture Support:** Apple Silicon (arm64) and Intel (x86_64)
