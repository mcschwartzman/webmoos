#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export WEBMOOS_ARCH="${WEBMOOS_ARCH:-arm64}"
export WEBMOOS_COMMUNITY_IMAGE="${WEBMOOS_COMMUNITY_IMAGE:-mcschwartzman/webmoos-community-arm:latest}"

exec "$ROOT_DIR/docker_auto_test.sh" "$@"
