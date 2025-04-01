#!/bin/bash

docker compose down &&
docker image rm webmoos-api &&
docker image rm webmoos-autonomy &&
docker image rm webmoos-ui &&
docker compose up


