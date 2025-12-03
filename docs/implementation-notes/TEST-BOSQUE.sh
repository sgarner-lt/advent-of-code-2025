#!/bin/bash
# Quick test script for Bosque installation and verification
# Run this to test the complete Bosque toolchain setup

set -e

echo "=================================="
echo "Testing Bosque Toolchain Setup"
echo "=================================="
echo ""

# Step 1: Check Node.js version
echo "Step 1: Checking Node.js version..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "Found Node.js: $NODE_VERSION"

    # Extract major version
    MAJOR_VERSION=$(echo "$NODE_VERSION" | sed 's/v//' | cut -d'.' -f1)
    if [ "$MAJOR_VERSION" -lt 22 ]; then
        echo "ERROR: Node.js 22+ required, found $NODE_VERSION"
        echo "Upgrade via: nvm install 22 && nvm use 22"
        exit 1
    fi
else
    echo "ERROR: Node.js not found"
    echo "Install via: nvm install 22"
    exit 1
fi
echo ""

# Step 2: Run installation
echo "Step 2: Running Bosque installation..."
./scripts/install_bosque.sh
echo ""

# Step 3: Run verification
echo "Step 3: Running Bosque verification..."
./scripts/verify_bosque.sh
echo ""

# Step 4: Summary
echo "=================================="
echo "Test Complete!"
echo "=================================="
echo ""
echo "Bosque is installed and working."
echo ""
echo "Try it yourself:"
echo "  cd hello/bosque"
echo "  bosque hello.bsq"
echo "  node jsout/Main.mjs"
echo ""
echo "Documentation: docs/languages/bosque.md"
echo ""
