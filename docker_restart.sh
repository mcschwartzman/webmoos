#!/bin/bash

docker compose -f docker-compose.fleet.yaml down &&
# docker image rm webmoos-api &&
docker rm webmoos-gilda-1 webmoos-shoreside-1 webmoos-henry-1
docker image rm webmoos-gilda webmoos-shoreside webmoos-henry
# docker image rm webmoos-ui &&
docker compose -f docker-compose.fleet.yaml up



