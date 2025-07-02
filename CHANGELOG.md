# Changelog

All notable changes to the DDEV MCP Inspector add-on will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0-beta.1] - 2025-01-02

### Added
- Initial beta release of DDEV MCP Inspector add-on
- Docker container configuration for MCP Inspector
- Support for both HTTP and HTTPS access
- `ddev mcp-inspector` command for connection information
- `ddev mcp-connect` command for connecting to MCP servers
- Health checks for reliable service startup
- Comprehensive test suite using Bats
- Support for STDIO, SSE, and Streamable HTTP protocols
- Persistent data volume for configurations
- Alternative hostname access via mcp-inspector subdomain

### Technical Details
- Based on Node.js 22 Alpine image
- MCP Inspector UI on port 6274
- MCP Proxy server on port 6277
- 45-second startup period for health checks
- Automatic npm package installation

### Documentation
- Comprehensive README with examples
- Contributing guidelines
- MIT License
- Troubleshooting guide
- Quick start guide
- Example MCP server implementation

### Known Issues (Beta)
- First container start may take 45-60 seconds for npm installation
- Health checks may occasionally timeout on slower systems
- Some MCP server types may require additional configuration

## [1.0.0] - TBD

### Planned for Stable Release
- Performance optimizations for faster startup
- Enhanced error handling and recovery
- Additional MCP server examples
- Automated testing for more MCP server types
- Improved health check reliability

## Version Guidelines

### Version Numbering
- MAJOR version: Incompatible changes, DDEV version requirement changes
- MINOR version: New features, backwards compatible
- PATCH version: Bug fixes, documentation updates

### Beta Releases
- Beta versions use the format: X.Y.Z-beta.N
- Beta releases may have breaking changes between versions
- Not recommended for production use
- Feedback and bug reports are highly encouraged

### Release Checklist
- [ ] All tests passing
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Version bumped in relevant files
- [ ] GitHub release created
- [ ] Tagged with version number

---

[Unreleased]: https://github.com/craftpulse/ddev-mcp-inspector/compare/1.0.0-beta.1...HEAD
[1.0.0-beta.1]: https://github.com/craftpulse/ddev-mcp-inspector/releases/tag/1.0.0-beta.1