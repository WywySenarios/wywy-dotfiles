# wywy-dotfiles

This repo is part of the Wywy repo line and is subject to Wywy conventions.

The base dotfiles repo for Wywy machines (i.e. shared between the operator and dev machine).

## Prerequisites

- AMD64 Debian 13 (trixie). The playbook asserts the distribution, release, and architecture.
- `sudo`, with a password.
- `git`.
- `uv`.
- `~/.local/bin` on `PATH`. The shared shell environment and the `uv` installer both add it.

## Install

Clone the repo to the dotfiles location and bootstrap the pinned Ansible toolchain:

```bash
git clone --recurse-submodules https://github.com/WywySenarios/wywy-dotfiles.git ~/.config/dotfiles/repos/wywy-dotfiles
cd ~/.config/dotfiles/repos/wywy-dotfiles
scripts/install.sh
```

Preview the playbook, then apply it:

```bash
uv run ansible-playbook playbooks/site.yaml --check --diff --ask-become-pass
uv run ansible-playbook playbooks/site.yaml --ask-become-pass
```

Verify the provisioned tools:

```bash
scripts/verify.sh
```

## Configuration

Role defaults live in `roles/<role_name>/defaults/main.yaml`.

## Status

Unstable.
