#!/bin/bash
#
# Install the pinned Ansible toolchain for wywy-dotfiles.
#
# Usage:
#   scripts/install.sh [--dry-run]
set -euo pipefail

REPO_ROOT="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/..")"
# shellcheck source=lib/output.sh
source "$REPO_ROOT/scripts/lib/output.sh"

WYWY_DRY_RUN=0
case "${1:-}" in
"") ;;
--dry-run) WYWY_DRY_RUN=1 ;;
*)
	error "install: unknown argument: $1"
	exit 1
	;;
esac
export WYWY_DRY_RUN

shopt -s nullglob
steps=("$REPO_ROOT"/scripts/install/*.sh)

if [[ "${#steps[@]}" -eq 0 ]]; then
	error "install: no steps found under $REPO_ROOT/scripts/install"
	exit 1
fi

header "Installing the wywy-dotfiles toolchain ($REPO_ROOT)"
for step in "${steps[@]}"; do
	"$step"
done

info "Toolchain install complete"
