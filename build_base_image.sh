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

IMAGE_REPO="${WEBMOOS_BASE_IMAGE_REPO:-cbenj27/moos-ivp-base}"
IMAGE_TAG="${WEBMOOS_BASE_IMAGE_TAG:-${ARCH}-dev}"

docker buildx build \
  --platform "linux/${ARCH}" \
  --load \
  -t "${IMAGE_REPO}:${IMAGE_TAG}" \
  "$ROOT_DIR/moos-ivp-base"
