#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export WEBMOOS_COMMUNITY_IMAGE="${WEBMOOS_COMMUNITY_IMAGE:-${WEBMOOS_COMMUNITY_IMAGE_REPO:-cbenj27/webmoos-community}:${WEBMOOS_COMMUNITY_IMAGE_TAG:-latest}}"
COMPOSE_FILE="${COMPOSE_FILE:-docker-compose.bridge.yaml}"
PULL_IMAGES="${PULL_IMAGES:-1}"

cd "$ROOT_DIR"

docker compose -f "$COMPOSE_FILE" down --remove-orphans
if [[ "$PULL_IMAGES" == "1" ]]; then
  docker compose -f "$COMPOSE_FILE" pull
fi
docker compose -f "$COMPOSE_FILE" up "$@"
