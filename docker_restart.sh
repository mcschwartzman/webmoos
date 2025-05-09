#!/bin/bash

docker compose -f docker-compose.fleet.yaml down &&
# docker image rm webmoos-api &&
docker rm webmoos-mathew-1 webmoos-shoreside-1 webmoos-clayton-1 webmoos-josh-1 webmoos-jeremy-1
docker image rm webmoos-mathew webmoos-shoreside webmoos-clayton webmoos-josh webmoos-jeremy
# docker image rm webmoos-ui &&
docker compose -f docker-compose.fleet.yaml up



