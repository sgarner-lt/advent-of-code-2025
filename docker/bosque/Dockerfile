# Dockerfile for Bosque Language Toolchain
# Base: Ubuntu 24.04 (officially supported by BosqueCore)
# Provides a working Bosque environment for macOS users via Podman/Docker

FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    git-lfs \
    build-essential \
    clang \
    python3 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 22 (required by BosqueCore)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Initialize git-lfs
RUN git lfs install

# Set working directory for BosqueCore
WORKDIR /opt/bosque

# Clone and build BosqueCore
RUN git clone https://github.com/BosqueLanguage/BosqueCore.git . \
    && npm install \
    && npm run build

# Create workspace directory for mounting user files
WORKDIR /workspace

# Set environment variables
ENV PATH="/opt/bosque/bin/src/cmd:${PATH}"
ENV BOSQUE_HOME="/opt/bosque"

# Create a simple wrapper script for easier invocation
RUN echo '#!/bin/bash\nnode /opt/bosque/bin/src/cmd/bosque.js "$@"' > /usr/local/bin/bosque \
    && chmod +x /usr/local/bin/bosque

# Default command: show Node.js and check bosque exists
CMD ["sh", "-c", "echo 'Bosque toolchain ready' && which bosque && node --version"]
