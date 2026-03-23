# 🚀 DogeUnblocker v4.2 — Gaming Hub + Proxy Arsenal

**One-click access at school: 🎮 Gaming Hub • 🔗 UV Proxy • 🛡️ Health Status**

[![Docker Pulls](https://img.shields.io/docker/pulls/yourrepo/doge-unblocker)](https://hub.docker.com/r/yourrepo/doge-unblocker)
[![Status](https://img.shields.io/badge/status-production-green.svg)](https://dogeunblocker.org)

---

## 🎯 Quick-Access Buttons (Click to Launch)

**Note:** These work after you run `./deploy.sh` locally (on Chromebook or any machine).

| Service | Direct Link | Description |
|---------|-------------|-------------|
| 🎮 Gaming Dashboard | [http://localhost:8080](http://localhost:8080) | 50+ HTML5 games |
| 🔗 UV Web Proxy | [http://localhost:3000/](http://localhost:3000/) | DogeUnblocker app + Bare/UV proxies |
| 📡 HTTP Proxy | [http://localhost:8081](http://localhost:8081) | Privoxy HTTP proxy |
| ✅ Health Status | [http://localhost:8080/health](http://localhost:8080/health) | Proxy uptime + status |
| 🔐 Tor SOCKS | `127.0.0.1:9050` | Tor exit nodes (terminal only) |

---

## 🚀 Quick Start (60 Seconds)

### Step 1: Clone & Build

```bash
git clone https://github.com/noboyorg/no.git
cd no
docker build -t doge-unblocker .
```

### Step 2: Run (Chromebook-Friendly Ports) ✅ CORRECTED

```bash
# Stop any existing containers
docker stop doge 2>/dev/null || true
docker rm doge 2>/dev/null || true

# CORRECTED PORT MAPPING (matches actual container ports)
docker run -d --name doge \
  -p 8080:80 \
  -p 3000:8000 \
  -p 8081:3128 \
  -p 9050:9050 \
  -v ./logs:/app/logs -v ./proxies:/app/proxies \
  doge-unblocker
```

**Port Mapping Reference:**
- Host `8080` → Container `80` (Nginx homepage/games)
- Host `3000` → Container `8000` (UV proxy app)
- Host `8081` → Container `3128` (Privoxy HTTP proxy)
- Host `9050` → Container `9050` (Tor SOCKS5)

### Step 3: Click & Launch

- **School Access:** Open [http://localhost:8080](http://localhost:8080) in Chrome browser
- **Public Network:** Get your IP with `hostname -I` then share `http://<YOUR-IP>:8080`
- **Proxy:** Route through [http://localhost:3000/](http://localhost:3000/)

---

## 🌐 ChromeOS Port Forwarding (Critical!)

**Issue:** "Error Forwarding Port" or services inaccessible on ChromeOS?

**Fix:** Add manual port forwarding rules in ChromeOS Linux (Beta):
1. Go to **Settings** → **Linux (Beta)** → **Port Forwarding**
2. Add these rules:
   - Port `80/TCP` → `8080`
   - Port `8000/TCP` → `3000`
   - Port `3128/TCP` → `8081`
   - Port `9050/TCP` → `9050`
3. Restart Docker:
   ```bash
   docker stop doge 2>/dev/null || true
   docker rm doge 2>/dev/null || true
   # Then re-run the docker run command above
   ```

**Get Your Public IP (Share with Classmates):**
```bash
hostname -I | awk '{print $1}'    # Example: 192.168.1.105
# Share: http://192.168.1.105:8080
```

---

## 🔍 Search Engines (Via Proxy)
Access these through the UV proxy at `/uv/`:
- [Google](/uv/https://www.google.com)
- [Bing](/uv/https://www.bing.com)
- [DuckDuckGo](/uv/https://duckduckgo.com)
- [Startpage](/uv/https://www.startpage.com)
- [Brave Search](/uv/https://search.brave.com)
- [Ecosia](/uv/https://www.ecosia.org)
- [Qwant](/uv/https://www.qwant.com)
- [Yandex](/uv/https://yandex.com)

---

## 🎮 GeForce NOW Integration

**Direct Access:** [http://localhost:8080/geforce.html](http://localhost:8080/geforce.html)

Play AAA games through your proxy:
```bash
# Option 1: Using docker-compose (RECOMMENDED)
docker-compose up -d

# Option 2: Manual docker run (CORRECT PORT MAPPING)
docker run -d --name doge \
  -p 8080:80 -p 3000:8000 -p 8081:3128 -p 9050:9050 \
  -v ./logs:/app/logs -v ./proxies:/app/proxies \
  doge-unblocker

# Then access:
# 🏠 Homepage: http://localhost:8080
# 🔗 UV Proxy: http://localhost:3000/
# 🛠️ Health: http://localhost:8080/health
# 🎮 GeForce NOW: http://localhost:8080/geforce.html
```

**If GeForce NOW doesn't load:**
1. Clear browser cache: `Ctrl+Shift+Del`
2. Try accessing another site first through the proxy to warm it up
3. Check your network connection
4. Reload the page

---


## 🔧 Deployment Options

| Method | Command | Access |
|--------|---------|--------|
| Local (Chromebook) | `./deploy.sh` | [http://localhost:8080](http://localhost:8080) |
| Docker Compose | `docker-compose -f docker-compose.prod.yml up -d` | Auto port-forward |
| School Network | Share IP:PORT (if permitted) | `http://<your-ip>:8080` |

---

## 📁 Repository Structure

```
noboyorg/no/
├── 📄 README.md              ← This file
├── 🐳 docker-compose.yml     ← Multi-region setup
├── 🐳 docker-compose.prod.yml ← Production (Traefik)
├── 🛠️ tools/
│   ├── payloads.json         ← XSS/SSRF/Open Redirect payloads
│   ├── proxy-rotator.py      ← Auto-rotate proxies
│   ├── doge-pentest.py       ← Pentest scanner
│   └── waf-bypass.py         ← WAF evasion techniques
├── 📊 configs/
│   ├── nginx.conf            ← Reverse proxy config
│   ├── privoxy.conf          ← HTTP proxy filters
│   ├── torrc-fixed.conf      ← Tor configuration
│   ├── supervisord.conf      ← Process manager
│   └── pm2-uv.json           ← PM2 cluster config
├── 🎯 proxies.txt            ← Proxy list (starter)
└── 📜 Dockerfile             ← Multi-stage build

```

---

## 🎓 School Project Notes

- **Authorization:** All testing is authorized under your Terms of Service
- **Isolated:** Runs in Docker containers (no school network impact)
- **Ethical:** Proxy used for security testing & portfolio scraping (your own assets)

---

## ⚙️ Architecture Diagram

```
┌─────────────────┐    ┌──────────────────┐
│   🎮 Homepage   │───▶│   Nginx (80/443) │
│ 50+ HTML5 Games │    │   Static + Proxy │
└─────────────────┘    └──────┬───────────┘
                             │
                ┌────────────▼────────────┐
                │ PM2 Cluster (Node 20)   │
    ┌───────────▼──────────┐│ ┌──────────▼──────────┐
    │   UV Frontend        ││ │   Bare TCP/UDP      │
    │   /uv/ (Port 3000)   ││ │   /bare/ (8081)     │
    └──────────────────────┘│ └─────────────────────┘
                            │
┌───────────────────────────▼──────────────────┐
│ Proxy Rotator (10k+ HTTP/SOCKS5) + Tor       │
│ 99.9% Uptime • Auto-Testing • Proxychains    │
└──────────────────────────────────────────────┘
```

---

## 🛠️ Useful Commands

```bash
# Build image
docker build -t doge-unblocker .

# Run container (CORRECT Chromebook-compatible ports)
docker run -d --name doge \
  -p 8080:80 -p 3000:8000 -p 8081:3128 -p 9050:9050 \
  -v ./logs:/app/logs -v ./proxies:/app/proxies \
  doge-unblocker

# Check container is running
docker ps | grep doge

# Check logs (troubleshooting)
docker logs -f doge | tail -20

# Stop container
docker stop doge

# Remove container
docker rm doge

# Test endpoints
curl http://localhost:8080/health
curl http://localhost:3000/  # UV Proxy
curl -x http://localhost:8081 http://httpbin.org/ip  # Privoxy test
curl --socks5-hostname 127.0.0.1:9050 http://httpbin.org/ip  # Tor test

# Run deployment script (fixed)
./deploy-fixed.sh

# Update to latest
./update.sh

# Run healthcheck validation
./healthcheck.sh
```

---

## 🔗 Reference Links

- [UV Proxy Docs](https://github.com/titaniumnetwork-dev/Ultraviolet)
- [Bare Server Docs](https://github.com/tomphttp/bare-server)
- [Tor Network](https://www.torproject.org/)
- [ChromeOS Linux Container](https://support.google.com/chromebook/answer/9145439)

---

## ⚖️ Legal Disclaimer

This tool is for **educational and authorized testing purposes only**. Unauthorized access to computer systems is illegal. Always obtain explicit permission before testing any network or system.
