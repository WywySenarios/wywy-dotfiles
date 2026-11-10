# Roles

`playbooks/site.yaml` applies these roles to the operator machine. `packages` depends on `docker_repo`: `docker-ce`, `docker-ce-cli`, and `docker-buildx-plugin` are only available once the Docker repository exists.

| Role              | Owns                                                      |
| ----------------- | --------------------------------------------------------- |
| `docker_repo`     | Docker apt repository and signing key.                    |
| `packages`        | apt packages and their `~/.local/bin` links.              |
| `docker_group`    | Operator membership in the docker group.                  |
| `proxmox_repo`    | Proxmox apt repository, key, and apt pin.                 |
| `binaries`        | Pinned userland binaries and their `~/.local/bin` links.  |
| `path_links`      | Guarded `~/.local/bin` symlinks for any provisioned tool. |
| `disable_suspend` | Automatic and lid-close suspend in GNOME.                 |

`path_links` is the shared link helper. It creates absolute `~/.local/bin/<name>` symlinks, backs up a displaced regular file to `<name>.bak`, and fails closed on a directory, a foreign symlink, or a broken link.

## Variables

Variable defaults are declared in each role's `defaults/main.yaml`.
