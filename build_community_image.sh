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

BASE_IMAGE_REPO="${WEBMOOS_BASE_IMAGE_REPO:-cbenj27/moos-ivp-base}"
BASE_IMAGE_TAG="${WEBMOOS_BASE_IMAGE_TAG:-${ARCH}-dev}"
BASE_IMAGE="${WEBMOOS_BASE_IMAGE:-${BASE_IMAGE_REPO}:${BASE_IMAGE_TAG}}"
IMAGE_REPO="${WEBMOOS_COMMUNITY_IMAGE_REPO:-cbenj27/webmoos-community}"
IMAGE_TAG="${WEBMOOS_COMMUNITY_IMAGE_TAG:-${ARCH}-dev}"
ARTIFACTS_DIR="${WEBMOOS_EXTEND_ARTIFACTS_DIR:-/tmp/charlie-linux-artifacts-${ARCH}}"

if [[ ! -x "${ARTIFACTS_DIR}/bin/pGenRescue" ]]; then
  echo "Missing executable artifact: ${ARTIFACTS_DIR}/bin/pGenRescue" >&2
  exit 1
fi

if [[ ! -f "${ARTIFACTS_DIR}/lib/libBHV_Scout.so" ]]; then
  echo "Missing behavior artifact: ${ARTIFACTS_DIR}/lib/libBHV_Scout.so" >&2
  exit 1
fi

docker buildx build \
  --platform "linux/${ARCH}" \
  --load \
  --build-context "artifacts=${ARTIFACTS_DIR}" \
  --build-arg "BASE_IMAGE=${BASE_IMAGE}" \
  -t "${IMAGE_REPO}:${IMAGE_TAG}" \
  "$ROOT_DIR/community"
