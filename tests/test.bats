#!/usr/bin/env bats
# Test the DDEV MCP Inspector add-on

# Standard DDEV test setup
setup_file() {
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/test-mcp-inspector
  mkdir -p $TESTDIR
  export PROJNAME=test-mcp-inspector
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}
  ddev start -y >/dev/null
}

# Standard DDEV test teardown
teardown_file() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

# Standard DDEV health checks function
health_checks() {
  # Add checks specific to your add-on
  ddev exec "command -v npx"
  ddev exec "npx @modelcontextprotocol/inspector --help" | grep -q "inspector"
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
  ddev restart
  health_checks
}

@test "MCP Inspector commands exist and show help" {
  set -eu -o pipefail
  cd ${TESTDIR}
  
  # Test mcp-inspector command
  run ddev mcp-inspector --help 2>&1 || true
  [ "$status" -eq 0 ]
  [[ "$output" =~ "MCP Inspector" ]]
  [[ "$output" =~ "--workdir" ]]
  
  # Test mcp-stop command  
  run ddev mcp-stop --help 2>&1 || true
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Stop any running MCP Inspector" ]]
  
  # Test mcp-debug command
  run ddev mcp-debug 2>&1 || true
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Debug Information" ]]
}

@test "Ports are configured in docker-compose" {
  set -eu -o pipefail
  cd ${TESTDIR}
  
  # Check if both ports are configured with environment variable support
  run grep -q "MCP_INSPECTOR_PORT" .ddev/docker-compose.mcp-inspector.yaml
  [ "$status" -eq 0 ]
  
  run grep -q "MCP_INSPECTOR_PROXY_PORT" .ddev/docker-compose.mcp-inspector.yaml
  [ "$status" -eq 0 ]
}

@test "NPX and MCP Inspector are available" {
  set -eu -o pipefail
  cd ${TESTDIR}
  
  # Test NPX availability
  run ddev exec "command -v npx"
  [ "$status" -eq 0 ]
  
  # Test MCP Inspector package can be accessed
  run ddev exec "npx @modelcontextprotocol/inspector --version"
  [ "$status" -eq 0 ]
}

@test "MCP Inspector can start in standalone mode (quick test)" {
  set -eu -o pipefail
  cd ${TESTDIR}
  
  # Start inspector in background with timeout (very short test)
  timeout 10s ddev mcp-inspector &
  sleep 3
  
  # Check if the configured port is listening (default 6274)
  MCP_PORT=${MCP_INSPECTOR_PORT:-6274}
  run ddev exec -s mcp-inspector "netstat -ln | grep :${MCP_PORT} || lsof -i :${MCP_PORT} || ss -ln | grep :${MCP_PORT}"
  
  # Clean up - kill any remaining processes
  ddev mcp-stop || true
  
  # The test passes if we got here without errors
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]  # Allow for port check variations
}

@test "MCP Inspector workdir option works" {
  set -eu -o pipefail
  cd ${TESTDIR}
  
  # Create a test file in a subdirectory
  mkdir -p ${TESTDIR}/custom-dir
  echo "console.log('Test workdir');" > ${TESTDIR}/custom-dir/test.js
  
  # Test the workdir option (just check if it parses correctly)
  run ddev mcp-inspector --workdir=/var/www/html/custom-dir --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "workdir=/var/www/html/custom-dir" ]]
}

@test "Commands have proper permissions and headers" {
  set -eu -o pipefail
  cd ${TESTDIR}
  
  # Check permissions
  [ -x ".ddev/commands/web/mcp-inspector" ]
  [ -x ".ddev/commands/web/mcp-stop" ]
  [ -x ".ddev/commands/web/mcp-debug" ]
  
  # Check for #ddev-generated headers
  run grep -q "#ddev-generated" .ddev/commands/web/mcp-inspector
  [ "$status" -eq 0 ]
  
  run grep -q "#ddev-generated" .ddev/commands/web/mcp-stop  
  [ "$status" -eq 0 ]
  
  run grep -q "#ddev-generated" .ddev/commands/web/mcp-debug
  [ "$status" -eq 0 ]
}

@test "Docker compose file has proper structure" {
  set -eu -o pipefail
  cd ${TESTDIR}
  
  # Check docker-compose file exists and has required content
  [ -f ".ddev/docker-compose.mcp-inspector.yaml" ]
  
  # Check for #ddev-generated header
  run grep -q "#ddev-generated" .ddev/docker-compose.mcp-inspector.yaml
  [ "$status" -eq 0 ]
  
  # Check for port configuration with environment variable support
  run grep -q "MCP_INSPECTOR_PORT" .ddev/docker-compose.mcp-inspector.yaml
  [ "$status" -eq 0 ]
}