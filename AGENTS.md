# AGENTS.md

This repository is a personal dotfiles setup for Linux/Arch.
It is primarily shell scripts and application config files.
Changes here often affect the local system directly; keep edits minimal and safe.

## Repository map
- `shell/` contains package manifests and the Arch/CachyOS dependency installer.
- `.config/hypr/` contains the active Hyprland Lua configuration.
- `.config/noctalia/` contains Noctalia's declarative TOML configuration.
- `.local/state/noctalia/settings.toml` is the only versioned Noctalia state file; the GUI writes its overrides there.
- `.config/fish/` contains the interactive shell configuration.
- `.config/espanso/` stores Espanso snippets (`base.yml`, `private.yml`).
- `.local/bin/` contains small helper scripts.
- `.local/share/fastfetch/` contains custom fastfetch logos.
- `.tmux.conf` is the tmux configuration.
- `.opencode/` contains OpenCode command assets (not part of the dotfiles runtime).

## Build, lint, test commands
Status: no standard build, lint, or test runner is defined in this repo.
There is no `package.json`, `Makefile`, or test framework config at the root.

If you need to validate changes:
- Shell scripts can be executed directly (see `shell/` and `.local/bin/`).
- Use `bash` for scripts and `fish -n` for Fish configuration.

Examples of common entry points:
- `bash shell/install-dependencies.sh desktop` installs base CLI tools, CachyOS Hyprland + Noctalia, and desktop apps.
- `bash shell/install-dependencies.sh core` installs only CLI tools and Fish.

Single test command: not applicable (no test suite found).
If you add tests or a build system, document the commands here.

## Optional sanity checks (manual)
- `bash -n path/to/script.sh` for bash syntax checks.
- `fish -n .config/fish/config.fish` for Fish syntax checks.
- `noctalia config validate` after Noctalia changes.
- `tmux source-file ~/.tmux.conf` to reload tmux config after edits.
- `hyprctl reload` can be used to reload Hyprland config if running.
- After any Hyprland config change, ensure `hyprctl configerrors` returns no errors.
- Use `stow --no --verbose=1 .` before applying changes to runtime symlinks.

## Agent workflow expectations
- Keep edits minimal and focused; avoid broad formatting changes.
- Do not run system-changing scripts unless explicitly requested.
- Prefer making the smallest safe change and preserve existing structure.
- If you create new files, match directory conventions and add executable bits when needed.
- Default to ASCII; only introduce Unicode when the file already uses it.

## Source of truth and symlinks
- This repository is the source of truth for dotfiles; runtime paths like `~/.config/...` and `~/.local/bin/...` are symlinked to files in this repo.
- Prefer editing repo paths such as `.config/hypr/...`, `.config/noctalia/...`, `.config/fish/...`, and `.local/bin/...`.
- Use runtime paths mainly for reloads, verification, or confirming how symlinks resolve on the current machine.
- Noctalia GUI changes are the exception: it writes through the versioned symlink at `.local/state/noctalia/settings.toml`.
- Keep all other Noctalia state, credentials, caches, and generated themes outside the repo.
- See `docs/config-model.md` and `docs/sync-model.md`.

## Runtime assumptions
- The `main` branch targets the primary CachyOS desktop with Hyprland, Noctalia, UWSM, and Fish.
- Package management uses `pacman` and `yay`.
- Paths are Linux-style and often rely on `$HOME`.
- Bash helpers should remain portable when they are not desktop-specific.

## Host targets
- Primary desktop: CachyOS with Hyprland and Noctalia; this is the only target of `main`.
- The notebook remains on the `arch-hyprland-vanilla` legacy branch until this setup stabilizes.
- There is currently no host override model in `main`.

## Code style: shell (bash/Fish)
- Use `#!/usr/bin/env bash` for Bash scripts and Fish syntax only under `.config/fish/`.
- Prefer `set -e` (and optionally `set -u`) in installer-style scripts.
- Use `[[ ... ]]` for conditionals and always quote variable expansions.
- Indentation is typically 2 spaces in Bash scripts.
- Keep functions small and named in lower_case with clear intent.
- Use `local` for function-scoped variables in Bash.
- Prefer `$HOME` over hard-coded paths when reasonable.
- Use `command -v tool &>/dev/null` before invoking optional tools.
- Use arrays for package lists, with one entry per line.
- Keep existing comments and language (many comments are Spanish).
- Avoid reformatting or reordering unless needed for the change.

## Code style: Fish config specifics
- Keep CachyOS' shared Fish configuration sourced before local overrides.
- Use `fish_add_path` for persistent path additions.
- Keep local functions and aliases grouped by topic when they are added.

## Code style: Hyprland config
- `.config/hypr/hyprland.lua` is the entry point.
- Keep the split Lua modules under `.config/hypr/config/`.
- Load modules with `require` and preserve their ordering.
- Use the installed Hyprland Lua API (`hl.config`, `hl.bind`, `hl.window_rule`, and related helpers).
- After edits, validate the live session with `hyprctl configerrors`.

## Code style: Noctalia
- Curated TOML belongs in `.config/noctalia/`.
- GUI-managed overrides belong only in `.local/state/noctalia/settings.toml`.
- Avoid defining the same value in both layers unless the override is intentional.
- Do not version `state.toml`, histories, credentials, catalogs, caches, or generated `noctalia.*` themes.
- Validate changes with `noctalia config validate`.

## Code style: Espanso YAML
- Use 2-space indentation under `matches:`.
- Each snippet is a list item with `trigger` and `replace` keys.
- Keep schema line and documentation comments at the top.
- Avoid editing `.config/espanso/match/private.yml` unless explicitly requested.
- Keep existing triggers and order unless a change requires reordering.

## Code style: JSON configs
- Preserve existing formatting; do not reformat whole files.
- Keep keys as-is and maintain ordering for readability.

## Code style: tmux
- Keep plugin list at the top of `.tmux.conf`.
- Keep TPM initialization at the end.
- Preserve keybind ordering and comments.

## Code style: Python
- Simple scripts with stdlib only; keep dependencies minimal.
- Use 4-space indentation and straightforward control flow.
- Prefer explicit variable names over clever one-liners.
- Use `if __name__ == "__main__":` for script entry points.
- Keep prompts and user-facing text in Spanish when applicable.

## Naming and organization
- Match existing file naming in each directory (snake, kebab, or lowercase).
- Avoid moving or renaming files unless necessary for the change.
- Keep user-facing strings in Spanish when editing existing Spanish text.
- Prefer adding new scripts under `.local/bin/` and configs under `.config/`.

## Error handling and safety
- Scripts that change system state should be idempotent where possible.
- Check for existing directories or packages before creating/installing.
- Use clear `echo` output for long-running scripts.
- Do not add destructive commands unless explicitly required.
- Avoid running package managers (`pacman`, `yay`) in automation unless asked.

## System-changing scripts
- `shell/install-dependencies.sh` installs packages.
- `fix-red.sh` modifies networking rules via `iptables`.

## Imports, sourcing, and ordering
- Keep Fish `source` statements before local overrides.
- Keep Hyprland `require` calls together in `hyprland.lua`.
- Noctalia loads TOML files alphabetically; use intentional names if the config is split.

## Privacy and secrets
- Treat `.config/espanso/match/private.yml` as sensitive.
- Avoid printing or exposing personal data in logs or output.
- Do not add credentials or tokens to this repo.
- Avoid copying sample secrets into public files.

## File permissions
- Preserve executable bits on scripts in `.local/bin/`.
- Do not change permissions unless required by the change.

## Cursor/Copilot rules
- No `.cursor/rules/`, `.cursorrules`, or `.github/copilot-instructions.md` found.

## When adding new tooling
- If you add build/lint/test tooling, update this file with exact commands.
- Include a single-test command if the runner supports it.
- Keep instructions concise and focused on agent automation.
