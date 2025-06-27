# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.1] - 2025-02-16

### Fixed
- Fixed "unbound variable" error when running `ddev mcp-inspector` without arguments
- Added upgrade instructions for migrating from 0.1.x to 0.2.x
- Improved error handling in command scripts

## [0.2.0] - 2025-02-15

### Changed
- **BREAKING CHANGE**: Complete architectural rewrite to dedicated Docker service
- MCP Inspector now runs as dedicated Docker service instead of extending web container
- Replace web container extension with dedicated mcp-inspector service
- Add proper container networking with HOST=0.0.0.0 binding
- Implement container-specific environment variable configuration
- Add CLIENT_PORT and SERVER_PORT environment variables for MCP Inspector
- Configure ALLOWED_ORIGINS for proper CORS handling
- Rewrite all commands to use dedicated service (ddev exec -s mcp-inspector)
- Remove npm global installation in favor of container-based approach
- Enhance debugging with container-specific diagnostics
- Add proper process management and cleanup in service context
- Update docker-compose to use Node.js Alpine image with proper volumes
- Implement container-aware port connectivity testing

### Added
- New `--workdir` parameter to specify custom working directory for server commands
- Port availability check before starting MCP Inspector
- Improved process management with verification
- Version information display when starting
- Enhanced error handling for server commands with validation
- Updated documentation for new features

### Fixed
- Resolves ERR_EMPTY_RESPONSE errors by ensuring MCP Inspector's proxy server properly binds to all interfaces and is accessible through DDEV's networking

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

[0.2.1]: https://github.com/craftpulse/ddev-mcp-inspector/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/craftpulse/ddev-mcp-inspector/compare/v0.1.3...v0.2.0
[0.1.3]: https://github.com/craftpulse/ddev-mcp-inspector/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/craftpulse/ddev-mcp-inspector/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/craftpulse/ddev-mcp-inspector/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/craftpulse/ddev-mcp-inspector/releases/tag/v0.1.0