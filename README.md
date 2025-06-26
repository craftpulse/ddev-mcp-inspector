[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com)
[![tests](https://github.com/craftpulse/ddev-mcp-inspector/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/craftpulse/ddev-mcp-inspector/actions/workflows/tests.yml?query=branch%3Amain)
[![last commit](https://img.shields.io/github/last-commit/craftpulse/ddev-mcp-inspector)](https://github.com/craftpulse/ddev-mcp-inspector/commits)
[![release](https://img.shields.io/github/v/release/craftpulse/ddev-mcp-inspector)](https://github.com/craftpulse/ddev-mcp-inspector/releases/latest)

# DDEV MCP Inspector

## Overview

This add-on integrates [MCP (Model Context Protocol) Inspector](https://github.com/modelcontextprotocol/inspector) into your [DDEV](https://ddev.com/) project, providing a web-based interface for testing and debugging MCP servers.

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
| `ddev describe` | View service status and used ports |

### Examples

```bash
# Start with Craft CMS MCP server
ddev mcp-inspector php /var/www/html/cms/craft mcp/serve

# Start with Python MCP server
ddev mcp-inspector python my-mcp-server.py

# Start with Node.js MCP server
ddev mcp-inspector node my-mcp-server.js

# Start in standalone mode for manual server connection
ddev mcp-inspector
```

### Access

Once started, MCP Inspector will be available at:
- `http://localhost:6274` (from your host machine)
- `https://your-project.ddev.site:6274` (via DDEV's HTTPS proxy)

## Advanced Customization

To change the exposed port:

```bash
ddev dotenv set .ddev/.env.mcp-inspector --mcp-inspector-port="6275"
ddev add-on get craftpulse/ddev-mcp-inspector
ddev restart
```

Make sure to commit the `.ddev/.env.mcp-inspector` file to version control.

All customization options (use with caution):

| Variable | Flag | Default |
| -------- | ---- | ------- |
| `MCP_INSPECTOR_PORT` | `--mcp-inspector-port` | `6274` |
| `MCP_INSPECTOR_HOST` | `--mcp-inspector-host` | `0.0.0.0` |

## Troubleshooting

### Port Already in Use

If port 6274 is already in use:

```bash
ddev mcp-stop
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