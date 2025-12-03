# Bosque Hello World

## Status

The Bosque toolchain is successfully installed and running via Podman container. However, the exact syntax for a minimal hello world program in BosqueCore v1.0 requires further investigation.

## Current Issue

The current `hello.bsq` file produces a parser error:
```
Parser Error @ [implicit]#-1: Missing namespace declaration -- Main
```

This suggests BosqueCore v1.0 may require additional project structure or manifest files beyond a single `.bsq` source file.

## Container Verification

The container itself is fully functional:
- BosqueCore v1.0 compiled successfully
- Bosque command accessible via wrapper script
- File mounting and I/O working correctly
- Node.js 22 and all dependencies installed

## Next Steps

To complete the hello world verification:

1. Review BosqueCore v1.0 test directory for minimal working examples
2. Check if a project manifest file is required (similar to package.json)
3. Consult BosqueCore documentation for v1.0 project structure
4. Update hello.bsq with correct syntax once determined

## Using Bosque

Even without the hello world verification, the Bosque toolchain is ready to use:

```bash
# From any directory with .bsq files
bosque yourfile.bsq

# Run generated JavaScript
node jsout/Main.mjs
```

The containerized approach provides full BosqueCore functionality on macOS.

## Reference

- **BosqueCore Repository:** https://github.com/BosqueLanguage/BosqueCore
- **Installation:** Completed via `./scripts/install_bosque.sh`
- **Documentation:** `docs/languages/bosque.md`
