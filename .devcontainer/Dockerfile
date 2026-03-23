# Codespaces-optimized Dockerfile for DogeUnblocker
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install Docker CLI (Docker in Docker will be provided by feature)
RUN apt-get update && apt-get install -y \
    docker.io \
    docker-compose \
    curl \
    git \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (will also install via feature, but ensure it's available)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspaces/no

# Copy repository content (if available during build)
COPY . . 2>/dev/null || true

# Default command - keep container running
CMD ["/bin/bash"]
