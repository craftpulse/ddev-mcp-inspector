[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com)
[![tests](https://github.com/craftpulse/ddev-mcp-inspector/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/craftpulse/ddev-mcp-inspector/actions/workflows/tests.yml?query=branch%3Amain)
[![last commit](https://img.shields.io/github/last-commit/craftpulse/ddev-mcp-inspector)](https://github.com/craftpulse/ddev-mcp-inspector/commits)
[![release](https://img.shields.io/github/v/release/craftpulse/ddev-mcp-inspector)](https://github.com/craftpulse/ddev-mcp-inspector/releases/latest)

# DDEV MCP Inspector

## Overview

This add-on integrates [MCP (Model Context Protocol) Inspector](https://github.com/modelcontextprotocol/inspector) into your [DDEV](https://ddev.com/) project as a dedicated service, providing a web-based interface for testing and debugging MCP servers.

MCP Inspector runs as a dual-component system: a React UI (port 6274) and a Node.js proxy server (port 6277) that bridges browser communications to MCP servers using the appropriate transport protocol.

## Installation

```bash
ddev add-on get craftpulse/ddev-mcp-inspector
ddev restart
```

After installation, make sure to commit the `.ddev` directory to version control.

## Usage

| Command | Description |
| ------- | ----------- |
| `ddev mcp-inspector [server-command]` | Start MCP Inspector with optional server command |
| `ddev mcp-inspector` | Start MCP Inspector in standalone mode |
| `ddev mcp-stop` | Stop any running MCP Inspector processes |
| `ddev mcp-debug` | Debug MCP Inspector setup and connectivity |
| `ddev describe` | View service status and used ports |

### Examples

```bash
# Start with Craft CMS MCP server
ddev mcp-inspector php /var/www/html/cms/craft mcp/serve

# Start with Python MCP server
ddev mcp-inspector python my-mcp-server.py

# Start with Node.js MCP server
ddev mcp-inspector node my-mcp-server.js

# Start with custom working directory
ddev mcp-inspector --workdir=/var/www/html node my-mcp-server.js

# Start in standalone mode for manual server connection
ddev mcp-inspector
```

### Access

Once started, MCP Inspector will be available at:
- `http://localhost:6274` (Inspector UI - recommended)
- `http://127.0.0.1:6274` (alternative if localhost redirects)

**Architecture**: MCP Inspector runs as a dedicated Docker service with both the UI (port 6274) and proxy server (port 6277) properly configured for container networking.

## Advanced Customization

To change the exposed ports and networking configuration:

```bash
ddev dotenv set .ddev/.env.mcp-inspector --mcp-inspector-port="6275"
ddev dotenv set .ddev/.env.mcp-inspector --mcp-inspector-proxy-port="6278"
ddev dotenv set .ddev/.env.mcp-inspector --mcp-inspector-host="0.0.0.0"
ddev add-on get craftpulse/ddev-mcp-inspector
ddev restart
```

Make sure to commit the `.ddev/.env.mcp-inspector` file to version control.

All customization options (use with caution):

| Variable | Flag | Default | Purpose |
| -------- | ---- | ------- | ------- |
| `MCP_INSPECTOR_PORT` | `--mcp-inspector-port` | `6274` | Inspector UI port |
| `MCP_INSPECTOR_PROXY_PORT` | `--mcp-inspector-proxy-port` | `6277` | Proxy server port |
| `MCP_INSPECTOR_HOST` | `--mcp-inspector-host` | `0.0.0.0` | Network binding (must be 0.0.0.0 for containers) |

## Troubleshooting

### MCP Inspector Service Issues

If MCP Inspector is not starting or you see container errors:

1. **Check service status**:
   ```bash
   ddev describe
   ddev logs -s mcp-inspector
   ```

2. **Restart the service**:
   ```bash
   ddev restart
   ddev mcp-inspector php /var/www/html/cms/craft mcp/serve
   ```

3. **Debug the configuration**:
   ```bash
   ddev mcp-debug
   ```

### MCP Proxy Server Issues

If you see `ERR_EMPTY_RESPONSE` on port 6277 or proxy connection errors:

1. **Check container networking**:
   ```bash
   ddev exec -s mcp-inspector netstat -tlnp | grep 6277
   ```

2. **Verify environment variables**:
   ```bash
   ddev exec -s mcp-inspector printenv | grep -E "HOST|PORT"
   ```

3. **Check authentication tokens** (if enabled):
   ```bash
   ddev logs -s mcp-inspector | grep -i token
   ```

4. **Test your MCP server command directly**:
   ```bash
   ddev exec -s mcp-inspector php /var/www/html/cms/craft mcp/serve --help
   ```

### HTTPS Redirect Issues

If you're getting redirected to HTTPS or SSL errors:

1. **Use localhost** (recommended):
   ```
   http://localhost:6274
   ```

2. **Use IP address** if localhost redirects:
   ```
   http://127.0.0.1:6274
   ```

3. **Disable HTTPS redirect in browser** (if needed):
   - Clear browser cache/cookies for the domain
   - Use incognito/private browsing mode

**Why this happens**: DDEV's `.ddev.site` domains enforce HTTPS redirects, and browsers may have HSTS policies that force HTTPS on all subdomains.

### Port Already in Use

If ports 6274 or 6277 are already in use:

```bash
ddev mcp-stop
ddev restart
ddev mcp-inspector [your-server-command]
```

### Server Not Responding

Test your server command directly:

```bash
ddev exec php /var/www/html/cms/craft mcp/serve --help
```

### Inspector Not Accessible

Ensure DDEV is running properly:

```bash
ddev describe
ddev restart
```

## Credits

**Contributed and maintained by [@craftpulse](https://github.com/craftpulse)**