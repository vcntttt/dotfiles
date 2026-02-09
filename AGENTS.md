# AGENTS.md

This repository is a personal dotfiles setup for Linux/Arch.
It is primarily shell scripts and application config files.
Changes here often affect the local system directly; keep edits minimal and safe.

## Repository map
- `shell/` contains zsh/bash env, aliases, and plugin setup.
- `omarchy/` is a reference-only config pack; kept from a past setup to reuse ideas as needed.
- `.config/hypr/` contains Hyprland configuration split across multiple `.conf` files.
- `.config/espanso/` stores Espanso snippets (`base.yml`, `private.yml`).
- `.config/rofi/` contains rofi scripts and themes.
- `.config/swaync/` contains notification center JSON config.
- `.local/bin/` contains small helper scripts.
- `.local/share/fastfetch/` contains custom fastfetch logos.
- `.tmux.conf` is the tmux configuration.
- `.opencode/` contains OpenCode command assets (not part of the dotfiles runtime).

## Build, lint, test commands
Status: no standard build, lint, or test runner is defined in this repo.
There is no `package.json`, `Makefile`, or test framework config at the root.

If you need to validate changes:
- Shell scripts can be executed directly (see `shell/` and `.local/bin/`).
- Use `bash` or `zsh` depending on the shebang or file context.

Examples of common entry points:
- `bash shell/plugins/install.sh` installs zsh plugins and packages.
- `bash omarchy/install.sh` runs the Omarchy installer (system-changing).
- `bash omarchy/boot.sh` performs Omarchy bootstrap steps.

Single test command: not applicable (no test suite found).
If you add tests or a build system, document the commands here.

## Optional sanity checks (manual)
- `bash -n path/to/script.sh` for bash syntax checks.
- `zsh -n path/to/config.zsh` for zsh syntax checks.
- `tmux source-file ~/.tmux.conf` to reload tmux config after edits.
- `hyprctl reload` can be used to reload Hyprland config if running.

## Agent workflow expectations
- Keep edits minimal and focused; avoid broad formatting changes.
- Do not run system-changing scripts unless explicitly requested.
- Prefer making the smallest safe change and preserve existing structure.
- If you create new files, match directory conventions and add executable bits when needed.
- Default to ASCII; only introduce Unicode when the file already uses it.

## Runtime assumptions
- Targets Arch-based Linux; package management uses `pacman` and `yay`.
- Paths are Linux-style and often rely on `$HOME`.
- Many scripts are intended for interactive shells (zsh).

## Code style: shell (bash/zsh)
- Use the correct shell: `#!/usr/bin/env bash` for bash scripts; zsh for interactive configs.
- Prefer `set -e` (and optionally `set -u`) in installer-style scripts.
- Use `[[ ... ]]` for conditionals and always quote variable expansions.
- Indentation is typically 2 spaces in bash/zsh scripts.
- Keep functions small and named in lower_case with clear intent.
- Use `local` for function-scoped variables in bash/zsh.
- Prefer `$HOME` over hard-coded paths when reasonable.
- Use `command -v tool &>/dev/null` before invoking optional tools.
- Use arrays for lists of packages or plugins, with one entry per line.
- Keep existing comments and language (many comments are Spanish).
- Avoid reformatting or reordering unless needed for the change.

## Code style: Zsh config specifics
- Use `source` for loading files and keep plugin load order stable.
- Use `autoload -Uz` and `bindkey` for keybindings.
- Keep alias blocks grouped by topic and comment headers intact.

## Code style: Hyprland config
- Files in `.config/hypr/` are composed with `source = ...` in `hyprland.conf`.
- Keep the existing split-file structure (envs, monitors, bindings, etc.).
- Use `#` for comments; keep commented rules for easy toggling.
- Maintain ordering to preserve user expectations.
- Preserve spacing around `=` and existing line grouping.

## Code style: Espanso YAML
- Use 2-space indentation under `matches:`.
- Each snippet is a list item with `trigger` and `replace` keys.
- Keep schema line and documentation comments at the top.
- Avoid editing `.config/espanso/match/private.yml` unless explicitly requested.
- Keep existing triggers and order unless a change requires reordering.

## Code style: JSON configs
- Preserve existing formatting; do not reformat whole files.
- Keep keys as-is and maintain ordering for readability.
- SwayNC config (`.config/swaync/config.json`) includes inline comments and mixed spacing.

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
- `omarchy/install.sh` and `omarchy/boot.sh` modify system state.
- `shell/plugins/install.sh` installs packages and clones repositories.
- `fix-red.sh` modifies networking rules via `iptables`.

## Imports, sourcing, and ordering
- Group environment variable exports together in `shell/env.sh`.
- Group aliases by topic in `shell/alias.sh` and keep headings.
- Keep `source` statements at the top of loader scripts.

## Privacy and secrets
- Treat `.config/espanso/match/private.yml` as sensitive.
- Avoid printing or exposing personal data in logs or output.
- Do not add credentials or tokens to this repo.
- Avoid copying sample secrets into public files.

## File permissions
- Preserve executable bits on scripts in `.local/bin/` and `shell/plugins/`.
- Do not change permissions unless required by the change.

## Cursor/Copilot rules
- No `.cursor/rules/`, `.cursorrules`, or `.github/copilot-instructions.md` found.

## When adding new tooling
- If you add build/lint/test tooling, update this file with exact commands.
- Include a single-test command if the runner supports it.
- Keep instructions concise and focused on agent automation.
