#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$ROOT_DIR/docker_arch.sh"

ARCH="${1:-$(detect_webmoos_arch)}"
case "$ARCH" in
  amd64|arm64)
    ;;
  *)
    echo "Usage: $0 [amd64|arm64]" >&2
    exit 1
    ;;
esac

CHARLIE_SRC="${CHARLIE_SRC:-/Users/charlesbenjamin/moos-ivp-charlie-github}"
SWARM_SRC="${SWARM_SRC:-/Users/charlesbenjamin/moos-ivp-swarm}"
ARTIFACTS_DIR="${WEBMOOS_EXTEND_ARTIFACTS_DIR:-/tmp/charlie-linux-artifacts-${ARCH}}"
BASE_IMAGE_REPO="${WEBMOOS_BASE_IMAGE_REPO:-charles/moos-ivp-base}"
BASE_IMAGE_TAG="${WEBMOOS_BASE_IMAGE_TAG:-${ARCH}-dev}"
BASE_IMAGE="${WEBMOOS_BASE_IMAGE:-${BASE_IMAGE_REPO}:${BASE_IMAGE_TAG}}"

rm -rf "$ARTIFACTS_DIR"
mkdir -p "$ARTIFACTS_DIR/bin" "$ARTIFACTS_DIR/lib"

docker run --rm \
  --platform "linux/${ARCH}" \
  --user "$(id -u):$(id -g)" \
  -v "${CHARLIE_SRC}:/src:ro" \
  -v "${SWARM_SRC}:/swarm:ro" \
  -v "${ARTIFACTS_DIR}:/artifacts" \
  "$BASE_IMAGE" \
  bash -lc '
    set -euo pipefail
    export MOOS_DIR=/git/moos-ivp/build/MOOS/MOOSCore
    export MOOSGeodesy_DIR=/git/moos-ivp/build/MOOS/MOOSGeodesy
    export CMAKE_PREFIX_PATH=/git/moos-ivp/build/MOOS/MOOSCore:/git/moos-ivp/build/MOOS/MOOSGeodesy
    mkdir -p /var/tmp/workspace
    ln -s /git/moos-ivp /var/tmp/workspace/moos-ivp
    ln -s /swarm /var/tmp/workspace/moos-ivp-swarm
    cp -R /src/. /var/tmp/workspace/moos-ivp-charlie-github
    rm -rf /var/tmp/workspace/moos-ivp-charlie-github/bin \
           /var/tmp/workspace/moos-ivp-charlie-github/lib \
           /var/tmp/workspace/moos-ivp-charlie-github/build
    cd /var/tmp/workspace/moos-ivp-charlie-github
    ./build.sh pGenRescue BHV_Scout
    cp bin/pGenRescue /artifacts/bin/
    cp lib/libBHV_Scout.so /artifacts/lib/
  '

file "$ARTIFACTS_DIR/bin/pGenRescue" "$ARTIFACTS_DIR/lib/libBHV_Scout.so"
