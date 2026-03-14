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
2. From the repo root, start the default mission with:

```bash
cd ~/webmoos
./docker_restart.sh -d
```

3. Open the shoreside viewer from `community/missions/swimmer_rescue` with:

```bash
cd ~/webmoos/community/missions/swimmer_rescue
pMarineViewer targ_shoreside.moos
```

4. Run the auto-test flow with:

```bash
./docker_auto_test.sh
```

To stop everything started by the repo:

```bash
./docker_stop_all.sh
```

The default published images are now:

- `cbenj27/moos-ivp-base:latest`
- `cbenj27/webmoos-community:latest`

Both tags are multi-arch manifests that serve `linux/arm64` and `linux/amd64`, so the same image name works on Apple Silicon and Intel hosts.

## Compose Modes

There are two supported compose topologies:

- `docker-compose.bridge.yaml`: three-container bridge-network swimmer-rescue mission. This is the default used by `./docker_restart.sh`.
- `docker-compose.yaml`: simpler host-network mission with two communities.
- `docker-compose.auto.yaml`: auto-test mission used by `./docker_auto_test.sh`.

The compose files bind-mount the mission files from this repo so you can iterate on `.moos` and `.bhv` files locally without rebuilding the images.

By default, `./docker_restart.sh` and `./docker_auto_test.sh` pull the image before launch so the host resolves the correct architecture from the published multi-arch tag. Set `PULL_IMAGES=0` only if you intentionally want to use a locally built tag without pulling.

## When To Restart vs Rebuild

You only need a restart when you change mission-level files that are bind-mounted from this repo, for example:

- `.moos` files
- `.bhv` files
- mission launch scripts under `community/missions`

Typical workflow:

```bash
./docker_stop_all.sh
./docker_restart.sh -d
```

You need an image rebuild when you change something that lives inside the image itself, for example:

- `moos-ivp-base/Dockerfile`
- `community/Dockerfile`
- `api/Dockerfile`
- the swimmer-rescue custom app/lib bundle produced by `scripts/images/build_swimmer_rescue_artifacts.sh`

Typical rebuild workflow:

```bash
cd ~/webmoos
ARCH=<arm64|amd64>
./scripts/images/build_base_image.sh "$ARCH"
./scripts/images/build_swimmer_rescue_artifacts.sh "$ARCH"
./scripts/images/build_community_image.sh "$ARCH"
```

That is the normal local-testing path: rebuild only the architecture you are actively running.

If you are updating the shared published images, rebuild both architectures before republishing the multi-arch tags.

## Advanced Usage

Most users should only need:

```bash
./docker_restart.sh -d
./docker_auto_test.sh
```

Use these overrides only when you have a specific reason:

```bash
COMPOSE_FILE=docker-compose.yaml ./docker_restart.sh -d
WEBMOOS_COMMUNITY_IMAGE=<some-other-tag> ./docker_restart.sh -d
WEBMOOS_COMMUNITY_IMAGE=<some-other-tag> ./docker_auto_test.sh
PULL_IMAGES=0 ./docker_restart.sh -d
```

## Custom App and Behavior Artifacts

The published community image already includes the required swimmer-rescue artifacts:

- `pGenRescue`
- `libBHV_Scout.so`

Those are built from your local Charlie repo during image creation and baked into `/opt/webmoos-extend` inside the image, so normal runtime use does not depend on host bind mounts for custom binaries or behavior libraries.

If you need to rebuild the images locally, use:

```bash
./scripts/images/build_base_image.sh arm64
./scripts/images/build_base_image.sh amd64
./scripts/images/build_swimmer_rescue_artifacts.sh arm64
./scripts/images/build_swimmer_rescue_artifacts.sh amd64
./scripts/images/build_community_image.sh arm64
./scripts/images/build_community_image.sh amd64
```

Variables that should be shared across MOOS communities, such as `TIMEWARP`, can be defined in `globals.env`.

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
- Make mission meta files in autonomy directory to override launch script

## Current Status

This branch no longer needs separate ARM64 and AMD64 image names. The architecture split has been replaced by Docker Hub multi-arch tags:

- [cbenj27/moos-ivp-base:latest](https://hub.docker.com/r/cbenj27/moos-ivp-base)
- [cbenj27/webmoos-community:latest](https://hub.docker.com/r/cbenj27/webmoos-community)

What remains split in-repo is topology, not CPU architecture:

- `docker-compose.bridge.yaml` for bridge networking
- `docker-compose.yaml` for host networking

## Top-level File Guide

- `README.md`: main setup and usage guide.
- `ARCH_NEUTRALITY.md`: branch-specific migration notes about the dual-arch work.
- `docker_restart.sh`: starts the default mission.
- `docker_stop_all.sh`: stops known WebMOOS compose stacks.
- `docker_auto_test.sh`: runs the swimmer-rescue auto-test loop.
- `docker-compose.bridge.yaml`: default bridge-network runtime topology.
- `docker-compose.auto.yaml`: auto-test topology.
- `docker-compose.yaml`: alternate host-network runtime topology.
- `docker-compose.api.yaml`: older API-specific compose file.
- `docker-compose.fleet.yaml`: older fleet-oriented compose file that still uses legacy assumptions.
- `globals.env`: shared mission environment defaults.
- `scripts`: image rebuild and publish helpers.
- `moos-ivp-base`: base image Dockerfile and build context.
- `community`: mission files and community image content.
- `api`: FastAPI image content.
- `ui`: web UI source.
- `config`: mosquitto and related runtime config.
- `images`: screenshots and README media.
- `remote_clayton.moos` and `remote_shoreside.moos`: standalone mission files for remote/manual workflows.
