# VS Code Setup Guide

Complete guide to setting up Visual Studio Code for all 5 languages in the Advent of Code 2025 project (Rust, Gleam, Roc, Carbon, Bosque).

## Platform Note

This guide is designed for **macOS only**. VS Code is cross-platform, but language toolchain paths and configurations may differ on other operating systems.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Recommended Extensions](#recommended-extensions)
- [Language Server Setup](#language-server-setup)
- [Workspace Configuration](#workspace-configuration)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)

## Prerequisites

Before configuring VS Code, ensure all language toolchains are installed:

```bash
# Install all languages using the master script
./scripts/install_all.sh

# Or install individual languages
./scripts/install_rust.sh
./scripts/install_gleam.sh
./scripts/install_roc.sh
./scripts/install_carbon.sh
./scripts/install_bosque.sh
```

## Recommended Extensions

### 1. Rust

**rust-analyzer** (Essential)
- Extension ID: `rust-lang.rust-analyzer`
- Provides IntelliSense, code completion, go-to-definition, refactoring, and inline diagnostics
- Automatically downloads and configures the Rust language server
- Install from VS Code Marketplace: [rust-analyzer](https://marketplace.visualstudio.com/items?itemName=rust-lang.rust-analyzer)

**Additional Rust Extensions** (Optional)
- **CodeLLDB** (`vadimcn.vscode-lldb`) - Native debugging support
- **crates** (`serayuzgur.crates`) - Dependency version management in Cargo.toml
- **Error Lens** (`usernamehw.errorlens`) - Inline error messages (useful for all languages)

### 2. Gleam

**Gleam** (Essential)
- Extension ID: `gleam.gleam`
- Provides syntax highlighting, LSP support, code completion, and diagnostics
- Includes integrated Gleam language server
- Install from VS Code Marketplace: [Gleam](https://marketplace.visualstudio.com/items?itemName=gleam.gleam)

**Verification:**
```bash
# Verify Gleam LSP is available
gleam lsp --help
```

### 3. Roc

**Roc Language Support** (Community Extension)
- Extension ID: `ivan-demchenko.roc-lang`
- Provides basic syntax highlighting for Roc files (.roc)
- Note: As of December 2025, Roc is pre-1.0 and language server support is experimental
- Install from VS Code Marketplace: [Roc](https://marketplace.visualstudio.com/items?itemName=ivan-demchenko.roc-lang)

**Limitations:**
- Limited or no IntelliSense/autocomplete support
- No integrated language server
- Basic syntax highlighting only

**Alternative:**
- Some developers use the Elm extension for similar syntax highlighting
- Official Roc LSP is in development but not yet stable

### 4. Carbon

**Carbon Language Support**
- **Status:** No official VS Code extension available as of December 2025
- Carbon is an experimental language in early development
- Currently no language server or IntelliSense support

**Workarounds:**
- Use C++ extension (`ms-vscode.cpptools`) for basic syntax highlighting
- Carbon syntax is similar to C++, so this provides minimal highlighting
- Extension ID: `ms-vscode.cpptools`

**Manual Configuration:**
You can associate `.carbon` files with C++ syntax:

Add to `.vscode/settings.json`:
```json
{
    "files.associations": {
        "*.carbon": "cpp"
    }
}
```

### 5. Bosque

**Bosque Language Support**
- **Status:** No official VS Code extension available as of December 2025
- Bosque is a research language with limited tooling support
- No language server or IntelliSense support

**Workarounds:**
- Use TypeScript extension for basic syntax highlighting (Bosque syntax has some similarities)
- Extension ID: `ms-vscode.vscode-typescript-next`
- Most developers edit Bosque files as plain text

**Manual Configuration:**
You can associate `.bsq` files with TypeScript syntax:

Add to `.vscode/settings.json`:
```json
{
    "files.associations": {
        "*.bsq": "typescript"
    }
}
```

## Language Server Setup

### Rust (rust-analyzer)

The rust-analyzer extension automatically manages the language server. No manual setup required.

**Verify Installation:**
1. Open a `.rs` file in VS Code
2. Check the bottom-right status bar for "rust-analyzer" status
3. Hover over a variable - you should see type information
4. Type to trigger autocomplete

**Manual rust-analyzer installation (if needed):**
```bash
rustup component add rust-analyzer
```

### Gleam LSP

The Gleam extension includes the language server. Ensure Gleam is installed:

```bash
# Verify Gleam is in PATH
which gleam

# Check version
gleam --version
```

**Verify LSP is working:**
1. Open a `.gleam` file in VS Code
2. Check for syntax highlighting
3. Hover over functions for documentation
4. Type to see autocomplete suggestions

### Roc

Roc does not currently have a stable language server. The community extension provides basic syntax highlighting only.

**No language server available:**
- No autocomplete
- No go-to-definition
- No inline diagnostics
- Basic syntax highlighting only

### Carbon

Carbon does not have a language server or VS Code extension. Use C++ extension for minimal syntax highlighting.

**No language server available:**
- No autocomplete
- No go-to-definition
- No inline diagnostics
- Limited syntax highlighting via C++ extension

### Bosque

Bosque does not have a language server or official VS Code extension.

**No language server available:**
- No autocomplete
- No go-to-definition
- No inline diagnostics
- Edit as plain text or associate with TypeScript syntax

## Workspace Configuration

Create or update `.vscode/settings.json` in your project root:

```json
{
    // Rust configuration
    "rust-analyzer.check.command": "clippy",
    "rust-analyzer.cargo.features": "all",
    "rust-analyzer.inlayHints.enable": true,
    "[rust]": {
        "editor.defaultFormatter": "rust-lang.rust-analyzer",
        "editor.formatOnSave": true
    },

    // Gleam configuration
    "[gleam]": {
        "editor.defaultFormatter": "gleam.gleam",
        "editor.formatOnSave": true
    },

    // Roc configuration (basic)
    "[roc]": {
        "editor.tabSize": 4,
        "editor.insertSpaces": true
    },

    // Carbon configuration (using C++ syntax)
    "files.associations": {
        "*.carbon": "cpp"
    },
    "[cpp]": {
        "editor.tabSize": 2,
        "editor.insertSpaces": true
    },

    // Bosque configuration (using TypeScript syntax)
    "files.associations": {
        "*.bsq": "typescript"
    },
    "[typescript]": {
        "editor.tabSize": 2,
        "editor.insertSpaces": true
    },

    // General editor settings
    "editor.rulers": [100],
    "editor.renderWhitespace": "boundary",
    "files.trimTrailingWhitespace": true,
    "files.insertFinalNewline": true,

    // Error lens (if installed)
    "errorLens.enabled": true,
    "errorLens.fontWeight": "normal"
}
```

### Recommended Workspace Extensions

Create `.vscode/extensions.json`:

```json
{
    "recommendations": [
        // Rust
        "rust-lang.rust-analyzer",
        "vadimcn.vscode-lldb",

        // Gleam
        "gleam.gleam",

        // Roc
        "ivan-demchenko.roc-lang",

        // Carbon/C++ (minimal support)
        "ms-vscode.cpptools",

        // General
        "usernamehw.errorlens",
        "eamodio.gitlens"
    ]
}
```

When teammates open the project, VS Code will suggest installing these extensions.

## Verification

### Rust Language Server Verification

1. Open `hello/rust/hello.rs`
2. **Syntax Highlighting:** Code should be colorized
3. **Hover Information:** Hover over `println!` to see documentation
4. **Autocomplete:** Start typing `std::` and see suggestions
5. **Diagnostics:** Introduce an error (e.g., `let x: i32 = "hello";`) and see inline error
6. **Status Bar:** Check bottom-right for rust-analyzer status

### Gleam Language Server Verification

1. Open a `.gleam` file in `hello/gleam/`
2. **Syntax Highlighting:** Code should be colorized
3. **Hover Information:** Hover over functions to see types
4. **Autocomplete:** Start typing and see suggestions
5. **Formatting:** Save file and verify it auto-formats (if enabled)

### Roc Extension Verification

1. Open `hello/roc/hello.roc`
2. **Syntax Highlighting:** Basic Roc syntax should be highlighted
3. **No LSP Features:** Autocomplete and hover won't work (expected)

### Carbon Extension Verification

1. Open a `.carbon` file in `hello/carbon/`
2. **Syntax Highlighting:** Basic C++-style highlighting (if configured)
3. **No LSP Features:** No autocomplete or diagnostics (expected)

### Bosque Extension Verification

1. Open a `.bsq` file in `hello/bosque/`
2. **Basic Highlighting:** TypeScript-style highlighting (if configured)
3. **No LSP Features:** No autocomplete or diagnostics (expected)

## Troubleshooting

### Issue: rust-analyzer not working

**Symptoms:**
- No autocomplete
- No hover information
- Status bar shows error

**Solutions:**

1. Check rust-analyzer output:
   - View > Output
   - Select "rust-analyzer" from dropdown
   - Check for error messages

2. Verify Rust installation:
   ```bash
   which rustc
   rustc --version
   source $HOME/.cargo/env
   ```

3. Restart VS Code language server:
   - Cmd+Shift+P (macOS)
   - Type "Rust Analyzer: Restart Server"
   - Select and execute

4. Reinstall rust-analyzer component:
   ```bash
   rustup component remove rust-analyzer
   rustup component add rust-analyzer
   ```

5. Reinstall VS Code extension:
   - Uninstall rust-analyzer extension
   - Reload VS Code
   - Reinstall rust-analyzer extension

### Issue: Gleam extension not working

**Symptoms:**
- No syntax highlighting
- No autocomplete

**Solutions:**

1. Verify Gleam installation:
   ```bash
   which gleam
   gleam --version
   ```

2. Check Gleam extension output:
   - View > Output
   - Select "Gleam" from dropdown

3. Verify Erlang is installed (required by Gleam):
   ```bash
   which erl
   erl -version
   ```

4. Reload VS Code:
   - Cmd+Shift+P
   - Type "Developer: Reload Window"

### Issue: Roc/Carbon/Bosque files show as plain text

**Symptoms:**
- No syntax highlighting
- File appears as plain text

**Solutions:**

1. Install recommended extensions (see above)

2. Manually set file association:
   - Click language mode in status bar (bottom-right)
   - Select appropriate language:
     - Roc: "Roc"
     - Carbon: "C++"
     - Bosque: "TypeScript"

3. Add file associations to settings.json (see Workspace Configuration above)

### Issue: Extensions not installing

**Solutions:**

1. Check internet connection

2. Check VS Code extension marketplace:
   - Visit https://marketplace.visualstudio.com
   - Search for extension
   - Verify it exists and is compatible with your VS Code version

3. Install extension manually:
   - Download `.vsix` file from marketplace
   - Extensions > Views and More Actions (•••) > Install from VSIX

4. Check VS Code logs:
   - Help > Toggle Developer Tools
   - Check Console tab for errors

### Issue: Performance problems with language servers

**Symptoms:**
- VS Code is slow
- High CPU usage
- Typing lag

**Solutions:**

1. Disable language servers for large files:
   Add to settings.json:
   ```json
   {
       "rust-analyzer.files.excludeDirs": ["target", "node_modules"],
       "rust-analyzer.cargo.buildScripts.enable": false
   }
   ```

2. Close unused editor tabs

3. Disable unused extensions

4. Increase VS Code memory limit:
   Add to settings.json:
   ```json
   {
       "files.maxMemoryForLargeFilesMB": 8192
   }
   ```

## Additional Resources

### Rust
- [rust-analyzer User Manual](https://rust-analyzer.github.io/)
- [Rust in VS Code](https://code.visualstudio.com/docs/languages/rust)

### Gleam
- [Gleam VS Code Extension](https://github.com/gleam-lang/vscode-gleam)
- [Gleam Editor Setup](https://gleam.run/writing-gleam/editor-setup/)

### Roc
- [Roc Editor Setup](https://www.roc-lang.org/install#editor-extensions)
- [Roc Community Discord](https://roc.zulipchat.com/) - Ask about editor support

### Carbon
- [Carbon Language GitHub](https://github.com/carbon-language/carbon-lang)
- Carbon editor support is in early stages - check GitHub issues

### Bosque
- [Bosque GitHub](https://github.com/BosqueLanguage/BosqueCore)
- No official editor support - file issues on GitHub for future development

### General VS Code
- [VS Code Docs](https://code.visualstudio.com/docs)
- [Language Server Protocol](https://microsoft.github.io/language-server-protocol/)

## Summary: Language Server Support

| Language | Extension Available | LSP Support | Autocomplete | Diagnostics | Go-to-Definition |
|----------|-------------------|-------------|--------------|-------------|------------------|
| Rust     | Yes (excellent)   | Yes (full)  | Yes          | Yes         | Yes              |
| Gleam    | Yes (good)        | Yes (full)  | Yes          | Yes         | Yes              |
| Roc      | Yes (basic)       | No          | No           | No          | No               |
| Carbon   | No (use C++)      | No          | No           | No          | No               |
| Bosque   | No (use TS)       | No          | No           | No          | No               |

**Note:** Rust and Gleam have excellent IDE support. Roc, Carbon, and Bosque are experimental languages with limited or no language server support. For these languages, you'll rely on compiler error messages and manual documentation lookups.

## Next Steps

1. Install recommended extensions from `.vscode/extensions.json`
2. Copy the sample settings to `.vscode/settings.json`
3. Verify language servers are working (especially Rust and Gleam)
4. Start coding and explore each language's capabilities
5. Refer to individual language documentation in `docs/languages/` for more details

---

**Last Updated:** 2025-12-03
