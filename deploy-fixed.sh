#!/bin/bash
set -e

echo "🚀 Deploying DogeUnblocker v4.2 (Fixed Ports)..."

# Cleanup
echo "⏹️  Stopping any existing containers..."
docker stop doge 2>/dev/null || true
docker rm doge 2>/dev/null || true

# Build
echo "🔨 Building image..."
docker build -t doge-unblocker .

# Run with CORRECTED port mapping
echo "🚀 Starting container..."
docker run -d --name doge \
  --restart unless-stopped \
  -p 8080:80 \
  -p 3000:8000 \
  -p 8081:3128 \
  -p 9050:9050 \
  -v ./logs:/app/logs \
  -v ./proxies:/app/proxies \
  doge-unblocker

# Give it time to start
sleep 3

# Verify
echo ""
echo "✅ Container deployed! Checking status..."
echo ""

echo "📊 Running health checks:"
echo "  🏠 Homepage: http://localhost:8080/health"
curl -s http://localhost:8080/health && echo "" || echo "❌ Homepage failed"

echo "  🔗 UV Proxy: http://localhost:3000/"
curl -s http://localhost:3000/ | head -5 && echo "" || echo "❌ UV Proxy failed"

echo "  📡 Privoxy: http://localhost:8081"
curl -s -x http://localhost:8081 http://httpbin.org/ip && echo "" || echo "❌ Privoxy failed"

echo "  🔐 Tor SOCKS: 127.0.0.1:9050"
curl -s --socks5-hostname 127.0.0.1:9050 http://httpbin.org/ip && echo "" || echo "❌ Tor failed"

echo ""
echo "🎯 Access Points:"
echo "   🏠 Dashboard: http://localhost:8080"
echo "   🔗 UV Proxy: http://localhost:3000/"
echo "   📡 HTTP Proxy: http://localhost:8081"
echo "   ✅ Health: http://localhost:8080/health"
echo "   🔐 Tor SOCKS: 127.0.0.1:9050"
echo "   🎮 GeForce NOW: http://localhost:8080/geforce.html"
echo ""
echo "📋 View logs: docker logs -f doge"
echo "🛑 Stop: docker stop doge"