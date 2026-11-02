#!/bin/bash
set -euo pipefail

REPO_ROOT="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../../..")"
cd "$REPO_ROOT"

export ANSIBLE_CONFIG="ansible.cfg"
export ANSIBLE_INVENTORY=/dev/null

echo "==> ansible-playbook --syntax-check" >&2
shopt -s nullglob globstar
playbooks=(playbooks/**/*.yaml)
[ "${#playbooks[@]}" -gt 0 ] || {
	echo "no playbooks matched playbooks/**/*.yaml" >&2
	exit 1
}
for playbook in "${playbooks[@]}"; do
	uv run ansible-playbook "$playbook" --syntax-check
done
