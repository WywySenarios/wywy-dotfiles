#!/bin/bash
set -euo pipefail

REPO_ROOT="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../../..")"
cd "$REPO_ROOT"

export ANSIBLE_CONFIG="ansible.cfg"

echo "==> ansible-lint (production profile)" >&2
uv run ansible-lint -c .ansible-lint inventory/ playbooks/ roles/
