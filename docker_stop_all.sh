#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILES=(
  "docker-compose.bridge.yaml"
  "docker-compose.auto.yaml"
  "docker-compose.yaml"
  "docker-compose.api.yaml"
  "docker-compose.fleet.yaml"
)

cd "$ROOT_DIR"

for compose_file in "${COMPOSE_FILES[@]}"; do
  if [[ -f "$compose_file" ]]; then
    docker compose -f "$compose_file" down --remove-orphans || true
  fi
done
