# Contributing

## Layout

| Path                 | Contents              |
| -------------------- | --------------------- |
| `inventory/`         | Ansible inventory.    |
| `playbooks/`         | Ansible playbooks.    |
| `roles/`             | Ansible roles.        |
| `scripts/install.sh` | Operator entrypoint.  |
| `scripts/lib/`       | Shared shell helpers. |
| `scripts/tests/`     | Test suites.          |

The playbook targets `localhost` with `ansible_connection: local` (`inventory/local/hosts.yaml`). No target configuration is needed.

## Development setup

Install the hooks once per clone. This requires `pre-commit`:

```bash
pre-commit install
```

## Testing

All suites are under `scripts/tests/\*\*/\*.sh`. Make sure they all pass before committing.

## Extra Code Conventions

- Installers must be idempotent and support `--dry-run`.
- Pin tool and collection versions. Do not install `latest` or any floating tag.

## A Final Warning

Do not commit with `--no-verify`.
