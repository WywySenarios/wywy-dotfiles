#!/bin/bash
#
# Idempotent Ansible toolchain installation.
#
# Prerequisite: uv.
#
# Usage:
#   scripts/install.sh [--dry-run]
set -euo pipefail

REPO_ROOT="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/..")"

# shellcheck source=../lib/output.sh
source "$REPO_ROOT/scripts/lib/output.sh"

DRY_RUN=false
case "${1:-}" in
"") ;;
--dry-run) DRY_RUN=true ;;
*)
	error "install: unknown argument: $1"
	exit 1
	;;
esac

if "$DRY_RUN"; then
	header "Plan (dry run)"
	info "uv sync --directory $REPO_ROOT --locked"
	exit 0
fi

header "Syncing the Ansible toolchain ($REPO_ROOT)"
uv sync --directory "$REPO_ROOT" --locked

info "Ansible toolchain ready ($REPO_ROOT/.venv)"
