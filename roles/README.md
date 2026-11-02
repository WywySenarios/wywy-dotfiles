# Roles

`playbooks/site.yaml` applies these roles to the operator machine. `packages` depends on `docker_repo`: `docker-ce`, `docker-ce-cli`, and `docker-buildx-plugin` are only available once the Docker repository exists.

| Role           | Owns                                      |
| -------------- | ----------------------------------------- |
| `docker_repo`  | Docker apt repository and signing key.    |
| `packages`     | apt packages                              |
| `proxmox_repo` | Proxmox apt repository, key, and apt pin. |
| `binaries`     | Pinned binaries                           |

## Variables

Variable defaults are declared in each role's `defaults/main.yaml`.
