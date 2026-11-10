# wywy-dotfiles

## Scope

This repository provisions the operator machine locally. It targets `localhost` and manages no remote hosts.

## Never change infrastructure state

Do not run `ansible-playbook` except as a `--check` run, unless the user explicitly asked for that exact apply.

Read-only commands such as `ansible-lint`, `ansible-playbook --syntax-check`, and `ansible-playbook --check` are allowed.

Every playbook run needs `--ask-become-pass`. Do not assume passwordless escalation.

## Testing

Run every suite before finishing, cheapest first:

```bash
scripts/tests/shell.sh
scripts/tests/ansible/syntax.sh
scripts/tests/ansible/lint.sh
```

Never commit with `--no-verify`.

## Conventions

- Standalone tools install to `~/.local/opt/<tool>/` and are linked into `~/.local/bin`. Standalone installs never use `sudo`.
- Apt is the only root install. `become: true` belongs on the individual apt, keyring, repository, and group tasks, never on the play.
- `~/.local/bin` is the only directory this repo expects on `PATH`. Never add a tool root.
- Tool thresholds live in role defaults. A probe that fails or does not parse is below the threshold. Never downgrade an installed tool.
- PATH links are never retargeted. A foreign, broken, or looping symlink is a failure, not something to overwrite.
- Use fully qualified module names. Do not add a `shell`, `command`, or `raw` task when a module covers the job.
- The Proxmox `-1` pin is load-bearing: it is the only thing keeping PVE kernels and meta-packages off this machine.
- Regenerate `uv.lock` whenever `pyproject.toml` pins change.
