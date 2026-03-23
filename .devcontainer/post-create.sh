#!/bin/bash
set -e

echo "🚀 DogeUnblocker - Codespaces Post-Create Setup"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "⚠️  Docker not running. Starting Docker..."
    sudo service docker start || true
    sleep 3
fi

# Check if container already running
if docker ps --filter name=doge --quiet | grep -q .; then
    echo "✅ Container already running"
    docker ps --filter name=doge --format "table {{.Names}}\t{{.Status}}"
else
    echo "🔨 Building DogeUnblocker image..."
    docker build -t doge-unblocker .
    
    echo "🚀 Starting container with correct port mappings..."
    docker run -d --name doge \
      --restart unless-stopped \
      -p 8080:80 \
      -p 3000:8000 \
      -p 8081:3128 \
      -p 9050:9050 \
      -v ./logs:/app/logs \
      -v ./proxies:/app/proxies \
      doge-unblocker
fi

# Display access information
echo ""
echo "✅ Setup Complete! Access your services:"
echo ""
echo "🎯 PUBLIC CODESPACES URLS:"
CODESPACE_NAME=$(echo $CODESPACE_NAME | cut -d- -f1-8)
if [ ! -z "$CODESPACE_NAME" ]; then
    echo "  🏠 Dashboard:     https://${CODESPACE_NAME}-8080.app.github.dev"
    echo "  🔗 UV Proxy:      https://${CODESPACE_NAME}-3000.app.github.dev"
    echo "  📡 HTTP Proxy:    https://${CODESPACE_NAME}-8081.app.github.dev:8081"
    echo "  🔐 Tor SOCKS5:    ${CODESPACE_NAME}-9050.app.github.dev:9050"
else
    echo "  (Codespace details not available - use VS Code Ports tab)"
fi

echo ""
echo "💡 TIPS:"
echo "  • Make ports PUBLIC in Ports tab (gear icon → Public)"
echo "  • View logs: docker logs -f doge"
echo "  • Test proxy: curl -x http://localhost:8081 http://httpbin.org/ip"
echo "  • Stop: docker stop doge"
echo ""
