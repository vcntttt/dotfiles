# --- CORE / ZSH --- #
alias sz="source ~/.zshrc"
alias zsh="nvim ~/.zshrc && source ~/.zshrc"

alias al="nvim ~/dotfiles/shell/alias.sh && source ~/.zshrc"
alias lal="bat ~/dotfiles/shell/alias.sh"

alias cat="bat"


# --- SISTEMA / ARCH --- #
alias pup="sudo pacman -Syu"
alias pi="sudo pacman -S"
alias pss="pacman -Ss"

alias yup="yay -Syu --noconfirm"

alias reflec="sudo reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist"
alias grub-reconf="sudo grub-mkconfig -o /boot/grub/grub.cfg"

alias chx="chmod +x"


# --- WM / QTILE --- #
alias logout="qtile cmd-obj -o cmd -f shutdown"
alias qlog="cat ~/.local/share/qtile/qtile.log"
alias rmqlog="rm ~/.local/share/qtile/qtile.log"

alias qconf="nvim ~/dotfiles/.config/qtile/"
alias ff="fastfetch --config default"

# --- WM / Hyprland --- #
alias rwb="pkill waybar && waybar &"

# --- EDITOR / NVIM --- #
alias nv="nvim ."
alias sn="sudo nvim"

alias nconf="nvim ~/.config/nvim"
alias ndot="nvim ~/dotfiles"

# espanso
alias ee="nvim ~/dotfiles/.config/espanso/match/base.yml && espanso restart"
alias lee="cat ~/dotfiles/.config/espanso/match/base.yml"


# --- ARCHIVOS / NAVEGACIÓN --- #
alias ..="cd .."
alias ...="cd ../.."

alias mkdir="mkdir -pv"
alias cp="cp -i"
alias mv="mv -i"

alias untar="tar -xf"
alias du="du -sh *"

alias fm="yazi"
alias fz="fzf"


# --- LISTADO / EZA --- #
alias ls="eza --icons=always -F always"
alias l="eza --icons=always --color=always --long --no-filesize --git --header"
alias la="eza --icons=always --color=always --long --all --git --header"
alias ll="eza --icons=always --color=always --long --all --no-user --no-filesize --git --header"
alias lt="eza --icons=always --tree --ignore-glob='node_modules|__pycache__'"


# --- GIT --- #
alias lg="lazygit"

alias ginit="git init --initial-branch=main"
alias gcl="git clone"

alias gs="git status"
alias ga="git add"
alias gap="git add -p"

alias gc="git commit -m"
alias gca="git commit -a -m"
alias gcp="git commit -p"
alias gcam="git commit --amend"

alias ulc="git reset --soft HEAD~1 && git restore --staged ."

alias gl="git log --all --graph"
alias gd="git diff"
alias gds="git diff --staged"

alias gb="git branch"
alias gco="git checkout"
alias gw="git switch"
alias gm="git merge"

alias gf="git fetch"
alias gu="git pull"
alias gur="git pull --rebase"
alias gp="git push"

# GitHub CLI
alias ghrc="gh repo create --public --source=. --remote=origin"


# --- BUN / NODE / PNPM --- #
alias npm="bun"
alias npx="bunx"
alias bx="bunx"

alias bi="bun install"
alias ba="bun add"

alias br="bun run"
alias brd="bun run dev"
alias brs="bun run start"
alias brb="bun run build"

alias cleanpm="bunx npkill"
alias checkseo="bunx check-site-meta"
alias bcn="bunx --bun shadcn@latest add"

alias ppi="pnpm install"
alias pr="pnpm run"
alias ppd="pnpm dev"


# --- DESARROLLO GENERAL --- #
alias c="code ."
alias lsc="cloc . --exclude-dir=node_modules,.next,dist,.turbo,.git,vendor --exclude-ext=svg,json,yaml --vcs git"


# --- DOCKER --- #
alias dcu="docker compose up -d"
alias dcd="docker compose down"


# --- TERRAFORM / INFRA --- #
alias tf="terraform"
alias tfi="terraform init"
alias tfp="terraform plan"
alias tfa="terraform apply --auto-approve"
alias tfia="terraform init && terraform apply --auto-approve"

alias rsh="ssh-keygen -R"


# --- MOBILE / ANDROID --- #
alias android="emulator -avd Low_Cost_Device_API_35 &"
alias bra="bun run android"

alias easapk="eas build -p android --profile preview"
alias eap="eas build -p --auto-submit"
alias bep="bunx expo prebuild"


# --- PYTHON --- #
alias pip="uv pip"
alias pif="pip freeze > requirements.txt"
alias pir="uv pip install -r requirements.txt"

alias pv="pyenv"
alias pvv="pyenv virtualenv"
alias pva="pyenv activate"
alias pvd="pyenv deactivate"

alias pt="python -m pytest"

# virtualenv estándar
alias vi="python -m venv .venv"
alias va="source .venv/bin/activate"
alias vd="deactivate"


# --- SERVICIOS LOCALES --- #
alias xmpstart="sudo /opt/lampp/lampp start"
alias xmpstop="sudo /opt/lampp/lampp stop"


# --- HARDWARE / PERIFÉRICOS --- #
alias mvttf="sudo mv *.ttf /usr/share/fonts/TTF && sudo fc-cache -fv"

alias ww="openrgb --profile '/home/vrivera/.config/OpenRGB/todo-blanco.orp'"
alias dpi='polychromatic-cli -n "Razer Viper V3 HyperSpeed" --dpi'


# --- INFO / UTILIDADES --- #
alias weather="curl wttr.in"
alias psu="ps aux | grep --color=auto"
alias ipinfo="ip -br addr"

alias typr="nvim -c 'Typr'"
