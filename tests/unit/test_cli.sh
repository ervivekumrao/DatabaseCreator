#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2024-2026 Vivek Umrao and DatabaseCreator contributors.
# ==============================================================================
# tests/unit/test_cli.sh - Unit Tests for CLI Routing & Argument Parsing
# ==============================================================================

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTS_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
PROJECT_ROOT="$(cd "${TESTS_DIR}/.." && pwd)"

source "${TESTS_DIR}/test_harness.sh"

test_suite_start "CLI Interface & Argument Routing"

test_help_flags() {
  "${PROJECT_ROOT}/bin/dbcreator" --help >/dev/null
  "${PROJECT_ROOT}/bin/dbcreator" -h >/dev/null
  "${PROJECT_ROOT}/CreateDB.sh" --help >/dev/null
  return 0
}

test_invalid_option_fails() {
  if "${PROJECT_ROOT}/bin/dbcreator" --invalid-flag-xyz >/dev/null 2>&1; then
    printf "Expected invalid option to exit with non-zero\n" >&2
    return 1
  fi
  return 0
}

test_backward_compatible_wrapper() {
  # Verify CreateDB.sh produces identical help as bin/dbcreator
  local out1 out2
  out1="$("${PROJECT_ROOT}/bin/dbcreator" --help)"
  out2="$("${PROJECT_ROOT}/CreateDB.sh" --help)"
  assert_equals "${out1}" "${out2}" "CreateDB.sh and bin/dbcreator help output differs"
}

test_help_lists_all_12_engines() {
  local help_out
  help_out="$("${PROJECT_ROOT}/bin/dbcreator" --help)"

  local expected_engines=(
    "mysql" "mariadb" "postgres" "mssql" "oracle"
    "mongodb" "db2" "redis" "clickhouse" "cockroach"
    "snowflake" "databricks"
  )

  for eng in "${expected_engines[@]}"; do
    assert_contains "${help_out}" "${eng}" "Help output missing engine: ${eng}"
  done
}

run_test "Help flags exit 0" test_help_flags
run_test "Invalid flags exit non-zero" test_invalid_option_fails
run_test "CreateDB.sh wrapper behaves identically to bin/dbcreator" test_backward_compatible_wrapper
run_test "Help output advertises all 12 supported engines" test_help_lists_all_12_engines

test_suite_end
