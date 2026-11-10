#!/bin/bash
#
# Remove the Ansible toolchain installed by scripts/install.sh.
#
# Usage:
#   scripts/uninstall.sh [--dry-run]
set -euo pipefail

REPO_ROOT="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/..")"
# shellcheck source=lib/output.sh
source "$REPO_ROOT/scripts/lib/output.sh"

WYWY_DRY_RUN=0
case "${1:-}" in
"") ;;
--dry-run) WYWY_DRY_RUN=1 ;;
*)
	error "uninstall: unknown argument: $1"
	exit 1
	;;
esac
export WYWY_DRY_RUN

shopt -s nullglob
steps=("$REPO_ROOT"/scripts/uninstall/*.sh)

if [[ "${#steps[@]}" -eq 0 ]]; then
	error "uninstall: no steps found under $REPO_ROOT/scripts/uninstall"
	exit 1
fi

header "Removing the wywy-dotfiles toolchain ($REPO_ROOT)"
for ((i = ${#steps[@]} - 1; i >= 0; i--)); do
	"${steps[$i]}"
done

info "Toolchain uninstall complete"
