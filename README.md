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

### Step 2: Run (Chromebook-Friendly Ports)

```bash
docker run -d --name doge \
  -p 8080:80 -p 3000:8000 -p 8081:3128 -p 9050:9050 \
  -v ./logs:/app/logs -v ./proxies:/app/proxies \
  doge-unblocker
```

**Port Mapping Reference:**
- Host `8080` → Container `80` (Nginx public interface)
- Host `3000` → Container `8000` (DogeUnblocker app)
- Host `8081` → Container `3128` (Privoxy)
- Host `9050` → Container `9050` (Tor SOCKS)

### Step 3: Click & Launch

- **School Access:** Open [http://localhost:8080](http://localhost:8080) in Chrome browser
- **Public Network:** Get your IP with `hostname -I` then share `http://<YOUR-IP>:8080`
- **Proxy:** Route through [http://localhost:3000/](http://localhost:3000/)

---

## 🌐 ChromeOS Port Forwarding (Critical!)

**Issue:** "Error Forwarding Port"?

**Fix:** Add manual port forwarding rules in ChromeOS:
1. Go to **Settings** → **Linux development environment** → **Port forwarding**
2. Add these rules:
   - Container `80` → Host `8080` (TCP) ✅
   - Container `3000` → Host `3000` (TCP) ✅
   - Container `8080` → Host `8081` (TCP) ✅
   - Container `9050` → Host `9050` (TCP) ✅
3. Restart Docker:
   ```bash
   docker stop doge && docker rm doge
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

# Option 2: Manual docker run
docker run -d --name doge \
  -p 3000:3000 -p 8080:8080 -p 9050:9050 \
  -v ./logs:/app/logs -v ./proxies:/app/proxies \
  doge-unblocker

# Then access:
# Homepage: http://localhost:8080
# UV Proxy: http://localhost:3000
# GeForce NOW: http://localhost:8080/geforce.html
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

# Run container (Chromebook-compatible)  
docker run -d --name doge \
  -p 3000:3000 -p 8080:8080 -p 9050:9050 \
  -v ./logs:/app/logs -v ./proxies:/app/proxies \
  doge-unblocker

# Check logs
docker logs -f doge

# Stop container
docker stop doge

# Health check
curl http://localhost:8080/health

# Run deployment script
./deploy.sh

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
