# WebMOOS
This repo is a simple proof-of-concept for a complete high-level autonomy simulation framework using MOOS-IvP.

## MOOS-IvP
[MOOS-IvP](https://oceanai.mit.edu/moos-ivp/pmwiki/pmwiki.php) is a lightweight middleware and behavior-based autonomy architecture maintained by the MIT Marine Autonomy lab. 

WebMOOS adds a simple Python-based FastAPI app that serves as a bridge between the MOOS-IvP middleware and a dead-simple web-UI based on p5.js, for easy enhancement.

![The p5.js web-ui](./images/webui1.gif)

Individual components (the web ui, the api, and the MOOS-IvP autonomy system) can be individually run on bare-metal if desired.

You can debug the mqtt server by subscribing to the node-report topic to ensure you're receiving node telemetry.

```
mosquitto_sub -h 10.1.0.4 -p 1883 -t node-report
```

## First-time Setup
1. Make sure Docker Desktop or Docker Engine with Compose v2 is installed.
2. From the repo root, start the default bridge-network mission with:

```bash
./docker_restart.sh -d
```

3. Open the shoreside viewer from `community/missions/swimmer_rescue` with:

```bash
pMarineViewer targ_shoreside.moos
```

The default published images are now:

- `cbenj27/moos-ivp-base:latest`
- `cbenj27/webmoos-community:latest`

Both tags are multi-arch manifests that serve `linux/arm64` and `linux/amd64`, so the same image name works on Apple Silicon and Intel hosts.

## Compose Modes

There are two supported compose topologies:

- [docker-compose.bridge.yaml](/Users/charlesbenjamin/webmoos/docker-compose.bridge.yaml): three-container bridge-network mission. This is the default used by [docker_restart.sh](/Users/charlesbenjamin/webmoos/docker_restart.sh) and [docker_auto_test.sh](/Users/charlesbenjamin/webmoos/docker_auto_test.sh).
- [docker-compose.yaml](/Users/charlesbenjamin/webmoos/docker-compose.yaml): simpler host-network mission with two communities.
- [docker-compose.auto.yaml](/Users/charlesbenjamin/webmoos/docker-compose.auto.yaml): auto-test mission used by [docker_auto_test.sh](/Users/charlesbenjamin/webmoos/docker_auto_test.sh).

Examples:

```bash
./docker_restart.sh -d
COMPOSE_FILE=docker-compose.yaml ./docker_restart.sh -d
./docker_auto_test.sh
WEBMOOS_COMMUNITY_IMAGE=cbenj27/webmoos-community:latest ./docker_auto_test.sh
```

The compose files bind-mount the mission files from this repo so you can iterate on `.moos` and `.bhv` files locally without rebuilding the images.

By default, [docker_restart.sh](/Users/charlesbenjamin/webmoos/docker_restart.sh) and [docker_auto_test.sh](/Users/charlesbenjamin/webmoos/docker_auto_test.sh) pull the image before launch so the host resolves the correct architecture from the published multi-arch tag. Set `PULL_IMAGES=0` if you intentionally want to use a locally built tag without pulling.

## Custom App and Behavior Artifacts

The published community image already includes the required Charlie artifacts:

- `pGenRescue`
- `libBHV_Scout.so`

Those are built from your local Charlie repo during image creation and baked into `/opt/webmoos-extend` inside the image, so normal runtime use does not depend on host bind mounts for custom binaries or behavior libraries.

If you need to rebuild the images locally, use:

```bash
./build_base_image.sh arm64
./build_base_image.sh amd64
./build_charlie_artifacts.sh arm64
./build_charlie_artifacts.sh amd64
./build_community_image.sh arm64
./build_community_image.sh amd64
```

Variables that should be shared across MOOS communities, such as `TIMEWARP`, can be defined in [globals.env](/Users/charlesbenjamin/webmoos/globals.env).

| Variable  | Description                   | Example                    |
|-----------|-------------------------------|----------------------------|
| MPORT     | Port to run MOOSDB on         | 9001                       |
| PSHARE    | Port for pshare route         | 9201                       |
| VIP       | Vehicle IP address            | 10.1.0.21                  |
| VNAME     | Vehicle name                  | clayton                    |
| VROLE     | Vehicle role                  | rescue                     |
| TMATE     | Teammate vehicle              | mathew                     |
| START_POS | Comma separated x,y,heading   | 4,-7,135                   |
| EXTENDBIN | Directory for extend binaries | /opt/webmoos-extend/bin    |
| EXTENDLIB | Directory for behavior libs   | /opt/webmoos-extend/lib    |

## To-do
- Make convenience script for killing all images/containers
- Make mission meta files in autonomy directory to override launch script
- Document process to restart docker containers with new code

## Current Status

This branch no longer needs separate ARM64 and AMD64 image names. The architecture split has been replaced by Docker Hub multi-arch tags:

- [cbenj27/moos-ivp-base:latest](https://hub.docker.com/r/cbenj27/moos-ivp-base)
- [cbenj27/webmoos-community:latest](https://hub.docker.com/r/cbenj27/webmoos-community)

What remains split in-repo is topology, not CPU architecture:

- [docker-compose.bridge.yaml](/Users/charlesbenjamin/webmoos/docker-compose.bridge.yaml) for bridge networking
- [docker-compose.yaml](/Users/charlesbenjamin/webmoos/docker-compose.yaml) for host networking
