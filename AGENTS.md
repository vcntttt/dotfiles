# AGENTS.md

Personal Linux/Arch dotfiles for the primary CachyOS desktop running Hyprland,
Noctalia, UWSM, and Fish. Keep changes small, focused, and safe: this repo is
the source of truth for the user's runtime configuration.

## Repository map

- `shell/`: package manifests and dependency installer.
- `.config/hypr/`: active Hyprland Lua configuration; `hyprland.lua` is the entry point.
- `.config/noctalia/`: curated Noctalia TOML configuration.
- `.local/state/noctalia/settings.toml`: only versioned GUI-managed state file.
- `.config/fish/`, `.config/espanso/`: Fish config and Espanso snippets.
- `.local/bin/`, `.local/share/fastfetch/`: helper scripts and Fastfetch assets.
- `.tmux.conf`: tmux configuration.
- `.opencode/`: OpenCode assets, not dotfiles runtime configuration.

The `main` branch targets the primary desktop. The old configuration is kept
on the `arch-hyprland-vanilla` legacy branch and at
`/home/vrivera/git-packages/legacy-dotfiles`; there is no host-override model.

Cuando te mencione alguna feature de omarchy que me gustaría incluir, puedes revisar '~/git-packages/omarchy', recuerda hacer un `git pull` antes de revisar.

## Source of truth and safety

- Edit repository paths, not runtime symlinks. Use runtime paths only to reload
  or verify the active configuration.
- Noctalia GUI overrides may write through the versioned state symlink. Keep
  other state, credentials, caches, histories, catalogs, and generated themes
  out of the repo.
- Treat `.config/espanso/match/private.yml` as sensitive. Never add or print
  credentials, tokens, or personal data.
- Do not run package managers or system-changing scripts unless explicitly
  requested. In particular, `shell/install-dependencies.sh` installs packages
  and `fix-red.sh` changes iptables rules.
- Preserve executable bits, existing comments/language, file formatting, and
  ordering unless the change requires otherwise. Default to ASCII.

## Conventions

- Bash scripts use `#!/usr/bin/env bash`, quoted expansions, `[[ ... ]]`, small
  lower-case functions, and `local` variables. Use arrays for package lists.
- Fish shared configuration must be sourced before local overrides; use
  `fish_add_path` for persistent paths.
- Hyprland modules are loaded with `require`; keep the installed Lua API and
  module ordering intact.
- Noctalia curated config belongs in `.config/noctalia/`; GUI-managed values
  belong in `.local/state/noctalia/settings.toml`.
- Espanso YAML uses two-space indentation and preserves the schema header,
  existing triggers, and order. Do not edit `private.yml` without explicit
  authorization.
- Preserve formatting and key ordering in JSON, tmux, and other configs.
- New scripts go under `.local/bin/`; new configs go under `.config/`.

## Validation

There is no standard build, test, or lint runner. Use the narrowest applicable
check after editing:

```sh
bash -n path/to/script.sh
fish -n .config/fish/config.fish
noctalia config validate
hyprctl configerrors
stow --no --verbose=1 .
```

Use `hyprctl reload` or `tmux source-file ~/.tmux.conf` only when a live reload
is needed. Do not invoke the installers as validation. If new tooling is
added, document its exact commands here, including a single-test command.
