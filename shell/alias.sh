## ------ QTILE ------ ##
alias logout="qtile cmd-obj -o cmd -f shutdown"
alias qlog="cat ~/.local/share/qtile/qtile.log"
alias rmqlog="rm ~/.local/share/qtile/qtile.log"
alias ff="fastfetch --config default " # --logo-color-1 35 -> morado

## ----- NVIM ----- ##
alias qconf="nvim ~/dotfiles/.config/qtile/"
alias nconf="nvim ~/.config/nvim"
alias ee="nvim ~/dotfiles/.config/espanso/match/base.yml && espanso restart"
alias lee="cat ~/dotfiles/.config/espanso/match/base.yml"
alias nv="nvim ."
alias sn="sudo nvim"
## ------ ARCH ------ ##
alias grub-reconf="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias reflec="sudo reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist"
alias chx="chmod +x"

## ------ ZSH ------ ##
alias zsh="nvim ~/.zshrc && source ~/.zshrc"
alias al="nvim ~/dotfiles/shell/alias.sh && source ~/.zshrc"
alias lal="bat ~/dotfiles/shell/alias.sh"
alias sz="source ~/.zshrc"
alias cat="bat"
## ------ PACMAN ------ ##
alias pup="sudo pacman -Syu"
alias yup="yay -Syu --noconfirm"
alias pi="sudo pacman -S"
alias pss="pacman -Ss"

## ------ ARCHIVOS ------ ##
copyfile() {
  if [ -f "$1" ]; then
    local rel_path
    rel_path=$(realpath --relative-to="$PWD" "$1" 2>/dev/null) || rel_path="$1"
    (echo "Ruta del archivo: ${rel_path}" && echo "" && cat "$1") | xclip -selection clipboard
    echo "Contenido de '$1' copiado al portapapeles."
  else
    echo "Error: El archivo '$1' no existe."
  fi
}
alias cpn='copyfile'

alias tgz='comprimir'
_comprimir() {
  local dir_name=$(basename "$1")
  tar -czvf "$dir_name".tar.gz "$1"
}

alias untar="tar -xf"
alias fm="yazi"
alias ndot="nvim ~/dotfiles"
alias mkdir="mkdir -pv"
alias cp="cp -i" #i -> confirmacion
alias mv="mv -i"
alias du="du -sh *" # Ver tamaño de archivos

## ------ EZA ------ ##
alias l="eza --icons=always --color=always --long --no-filesize --git"
alias ll="eza --icons=always --color=always --long --all --no-user --no-filesize --git"
alias ls="eza --icons=always -F always"
alias la="eza --icons=always --color=always --long --all --git"
alias lt="eza --icons=always --color=always --tree --ignore-glob='node_modules|__pycache__'"
alias lg="lazygit"
## ------ DESARROLLO ------ ##
alias cleanpm="bunx npkill"                                                                                       # cli tool para eliminar paquetes de node_modules
alias lsc="cloc . --exclude-dir=node_modules,.next,dist,.turbo,.git,vendor --exclude-ext=svg,json,yaml --vcs git" # cuenta la cantidad de archivos
alias c="code ."
alias checkseo="bunx check-site-meta"

## ------ GIT ------ ##
ghiFunction() {
  git init && gh repo create "$1" --public --source=. --remote=origin
}
alias gcl="git clone"
alias ginit="git init --initial-branch=main"
alias gs="git status"
alias ga="git add"
alias gap="git add -p"
# commits
alias gca="git commit -a -m"
alias gc="git commit -m"
alias gcp="git commit -p"
alias gcam="git commit --amend "
alias ulc="git reset --soft HEAD~1 && git restore --staged ."
alias gl="git log --all --graph"
alias gd="git diff"
alias gds="git diff --staged"
# branchs
alias gb="git branch"
alias gco="git checkout"
alias gw="git switch"
alias gm="git merge"
alias gf="git fetch"
alias gu="git pull"
alias gur="git pull --rebase"
alias gp="git push"
# gh-cli
alias ghinit=ghiFunction
alias ghrc="gh repo create --public --source=. --remote=origin"

### ------ BUN ------ ###
alias npm="bun"
alias npx-"bunx"
alias bx="bunx"
alias br="bun run"
alias brd="bun run dev"
alias brs="bun run start"
alias bi="bun install"
alias ba="bun add"
alias brb="bun run build"
alias bcn="bunx --bun shadcn@latest add"

### ------ DOCKER ------ ###
alias dcu="docker compose up -d"
alias dcd="docker compose down"
### ------ TERRAFORM ------ ###
alias tf="terraform"
alias tfi="terraform init"
alias tfp="terraform plan"
alias tfa="terraform apply --auto-approve"
alias tfia="terraform init && terraform apply --auto-approve"
alias rsh="ssh-keygen -R"
### ------ MOBILE ------ ###
alias android="emulator -avd Low_Cost_Device_API_35 &"
alias easapk="eas build -p android --profile preview"
alias eap="eas build -p --auto-submit"
alias bep="bunx expo prebuild"
alias bra="bun run android"
## ------ PNPM ------ ##
alias pr="pnpm run"
alias ppd="pnpm dev"
alias ppi="pnpm install"

## ------ LAMP ------ ##
alias xmpstart="sudo /opt/lampp/lampp start"
alias xmpstop="sudo /opt/lampp/lampp stop"

## ------ PYTHON ------ ##
alias pip="uv pip"
alias pif="pip freeze > requirements.txt"
alias pir="uv pip install -r requirements.txt"
alias pv="pyenv"
alias pvv="pyenv virtualenv"
alias pva="pyenv activate"
alias pvd="pyenv deactivate"
alias pt="python -m pytest"

### manejo estandar de entornos virtuales en python
alias vi="python -m venv .venv"
alias va="source .venv/bin/activate"
alias vd="deactivate"

## ------ OTROS ------ ##
brilloFunction() {
  if [ "$1" -eq 0 ]; then
    xrandr --output DP-0 --brightness "$2"
  elif [ "$1" -eq 1 ]; then
    xrandr --output HDMI-1 --brightness "$2"
  else
    xrandr --output DP-0 --brightness "$2"
    xrandr --output HDMI-1 --brightness "$2"
  fi
}

alias mvttf="sudo mv *.ttf /usr/share/fonts/TTF && sudo fc-cache -fv"
alias brillodk=brilloFunction
alias typr="nvim -c 'Typr'"

# Informacion
alias weather="curl wttr.in"
alias psu="ps aux | grep --color=auto"
alias ipinfo="ip -br addr"
# Perifericos
alias ww="openrgb --profile '/home/vrivera/.config/OpenRGB/todo-blanco.orp'"
alias dpi='polychromatic-cli -n "Razer Viper V3 HyperSpeed" --dpi'
alias ssvps="ssh elvis@190.102.240.108"
