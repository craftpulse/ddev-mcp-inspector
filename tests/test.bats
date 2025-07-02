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

@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || exit 1
  echo "# Running ddev add-on get ${DIR}"
  ddev add-on get ${DIR}
  ddev restart
  
  # Check that the mcp-inspector service is running
  ddev exec -s mcp-inspector true
}

@test "mcp inspector responds" {
  set -eu -o pipefail
  cd ${TESTDIR} || exit 1
  
  # Wait for service to be ready - increased timeout
  echo "# Waiting for MCP Inspector to start..."
  timeout=120
  while [ $timeout -gt 0 ]; do
    if ddev exec -s mcp-inspector curl -s http://localhost:6274 >/dev/null 2>&1; then
      echo "# MCP Inspector is responding"
      break
    fi
    sleep 2
    timeout=$((timeout - 2))
  done
  
  if [ $timeout -le 0 ]; then
    echo "# MCP Inspector failed to start within 2 minutes"
    ddev logs -s mcp-inspector
    exit 1
  fi
  
  # Check if the inspector UI is accessible via HTTPS
  response=$(curl -s -k https://test-ddev-mcp-inspector.ddev.site:6275 || echo "FAILED")
  if echo "$response" | grep -q -i "inspector\|react\|html"; then
    echo "# MCP Inspector UI is accessible"
  else
    echo "# MCP Inspector UI check failed. Response: $response"
    ddev logs -s mcp-inspector
    exit 1
  fi
}