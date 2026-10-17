#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2024-2026 Vivek Umrao and DatabaseCreator contributors.
# ==============================================================================
# Database Creator - Multi-Vendor Database & Cache Container Orchestrator
# Primary Entrypoint Wrapper (backward-compatible)
# ==============================================================================

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "${SCRIPT_DIR}/bin/dbcreator" "$@"
