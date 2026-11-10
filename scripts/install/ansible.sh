#!/bin/bash
#
# Sync the pinned Ansible toolchain and collections.
set -euo pipefail

REPO_ROOT="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../..")"
# shellcheck source=../lib/output.sh
source "$REPO_ROOT/scripts/lib/output.sh"
# shellcheck source=../lib/preflight.sh
source "$REPO_ROOT/scripts/lib/preflight.sh"
# shellcheck source=../lib/run.sh
source "$REPO_ROOT/scripts/lib/run.sh"

wywy_require_cmd uv "install it from https://docs.astral.sh/uv/"
wywy_require_cmd git "install git"

ANSIBLE_COLLECTIONS_PATH="$REPO_ROOT/.ansible/collections"
export ANSIBLE_COLLECTIONS_PATH

header "Initializing submodules ($REPO_ROOT)"
wywy_run git -C "$REPO_ROOT" submodule update --init --recursive

header "Syncing the Ansible toolchain ($REPO_ROOT)"
wywy_run uv sync --directory "$REPO_ROOT" --locked

header "Installing pinned Ansible collections ($ANSIBLE_COLLECTIONS_PATH)"
wywy_run uv run --directory "$REPO_ROOT" ansible-galaxy collection install \
	-r "$REPO_ROOT/requirements.yaml" \
	-p "$ANSIBLE_COLLECTIONS_PATH"

info "Ansible toolchain ready ($REPO_ROOT/.venv)"
