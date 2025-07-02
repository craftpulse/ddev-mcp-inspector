# DDEV MCP Inspector Add-on

This add-on runs the Model Context Protocol (MCP) Inspector in its own container within your DDEV environment.

## What is MCP Inspector?

The MCP Inspector is a developer tool for testing and debugging Model Context Protocol servers. It provides:
- A visual UI for interacting with MCP servers
- Support for STDIO, SSE, and Streamable HTTP protocols
- Tool execution and testing capabilities
- Resource browsing and prompt testing

## Installation

```bash
ddev get craftpulse/ddev-mcp-inspector
ddev restart
```

## Usage

### Access MCP Inspector

After installation, MCP Inspector is available at:
- **UI**: `https://<projectname>.ddev.site:6274`
- **Proxy**: `https://<projectname>.ddev.site:6277`

Alternative URL:
- `https://mcp-inspector.<projectname>.ddev.site`

### Commands

Show connection information:
```bash
ddev mcp-inspector
```

Connect to an MCP server:
```bash
ddev mcp-connect npx @modelcontextprotocol/server-everything
```

### Testing MCP Servers

1. Place your MCP server code in your project directory
2. Use `ddev mcp-connect` to run your server:
   ```bash
   ddev mcp-connect node ./my-mcp-server/index.js
   ```

### Container Communication

From within other DDEV containers, you can connect to:
- MCP Inspector UI: `http://mcp-inspector:6274`
- MCP Proxy: `http://mcp-inspector:6277`

## Examples

### Testing a Local MCP Server

```bash
# Create a simple MCP server
mkdir my-mcp-server
cd my-mcp-server
npm init -y
npm install @modelcontextprotocol/sdk

# Create your server implementation
# Then connect it to the inspector
ddev mcp-connect node ./my-mcp-server/index.js
```

### Testing External MCP Servers

In the MCP Inspector UI:
1. Select the transport type (SSE or Streamable HTTP)
2. Enter the server URL
3. Click Connect

## Technical Details

- Runs in a dedicated container: `ddev-<projectname>-mcp-inspector`
- Based on Node.js 22 Alpine image
- Exposes ports 6274 (UI) and 6277 (Proxy)
- Includes health checks for reliability
- Supports both HTTP and HTTPS access
- Persistent data volume for configurations

## Configuration

The MCP Inspector can be configured through environment variables in `.ddev/docker-compose.mcp-inspector.yaml`:

```yaml
environment:
  - CLIENT_PORT=6274
  - SERVER_PORT=6277
  - MCP_SERVER_REQUEST_TIMEOUT=10000
  - MCP_REQUEST_TIMEOUT_RESET_ON_PROGRESS=true
  - MCP_REQUEST_MAX_TOTAL_TIMEOUT=60000
```

## Troubleshooting

### Check Service Status

```bash
# View logs
ddev logs -s mcp-inspector

# Check if container is running
docker ps | grep mcp-inspector

# Test internal connectivity
ddev exec curl http://mcp-inspector:6274
```

### Common Issues

**Service not starting**: 
- Wait 30-45 seconds for initialization
- Check logs for npm install errors
- Ensure ports 6274 and 6277 are not in use

**Cannot access UI**:
- Verify DDEV router is running: `ddev poweroff && ddev start`
- Check SSL certificate trust for HTTPS access
- Try HTTP access as fallback

**Connection errors**:
- Ensure MCP server is running in DDEV environment
- Use internal hostnames for container-to-container communication
- Check network connectivity between containers

### Restart the Service

```bash
ddev restart
```

## Development

### Customizing the Inspector

To use a custom MCP Inspector build:

1. Place your inspector source in `.ddev/mcp-inspector-src/`
2. Modify the package.json as needed
3. Restart DDEV

### Adding MCP Servers

Place MCP servers in your project and reference them:
```bash
ddev mcp-connect node /var/www/html/path/to/server.js
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Test with `bats tests/test.bats`
4. Submit a pull request

## License

MIT License

## Credits

- [Model Context Protocol](https://modelcontextprotocol.io/)
- [MCP Inspector](https://github.com/modelcontextprotocol/inspector)
- [DDEV](https://ddev.com/)