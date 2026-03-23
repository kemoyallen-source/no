#!/bin/bash
echo "🚀 DogeUnblocker Codespace Full Reset..."

# Kill all
docker stop $(docker ps -q) 2>/dev/null || true
docker rm $(docker ps -a -q) 2>/dev/null || true
docker system prune -af

# PERFECT CODESPACE BUILD
docker build -t doge-unblocker .
docker run -d --name doge \
  --network host \
  -v $(pwd)/logs:/app/logs \
  -v $(pwd)/proxies:/app/proxies \
  doge-unblocker

echo "⏳ Waiting 30s for services..."
sleep 30

echo "📊 Status Check:"
docker logs doge --tail 15
echo ""
echo "🔗 LIVE URLS (All PUBLIC):"
echo "🏠 Dashboard:     https://improved-succotash-v6xwwgqjr7j4fw6vq-80.app.github.dev"
echo "🔗 UV Proxy:      https://improved-succotash-v6xwwgqjr7j4fw6vq-3000.app.github.dev/"
echo "🛠️ Backend:       https://improved-succotash-v6xwwgqjr7j4fw6vq-8000.app.github.dev/"
echo "📡 Privoxy:       https://improved-succotash-v6xwwgqjr7j4fw6vq-3128.app.github.dev"
echo "🎮 Games:         https://improved-succotash-v6xwwgqjr7j4fw6vq-8080.app.github.dev"
echo ""
echo "✅ All services deployed!"
