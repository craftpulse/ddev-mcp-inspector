# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.3] - 2025-01-27

### Added
- Port 6277 exposure for MCP Inspector's internal proxy server
- `MCP_INSPECTOR_PROXY_PORT` environment variable for proxy port configuration

## [0.1.2] - 2025-01-27

### Fixed
- Removed unsupported `--host` and `--port` CLI options that caused ERR_PARSE_ARGS_INVALID_OPTION_VALUE errors
- Simplified command execution to use MCP Inspector's default behavior

## [0.1.1] - 2025-01-27

### Fixed
- Resolved MCP Inspector argument parsing error when running with server commands
- Fixed ERR_PARSE_ARGS_INVALID_OPTION_VALUE error by adding proper `--` separator between inspector options and server command
- Improved error handling and debugging output for troubleshooting
- Enhanced help functionality to show both local and MCP Inspector CLI help

## [0.1.0] - 2025-01-27

### Added
- Initial release of DDEV MCP Inspector Add-on
- Web interface for testing and debugging MCP servers locally
- Support for Craft CMS, Python, Node.js, and other MCP server implementations
- Custom DDEV commands: `ddev mcp-inspector` and `ddev mcp-stop`
- Port exposure on 6274 (configurable via environment variables)
- Comprehensive BATS test suite
- GitHub Actions CI/CD workflow
- Environment variable support for customization:
  - `MCP_INSPECTOR_PORT` (default: 6274)
  - `MCP_INSPECTOR_HOST` (default: 0.0.0.0)

[0.1.1]: https://github.com/craftpulse/ddev-mcp-inspector/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/craftpulse/ddev-mcp-inspector/releases/tag/v0.1.0

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).