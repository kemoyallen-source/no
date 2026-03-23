FROM node:20-alpine AS base
RUN apk add --no-cache bash curl wget git nginx supervisor tor privoxy dumb-init tzdata tini \
    nmap nmap-ncat socat iptables ip6tables bind-tools jq && \
    npm i -g pm2 @pm2/io

FROM base AS builder
WORKDIR /app
# Clone upstream DogeUnblocker-v4 (no build step needed - pure Node.js app)
RUN git clone --depth 1 https://github.com/DogeLeader/DogeUnblocker-v4.git . && \
    npm install --legacy-peer-deps && \
    npm cache clean --force

FROM base AS runtime  
WORKDIR /app

# Copy built Node app from builder
COPY --from=builder /app/index.js ./
COPY --from=builder /app/node_modules ./node_modules  
COPY --from=builder /app/package.json ./
COPY --from=builder /app/static ./static

# Copy local configs + tools (override/enhance upstream)
COPY configs/ ./configs/
COPY tools/ ./tools/
COPY agloader-fixed.html ./static/agloader.html
COPY entrypoint.sh /entrypoint.sh

# Create required directories and default proxy list
RUN mkdir -p /app/proxies /app/logs /app/certs /app/public && \
    echo "Creating default proxy list..." && \
    echo "127.0.0.1:3000" > /app/proxies/http.txt && \
    echo "127.0.0.1:3128" >> /app/proxies/http.txt && \
    chmod +x /entrypoint.sh /app/tools/* 2>/dev/null || true

# Pre-initialize live proxy files
RUN touch /app/proxies/{http,https,socks4,socks5}.live && \
    echo "127.0.0.1:3000" > /app/proxies/http.live

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:80/ 2>/dev/null | grep -q "DOCTYPE" || exit 1

EXPOSE 80 443 3000 8080 9050 3128 1080
ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]
