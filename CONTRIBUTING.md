# Contributing to DDEV MCP Inspector

Thank you for your interest in contributing to the DDEV MCP Inspector add-on! This document provides guidelines and instructions for contributing.

## Code of Conduct

Please be respectful and constructive in all interactions. We aim to maintain a welcoming environment for all contributors.

## How to Contribute

### Reporting Issues

1. Check existing issues to avoid duplicates
2. Use the issue template if provided
3. Include:
   - DDEV version (`ddev version`)
   - Operating system and version
   - Steps to reproduce
   - Expected vs actual behavior
   - Relevant logs (`ddev logs -s mcp-inspector`)

### Submitting Pull Requests

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Make your changes
4. Test thoroughly (see Testing section)
5. Commit with clear messages
6. Push to your fork
7. Submit a pull request with:
   - Clear description of changes
   - Link to related issue(s)
   - Test results

## Development Setup

### Prerequisites

- DDEV v1.23.0 or higher
- Docker
- Git
- Bats (for testing)

### Local Development

1. Clone your fork:
   ```bash
   git clone https://github.com/your-username/ddev-mcp-inspector.git
   cd ddev-mcp-inspector
   ```

2. Create a test project:
   ```bash
   mkdir ~/test-mcp-inspector
   cd ~/test-mcp-inspector
   ddev config --project-name=test-mcp-inspector
   ddev start
   ```

3. Install your local version:
   ```bash
   ddev get /path/to/your/ddev-mcp-inspector
   ddev restart
   ```

## Testing

### Running Tests

```bash
cd tests
bats test.bats
```

### Test Requirements

All pull requests must:
- Pass existing tests
- Include tests for new features
- Maintain test coverage

### Writing Tests

Tests use the Bats testing framework. Example test:

```bash
@test "verify new feature works" {
  set -eu -o pipefail
  cd ${TESTDIR}
  ddev get ${DIR}
  ddev restart >/dev/null
  
  # Your test assertions here
  run ddev your-new-command
  [ "$status" -eq 0 ]
  [[ "$output" =~ "expected output" ]]
}
```

## Project Structure

```
ddev-mcp-inspector/
├── .github/
│   └── workflows/
│       └── tests.yml          # CI configuration
├── commands/
│   ├── host/
│   │   └── mcp-inspector      # Host command
│   └── web/
│       └── mcp-connect        # Web container command
├── tests/
│   └── test.bats              # Test suite
├── docker-compose.mcp-inspector.yaml
├── install.yaml               # DDEV add-on manifest
├── README.md
├── CONTRIBUTING.md
└── LICENSE
```

## Coding Standards

### Shell Scripts

- Use `#!/bin/bash` for consistency
- Include proper error handling: `set -eu -o pipefail`
- Add descriptive comments
- Follow DDEV command conventions

### YAML Files

- Use 2-space indentation
- Include `#ddev-generated` marker
- Follow DDEV service naming: `ddev-${DDEV_SITENAME}-servicename`

### Documentation

- Keep README.md up to date
- Document new features and commands
- Include examples
- Update troubleshooting section

## Release Process

1. Update version references
2. Update CHANGELOG.md
3. Create release PR
4. After merge, create GitHub release
5. Tag with semantic version (e.g., v1.2.3)

## Getting Help

- Open an issue for questions
- Check DDEV documentation: https://ddev.readthedocs.io/
- Join DDEV Discord: https://discord.gg/hCZFfAMc5k

## Recognition

Contributors will be acknowledged in:
- Release notes
- README.md credits section
- GitHub contributors page

Thank you for contributing to DDEV MCP Inspector!