#!/bin/bash
#
# Shell checks: shebangs, syntax, formatting, executable bits, and shellcheck
# for every shell script in the tree. Sourced modules under scripts/lib/ belong
# to wywy-shlib and are tested there, so this suite skips them.
set -euo pipefail

REPO_ROOT="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../..")"
cd "$REPO_ROOT"

# shellcheck source=../lib/output.sh
source "$REPO_ROOT/scripts/lib/output.sh"

shopt -s nullglob globstar

shell_scripts=()
for file in **/*.sh; do
	case "$file" in
	scripts/lib/*) continue ;;
	esac
	shell_scripts+=("$file")
done

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

function check_shebangs() {
	local failed=0
	local file
	local first

	for file in "${shell_scripts[@]}"; do
		IFS= read -r first <"$file"
		if [[ "$first" != "#!/bin/bash" ]]; then
			error "missing #!/bin/bash: $file"
			failed=1
		fi
	done

	return "$failed"
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

function check_format() {
	local diff

	if ! diff="$(uv run --directory "$REPO_ROOT" shfmt -d "${shell_scripts[@]}")"; then
		printf '%s\n' "$diff" >&2
		return 1
	fi
}

function check_executable_bits() {
	local failed=0
	local file

	for file in "${shell_scripts[@]}"; do
		if [[ ! -x "$file" ]]; then
			error "not executable: $file"
			failed=1
		fi
	done

	return "$failed"
}

function check_shellcheck() {
	uv run --directory "$REPO_ROOT" shellcheck -x -P SCRIPTDIR "${shell_scripts[@]}"
}

run_check "shebangs" check_shebangs
run_check "syntax" check_bash_syntax
run_check "format" check_format
run_check "executable bits" check_executable_bits
run_check "shellcheck" check_shellcheck

if [[ "$status" -ne 0 ]]; then
	error "Shell checks failed."
	exit 1
fi

info "Shell checks passed (${#shell_scripts[@]} scripts)."
