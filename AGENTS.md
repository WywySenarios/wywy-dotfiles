# wywy-dotfiles

## Scope

This repository locally installs the APT packages and binaries required by Wywy-Website-Control on the operator machine.
It targets `localhost` and manages no remote hosts.

## Never change infrastructure state

Do not run `ansible-playbook` except as a `--check` run, unless the user explicitly asked for that exact apply.
Read-only commands such as `ansible-lint`, `ansible-playbook --syntax-check`, and `ansible-playbook --check` are allowed.

Every playbook run needs `--ask-become-pass`. Do not assume passwordless escalation.

## Toolchain

- The Ansible toolchain is pinned in `pyproject.toml` and `uv.lock`. Change the pins and regenerate the lock in the same commit.
- `uv` is a prerequisite. `scripts/install.sh` provisions the toolchain.
- Playbooks use fully qualified module names (`ansible.builtin.apt`, not `apt`).
- Packages and binaries are managed by roles under `roles/`. Do not add a `shell`, `command`, or `raw` task when a module covers the job.
- The Proxmox VE source is preference-limited by `roles/proxmox_repo`. Do not loosen `/etc/apt/preferences.d/proxmox.pref`: the `-1` pin is the only thing keeping PVE kernels and meta-packages off this machine.

## Testing

Run suites through `scripts/tests/**`. If no suite exists, report that instead of inventing one.
