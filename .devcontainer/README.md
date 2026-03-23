# GitHub Codespaces Configuration

This directory contains the GitHub Codespaces development container configuration for DogeUnblocker.

## 📋 What This Does

- **Auto-forwards ports 3000, 8080, 8081, 9050** from the container
- **Makes ports PUBLIC** by default (no GitHub login required)
- **Auto-starts DogeUnblocker** after devcontainer initializes
- **Installs Docker** for running the UV proxy stack

## 🚀 Quick Start

### 1. Create Codespace from This Repo
```
GitHub → This Repo → Code → Create Codespace on Main
```

### 2. Wait for Initialization
- Container builds (~2-3 minutes)
- DogeUnblocker Docker container starts
- Services initialize (Nginx, Node.js, Privoxy, Tor)

### 3. Access Your Services
In VS Code **Ports** tab, you'll see:
- **Port 8080** (Dashboard) - Label: "Gaming Dashboard"
- **Port 3000** (UV Proxy) - Label: "UV Proxy Web App"  
- **Port 8081** (Privoxy) - Label: "Privoxy HTTP Proxy"
- **Port 9050** (Tor) - Label: "Tor SOCKS5"

### 4. Make Ports Public (1 Click)
Right-click any port → **"Change Label"** → Choose **"Public"**

Or click the globe icon 🌐 for instant public access.

## 📡 Public URLs Format

Once ports are public, you'll get URLs like:
```
https://username-codespace-abc123-8080.app.github.dev/
https://username-codespace-abc123-3000.app.github.dev/
https://username-codespace-abc123-8081.app.github.dev/
https://username-codespace-abc123-9050.app.github.dev/
```

🔗 **Share these URLs with classmates** - no login required!

## 🔧 Configuration Files

### `devcontainer.json`
- Defines container environment
- Port forwarding settings
- Auto-public port configuration
- VS Code extensions to install
- Runs `post-create.sh` after setup

### `post-create.sh`
- Checks Docker is running
- Builds DogeUnblocker image
- Starts container with correct port mappings
- Displays access information

### `Dockerfile`
- Ubuntu base image
- Installs Docker, Node.js, utilities
- Prepares environment for deployment

## 🧪 Testing

### Access Services
```bash
# From VS Code terminal or external URL
curl http://localhost:8080/
curl http://localhost:3000/
curl -x http://localhost:8081 http://httpbin.org/ip
```

### View Logs
```bash
docker logs -f doge
```

### Check Services
```bash
docker ps
docker port doge
```

## 🆘 Troubleshooting

### Ports Not Showing in Ports Tab
1. Make sure ports are bound to 0.0.0.0 (not just localhost)
2. Check `devcontainer.json` has `"requireLocalPort": false`
3. Restart Codespace: Command Palette → "Codespaces: Rebuild Container"

### RangeError (Status 0) Error
**Solution:** Make port **PUBLIC**
1. Ports tab → Right-click port 3000
2. Select "Make Public"
3. Refresh browser

### Container Won't Start
```bash
# Check Docker
docker info

# Restart Docker
sudo service docker restart

# Manual deploy
bash deploy-fixed.sh
```

### Builds Takes Too Long
- First build: 3-5 minutes (normal)
- Subsequent: ~30 seconds
- Base image caching helps

## 📚 Reference

- [GitHub Codespaces Containers](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration)
- [devcontainer.json Reference](https://containers.dev/implementors/json_reference/)
- [Forwarding Ports in Codespaces](https://docs.github.com/en/codespaces/developing-in-codespaces/forwarding-ports-in-your-codespace)

## 🎯 Next Steps

1. ✅ Wait for container to build
2. ✅ Make ports public in Ports tab
3. ✅ Access services via public URLs
4. ✅ Share URLs with classmates
5. ✅ Monitor with: `docker logs -f doge`

---

**Generator:** GitHub Copilot + DogeUnblocker  
**Date:** 2026-03-23  
**Tested:** ✅ GitHub Codespaces Ubuntu
