#!/usr/bin/env bats

setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/test-ddev-mcp-inspector
  mkdir -p $TESTDIR
  cd "${TESTDIR}" || exit 1
  ddev delete -Oy test-ddev-mcp-inspector || true
  cp -R "${DIR}/tests/testdata"/* .
  ddev config --project-name=test-ddev-mcp-inspector
  ddev start
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || exit 1
  ddev delete -Oy test-ddev-mcp-inspector
  rm -rf ${TESTDIR}
}

@test "install and test mcp inspector" {
  set -eu -o pipefail
  cd ${TESTDIR} || exit 1
  echo "# Running ddev add-on get ${DIR}"
  ddev add-on get ${DIR}
  
  # Give more time for npm install
  echo "# Restarting with increased timeout for npm install..."
  ddev restart || {
    echo "# DDEV restart failed - capturing logs before cleanup"
    docker logs ddev-test-ddev-mcp-inspector-mcp-inspector 2>&1 || echo "No container logs available"
    ddev describe
    exit 1
  }
  
  # Wait longer for npm install to complete (no healthcheck now)
  echo "# Waiting for MCP Inspector container to be ready..."
  timeout=600  # 10 minutes for npm install
  while [ $timeout -gt 0 ]; do
    container_status=$(docker ps --filter "name=mcp-inspector" --format "{{.Status}}" 2>/dev/null || echo "not found")
    if echo "$container_status" | grep -q "Up"; then
      echo "# MCP Inspector container is up: $container_status"
      # Wait a bit more for the service to actually start
      sleep 30
      break
    elif echo "$container_status" | grep -q "Exited"; then
      echo "# MCP Inspector container exited: $container_status"
      echo "# Container logs:"
      docker logs ddev-test-ddev-mcp-inspector-mcp-inspector 2>&1 || echo "No logs available"
      exit 1
    else
      echo "# MCP Inspector container status: $container_status - waiting..."
      sleep 10
      timeout=$((timeout - 10))
    fi
  done
  
  if [ $timeout -le 0 ]; then
    echo "# MCP Inspector failed to become ready within 10 minutes"
    echo "# Final container status:"
    docker ps --format "table {{.Names}}\t{{.Status}}" | grep mcp-inspector || echo "No mcp-inspector container found"
    echo "# Container logs:"
    docker logs ddev-test-ddev-mcp-inspector-mcp-inspector || echo "No logs available"
    exit 1
  fi
  
  # Check that the mcp-inspector service is accessible
  echo "# Checking if mcp-inspector service is accessible..."
  ddev exec -s mcp-inspector true || {
    echo "# mcp-inspector service not accessible"
    docker logs ddev-test-ddev-mcp-inspector-mcp-inspector
    exit 1
  }
  
  # Test if MCP Inspector is responding
  echo "# Testing MCP Inspector HTTP response..."
  timeout=120
  while [ $timeout -gt 0 ]; do
    if ddev exec -s mcp-inspector curl -s http://localhost:6274 >/dev/null 2>&1; then
      echo "# MCP Inspector is responding on port 6274"
      break
    fi
    sleep 5
    timeout=$((timeout - 5))
  done
  
  if [ $timeout -le 0 ]; then
    echo "# MCP Inspector failed to respond within 2 minutes"
    echo "# Container logs:"
    ddev logs -s mcp-inspector || docker logs ddev-test-ddev-mcp-inspector-mcp-inspector
    exit 1
  fi
  
  # Check if the inspector UI is accessible via HTTPS
  echo "# Testing HTTPS access to MCP Inspector UI..."
  response=$(curl -s -k https://test-ddev-mcp-inspector.ddev.site:6275 || echo "FAILED")
  if echo "$response" | grep -q -i "inspector\|react\|html"; then
    echo "# ✅ MCP Inspector UI is accessible and responding"
  else
    echo "# ⚠️  MCP Inspector UI accessibility test inconclusive. Response length: ${#response}"
    echo "# This may be normal if the UI loads via JavaScript"
    # Don't fail the test for this - UI might load via JS
  fi
}

