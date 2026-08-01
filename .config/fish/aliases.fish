# Abreviaciones personales.
#
# Fish las expande en la línea de comandos al pulsar espacio o Enter, por lo
# que el comando completo queda visible y se guarda así en el historial.

# zoxide
if command -q zoxide
    abbr --add cd z
end

# Core / Fish
abbr --add sz 'source ~/.config/fish/config.fish'
abbr --add zsh 'nvim ~/.zshrc; source ~/.zshrc'
abbr --add al 'nvim "$HOME/dotfiles/.config/fish/aliases.fish"; source "$HOME/dotfiles/.config/fish/config.fish"'
abbr --add lal 'bat "$HOME/dotfiles/.config/fish/aliases.fish"'

if command -q bat
    abbr --add cat bat
else if command -q batcat
    abbr --add bat batcat
    abbr --add cat batcat
end

# Sistema / Arch
abbr --add pup 'sudo pacman -Syu'
abbr --add pas 'sudo pacman -S --needed'
abbr --add pss 'pacman -Ss'
abbr --add yup 'yay -Syu --noconfirm'
abbr --add reflec 'sudo reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist'
abbr --add grub-reconf 'sudo grub-mkconfig -o /boot/grub/grub.cfg'
abbr --add chx 'chmod +x'
abbr --add off 'shutdown now'

# Window manager / Hyprland
abbr --add logout 'hyprctl dispatch exit'
abbr --add ra restart-app
abbr --add rn 'restart-app noctalia'
abbr --add restart-noctalia 'restart-app noctalia'
abbr --add extend projector
abbr --add ff 'fastfetch --config default'
abbr --add ahc apply-host-config
abbr --add deps 'bash ~/dotfiles/shell/install-dependencies.sh'

# Secretos / Infisical
abbr --add ssi 'secrets-sync import'
abbr --add sse 'secrets-sync export'
abbr --add ssa 'secrets-sync audit'

# Editor / Neovim
abbr --add nv 'nvim .'
abbr --add sn 'sudo nvim'
abbr --add nconf 'nvim ~/.config/nvim'
abbr --add ndot 'nvim ~/dotfiles'
abbr --add ee 'nvim ~/dotfiles/.config/espanso/match/base.yml; espanso restart'
abbr --add lee 'cat ~/dotfiles/.config/espanso/match/base.yml'

# Archivos / navegación
abbr --add .. 'cd ..'
abbr --add ... 'cd ../..'
abbr --add mkdir 'mkdir -pv'
abbr --add cp 'cp -iv'
abbr --add mv 'mv -i'
abbr --add untar 'tar -xf'
abbr --add du 'du -sh *'
abbr --add fm yazi
abbr --add fz fzf
abbr --add cpf copyfile
abbr --add cpd copydir

# Listado / Eza
abbr --add ls 'eza --icons=always -F always'
abbr --add ll 'eza --icons=always --color=always --long --no-filesize --git --header'
abbr --add la 'eza --icons=always --color=always --long --all --git --header'
abbr --add l 'eza --icons=always --color=always --long --no-user --no-filesize --git --header'
abbr --add lt "eza --icons=always --tree --ignore-glob='node_modules|__pycache__'"
abbr --add fl 'fc-list : family | sort | uniq | grep -i'
abbr --add lsc 'cloc . --exclude-dir=node_modules,.next,dist,.turbo,.git,vendor --exclude-ext=svg,json,yaml --vcs git'

# Git
abbr --add lg lazygit
abbr --add ginit 'git init --initial-branch=main'
abbr --add gcl 'git clone --depth=1'
abbr --add gs 'git status'
abbr --add ga 'git add'
abbr --add gap 'git add -p'
abbr --add gc 'git commit -m'
abbr --add gca 'git commit -a -m'
abbr --add gcp 'git commit -p'
abbr --add gcam 'git commit --amend'
abbr --add ulc 'git reset --soft HEAD~1; git restore --staged .'
abbr --add gl 'git log --all --graph'
abbr --add gd 'git diff'
abbr --add gds 'git diff --staged'
abbr --add gb 'git branch'
abbr --add gco 'git checkout'
abbr --add gw 'git switch'
abbr --add gm 'git merge'
abbr --add gf 'git fetch'
abbr --add gu 'git pull'
abbr --add gur 'git pull --rebase'
abbr --add gp 'git push'
abbr --add ghrc 'gh repo create --public --source=. --remote=origin'

# Bun / Node / pnpm
abbr --add npm bun
abbr --add npx bunx
abbr --add bx bunx
abbr --add bi 'bun install'
abbr --add ba 'bun add'
abbr --add br 'bun run'
abbr --add brd 'bun run dev'
abbr --add brs 'bun run start'
abbr --add brb 'bun run build'
abbr --add ppi 'pnpm install'
abbr --add pr 'pnpm run'
abbr --add ppd 'pnpm dev'

abbr --add cleanpm 'bunx npkill'
abbr --add checkseo 'bunx check-site-meta'
abbr --add bcn 'bunx --bun shadcn@latest add'

# Docker
abbr --add dcu 'docker compose up -d'
abbr --add dcd 'docker compose down'
abbr --add dc 'docker compose'
abbr --add dcb 'docker compose build'

# Terraform / infraestructura
abbr --add tf terraform
abbr --add tfi 'terraform init'
abbr --add tfp 'terraform plan'
abbr --add tfa 'terraform apply --auto-approve'
abbr --add tfia 'terraform init; terraform apply --auto-approve'
abbr --add rsh 'ssh-keygen -R'
abbr --add stga 'systemctl status openvpn-client@galileo'

# Mobile / Android
abbr --add android 'emulator -avd Low_Cost_Device_API_35 &'
abbr --add bra 'bun run android'
abbr --add easapk 'eas build -p android --profile preview'
abbr --add eap 'eas build -p --auto-submit'
abbr --add bep 'bunx expo prebuild'

# Python
abbr --add pip 'uv pip'
abbr --add pif 'pip freeze > requirements.txt'
abbr --add pir 'uv pip install -r requirements.txt'
abbr --add py 'uv run'
abbr --add pv pyenv
abbr --add pvv 'pyenv virtualenv'
abbr --add pva 'pyenv activate'
abbr --add pvd 'pyenv deactivate'
abbr --add pt 'python -m pytest'
abbr --add vi 'python -m venv .venv'
abbr --add va 'source .venv/bin/activate.fish'
abbr --add vd deactivate

# Hardware / periféricos
abbr --add mvttf 'sudo mv *.ttf /usr/share/fonts/TTF; sudo fc-cache -fv'

# Información / utilidades
abbr --add weather 'curl wttr.in'
abbr --add psu 'ps aux | grep --color=auto'
abbr --add ipinfo 'ip -br addr'
abbr --add typr "nvim -c 'Typr'"

# Tmux / herramientas
abbr --add t tmux
abbr --add ta 'tmux attach -t'
abbr --add tn 'tmux new -s'
abbr --add tls 'tmux ls'
abbr --add tk 'tmux kill-session -t'
abbr --add mkey 'openssl rand -hex 32'
abbr --add oc opencode
abbr --add zed 'zeditor .'
abbr --add sshl 'ssh vrivera@caburgua.tailf8b14c.ts.net'
abbr --add kctl kubectl
abbr --add bar 'noctalia msg bar-show'
