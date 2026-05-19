#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${COMPOSE_FILE:-docker-compose.auto.amd64.yaml}"
MISSION_DIR="${MISSION_DIR:-$ROOT_DIR/community/missions/auto_swimmer_rescue}"
STARTUP_WAIT_SECONDS="${STARTUP_WAIT_SECONDS:-5}"
INPUT_SPEED_START="${INPUT_SPEED_START:-1}"
INPUT_SPEED_END="${INPUT_SPEED_END:-10}"
PULL_IMAGES="${PULL_IMAGES:-1}"

cleanup() {
  docker compose -f "$COMPOSE_FILE" down --remove-orphans || true
}

trap cleanup EXIT INT TERM

cd "$ROOT_DIR"

if [[ "$PULL_IMAGES" == "1" ]]; then
  docker compose -f "$COMPOSE_FILE" pull
fi

for ((inputspeed=INPUT_SPEED_START; inputspeed<=INPUT_SPEED_END; inputspeed++)); do
  echo "Launching Docker Compose with speed=$inputspeed..."

  docker compose -f "$COMPOSE_FILE" down --remove-orphans
  docker compose -f "$COMPOSE_FILE" up --abort-on-container-exit &
  COMPOSE_PID=$!

  sleep "$STARTUP_WAIT_SECONDS"

  echo "Injecting SURVEY_UPDATE for speed=$inputspeed"
  uPokeDB --host=localhost --port=9000 "SURVEY_UPDATE:=speed=$inputspeed"

  echo "Waiting for Docker Compose (PID $COMPOSE_PID) to finish..."
  wait "$COMPOSE_PID"

  echo "Docker Compose exited for speed=$inputspeed. Proceeding to next."
done
