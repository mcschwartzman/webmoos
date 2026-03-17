#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Resolve the local host architecture into the Docker platform names we use
# for local staging images and containerized artifact builds.
detect_webmoos_arch() {
  local arch="${WEBMOOS_ARCH:-$(uname -m)}"
  case "$arch" in
    x86_64|amd64)
      echo "amd64"
      ;;
    aarch64|arm64)
      echo "arm64"
      ;;
    *)
      echo "Unsupported architecture: $arch" >&2
      return 1
      ;;
  esac
}

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
BASE_IMAGE_REPO="${WEBMOOS_BASE_IMAGE_REPO:-cbenj27/moos-ivp-base}"
BASE_IMAGE_TAG="${WEBMOOS_BASE_IMAGE_TAG:-${ARCH}-dev}"
BASE_IMAGE="${WEBMOOS_BASE_IMAGE:-${BASE_IMAGE_REPO}:${BASE_IMAGE_TAG}}"

# Start from a clean artifact directory so later image builds do not pick up
# stale binaries from a previous architecture or earlier build.
rm -rf "$ARTIFACTS_DIR"
mkdir -p "$ARTIFACTS_DIR/bin" "$ARTIFACTS_DIR/lib"

# Build Charlie's Linux artifacts inside the selected base image instead of on
# the host. That keeps the toolchain consistent with the runtime image and lets
# us target either amd64 or arm64 from one script.
docker run --rm \
  --platform "linux/${ARCH}" \
  --user "$(id -u):$(id -g)" \
  -v "${CHARLIE_SRC}:/src:ro" \
  -v "${SWARM_SRC}:/swarm:ro" \
  -v "${ARTIFACTS_DIR}:/artifacts" \
  "$BASE_IMAGE" \
  bash -lc '
    set -euo pipefail
    # Point Charlie'\''s build at the MOOS libraries already compiled into the
    # base image.
    export MOOS_DIR=/git/moos-ivp/build/MOOS/MOOSCore
    export MOOSGeodesy_DIR=/git/moos-ivp/build/MOOS/MOOSGeodesy
    export CMAKE_PREFIX_PATH=/git/moos-ivp/build/MOOS/MOOSCore:/git/moos-ivp/build/MOOS/MOOSGeodesy

    # Assemble a temporary workspace that mirrors the repo layout expected by
    # Charlie'\''s build script, then copy only the resulting artifacts back out.
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
