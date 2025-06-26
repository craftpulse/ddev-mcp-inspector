[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com)
[![tests](https://github.com/craftpulse/ddev-mcp-inspector/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/craftpulse/ddev-mcp-inspector/actions/workflows/tests.yml?query=branch%3Amain)
[![last commit](https://img.shields.io/github/last-commit/craftpulse/ddev-mcp-inspector)](https://github.com/craftpulse/ddev-mcp-inspector/commits)
[![release](https://img.shields.io/github/v/release/craftpulse/ddev-mcp-inspector)](https://github.com/craftpulse/ddev-mcp-inspector/releases/latest)

# DDEV Mcp Inspector

## Overview

This add-on integrates Mcp Inspector into your [DDEV](https://ddev.com/) project.

## Installation

```bash
ddev add-on get craftpulse/ddev-mcp-inspector
ddev restart
```

After installation, make sure to commit the `.ddev` directory to version control.

## Usage

| Command | Description |
| ------- | ----------- |
| `ddev describe` | View service status and used ports for Mcp Inspector |
| `ddev logs -s mcp-inspector` | Check Mcp Inspector logs |

## Advanced Customization

To change the Docker image:

```bash
ddev dotenv set .ddev/.env.mcp-inspector --mcp-inspector-docker-image="busybox:stable"
ddev add-on get craftpulse/ddev-mcp-inspector
ddev restart
```

Make sure to commit the `.ddev/.env.mcp-inspector` file to version control.

All customization options (use with caution):

| Variable | Flag | Default |
| -------- | ---- | ------- |
| `MCP_INSPECTOR_DOCKER_IMAGE` | `--mcp-inspector-docker-image` | `busybox:stable` |

## Credits

**Contributed and maintained by [@craftpulse](https://github.com/craftpulse)**
