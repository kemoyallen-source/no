#!/bin/bash
set -euo pipefail

export UV_PORT=${UV_PORT:-3000}
export BARE_PORT=${BARE_PORT:-8080}
export TOR_PORT=${TOR_PORT:-9050}

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a /app/logs/entrypoint.log; }

# Create required directories
mkdir -p /app/logs /app/proxies /app/certs /tmp/tor-data
log "Initialized directories"

# Initialize proxy list if missing
if [ ! -f /app/proxies/http.txt ] || [ ! -s /app/proxies/http.txt ]; then
  log "Initializing proxy list..."
  echo "127.0.0.1:3000" > /app/proxies/http.txt
  echo "127.0.0.1:3128" >> /app/proxies/http.txt
fi

# Start Tor in background
if [ -f /app/configs/torrc-fixed.conf ]; then
  log "Starting Tor..."
  tor -f /app/configs/torrc-fixed.conf > /app/logs/tor.log 2>&1 &
  sleep 3
fi

# Start Privoxy if config exists
if [ -f /app/configs/privoxy.conf ]; then
  log "Starting Privoxy..."
  privoxy --pidfile /app/logs/privoxy.pid /app/configs/privoxy.conf > /app/logs/privoxy.log 2>&1 &
  sleep 2
fi

# Start main Node.js application (UV proxy)
log "Starting Node.js application on port ${UV_PORT}..."
cd /app
node index.js &
APP_PID=$!
sleep 3

# Start Nginx reverse proxy if config exists
if [ -f /app/configs/nginx.conf ]; then
  log "Starting Nginx reverse proxy..."
  nginx -c /app/configs/nginx.conf -g 'daemon off; error_log /app/logs/nginx_error.log warn;' &
  sleep 2
fi

log "✅ All services started (PIDs: app=$APP_PID)"

# Keep container running and monitor services
while true; do
  # Check if main app is still running
  if ! kill -0 $APP_PID 2>/dev/null; then
    log "❌ Node app crashed, restarting..."
    cd /app && node index.js &
    APP_PID=$!
  fi
  sleep 30
done
