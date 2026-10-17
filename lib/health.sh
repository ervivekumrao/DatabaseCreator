#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2024-2026 Vivek Umrao and DatabaseCreator contributors.
# ==============================================================================
# lib/health.sh - Container Readiness Probing & State Monitoring
# ==============================================================================

[[ -n "${_LIB_HEALTH_LOADED:-}" ]] && return 0
_LIB_HEALTH_LOADED=1

is_container_running() {
  local name="$1"
  local running
  running="$("${CONTAINER_ENGINE}" inspect -f '{{.State.Running}}' "${name}" 2>/dev/null || echo "false")"
  [[ "${running}" == "true" ]]
}

wait_for_container_health() {
  local name="$1"
  local port="$2"
  local max_attempts="${3:-30}"
  local sleep_interval="${4:-4}"
  local attempt=1
  local health_status=""

  if ! is_container_running "${name}"; then
    log_error "Container '${name}' failed to start."
    "${CONTAINER_ENGINE}" logs "${name}" 2>&1 | tail -n 20 >&2 || true
    return 1
  fi

  log_info "Container '${name}' is running on port ${port}. Probing readiness..."

  while [[ ${attempt} -le ${max_attempts} ]]; do
    if ! is_container_running "${name}"; then
      log_error "Container '${name}' stopped unexpectedly during initialization."
      "${CONTAINER_ENGINE}" logs "${name}" 2>&1 | tail -n 25 >&2 || true
      return 1
    fi

    health_status="$("${CONTAINER_ENGINE}" inspect -f '{{if .State.Health}}{{.State.Health.Status}}{{else}}running{{end}}' "${name}" 2>/dev/null || echo "unknown")"

    if [[ "${health_status}" == "healthy" || "${health_status}" == "running" ]]; then
      log_success "Database instance '${name}' is up and healthy!"
      printf "  * Host Port:  ${CLR_BOLD}%s${CLR_RESET}\n" "${port}"
      printf "  * Engine:     ${CLR_BOLD}%s${CLR_RESET}\n" "${CONTAINER_ENGINE}"
      printf "  * Manage:     ./CreateDB.sh logs %s | ./CreateDB.sh stop %s\n\n" "${name}" "${name}"
      return 0
    fi

    printf "."
    sleep "${sleep_interval}"
    ((attempt++))
  done

  log_warn "Readiness probe timeout reached (status: ${health_status}). Container is still active."
  printf "Inspect container output: ${CLR_BOLD}%s logs %s${CLR_RESET}\n" "${CONTAINER_ENGINE}" "${name}"
  return 0
}
