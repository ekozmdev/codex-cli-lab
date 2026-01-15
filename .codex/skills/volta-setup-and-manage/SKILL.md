---
name: volta-setup-and-manage
description: Install and manage Volta toolchains for Node.js and package managers. Use when installing or updating Volta on macOS/Linux/Windows, setting up shell/PATH variables, installing default Node/npm/yarn/pnpm versions, pinning project tool versions in package.json, listing or uninstalling tools/packages, or troubleshooting Volta resolution.
---

# Volta Setup and Management

## Task map

- Install or uninstall Volta: use `references/volta-install.md`.
- Manage default toolchains and global packages: use `references/volta-toolchain.md`.
- Pin per-project tool versions: use `references/volta-toolchain.md`.
- Inspect or remove tools: use `references/volta-toolchain.md`.
- Troubleshoot PATH or binary selection: use `references/volta-toolchain.md`.

## Working notes

- Prefer version placeholders like `<version>` to avoid hardcoding.
- Run pinning commands from the project directory that owns the target `package.json`.
