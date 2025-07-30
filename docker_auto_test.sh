#!/bin/bash

COMPOSE_FILE="docker-compose.auto.yaml"
MISSION_DIR=~/webmoos/community/missions/swimmer_rescue

for inputspeed in {1..10}; do
  echo "Launching Docker Compose with speed=$inputspeed..."

  # Start Docker Compose in the background
  docker compose -f "$COMPOSE_FILE" up --abort-on-container-exit &
  COMPOSE_PID=$!

  # Wait a few seconds to ensure MOOS communities are up
  sleep 5
  
  # Run pAutoPoke immediately after launch
  echo "Injecting SURVEY_UPDATE for speed=$inputspeed"
  cd "$MISSION_DIR"
  pAutoPoke targ_abe "SURVEY_UPDATE=speed=$inputspeed"

  # Wait for Docker Compose to exit
  echo "Waiting for Docker Compose (PID $COMPOSE_PID) to finish..."
  wait $COMPOSE_PID

  echo "Docker Compose exited for speed=$inputspeed. Proceeding to next."
done
