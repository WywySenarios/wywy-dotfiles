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

Preview the changes the playbook would make:

```bash
uv run ansible-playbook playbooks/site.yaml --check --diff --ask-become-pass
```

Apply them:

```bash
uv run ansible-playbook playbooks/site.yaml --ask-become-pass
```

## Configuration

The required package list lives in `roles/packages/defaults/main.yaml`. Pinned binary versions and their SHA-256 checksums live in `roles/binaries/defaults/main.yaml`.

## Status

Unstable.
