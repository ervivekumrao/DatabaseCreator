#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2024-2026 Vivek Umrao and DatabaseCreator contributors.
# ==============================================================================
# lib/lifecycle.sh - Container Lifecycle Operations (status, logs, stop, rm)
# ==============================================================================

[[ -n "${_LIB_LIFECYCLE_LOADED:-}" ]] && return 0
_LIB_LIFECYCLE_LOADED=1

handle_lifecycle_command() {
  local action="$1"
  local target="${2:-${CONTAINER_DB_NAME:-localdb}}"

  if command -v podman >/dev/null 2>&1; then
    CONTAINER_ENGINE="podman"
  elif command -v docker >/dev/null 2>&1; then
    CONTAINER_ENGINE="docker"
  else
    log_error "Neither podman nor docker is installed."
    exit 1
  fi

  case "${action}" in
    status)
      log_info "Active containers managed with ${CONTAINER_ENGINE}:"
      "${CONTAINER_ENGINE}" ps --filter "name=${target}"
      exit 0
      ;;
    stop)
      log_info "Stopping container '${target}'..."
      "${CONTAINER_ENGINE}" stop "${target}"
      exit 0
      ;;
    logs)
      log_info "Following logs for '${target}'..."
      "${CONTAINER_ENGINE}" logs -f "${target}"
      exit 0
      ;;
    rm|remove)
      log_info "Stopping and removing container '${target}'..."
      "${CONTAINER_ENGINE}" rm -f "${target}"
      exit 0
      ;;
  esac
}
