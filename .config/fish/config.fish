if not set -q __vrivera_cachyos_config_loaded
    source /usr/share/cachyos-fish-config/cachyos-config.fish
    set -g __vrivera_cachyos_config_loaded 1
end

# Editor predeterminado para herramientas de consola y sudoedit
set -gx EDITOR /usr/bin/nvim
set -gx VISUAL /usr/bin/nvim
set -gx SUDO_EDITOR /usr/bin/nvim

# Desactivar el saludo de CachyOS (fastfetch)
function fish_greeting
end

# opencode
fish_add_path "$HOME/.opencode/bin"

# Herramientas instaladas fuera de los dotfiles (Codex y Pi)
fish_add_path "$HOME/.local/bin-extra"

# zoxide
if command -q zoxide
    zoxide init fish | source
    alias cd __zoxide_z
end

# Funciones personales migradas desde shell/alias.sh
function mkpdf
    set -l file $argv[1]

    if test -z "$file"
        printf 'Uso: mkpdf <ruta-al-tex>\n'
        return 1
    end

    latexmk -pdf "$file"; and latexmk -c "$file"
end

function projector_status
    command -q hyprctl; or return 1
    command -q jq; or return 1

    set -l projector_state (hyprctl -j monitors all 2>/dev/null | jq -r '
    map(select(.name == "HDMI-A-1"))
    | if length == 0 then "disconnected"
      elif .[0].disabled then "disabled"
      elif .[0].mirrorOf == "eDP-1" then "mirror"
      else "extended"
      end
  ')

    printf '%s\n' "$projector_state"
end

function projector_off
    hyprctl keyword workspace '6, monitor:eDP-1' >/dev/null
    hyprctl keyword workspace '7, monitor:eDP-1' >/dev/null
    hyprctl keyword monitor 'HDMI-A-1, disable'
    command pkill -RTMIN+8 waybar >/dev/null 2>&1; or true
end

function mirror
    set -l projector_state (projector_status); or begin
        printf 'No pude consultar Hyprland o jq.\n'
        return 1
    end

    if test "$projector_state" = disconnected
        printf 'No detecto el proyector en HDMI-A-1.\n'
        return 1
    end

    if test "$projector_state" = mirror
        projector_off
        return
    end

    hyprctl keyword monitor 'HDMI-A-1, disable' >/dev/null 2>&1; or true
    hyprctl keyword workspace '6, monitor:eDP-1' >/dev/null
    hyprctl keyword workspace '7, monitor:eDP-1' >/dev/null
    hyprctl keyword monitor 'HDMI-A-1, preferred, auto, 1, mirror, eDP-1'
    command pkill -RTMIN+8 waybar >/dev/null 2>&1; or true
end

function projector
    set -l projector_state (projector_status); or begin
        printf 'No pude consultar Hyprland o jq.\n'
        return 1
    end

    if test "$projector_state" = disconnected
        printf 'No detecto el proyector en HDMI-A-1.\n'
        return 1
    end

    if test "$projector_state" = extended
        projector_off
        return
    end

    hyprctl keyword monitor 'HDMI-A-1, disable' >/dev/null 2>&1; or true
    hyprctl keyword monitor 'HDMI-A-1, preferred, auto-right, 1' >/dev/null
    hyprctl keyword workspace '6, monitor:HDMI-A-1' >/dev/null
    hyprctl keyword workspace '7, monitor:HDMI-A-1' >/dev/null
    command pkill -RTMIN+8 waybar >/dev/null 2>&1; or true
end

function tm
    set -l session $argv[1]
    tmux attach -t "$session"; or tmux new -s "$session"
end

function scphl
    command scp $argv 'vrivera@caburgua.tailf8b14c.ts.net:/home/vrivera'
end

function booksend
    if test (count $argv) -eq 0
        printf 'Uso: booksend <archivo...>\n'
        return 1
    end

    if test -d /srv/data/apps/calibre-web/ingest
        command cp -iv $argv /srv/data/apps/calibre-web/ingest/
    else
        command scp $argv 'vrivera@caburgua.tailf8b14c.ts.net:/srv/data/apps/calibre-web/ingest/'
    end
end

# aliases personales migrados desde shell/alias.sh
alias sz 'source ~/.config/fish/config.fish'
alias zsh 'nvim ~/.zshrc; source ~/.zshrc'
alias al 'nvim ~/dotfiles/.config/fish/config.fish; source ~/.config/fish/config.fish'
alias lal 'cat ~/dotfiles/.config/fish/config.fish'

if command -q bat
    alias cat bat
else if command -q batcat
    alias bat batcat
    alias cat batcat
end

# Sistema / Arch
alias pup 'sudo pacman -Syu'
alias pas 'sudo pacman -S --needed'
alias pss 'pacman -Ss'
alias yup 'yay -Syu --noconfirm'
alias reflec 'sudo reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist'
alias grub-reconf 'sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias chx 'chmod +x'
alias off 'shutdown now'

# Window manager / Hyprland
alias logout 'hyprctl dispatch exit'
alias ra restart-app
alias rwall 'systemctl --user restart hyprpaper.service'
alias extend projector
alias ff 'fastfetch --config default'
alias ahc apply-host-config
alias deps 'bash ~/dotfiles/shell/install-dependencies.sh'

# Editor / Neovim
alias nv 'nvim .'
alias sn 'sudo nvim'
alias nconf 'nvim ~/.config/nvim'
alias ndot 'nvim ~/dotfiles'
alias ee 'nvim ~/dotfiles/.config/espanso/match/base.yml; espanso restart'
alias lee 'cat ~/dotfiles/.config/espanso/match/base.yml'

# Archivos / navegación
alias .. 'cd ..'
alias ... 'cd ../..'
alias mkdir 'mkdir -pv'
alias cp 'cp -iv'
alias mv 'mv -i'
alias untar 'tar -xf'
alias du 'du -sh *'
alias fm yazi
alias fz fzf
alias cpf copyfile
alias cpd copydir

# Listado / Eza
alias ls 'eza --icons=always -F always'
alias ll 'eza --icons=always --color=always --long --no-filesize --git --header'
alias la 'eza --icons=always --color=always --long --all --git --header'
alias l 'eza --icons=always --color=always --long --all --no-user --no-filesize --git --header'
alias lt "eza --icons=always --tree --ignore-glob='node_modules|__pycache__'"
alias fl 'fc-list : family | sort | uniq | grep -i'

# Git
alias lg lazygit
alias ginit 'git init --initial-branch=main'
alias gcl 'git clone --depth=1'
alias gs 'git status'
alias ga 'git add'
alias gap 'git add -p'
alias gc 'git commit -m'
alias gca 'git commit -a -m'
alias gcp 'git commit -p'
alias gcam 'git commit --amend'
alias ulc 'git reset --soft HEAD~1; git restore --staged .'
alias gl 'git log --all --graph'
alias gd 'git diff'
alias gds 'git diff --staged'
alias gb 'git branch'
alias gco 'git checkout'
alias gw 'git switch'
alias gm 'git merge'
alias gf 'git fetch'
alias gu 'git pull'
alias gur 'git pull --rebase'
alias gp 'git push'
alias ghrc 'gh repo create --public --source=. --remote=origin'

# Bun / Node / pnpm
alias npm bun
alias npx bunx
alias bx bunx
alias bi 'bun install'
alias ba 'bun add'
alias br 'bun run'
alias brd 'bun run dev'
alias brs 'bun run start'
alias brb 'bun run build'
alias cleanpm 'bunx npkill'
alias checkseo 'bunx check-site-meta'
alias bcn 'bunx --bun shadcn@latest add'
alias ppi 'pnpm install'
alias pr 'pnpm run'
alias ppd 'pnpm dev'

# Desarrollo general
alias c 'code .'
alias lsc 'cloc . --exclude-dir=node_modules,.next,dist,.turbo,.git,vendor --exclude-ext=svg,json,yaml --vcs git'

# Docker
alias dcu 'docker compose up -d'
alias dcd 'docker compose down'
alias dc 'docker compose'
alias dcb 'docker compose build'

# Terraform / infraestructura
alias tf terraform
alias tfi 'terraform init'
alias tfp 'terraform plan'
alias tfa 'terraform apply --auto-approve'
alias tfia 'terraform init; terraform apply --auto-approve'
alias rsh 'ssh-keygen -R'
alias stga 'systemctl status openvpn-client@galileo'

# Mobile / Android
set -gx ANDROID_SDK_ROOT "$HOME/Android/Sdk"
set -gx ANDROID_HOME "$ANDROID_SDK_ROOT"
set -gx ANDROID_AVD_HOME "$HOME/.config/.android/avd"
set -gx ANDROID_SDK_HOME "$HOME/.config/.android"
fish_add_path "$ANDROID_SDK_ROOT/platform-tools" "$ANDROID_SDK_ROOT/emulator" "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"

alias android 'emulator -avd Low_Cost_Device_API_35 &'
alias bra 'bun run android'
alias easapk 'eas build -p android --profile preview'
alias eap 'eas build -p --auto-submit'
alias bep 'bunx expo prebuild'

# Python
alias pip 'uv pip'
alias pif 'pip freeze > requirements.txt'
alias pir 'uv pip install -r requirements.txt'
alias py 'uv run'
alias pv pyenv
alias pvv 'pyenv virtualenv'
alias pva 'pyenv activate'
alias pvd 'pyenv deactivate'
alias pt 'python -m pytest'
alias vi 'python -m venv .venv'
alias va 'source .venv/bin/activate.fish'
alias vd deactivate

# Servicios locales
alias xmpstart 'sudo /opt/lampp/lampp start'
alias xmpstop 'sudo /opt/lampp/lampp stop'

# Hardware / periféricos
alias mvttf 'sudo mv *.ttf /usr/share/fonts/TTF; sudo fc-cache -fv'
alias ww "openrgb --profile '/home/vrivera/.config/OpenRGB/todo-blanco.orp'"
alias dpi 'polychromatic-cli -n "Razer Viper V3 HyperSpeed" --dpi'

# Información / utilidades
alias weather 'curl wttr.in'
alias psu 'ps aux | grep --color=auto'
alias ipinfo 'ip -br addr'
alias typr "nvim -c 'Typr'"

# Tmux
alias t tmux
alias ta 'tmux attach -t'
alias tn 'tmux new -s'
alias tls 'tmux ls'
alias tk 'tmux kill-session -t'
alias mkey 'openssl rand -hex 32'
alias oc opencode
alias zed 'zeditor .'
alias sshl 'ssh vrivera@caburgua.tailf8b14c.ts.net'
alias kctl kubectl
alias bar 'noctalia msg bar-show'

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
