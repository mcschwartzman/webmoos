# Arch Neutrality

What changed:

- `cbenj27/moos-ivp-base:latest` is now a real multi-arch image
- `cbenj27/webmoos-community:latest` is now a real multi-arch image
- `community/Dockerfile` now bakes Charlie's Linux `bin/` and `lib/` artifacts into the image
- `docker_restart.sh` and `docker_auto_test.sh` now use one image name by default
- the remaining compose split is topology-based rather than architecture-based

How to use:

- Auto-test on current machine: `./docker_auto_test.sh`
- Restart default bridge mission: `./docker_restart.sh -d`
- Use host-network compose instead: `COMPOSE_FILE=docker-compose.yaml ./docker_restart.sh -d`
- Override image: `WEBMOOS_COMMUNITY_IMAGE=<image> ./docker_auto_test.sh`

Topology files:

- `docker-compose.bridge.yaml`: bridge-network mission
- `docker-compose.auto.yaml`: bridge-network auto-test mission
- `docker-compose.yaml`: host-network mission
