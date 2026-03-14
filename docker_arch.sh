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
  local arch
  arch="$(detect_webmoos_arch)" || return 1
  case "$arch" in
    amd64)
      echo "mcschwartzman/webmoos-community:latest"
      ;;
    arm64)
      echo "mcschwartzman/webmoos-community-arm:latest"
      ;;
  esac
}

default_webmoos_auto_compose() {
  echo "docker-compose.auto.yaml"
}

default_webmoos_restart_compose() {
  local arch
  arch="$(detect_webmoos_arch)" || return 1
  case "$arch" in
    amd64)
      echo "docker-compose.yaml"
      ;;
    arm64)
      echo "docker-compose.arm.yaml"
      ;;
  esac
}
