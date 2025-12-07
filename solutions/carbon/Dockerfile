# Carbon Language Build Environment for Advent of Code 2025
# Based on Ubuntu (officially supported by Carbon)

FROM ubuntu:22.04

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for Carbon toolchain
RUN apt-get update && apt-get install -y \
    build-essential \
    clang-19 \
    lld-19 \
    libc++-19-dev \
    libc++abi-19-dev \
    git \
    python3 \
    python3-pip \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set up Clang 19 as default
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-19 100 \
    && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-19 100 \
    && update-alternatives --install /usr/bin/lld lld /usr/bin/lld-19 100

# Clone Carbon repository
WORKDIR /opt
RUN git clone --depth 1 https://github.com/carbon-language/carbon-lang.git

# Build Carbon toolchain
WORKDIR /opt/carbon-lang
RUN ./scripts/run_bazelisk.py build //toolchain

# Add Carbon to PATH
ENV PATH="/opt/carbon-lang/bazel-bin/toolchain:$PATH"

# Set working directory for solutions
WORKDIR /workspace

# Default command
CMD ["/bin/bash"]
