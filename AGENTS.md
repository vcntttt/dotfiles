# AGENTS.md

Personal dotfiles for two CachyOS/Hyprland/Noctalia machines and the Ubuntu
Server host Caburgua. Keep changes small, focused, and safe: this repo is the
source of truth for the user's runtime configuration.

## Repository map

- `shell-common/`: shared Fish, tmux and shell utilities package.
- `common/`: shared CLI/application configuration package.
- `graphical/`: shared Hyprland, Noctalia, Ghostty and GUI package.
- `desktop/`, `notebook/`, `caburgua/`: small host-specific Stow overlays.
- `shell/`: setup scripts, dependency manifests and host selection helper.
- `.opencode/`: OpenCode assets, not dotfiles runtime configuration.

The `main` branch contains the common base and all three host overlays. The
legacy configuration remains on `arch-hyprland-vanilla` and at
`/home/vrivera/git-packages/legacy-dotfiles` for reference.

Cuando te mencione alguna feature de omarchy que me gustaría incluir, puedes revisar '~/git-packages/omarchy', recuerda hacer un `git pull` antes de revisar.

## Source of truth and safety

- Edit repository paths, not runtime symlinks. Use runtime paths only to reload
  or verify the active configuration.
- The setup scripts write the selected host to
  `~/.config/dotfiles/host`, back up conflicting real files, and stow only the
  selected packages.
- Host-specific files are direct symlinks, so editing them does not require a
  second apply command; only the application itself may need a reload.
- Noctalia GUI overrides may write through the selected host's versioned state
  symlink. Keep other state, credentials, caches, histories, catalogs, and
  generated themes out of the repo.
- Treat `shell-common/.config/espanso/match/private.yml` as sensitive. Never
  add or print credentials, tokens, or personal data.
- Do not run package managers or system-changing scripts unless explicitly
  requested. In particular, `shell/install-dependencies.sh` installs packages
  and `graphical/.local/bin/fix-red.sh` changes iptables rules.
- Preserve executable bits, existing comments/language, file formatting, and
  ordering unless the change requires otherwise. Default to ASCII.

## Conventions

- Bash scripts use `#!/usr/bin/env bash`, quoted expansions, `[[ ... ]]`, small
  lower-case functions, and `local` variables. Use arrays for package lists.
- Fish shared configuration must be sourced before local host overrides; use
  `fish_add_path` for persistent paths.
- Hyprland common modules live in `graphical/.config/hypr/` and are loaded with
  `require`; host values live in the selected package's `config/host.lua`.
- Noctalia plugins live in `graphical/.config/noctalia/plugins/`; host TOML
  belongs in `desktop/` or `notebook/`.
- Espanso YAML uses two-space indentation and preserves the schema header,
  existing triggers, and order. Do not edit `private.yml` without explicit
  authorization.
- Preserve formatting and key ordering in JSON, tmux, and other configs.
- New shared shell scripts go under `shell-common/.local/bin/`; graphical
  helpers go under `graphical/.local/bin/`; setup scripts go under `shell/`.
- A host-specific script or config belongs under the matching host package.

## Validation

There is no standard build, test, or lint runner. Use the narrowest applicable
check after editing:

```sh
bash -n shell/setup-host.sh
bash -n shell/setup-desktop.sh
fish -n shell-common/.config/fish/config.fish
stow --no --verbose=1 --dir=. --target="$HOME" --no-folding \
  shell-common common graphical notebook
noctalia config validate
hyprctl configerrors
```

Use `hyprctl reload` or `tmux source-file ~/.tmux.conf` only when a live reload
is needed. Do not invoke the dependency installer as validation. If new
tooling is added, document its exact commands here, including a single-test
command.
