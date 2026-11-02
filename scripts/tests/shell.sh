#!/bin/bash
#
# Shell script checks: syntax and executable bits for every shell script in the tree.
set -euo pipefail

REPO_ROOT="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../..")"
cd "$REPO_ROOT"

# shellcheck source=../lib/output.sh
source "$REPO_ROOT/scripts/lib/output.sh"

shopt -s nullglob globstar
shell_scripts=(**/*.sh)

if [[ "${#shell_scripts[@]}" -eq 0 ]]; then
	error "no shell scripts found under $REPO_ROOT"
	exit 1
fi

status=0

function run_check() {
	local name="$1"
	shift
	if "$@"; then
		info "PASS: $name"
	else
		error "FAIL: $name"
		status=1
	fi
}

function check_bash_syntax() {
	local failed=0
	local file
	for file in "${shell_scripts[@]}"; do
		if ! bash -n "$file"; then
			error "syntax error: $file"
			failed=1
		fi
	done
	return "$failed"
}

function check_executable_bits() {
	local failed=0
	local file
	for file in "${shell_scripts[@]}"; do
		# Sourced helpers are not entrypoints.
		case "$file" in
		scripts/lib/*) continue ;;
		esac
		if [[ ! -x "$file" ]]; then
			error "not executable: $file"
			failed=1
		fi
	done
	return "$failed"
}

run_check "shell syntax" check_bash_syntax
run_check "executable bits" check_executable_bits

if [[ "$status" -ne 0 ]]; then
	error "Shell checks failed."
	exit 1
fi

info "Shell checks passed (${#shell_scripts[@]} scripts)."
