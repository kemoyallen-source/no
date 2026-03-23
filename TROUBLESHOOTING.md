# 🔧 Troubleshooting Guide - RangeError & Proxy Issues

## 🚨 Quick Diagnosis

### Step 1: Check Container Logs
```bash
docker logs doge --tail 30
```
Look for: `ERROR`, `FAILED`, `not starting`, `bind failed`

### Step 2: Verify Services Are Running
```bash
docker ps --filter name=doge --format "{{.Status}}"
# Should show: Up XXX (health: starting) or Up XXX
```

### Step 3: Check All Ports Are Listening
```bash
docker exec doge netstat -tulpn | grep LISTEN
# Should show:
# - Nginx on port 80
# - Node.js on port 8000  
# - Privoxy on port 3128
# - Tor on 9050 & 9051
```

### Step 4: Test Nginx is Proxying
```bash
docker exec doge sh -c 'echo -e "GET / HTTP/1.0\r\nHost: localhost\r\n\r\n" | nc -w2 localhost 80' | head -5
# Should return HTML (not 404)
```

### Step 5: Check Nginx Config is Loaded
```bash
docker exec doge ps aux | grep nginx
# Should show: nginx -c /app/configs/nginx.conf
```

---

## 🐛 Common Issues & Fixes

### Issue: RangeError (Status 0) in Browser
**Likely Cause:** Nginx not proxying correctly

**Diagnosis:**
```bash
# Check if Nginx is using custom config
docker exec doge ps aux | grep nginx

# Check Nginx error logs
docker exec doge cat /app/logs/nginx_error.log
```

**Fix:**
```bash
# Verify nginx.conf exists and is correct
docker exec doge cat /app/configs/nginx.conf | grep -E 'listen|proxy_pass'

# Should show:
# listen 80;
# proxy_pass http://uv_backend;
# server localhost:8000;
```

### Issue: Port Already in Use
**Symptom:** "Address already in use" or "Bind failed"

**Fix:**
```bash
# Kill old container
docker stop doge 2>/dev/null || true
docker rm doge 2>/dev/null || true

# Wait a moment
sleep 2

# Redeploy
bash deploy-fixed.sh
```

### Issue: Services Slow/Not Starting
**Symptom:** Container running but services not responding

**Fix:**
```bash
# Wait 30-60 seconds for full startup
sleep 30
docker logs doge | tail -5

# Services should show:
# ✅ All services started (PIDs: app=XX)
```

### Issue: Can't Access from Host
**Symptom:** Connection refused on localhost:8080

**Fix:**
```bash
# Check port mapping
docker port doge
# Should show: 80/tcp -> 0.0.0.0:8080

# Test from inside container
docker exec doge wget -qO- http://localhost:80/ | head -3

# If that works but host fails:
# Check firewall: sudo ufw status
```

### Issue: Nginx Returns 404
**Symptom:** "404 Not Found" when accessing http://localhost:8080

**Causes:**
1. Nginx not using custom config
2. Upstream (port 8000) not responding
3. Proxy headers misconfigured

**Fix:**
```bash
# Fix 1: Verify custom config is active
docker exec doge nginx -T | grep -A5 "listen 80"
# Should show our server block with proxy_pass

# Fix 2: Verify Node.js is running on 8000
docker exec doge netstat -tulpn | grep 8000
# Should show: :::8000 ... LISTEN ... node

# Fix 3: Test direct connection to Node.js
docker exec doge wget -qO- http://localhost:8000/ | head -3
# Should return HTML
```

### Issue: WebSocket Errors
**Symptom:** WebSocket connection failed

**Fix:**
```bash
# Verify proxy headers in nginx.conf
docker exec doge grep -A2 "Upgrade" /app/configs/nginx.conf

# Should have:
# proxy_set_header Upgrade $http_upgrade;
# proxy_set_header Connection 'upgrade';
```

---

## 🔄 Recovery Steps

### Nuclear Option: Full Reset
```bash
# Stop
docker stop doge 2>/dev/null || true
docker rm doge 2>/dev/null || true

# Verify removed
docker ps | grep doge || echo "✅ Removed"

# Clean
docker system prune -f

# Rebuild
docker build --no-cache -t doge-unblocker .

# Deploy
bash deploy-fixed.sh

# Verify
sleep 5
docker ps | grep doge
docker logs doge | tail -5
```

### Quick Restart
```bash
docker restart doge
sleep 3
docker logs doge | tail -5
```

### Check Everything
```bash
echo "=== Container Status ===" && \
docker ps --filter name=doge && \
echo "=== Ports ===" && \
docker port doge && \
echo "=== Listening Services ===" && \
docker exec doge netstat -tulpn | grep LISTEN && \
echo "=== Logs ===" && \
docker logs doge | tail -10
```

---

## ✅ Verification Checklist

When deployment is working, all of these should pass:

- [ ] `docker ps` shows doge container "Up"
- [ ] Port 8080 is mapped to container port 80
- [ ] Port 3000 is mapped to container port 8000
- [ ] Port 8081 is mapped to container port 3128
- [ ] Port 9050 is mapped to container port 9050
- [ ] Nginx process shows: `nginx -c /app/configs/nginx.conf`
- [ ] Node.js running on port 8000
- [ ] Privoxy running on port 3128
- [ ] Tor running on port 9050
- [ ] Nginx error log shows requests forwarded successfully
- [ ] `http://localhost:8080` returns HTML (not 404)
- [ ] Can access `http://localhost:3000/` directly
- [ ] `docker logs doge` shows "✅ All services started"

---

## 🆘 When All Else Fails

### Detailed Debugging
```bash
# Get full container info
docker inspect doge | jq . > doge-debug.json

# Get full logs
docker logs doge > doge-logs.txt 2>&1

# Get detailed port info
docker port doge > doge-ports.txt

# Get service status inside container
docker exec doge sh << 'EOF'
echo "=== Check Nginx ==="
ps aux | grep nginx
echo "=== Check Node.js ==="
ps aux | grep node
echo "=== Nginx Config Test ==="
nginx -c /app/configs/nginx.conf -t
echo "=== Ports Listening ==="
netstat -tulpn
EOF > doge-services.txt
```

### Share Debug Info
```bash
# Compress debug info
tar czf doge-debug.tar.gz doge-*.txt doge-*.json

# View what's in it
tar -tzf doge-debug.tar.gz
```

---

## 📞 Reference Links

- **Nginx Docs:** https://nginx.org/en/docs/
- **Reverse Proxy Guide:** https://nginx.org/en/docs/http/ngx_http_proxy_module.html
- **Docker Docs:** https://docs.docker.com/
- **DogeUnblocker:** https://github.com/DogeLeader/DogeUnblocker-v4

---

**Last Updated:** 2026-03-23  
**Fixed Issues:** RangeError (Status 0), Nginx 404, Port Mapping Conflicts
