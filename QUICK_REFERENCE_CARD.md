# 🎯 Quick Reference Card - DogeUnblocker v4.2

## 🚀 Quick Commands

```bash
# Deploy
bash deploy-fixed.sh

# Check status
docker ps | grep doge

# View logs
docker logs -f doge

# Stop
docker stop doge

# Restart
docker restart doge

# Full reset
docker stop doge 2>/dev/null || true && docker rm doge 2>/dev/null || true && bash deploy-fixed.sh
```

---

## 🌐 Access Points (Localhost)

| Service | URL | Use Case |
|---------|-----|----------|
| 🏠 Games | http://localhost:8080 | Play 50+ HTML5 games |
| 🔗 Proxy | http://localhost:3000/ | Web-based UV proxy app |
| ✅ Health | http://localhost:8080/health | Check uptime |
| 🎮 GeForce | http://localhost:8080/geforce.html | Stream AAA games |
| 📡 HTTP | http://localhost:8081 | Privoxy (browser proxy) |
| 🔐 Tor | 127.0.0.1:9050 | SOCKS5 (terminal) |

---

## 🌍 Network Access (Replace X.X.X.X with your IP)

```bash
# Get your IP
hostname -I | awk '{print $1}'

# Share with classmates
http://X.X.X.X:8080          # Games
http://X.X.X.X:3000/         # Proxy  
http://X.X.X.X:8081 (proxy)  # HTTP
127.0.0.1:9050 (proxy)       # Tor
```

---

## 📱 ChromeOS Setup

**Settings → Linux (Beta) → Port Forwarding:**
- 80 → 8080
- 8000 → 3000
- 3128 → 8081
- 9050 → 9050

---

## 🛠️ Port Mapping Reference

```
Host:8080   ← → Container:80    (Nginx)
Host:3000   ← → Container:8000  (UV Proxy)
Host:8081   ← → Container:3128  (Privoxy)
Host:9050   ← → Container:9050  (Tor)
```

---

## 🧪 Browser Tests

```
✅ http://localhost:8080          # Homepage loads
✅ http://localhost:3000/         # UV Proxy loads
✅ http://localhost:8080/health   # Health page shows
🎮 http://localhost:8080/geforce.html  # GeForce loads
```

---

## 🔧 Tools Location

```
tools/doge-pentest.py      # Vulnerability scanner
tools/waf-bypass.py        # WAF evasion
tools/proxy-rotator.py     # Proxy rotation
tools/payloads.json        # Exploit payloads
```

---

## 🚨 Common Fixes

| Problem | Solution |
|---------|----------|
| Port in use | `docker stop doge && docker rm doge` |
| Can't access | Add ChromeOS port forwarding |
| Services slow | Wait 1-2 min for startup |
| Proxy failing | Check logs: `docker logs doge` |
| Games not loading | Clear cache: Ctrl+Shift+Del |

---

## ⚡ One-Liner Redeploy

```bash
docker stop doge 2>/dev/null || true && docker rm doge 2>/dev/null || true && cd /workspaces/no && bash deploy-fixed.sh
```

---

**Status:** ✅ Deployed & Running  
**Last Updated:** 2026-03-23
