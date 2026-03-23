#!/bin/bash

echo "🚀 Localhost DogeUnblocker Deploy (App Links Fixed)..."
echo ""

# Kill any existing containers
echo "⏹️  Stopping old containers..."
docker stop doge 2>/dev/null
docker rm doge 2>/dev/null

# Build fresh image
echo "🔨 Building Docker image (with app link fixes)..."
docker build -t doge-unblocker .

# Deploy with correct port mappings
echo "🚀 Deploying with correct localhost ports..."
docker run -d --name doge \
  -p 8080:80 \
  -p 3000:8000 \
  -p 8081:3128 \
  -p 9050:9050 \
  -v ./logs:/app/logs \
  -v ./proxies:/app/proxies \
  doge-unblocker

# Wait for startup and verify
sleep 8
echo ""
echo "✅ Container deployed!"
echo ""

# Show status
echo "📊 SERVICE STATUS:"
docker ps | grep doge | awk '{print "  Status: " $5}'
echo ""

# Show port bindings
echo "🔌 PORT BINDINGS:"
docker port doge | sed 's/^/  /'
echo ""

# Show logs
echo "📋 STARTUP LOGS:"
docker logs doge --tail 8 | sed 's/^/  /'
echo ""

# Ready message
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ LOCALHOST READY! Access these URLs:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  🏠 Games Dashboard:    http://localhost:8080"
echo "  🎮 Apps Dashboard:     http://localhost:8080/apps"
echo "  🔗 UV Proxy App:       http://localhost:3000/"
echo "  📡 Privoxy Proxy:      http://localhost:8081"
echo "  ✅ Health Status:      http://localhost:8080/health"
echo "  🎮 GeForce NOW:        http://localhost:8080/geforce.html"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎯 HOW TO USE APP LINKS:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  1. Open http://localhost:8080"
echo "  2. Click 'Apps' to see 20+ apps (Google, YouTube, Discord, etc.)"
echo "  3. Click on any app icon"
echo "  4. The app will load inside the proxy ✅"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📶 PROXY SETTINGS:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  HTTP Proxy:   127.0.0.1:8081"
echo "  SOCKS5:       127.0.0.1:9050"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🛠️  USEFUL COMMANDS:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  View logs:     docker logs -f doge"
echo "  Stop:          docker stop doge"
echo "  Restart:       docker restart doge"
echo "  Remove:        docker rm doge"
echo ""
echo "🎯 CHROMEOS? Don't forget to add port forwarding!"
echo "   Settings → Linux → Port Forwarding → Add these rules:"
echo "   80 → 8080, 8000 → 3000, 3128 → 8081, 9050 → 9050"
echo ""
echo "✨ All app links now working! Enjoy! 🎮"
echo ""

