# Changelog

All notable changes to the DDEV MCP Inspector add-on will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release of DDEV MCP Inspector add-on
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

## [1.0.0] - TBD

### Added
- First stable release
- Full compatibility with DDEV v1.23.0+
- Production-ready health checks and timeouts
- Complete test coverage

### Fixed
- Container startup timeout issues
- Port exposure for both HTTP and HTTPS
- Network connectivity between containers

### Security
- No security vulnerabilities in dependencies
- Proper container isolation
- SSL/TLS support through DDEV router

## Version Guidelines

### Version Numbering
- MAJOR version: Incompatible changes, DDEV version requirement changes
- MINOR version: New features, backwards compatible
- PATCH version: Bug fixes, documentation updates

### Release Checklist
- [ ] All tests passing
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Version bumped in relevant files
- [ ] GitHub release created
- [ ] Tagged with version number

---

[Unreleased]: https://github.com/craftpulse/ddev-mcp-inspector/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/craftpulse/ddev-mcp-inspector/releases/tag/v1.0.0