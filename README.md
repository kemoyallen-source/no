# 🚀 DogeUnblocker v4.2 - Gaming Hub + Proxy Arsenal

**50+ HTML5 Games • 10k+ Proxy Rotation • Tor Bridges • UV+Bare Stack • Dogecoin RPC Pentest**

[![Docker Pulls](https://img.shields.io/docker/pulls/yourrepo/doge-unblocker)](https://hub.docker.com/r/yourrepo/doge-unblocker)
[![Status](https://img.shields.io/badge/status-production-green.svg)](https://dogeunblocker.org)

## 🎮 Features

### Gaming Dashboard (`/`)
### 🔒 Pentest Arsenal
## 🚀 Quick Start (60 Seconds)

```bash
# 1. Clone + Build
git clone <this-repo>
cd doge-unblocker
docker build -t doge-unblocker.

# 2. Run (All ports exposed)
docker run -d --name doge --restart unless-stopped \
  -p 80:80 -p 443:443 -p 3000:3000 -p 8080:8080 -p 9050:9050 \
  -v ./logs:/app/logs -v ./proxies:/app/proxies \
  doge-unblocker

# 3. Access Dashboard
curl http://localhost/           # 🎮 Gaming Home
curl http://localhost/uv/        # 🔗 Web Proxy
curl http://localhost/health     # ✅ Status
┌─────────────────┐    ┌──────────────────┐
│   🎮 Homepage   │───▶│   Nginx (80/443) │
│ 50+ HTML5 Games │    │   Static + Proxy │
└─────────────────┘    └──────┬───────────┘
                             │
                ┌────────────▼────────────┐
                │ PM2 Cluster (Node 20)   │
    ┌───────────▼──────────┐│ ┌──────────▼──────────┐
    │   UV Frontend        ││ │   Bare TCP/UDP      │
    │   /uv/ (Port 3001)   ││ │   /bare/ (8080)     │
    └──────────────────────┘│ └─────────────────────┘
                            │
┌───────────────────────────▼──────────────────┐
│ Proxy Rotator (10k+ HTTP/SOCKS5) + Tor       │
│ 99.9% Uptime • Auto-Testing • Proxychains    │
└──────────────────────────────────────────────┘
