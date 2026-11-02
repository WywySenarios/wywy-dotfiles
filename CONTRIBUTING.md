# Contributing

## Layout

| Path                 | Contents                  |
| -------------------- | ------------------------- |
| `inventory/`         | Ansible inventory.        |
| `playbooks/`         | Ansible playbooks.        |
| `roles/`             | Ansible roles.            |
| `scripts/install.sh` | Operator entrypoint.      |
| `scripts/lib/`       | Shared shell helpers.     |
| `scripts/tests/`     | Test suite entrypoint(s). |

## Development setup

1. Clone the repository.
2. Install the pinned Ansible toolchain:

   ```bash
   scripts/install.sh
   ```

3. Install the hooks once per clone:

   ```bash
   pre-commit install
   ```

The playbook targets `localhost` with `ansible_connection: local` (`inventory/local/hosts.yaml`). No target configuration is needed.

## Testing

All suites are under scripts/tests/\*\*/\*.sh

## Extra Code Conventions

- Installers are idempotent and support `--dry-run`.
- Pin tool and collection versions. Do not install `latest` or any floating tag.=

## A Final Warning

Do not commit with `--no-verify`.
