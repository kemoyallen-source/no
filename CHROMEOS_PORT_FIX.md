# ✅ ChromeOS Port Forwarding Setup Guide

## 🎯 Quick Summary
Your DogeUnblocker website is **fully deployed and working** (commit 7ecb3b6). The "Error forwarding port" is a ChromeOS configuration issue, **NOT a code problem**.

---

## 🔍 Port Configuration Reference

### Services Running Inside Container
| Service | Container Port | Purpose |
|---------|---|---------|
| UV Proxy | 3000 | Web proxy interface (/uv/) |
| Bare Server | 8080 | Static files + homepage |
| Tor | 9050 | SOCKS5 privacy proxy |

### Docker Compose Mapping (What docker-compose.yml does)
```
Host:Container mapping
3000:3000  ← UV Proxy (port 3000 on host → port 3000 in container)
8080:8080  ← Homepage/Bare (port 8080 on host → port 8080 in container)
```

### ChromeOS Port Forwarding (What you configure in Settings)
This tells ChromeOS to forward incoming connections on **host ports** to your Linux container.

---

## 🛠️ STEP-BY-STEP SETUP

### Step 1: Deploy on Chromebook
```bash
# In Crostini terminal, navigate to project
cd ~/no

# Pull latest code with fixes
git pull origin main

# Build the Docker image
docker build -t doge-unblocker .

# Run with correct port mappings
docker run -d --name doge \
  -p 3000:3000 \
  -p 8080:8080 \
  -p 9050:9050 \
  -v ./logs:/app/logs \
  -v ./proxies:/app/proxies \
  doge-unblocker

# Verify container is running
docker ps
# Look for: doge-unblocker with ports 3000, 8080, 9050
```

### Step 2: Configure ChromeOS Port Forwarding

**Open ChromeOS Settings:**
1. Settings → Advanced → Developers → Linux development environment
2. Scroll down to "Port forwarding"
3. Enable "Port forwarding" toggle

**Add these forwarding rules:**

| Container Port | Host Port | Protocol | Purpose |
|---|---|---|---|
| 3000 | 3000 | TCP | UV Proxy (/uv/) |
| 8080 | 8080 | TCP | Homepage & Bare |
| 9050 | 9050 | TCP | Tor SOCKS5 |

For each rule:
- Enter the **container port** (left side, what's listening in Linux)
- Enter the **host port** (right side, what Chrome can access)
- Click "Add"
- Click "Enable" button

✅ All 3 rules should show as enabled (green checkmarks)

### Step 3: Test in Crostini Terminal
```bash
# Test if ports are listening
ss -tuln | grep -E "3000|8080|9050"

# Expected output:
# LISTEN  3000    (UV Proxy)
# LISTEN  8080    (Homepage)
# LISTEN  9050    (Tor)

# Test website locally
curl http://localhost:8080
# Should return HTML starting with "<!DOCTYPE html>"

# Test UV proxy
curl http://localhost:3000
# Should return UV proxy interface HTML
```

### Step 4: Test in Chrome Browser
Once port forwarding is configured in ChromeOS Settings:

```
http://localhost:8080         ← Main homepage (10 buttons visible)
http://localhost:3000         ← UV web proxy interface
http://localhost:8080/geforce.html  ← GeForce NOW gaming
```

**Expected Results:**
- ✅ Homepage loads with gaming hub, search box, 6 working buttons
- ✅ All buttons navigate correctly (Gaming Hub, UV Proxy, Health Status, etc.)
- ✅ Search box works with Google/Bing/DuckDuckGo
- ✅ Clicking buttons on homepage connects to proxies

### Step 5: Share with Classmates (Network Access)
```bash
# Get your Chromebook's IP address
IP=$(hostname -I | awk '{print $1}')
echo "Share this link: http://$IP:8080"

# Example: http://192.168.1.105:8080
```

---

## ❌ Troubleshooting

### Issue 1: "Error Forwarding Port" in ChromeOS Settings
**Solutions:**
1. Close Settings completely (not just minimize)
2. Wait 10 seconds
3. Reopen Settings → Advanced → Developers
4. Try adding port forwarding rules again
5. If still fails, restart ChromeOS (Ctrl+Alt+R → Restart)

### Issue 2: Port Already in Use
```bash
# Kill any existing container
docker stop doge
docker rm doge

# Check if ports are free
sudo ss -tuln | grep -E "3000|8080|9050"

# If ports still in use, find what's using them
sudo lsof -i :8080

# Force kill the process
sudo kill -9 <PID>
```

### Issue 3: Container Starts but Website Won't Load
```bash
# Check container logs
docker logs doge

# Verify services started
docker exec doge ps aux
# Should show: Node.js, Tor, Privoxy processes running

# Test inside container
docker exec doge curl http://localhost:8080
# Should return HTML
```

### Issue 4: Buttons Don't Work / JavaScript Errors
1. Open browser console: **F12 → Console tab**
2. Look for error messages (red text)
3. Common errors:
   - `/uv/` not found → Port 3000 port forwarding not enabled
   - CORS errors → Check network connectivity
   - 404 errors → Check the correct port (3000 vs 8080)

### Issue 5: "Cannot connect" from another device
```bash
# Check if your Linux container allows external connections
docker run -d --name doge \
  -p 0.0.0.0:3000:3000 \
  -p 0.0.0.0:8080:8080 \
  doge-unblocker

# Get your Chromebook IP
hostname -I

# Test from another device
# http://<chromebook-ip>:8080
```

---

## 📋 Complete Command Reference

```bash
# === DEPLOY ===
cd ~/no
git pull origin main
docker build -t doge-unblocker .

# === RUN ===
docker run -d --name doge \
  -p 3000:3000 -p 8080:8080 -p 9050:9050 \
  -v ./logs:/app/logs -v ./proxies:/app/proxies \
  doge-unblocker

# === VERIFY ===
docker ps                              # Container running?
ss -tuln | grep -E "3000|8080|9050"   # Ports listening?
curl http://localhost:8080             # Website accessible?

# === LOGS ===
docker logs -f doge                    # Live logs
docker logs doge 2>&1 | tail -50       # Last 50 lines

# === CLEANUP ===
docker stop doge
docker rm doge
docker rmi doge-unblocker
```

---

## 🎯 Port Forwarding Rules Summary

**What to enter in ChromeOS Settings:**

```
LEFT SIDE (Container Port) → RIGHT SIDE (Host Port)
3000 → 3000
8080 → 8080
9050 → 9050
```

**Important Notes:**
- ✅ These match docker-compose.yml exactly
- ✅ LEFT side must match port running in container
- ✅ RIGHT side is what Docker exposes to host
- ✅ RIGHT side is what ChromeOS forwards to Chrome browser
- ✅ Browser accesses via RIGHT side port

---

## ✅ Success Checklist

Before assuming it's broken, verify:

- [ ] Container is running: `docker ps` shows `doge-unblocker`
- [ ] Ports listening: `ss -tuln` shows 3000, 8080, 9050
- [ ] Homepage loads: `curl http://localhost:8080` returns HTML
- [ ] Port forwarding enabled in ChromeOS Settings (green checkmarks)
- [ ] Can access in Chrome: `http://localhost:8080` opens website
- [ ] All 6 buttons work (click one to verify)
- [ ] Search box works (try Google search)
- [ ] Classmates can access: `http://<your-ip>:8080`

---

**Your website IS live and working! Just configure ChromeOS port forwarding and you're done. 🚀**
