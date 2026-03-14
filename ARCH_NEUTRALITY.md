# Arch Neutrality

What changed:

- `docker_auto_test.sh` now auto-detects `arm64` vs `amd64`
- `docker_auto_test_arm.sh` and `docker_auto_test_amd64.sh` are compatibility wrappers
- `docker_restart.sh` now auto-selects the current arch by default
- compose files now accept `WEBMOOS_COMMUNITY_IMAGE`
- `community/Dockerfile` now accepts `BASE_IMAGE`

How to use:

- Auto-test on current machine: `./docker_auto_test.sh`
- Force ARM: `./docker_auto_test_arm.sh`
- Force AMD64: `./docker_auto_test_amd64.sh`
- Override image: `WEBMOOS_COMMUNITY_IMAGE=<image> ./docker_auto_test.sh`
- Override base image when building: `docker build --build-arg BASE_IMAGE=<image> ./community`

Still blocked on external image work:

- publish `mcschwartzman/moos-ivp-base` as a real multi-arch image
- publish `mcschwartzman/webmoos-community` as a real multi-arch image
- once that exists, most arch-specific compose/script duplication can be removed
