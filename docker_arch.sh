#!/usr/bin/env bash

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

default_webmoos_image() {
  echo "${WEBMOOS_COMMUNITY_IMAGE_REPO:-cbenj27/webmoos-community}:${WEBMOOS_COMMUNITY_IMAGE_TAG:-latest}"
}

default_webmoos_auto_compose() {
  echo "docker-compose.auto.yaml"
}

default_webmoos_restart_compose() {
  echo "docker-compose.bridge.yaml"
}
