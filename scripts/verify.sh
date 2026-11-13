#!/bin/bash
#
# Verify that every tool this repository provisions is installed, PATH-visible,
# and at or above its declared threshold.
set -euo pipefail

REPO_ROOT="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/..")"
# shellcheck source=lib/output.sh
source "$REPO_ROOT/scripts/lib/output.sh"

BINARIES_DEFAULTS="$REPO_ROOT/roles/binaries/defaults/main.yaml"

# Read a scalar value from the role defaults. The defaults file is the single
# source of truth for the threshold versions.
function read_default() {
	local key="$1"
	local file="$2"

	sed -n "s/^${key}:[[:space:]]*//p" "$file" | sed -n '1p' | tr -d "\"'"
}

function strip_version() {
	local version="$1"

	version="${version#v}"
	version="${version%%+*}"
	printf '%s\n' "$version"
}

function version_ge() {
	local have="$1"
	local want="$2"

	[[ -n "$have" ]] || return 1
	[[ "$(printf '%s\n%s\n' "$want" "$have" | sort -V | sed -n '1p')" == "$want" ]]
}

function check_command() {
	local name="$1"
	local resolved

	if ! resolved="$(command -v -- "$name")"; then
		error "required command not found: $name"
		FAILED=1
		return
	fi

	case "$resolved" in
	"$HOME/.local/bin/"*) ;;
	*)
		error "$name resolves to $resolved, not ~/.local/bin"
		FAILED=1
		;;
	esac
}

function check_version() {
	local name="$1"
	local have="$2"
	local want="$3"

	if [[ -z "$have" ]]; then
		error "$name: could not determine the installed version"
		FAILED=1
	elif version_ge "$have" "$want"; then
		info "$name $have (threshold $want)"
	else
		error "$name $have is below the threshold $want"
		FAILED=1
	fi
}

FAILED=0

header "Verifying the operator toolchain"

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
	error "$HOME/.local/bin is not on PATH"
	FAILED=1
fi

for name in sops helm kubectl tofu age curl openssl vim xorriso docker htpasswd; do
	check_command "$name"
done

sops_threshold="$(read_default binaries_sops_version "$BINARIES_DEFAULTS")"
helm_threshold="$(read_default binaries_helm_version "$BINARIES_DEFAULTS")"
kubectl_threshold="$(read_default binaries_kubectl_version "$BINARIES_DEFAULTS")"
tofu_threshold="$(read_default binaries_tofu_version "$BINARIES_DEFAULTS")"

if sops_raw="$(sops --version)"; then
	sops_have="$(strip_version "$(printf '%s\n' "$sops_raw" | awk 'NR == 1 { print $2 }')")"
else
	sops_have=""
fi
check_version sops "$sops_have" "$sops_threshold"

if helm_raw="$(helm version --short)"; then
	helm_have="$(strip_version "${helm_raw%% *}")"
else
	helm_have=""
fi
check_version helm "$helm_have" "$helm_threshold"

if kubectl_raw="$(kubectl version --client -o json)"; then
	kubectl_have="$(strip_version "$(printf '%s\n' "$kubectl_raw" | sed -n 's/.*"gitVersion"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')")"
else
	kubectl_have=""
fi
check_version kubectl "$kubectl_have" "$kubectl_threshold"

if tofu_raw="$(tofu version -json)"; then
	tofu_have="$(strip_version "$(printf '%s\n' "$tofu_raw" | sed -n 's/.*"terraform_version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')")"
else
	tofu_have=""
fi
check_version tofu "$tofu_have" "$tofu_threshold"

if [[ "$FAILED" -ne 0 ]]; then
	error "verification failed"
	exit 1
fi

info "Verification passed"
