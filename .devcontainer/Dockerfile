# [Choice] Base image for the devcontainer
ARG VARIANT="ubuntu"
FROM mcr.microsoft.com/devcontainers/base:${VARIANT}

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/home/vscode
ENV PATH="$HOME/.local/share/solana/install/active_release/bin:$HOME/.cargo/bin:${PATH}"

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates git build-essential pkg-config libssl-dev libudev-dev \
    libclang-dev cmake python3 python3-pip unzip gnupg2 wget sudo jq \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Ensure non-root vscode user exists (devcontainers base already provides it)
USER vscode
WORKDIR /workspaces/test-solana

# Install Node.js (v20) and npm via NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - \
  && sudo apt-get install -y nodejs \
  && npm --version

# Install Rust (rustup)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/vscode/.cargo/bin:${PATH}"

# Install Solana CLI (stable)
RUN sh -c "$(curl -sSfL https://release.solana.com/stable/install)" || true
ENV PATH="/home/vscode/.local/share/solana/install/active_release/bin:${PATH}"

# Install Anchor CLI (may take some time)
RUN source /home/vscode/.cargo/env && cargo install --git https://github.com/coral-xyz/anchor --locked anchor-cli || true

# Install global npm tooling useful for the frontend
RUN npm install -g npm@latest yarn

# Create workspace folder
RUN mkdir -p /workspaces/test-solana
WORKDIR /workspaces/test-solana

# Copy helper script into the image
COPY --chown=vscode:vscode start-services.sh /usr/local/bin/start-services.sh
RUN chmod +x /usr/local/bin/start-services.sh

# Expose useful ports
EXPOSE 8899 8900 5173

CMD ["/bin/bash"]
