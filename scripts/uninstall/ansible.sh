#!/bin/bash
#
# Remove the Ansible toolchain and collections.
set -euo pipefail

REPO_ROOT="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../..")"
# shellcheck source=../lib/output.sh
source "$REPO_ROOT/scripts/lib/output.sh"
# shellcheck source=../lib/run.sh
source "$REPO_ROOT/scripts/lib/run.sh"

COLLECTIONS_DIR="$REPO_ROOT/.ansible/collections"

if [[ -d "$COLLECTIONS_DIR" ]]; then
	header "Removing Ansible collections ($COLLECTIONS_DIR)"
	wywy_run rm -rf "$COLLECTIONS_DIR"
else
	info "Ansible collections already absent ($COLLECTIONS_DIR)"
fi

if [[ -d "$REPO_ROOT/.venv" ]]; then
	header "Removing the Ansible toolchain ($REPO_ROOT/.venv)"
	wywy_run rm -rf "$REPO_ROOT/.venv"
else
	info "Ansible toolchain already absent ($REPO_ROOT/.venv)"
fi
