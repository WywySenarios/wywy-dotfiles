# wywy-dotfiles

This repo is part of the Wywy repo line and is subject to Wywy conventions.

The control repo (Wywy-Website-Control)'s operator machine configuration.

## Prerequisites

- AMD64 Debian (YMMV with Debian-based distributions)
- `sudo`, with a password
- `git`
- `uv`

## Setup

Install the pinned Ansible toolchain:

```bash
scripts/install.sh
```

## Usage

Apply the playbook to this machine:

```bash
uv run ansible-playbook playbooks/site.yaml --ask-become-pass
```

Pins and checksums live in `roles/packages/defaults/main.yaml` and `roles/binaries/defaults/main.yaml`.

## Status

Unstable.
