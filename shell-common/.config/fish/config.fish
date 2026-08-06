if not set -q __vrivera_cachyos_config_loaded; and test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
    set -g __vrivera_cachyos_config_loaded 1
end

set -l dotfiles_host_file "$HOME/.config/dotfiles/host"
if test -f "$dotfiles_host_file"
    set -gx DOTFILES_HOST (string trim < "$dotfiles_host_file")
end

# Editor predeterminado para herramientas de consola y sudoedit
set -gx EDITOR /usr/bin/nvim
set -gx VISUAL /usr/bin/nvim
set -gx SUDO_EDITOR /usr/bin/nvim

# opencode
fish_add_path "$HOME/.opencode/bin"

# Herramientas instaladas fuera de los dotfiles (Codex y Pi)
fish_add_path "$HOME/.local/bin-extra"

# zoxide
if command -q zoxide
    zoxide init fish | source
end

source "$HOME/.config/fish/functions.fish"
source "$HOME/.config/fish/aliases.fish"

if test -f "$HOME/.config/fish/host.fish"
    source "$HOME/.config/fish/host.fish"
end

# Mobile / Android
set -gx ANDROID_SDK_ROOT "$HOME/Android/Sdk"
set -gx ANDROID_HOME "$ANDROID_SDK_ROOT"
set -gx ANDROID_AVD_HOME "$HOME/.config/.android/avd"
set -gx ANDROID_SDK_HOME "$HOME/.config/.android"
fish_add_path "$ANDROID_SDK_ROOT/platform-tools" "$ANDROID_SDK_ROOT/emulator" "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# opencode
fish_add_path /home/vrivera/.opencode/bin
