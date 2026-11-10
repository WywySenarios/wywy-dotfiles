# Contributing

## Repository layout

| Path                   | Contents                                           |
| ---------------------- | -------------------------------------------------- |
| `inventory/`           | Ansible inventory.                                 |
| `playbooks/`           | Ansible playbooks.                                 |
| `roles/`               | Ansible roles.                                     |
| `scripts/install.sh`   | Toolchain bootstrap.                               |
| `scripts/install/`     | Bootstrap steps.                                   |
| `scripts/uninstall.sh` | Toolchain teardown.                                |
| `scripts/uninstall/`   | Teardown steps.                                    |
| `scripts/lib/`         | Shared Bash helpers from `wywy-shlib`.             |
| `scripts/tests/`       | Test suites.                                       |
| `scripts/verify.sh`    | User-facing verification of the provisioned tools. |

The playbook targets `localhost` with `ansible_connection: local` (`inventory/local/hosts.yaml`). No target configuration is needed.

## Development setup

Initialize the submodule, then install the hooks once per clone. This requires `pre-commit`:

```bash
git submodule update --init --recursive
pre-commit install
```

## Testing

Run every suite before committing:

```bash
scripts/tests/shell.sh
scripts/tests/ansible/syntax.sh
scripts/tests/ansible/lint.sh
```

## Conventions

- Installers are idempotent and support `--dry-run`.
- Standalone tools install to `~/.local/opt/<tool>/` and are linked into `~/.local/bin`. Standalone installs never use `sudo`.
- Apt is the only root install. Exact apt pins are replaced with `CONVENTION EXCEPTION: <reason>` when a pin would block security updates.
- Pin tool and collection versions. Do not install `latest` or any floating tag.
- PATH links use absolute targets and are never retargeted.

## Submitting changes

Create a branch, keep the change focused, and run the suites before pushing. Open a pull request against `main` and describe behavior changes and any new pin or exception.
