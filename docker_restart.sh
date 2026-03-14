#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$ROOT_DIR/docker_arch.sh"

export WEBMOOS_COMMUNITY_IMAGE="${WEBMOOS_COMMUNITY_IMAGE:-$(default_webmoos_image)}"
COMPOSE_FILE="${COMPOSE_FILE:-$(default_webmoos_restart_compose)}"
PULL_IMAGES="${PULL_IMAGES:-1}"

cd "$ROOT_DIR"

docker compose -f "$COMPOSE_FILE" down --remove-orphans
if [[ "$PULL_IMAGES" == "1" ]]; then
  docker compose -f "$COMPOSE_FILE" pull
fi
docker compose -f "$COMPOSE_FILE" up "$@"
