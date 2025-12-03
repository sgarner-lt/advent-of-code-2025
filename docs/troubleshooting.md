# Troubleshooting Guide

Comprehensive troubleshooting guide for all 5 language toolchains in the Advent of Code 2025 project.

## Table of Contents

- [Common Issues Across All Languages](#common-issues-across-all-languages)
- [Platform-Specific Issues (macOS)](#platform-specific-issues-macos)
- [Rust-Specific Issues](#rust-specific-issues)
- [Gleam-Specific Issues](#gleam-specific-issues)
- [Roc-Specific Issues](#roc-specific-issues)
- [Carbon-Specific Issues](#carbon-specific-issues)
- [Bosque-Specific Issues](#bosque-specific-issues)
- [VS Code and Language Server Issues](#vs-code-and-language-server-issues)
- [Fallback Strategies](#fallback-strategies)
- [Getting Help](#getting-help)

---

## Common Issues Across All Languages

### Issue: Command not found after installation

**Symptoms:**
```bash
$ rustc --version
zsh: command not found: rustc
```

**Cause:** The language binary is not in your shell's PATH environment variable.

**Solutions:**

1. **Restart your terminal** - This will reload your shell configuration files
2. **Manually source your shell configuration:**
   ```bash
   # For zsh (macOS default)
   source ~/.zshrc

   # For bash
   source ~/.bashrc
   ```

3. **For Rust/Cargo specifically:**
   ```bash
   source $HOME/.cargo/env
   ```

4. **For Roc and Bosque (installed to ~/.local/bin):**
   ```bash
   export PATH="$HOME/.local/bin:$PATH"

   # Make permanent by adding to ~/.zshrc
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
   ```

---

### Issue: Installation script permission denied

**Symptoms:**
```bash
$ ./scripts/install_all.sh
zsh: permission denied: ./scripts/install_all.sh
```

**Cause:** Script files don't have execute permissions.

**Solution:**
```bash
# Make all scripts executable
chmod +x scripts/*.sh

# Or for a specific script
chmod +x scripts/install_rust.sh
```

---

### Issue: Prerequisites check fails

**Symptoms:**
```
[ERROR] Homebrew is not installed
[ERROR] Git is not installed
[ERROR] Xcode Command Line Tools are not installed
```

**Solution:** Install the missing prerequisites:

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Git
brew install git

# Install Xcode Command Line Tools
xcode-select --install
```

---

### Issue: Insufficient disk space

**Symptoms:**
```
Error: No space left on device
```

**Cause:** Some languages (especially Carbon) require significant disk space.

**Space Requirements:**
- Rust: ~1 GB
- Gleam: ~500 MB (includes Erlang runtime)
- Roc: ~100 MB (nightly binary)
- Carbon: ~10 GB (includes LLVM, Clang, Bazel artifacts)
- Bosque: ~3 GB (container image)

**Solution:**
1. Free up disk space by removing unused applications/files
2. For Carbon, consider skipping if space is limited: `./scripts/install_all.sh --skip-carbon`

---

## Platform-Specific Issues (macOS)

### Issue: macOS quarantine attribute on downloaded binaries

**Symptoms:**
```
"roc" cannot be opened because it is from an unidentified developer
```

**Cause:** macOS applies a quarantine attribute to downloaded files.

**Solution:**
```bash
# Remove quarantine attribute from Roc
xattr -d com.apple.quarantine ~/.local/bin/roc

# Verify it works
roc version
```

**Note:** This is safe for official releases from the Roc GitHub repository.

---

### Issue: Rosetta 2 required for x86_64 binaries on Apple Silicon

**Symptoms:**
```
Bad CPU type in executable
```

**Cause:** Some experimental languages may only provide x86_64 binaries, which require Rosetta 2 on Apple Silicon Macs.

**Solution:**
```bash
# Install Rosetta 2 (if prompted)
softwareupdate --install-rosetta
```

---

### Issue: macOS firewall blocking network connections

**Symptoms:**
- Installation scripts hang when downloading packages
- Homebrew installations timeout

**Solution:**
1. Check System Preferences > Security & Privacy > Firewall
2. Temporarily disable firewall during installation
3. Or add exceptions for Terminal, Homebrew, and development tools

---

## Rust-Specific Issues

### Issue: rustup-init fails to install

**Symptoms:**
```
error: could not download file from 'https://...'
```

**Solutions:**

1. **Check network connection** - Ensure you can access https://rustup.rs
2. **Try manual installation:**
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```

3. **Check proxy settings** if behind corporate firewall

---

### Issue: Rust version below 1.83.0

**Symptoms:**
```
[ERROR] rustc version 1.75.0 is below minimum requirement (1.83.0)
```

**Solution:**
```bash
# Update Rust to latest stable
rustup update stable
rustup default stable

# Verify version
rustc --version
```

---

## Gleam-Specific Issues

### Issue: Erlang runtime not installed

**Symptoms:**
```
Error: erlang not found
```

**Cause:** Gleam runs on the BEAM VM and requires Erlang.

**Solution:**
```bash
# Erlang should install automatically with Gleam
brew install erlang

# Verify installation
erl -version
```

---

### Issue: Gleam version mismatch

**Symptoms:**
- Compilation errors with existing Gleam projects
- Missing language features

**Solution:**
```bash
# Update Gleam to latest
brew upgrade gleam

# Verify version (should be 1.13.0+)
gleam --version
```

---

## Roc-Specific Issues

### Issue: Roc hello world fails with platform version errors

**Symptoms:**
```
MODULE NOT IMPORTED in hello.roc
The `Task` module is not imported
```

**Cause:** The Roc basic-cli platform version in hello.roc is incompatible with the installed Roc version.

**Status:** Known issue - Roc is pre-1.0 and experimental. Platform compatibility changes frequently.

**Solutions:**

1. **Update platform URL in hello.roc** - Check [Roc examples](https://github.com/roc-lang/examples) for current platform version
2. **Use a simpler hello world** without platforms:
   ```roc
   app [main] { pf: platform "..." }
   main = "Hello from Roc!"
   ```

3. **Accept that hello world may not work** - The Roc toolchain itself is installed and functional for more complex programs

**Workaround:** Focus on using Roc for algorithm implementations rather than I/O-heavy programs until platform stabilizes.

---

### Issue: Roc binary not found after installation

**Symptoms:**
```
command not found: roc
```

**Solution:**
```bash
# Roc is installed to ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"

# Make permanent
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Verify
roc version
```

---

## Carbon-Specific Issues

### Issue: Bazel build takes 15-30 minutes

**Symptoms:**
- Initial Carbon build appears to hang
- High CPU usage during build

**Cause:** Bazel must build LLVM, Clang, and the Carbon toolchain from source.

**Solution:**
- **Be patient** - This is normal for the first build
- **Ensure adequate resources:**
  - At least 4 GB RAM available
  - 10+ GB free disk space
  - Allow 15-30 minutes for completion

---

### Issue: Bazel build fails with compiler errors

**Symptoms:**
```
ERROR: Build failed
fatal error: '...' file not found
```

**Solutions:**

1. **Ensure Xcode Command Line Tools are installed:**
   ```bash
   xcode-select --install
   xcode-select -p  # Should show /Library/Developer/CommandLineTools
   ```

2. **Update Bazelisk:**
   ```bash
   brew upgrade bazelisk
   ```

3. **Clean and rebuild:**
   ```bash
   cd ~/.local/carbon/carbon-lang
   bazel clean --expunge
   bazel build //explorer
   ```

4. **Check Carbon repository for updates:**
   ```bash
   cd ~/.local/carbon/carbon-lang
   git pull origin trunk
   bazel build //explorer
   ```

---

### Issue: Carbon explorer not found

**Symptoms:**
```
bazel-bin/explorer/explorer: No such file or directory
```

**Cause:** Carbon has not been built yet, or build failed.

**Solution:**
```bash
cd ~/.local/carbon/carbon-lang
bazel build //explorer

# Verify build succeeded
ls -la bazel-bin/explorer/explorer
```

---

## Bosque-Specific Issues

### Issue: Podman not installed

**Symptoms:**
```
[ERROR] podman not found in PATH
```

**Solution:**
```bash
# Install Podman
brew install podman

# Initialize Podman machine
podman machine init

# Start Podman machine
podman machine start

# Verify
podman --version
```

---

### Issue: Podman machine not running

**Symptoms:**
```
[ERROR] Podman machine not running
Cannot connect to Podman socket
```

**Solution:**
```bash
# Check machine status
podman machine info

# Start machine if stopped
podman machine start

# Verify machine is running
podman machine info | grep machinestate
# Should show: machinestate: Running
```

---

### Issue: Bosque container image not built

**Symptoms:**
```
[ERROR] Bosque container image not built
```

**Solution:**
```bash
# Rebuild Bosque container
./scripts/install_bosque.sh

# Verify image exists
podman images | grep bosque-toolchain
```

---

### Issue: Bosque hello world syntax errors

**Symptoms:**
```
Failed to load user src file!
Namespace errors
```

**Status:** Known issue - BosqueCore v1.0 parser expects specific project structure. This is separate from the containerized toolchain functionality, which is fully operational.

**Solutions:**

1. **Check BosqueCore documentation** for current syntax requirements
2. **Use example programs** from the official repository
3. **Focus on algorithm implementations** rather than simple hello world

**Note:** The Bosque container and toolchain are fully functional. The hello world syntax requires investigation per the project tasks.

---

### Issue: Bosque commands slow

**Symptoms:**
- Each bosque command takes 1-2 seconds
- Container startup overhead noticeable

**Cause:** This is expected - the wrapper script must start a container for each command.

**Mitigation:**
- **Batch operations** where possible
- **Use interactive container session** for multiple commands:
  ```bash
  podman run -it --rm -v "$(pwd)":/workspace bosque-toolchain:latest bash
  # Now you're inside the container
  bosque compile file.bsq
  bosque run file.bsq
  ```

---

## VS Code and Language Server Issues

### Issue: Language server not starting

**Symptoms:**
- No autocomplete or error checking
- VS Code status bar shows "Language server crashed"

**Solutions by Language:**

**Rust (rust-analyzer):**
```bash
# Reinstall rust-analyzer via rustup
rustup component add rust-analyzer

# Or install via VS Code extension marketplace
# Extension: rust-lang.rust-analyzer
```

**Gleam:**
```bash
# Install Gleam language server
gleam lsp

# Or install via VS Code extension
# Extension: gleam.gleam
```

**Roc:**
- Limited language server support
- Use basic syntax highlighting only
- Extension: ivan-demchenko.roc-lang

**Carbon:**
- No language server available yet
- Use C++ syntax as fallback
- Settings: `"files.associations": {"*.carbon": "cpp"}`

**Bosque:**
- No language server available
- Use TypeScript syntax as fallback
- Settings: `"files.associations": {"*.bsq": "typescript"}`

---

### Issue: VS Code can't find compiler

**Symptoms:**
```
rust-analyzer failed to discover workspace
Cannot find cargo binary
```

**Solution:**
```bash
# Ensure VS Code can access your PATH
# Add to ~/.zshrc or ~/.bashrc:
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

# Restart VS Code completely (not just reload window)
```

---

## Fallback Strategies

### If a language fails to install completely

1. **Try manual installation** - See per-language docs in `docs/languages/<language>.md`
2. **Check official language documentation** for platform-specific issues
3. **Skip the problematic language** and continue with others:
   ```bash
   ./scripts/install_all.sh --skip-carbon
   ```

4. **Use alternative approaches:**
   - **Roc:** Try different nightly build versions
   - **Carbon:** Use online Carbon explorer (https://carbon-lang.dev/)
   - **Bosque:** Native Linux installation (requires Linux VM)

---

### If multiple languages fail

1. **Verify all prerequisites** are installed:
   ```bash
   brew --version
   git --version
   xcode-select -p
   ```

2. **Check available disk space:**
   ```bash
   df -h
   ```

3. **Try individual installation scripts** to isolate issues:
   ```bash
   ./scripts/install_rust.sh
   ./scripts/install_gleam.sh
   ```

4. **Review installation logs** for specific error messages

---

### If everything fails

1. **Check system compatibility:**
   - macOS version (10.15 Catalina or later recommended)
   - Available RAM (8 GB minimum, 16 GB recommended)
   - Free disk space (20 GB+ for all languages)

2. **Try minimal installation:**
   ```bash
   # Install only stable languages
   ./scripts/install_all.sh --only-rust --only-gleam
   ```

3. **Consult the project README** for updated requirements or known issues

---

## Getting Help

### Official Language Support Channels

**Rust:**
- Documentation: https://doc.rust-lang.org/
- Forum: https://users.rust-lang.org/
- Discord: https://discord.gg/rust-lang

**Gleam:**
- Documentation: https://gleam.run/
- Discord: https://discord.gg/Fm8Pwmy
- GitHub Discussions: https://github.com/gleam-lang/gleam/discussions

**Roc:**
- Documentation: https://www.roc-lang.org/
- Zulip Chat: https://roc.zulipchat.com/
- GitHub Issues: https://github.com/roc-lang/roc/issues

**Carbon:**
- Documentation: https://github.com/carbon-language/carbon-lang
- Discord: https://discord.gg/ZjVdShJDAs
- GitHub Discussions: https://github.com/carbon-language/carbon-lang/discussions

**Bosque:**
- Documentation: https://github.com/BosqueLanguage/BosqueCore
- GitHub Issues: https://github.com/BosqueLanguage/BosqueCore/issues

---

### Debugging Tips

1. **Run installation scripts with verbose output:**
   ```bash
   bash -x ./scripts/install_rust.sh
   ```

2. **Check installation logs** for specific error messages

3. **Verify each step manually** by following per-language documentation

4. **Test in isolation:**
   - Create a new user account
   - Test installation in a clean environment
   - This helps identify conflicts with existing tools

5. **Document your configuration:**
   - macOS version
   - Installed tools and versions
   - Shell configuration files content
   - Any custom environment variables

---

### Known Limitations

**Project Scope:**
- **macOS only** - Scripts assume macOS environment
- **Experimental languages** - Roc, Carbon, and Bosque are pre-1.0 and may have issues
- **Platform compatibility** - Not tested on Linux or Windows

**Experimental Language Stability:**
- **Roc:** Nightly builds may have breaking changes
- **Carbon:** Toolchain under active development
- **Bosque:** Research project, limited documentation

**Performance:**
- **Carbon:** Long initial build times (15-30 minutes)
- **Bosque:** Container startup overhead (1-2 seconds per command)

---

## Quick Reference

### Verification Commands

```bash
# Check all installations
./scripts/verify_installation.sh

# Check specific language
rustc --version && cargo --version    # Rust
gleam --version                       # Gleam
~/.local/bin/roc version              # Roc
ls ~/.local/carbon/carbon-lang        # Carbon
podman images | grep bosque           # Bosque
```

### Reinstallation Commands

```bash
# Reinstall all languages (idempotent)
./scripts/install_all.sh

# Reinstall specific language
./scripts/install_rust.sh
./scripts/install_gleam.sh
./scripts/install_roc.sh
./scripts/install_carbon.sh
./scripts/install_bosque.sh
```

### PATH Configuration

```bash
# Add to ~/.zshrc for permanent PATH updates
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

# Apply immediately
source ~/.zshrc
```

---

**Last Updated:** 2025-12-03
**Project:** Advent of Code 2025 - Language Toolchain Setup
**Platform:** macOS only
**Languages:** Rust, Gleam, Roc, Carbon, Bosque
