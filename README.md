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
- **Client UI**: `https://<projectname>.ddev.site:6275`
- **Proxy Server**: `https://<projectname>.ddev.site:6278`

### Commands

Open MCP Inspector in browser:
```bash
ddev mcp-inspector
```

Check service status:
```bash
ddev mcp-inspector status
```

View service logs:
```bash
ddev mcp-inspector logs
```

### Connecting to MCP Servers

#### Option 1: Craft CMS MCP Plugin
If you have a Craft CMS project with the MCP plugin installed:

1. **In the MCP Inspector UI**, select **"STDIO"** transport
2. **Use this command**:
   ```bash
   docker exec -i ddev-YOUR-CRAFT-PROJECT-web craft mcp/serve
   ```
   Replace `YOUR-CRAFT-PROJECT` with your actual Craft project name.

3. **Alternative for same project**: If the MCP Inspector is in the same DDEV project as Craft:
   ```bash
   craft mcp/serve
   ```

#### Option 2: External MCP Servers
For other MCP servers running in DDEV containers:

1. **Node.js servers**:
   ```bash
   docker exec -i ddev-PROJECT-NAME-web node ./path/to/server.js
   ```

2. **Python servers**:
   ```bash
   docker exec -i ddev-PROJECT-NAME-web python ./path/to/server.py
   ```

### Container Communication

From within other DDEV containers, you can connect to:
- MCP Inspector Client UI: `http://mcp-inspector:6274`
- MCP Proxy Server: `http://mcp-inspector:6277`

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
- Exposes ports 6274 (Client UI) and 6277 (Proxy Server)
- HTTPS access via ports 6275 (Client UI) and 6278 (Proxy Server)
- Includes health checks for reliability
- Supports authentication bypass for development

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

**CORS errors when accessing proxy**:
- Ensure both client (6274) and proxy (6277) services are running
- Check logs: `ddev mcp-inspector logs`
- Restart the service: `ddev restart`
- The proxy server should accept CORS requests from the client

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