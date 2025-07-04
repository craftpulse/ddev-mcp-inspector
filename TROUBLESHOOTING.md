# Troubleshooting Guide - DDEV MCP Inspector

This guide helps resolve common issues with the DDEV MCP Inspector add-on.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Startup Problems](#startup-problems)
- [Connection Issues](#connection-issues)
- [Performance Issues](#performance-issues)
- [Network and SSL Issues](#network-and-ssl-issues)
- [Debug Commands](#debug-commands)

## Installation Issues

### Error: "ddev get" fails

**Symptom**: Installation fails with error message

**Solutions**:
```bash
# Update DDEV to latest version
brew upgrade ddev  # macOS
# or
sudo apt-get update && sudo apt-get upgrade ddev  # Linux

# Clear DDEV cache
ddev clean --all
ddev poweroff

# Try installation again
ddev get craftpulse/ddev-mcp-inspector
```

### Error: "docker-compose version mismatch"

**Symptom**: YAML parsing errors during installation

**Solution**:
```bash
# Check Docker Compose version
docker-compose version

# Update if needed
# Then retry installation
```

## Startup Problems

### MCP Inspector container keeps restarting

**Symptom**: Container shows "Restarting" status

**Debug steps**:
```bash
# Check container status
docker ps -a | grep mcp-inspector

# View detailed logs
ddev logs -s mcp-inspector --tail=100

# Check for npm errors
ddev exec -s mcp-inspector npm list
```

**Common fixes**:
1. Increase health check start period in `docker-compose.mcp-inspector.yaml`:
   ```yaml
   healthcheck:
     start_period: 60s  # Increase from 45s
   ```

2. Clear npm cache:
   ```bash
   ddev exec -s mcp-inspector npm cache clean --force
   ddev restart
   ```

### Service times out during startup

**Symptom**: "Service mcp-inspector is unhealthy" after `ddev restart`

**Solutions**:
```bash
# 1. Manual start with extended timeout
DDEV_HEALTHCHECK_TIMEOUT=180 ddev start

# 2. Check resource constraints
docker system df
docker system prune -a  # If low on space

# 3. Restart Docker daemon
# macOS: Restart Docker Desktop
# Linux: sudo systemctl restart docker
```

## Connection Issues

### Cannot access MCP Inspector UI

**Symptom**: Browser shows "Cannot reach this site"

**Diagnostics**:
```bash
# Test internal connectivity
ddev exec curl -v http://mcp-inspector:6274

# Check port binding
docker port ddev-${DDEV_SITENAME}-mcp-inspector

# Verify routing
ddev exec -s web ping mcp-inspector -c 3
```

**Solutions**:
1. Check DDEV router:
   ```bash
   ddev poweroff
   ddev start
   ```

2. Verify hostname resolution:
   ```bash
   # Add to /etc/hosts if needed
   127.0.0.1 yourproject.ddev.site
   ```

3. Try alternative URLs:
   - `http://yourproject.ddev.site:6274` (HTTP)
   - `https://mcp-inspector.yourproject.ddev.site` (subdomain)

### MCP server connection fails

**Symptom**: "Failed to connect to MCP server" in UI

**Debug MCP server**:
```bash
# Test MCP server directly
ddev exec npx @modelcontextprotocol/server-everything --version

# Check if server starts
ddev exec -s web node /path/to/server.js

# View server logs
ddev logs -s web --tail=50
```

**Common fixes**:
1. Ensure server is accessible from web container
2. Use full paths for local servers
3. Check server dependencies are installed

## Performance Issues

### Slow response times

**Solutions**:
1. Increase container resources:
   ```bash
   # In .ddev/config.yaml
   web_extra_exposed_ports:
   - name: mcp-inspector
     container_port: 6274
     host_port: 6274
   ```

2. Optimize Docker:
   ```bash
   # Increase Docker memory allocation
   # Docker Desktop > Settings > Resources
   ```

### High CPU usage

**Debug**:
```bash
# Monitor container resources
docker stats ddev-${DDEV_SITENAME}-mcp-inspector

# Check for runaway processes
ddev exec -s mcp-inspector top
```

## Network and SSL Issues

### SSL certificate errors

**Symptom**: Browser warning about invalid certificate

**Solutions**:
1. Trust DDEV's certificate authority:
   ```bash
   mkcert -install
   ddev poweroff && ddev start
   ```

2. Use HTTP as workaround:
   ```bash
   # Access via HTTP instead
   http://yourproject.ddev.site:6274
   ```

### Cross-Origin Resource Sharing (CORS) errors

**Fix**: Add CORS headers in docker-compose override:
```yaml
# .ddev/docker-compose.mcp-inspector_override.yaml
services:
  mcp-inspector:
    environment:
      - CORS_ORIGIN=*
```

## Debug Commands

### Essential debugging commands

```bash
# Service status
ddev describe
ddev status

# Container inspection
docker inspect ddev-${DDEV_SITENAME}-mcp-inspector

# Network debugging
ddev exec -s mcp-inspector netstat -tlnp
ddev exec -s mcp-inspector nslookup web

# File system check
ddev exec -s mcp-inspector ls -la /app
ddev exec -s mcp-inspector df -h

# Process list
ddev exec -s mcp-inspector ps aux

# Environment variables
ddev exec -s mcp-inspector env | grep -E "(MCP|DDEV|PORT)"
```

### Creating debug logs

```bash
# Capture full debug output
ddev logs -s mcp-inspector > mcp-debug.log
docker inspect ddev-${DDEV_SITENAME}-mcp-inspector >> mcp-debug.log
ddev describe >> mcp-debug.log
```

## Getting Additional Help

If these solutions don't resolve your issue:

1. **Collect debug information**:
   ```bash
   ddev debug test
   ddev version
   docker version
   ```

2. **Create detailed issue report**:
   - Include all debug output
   - List steps to reproduce
   - Mention your OS and versions

3. **Get help**:
   - [GitHub Issues](https://github.com/craftpulse/ddev-mcp-inspector/issues)
   - [DDEV Discord](https://discord.gg/hCZFfAMc5k)
   - [MCP Community](https://modelcontextprotocol.io/community)

## Known Issues

### Issue: First start takes longer than expected
- **Status**: Expected behavior
- **Workaround**: Wait 45-60 seconds on first start
- **Reason**: npm package installation

### Issue: Port 6274/6277 already in use
- **Solution**: Change ports in docker-compose.mcp-inspector.yaml
- **Example**:
  ```yaml
  environment:
    - CLIENT_PORT=7274
    - SERVER_PORT=7277
    - HTTP_EXPOSE=7274:7274,7277:7277
  ```

Remember to check the [CHANGELOG.md](CHANGELOG.md) for updates that might address your issue.