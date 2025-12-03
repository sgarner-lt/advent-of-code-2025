#!/bin/bash

# Bosque Wrapper Script for macOS using Podman
#
# This script forwards Bosque commands to a containerized Linux environment
# where BosqueCore can run properly (macOS has native module build issues).
#
# Usage: bosque <arguments>
# Example: bosque compile hello.bsq

set -euo pipefail

# Configuration
readonly CONTAINER_IMAGE="bosque-toolchain:latest"
readonly WORKSPACE_DIR="$(pwd)"

# Check if podman is available
if ! command -v podman &> /dev/null; then
    echo "Error: podman is not installed" >&2
    echo "Install via Homebrew: brew install podman" >&2
    echo "Then initialize: podman machine init && podman machine start" >&2
    exit 1
fi

# Check if podman machine is running
if ! podman machine info &> /dev/null; then
    echo "Error: Podman machine is not running" >&2
    echo "Start it with: podman machine start" >&2
    exit 1
fi

# Check if the Bosque container image exists
if ! podman image exists "$CONTAINER_IMAGE"; then
    echo "Error: Bosque container image not found: $CONTAINER_IMAGE" >&2
    echo "Build it first using: ./scripts/install_bosque.sh" >&2
    exit 1
fi

# Run Bosque command in container
# - Mount current directory to /workspace
# - Run as current user to preserve file permissions
# - Remove container after execution (--rm)
# - Interactive mode for proper output handling
podman run \
    --rm \
    -it \
    -v "${WORKSPACE_DIR}:/workspace:z" \
    -w /workspace \
    "${CONTAINER_IMAGE}" \
    bosque "$@"
