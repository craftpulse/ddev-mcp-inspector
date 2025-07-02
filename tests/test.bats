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
  
  # Wait for service to be ready
  sleep 10
  
  # Check if the inspector UI is accessible
  curl -s -k https://test-ddev-mcp-inspector.ddev.site:6275 | grep -q "MCP Inspector"
}