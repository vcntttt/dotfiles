# Editor
export EDITOR="nvim"
export VISUAL="nvim"

# Terminal
export TERM="xterm-256color"

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# PATH base
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$HOME/.local/bin:$PATH"

# Android (esto sí es entorno, no runtime)
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_AVD_HOME="$HOME/.config/.android/avd"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools"
export MAESTRO_OUTPUT_DIR="$PWD/.maestro/_runs"

# Cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Bat
export BAT_THEME="base16"

# BUN
export PATH="/home/vrivera/.cache/.bun/bin:$PATH"
export SSH_AUTH_SOCK
export GNOME_KEYRING_CONTROL
