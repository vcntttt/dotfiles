## ------ QTILE ------ ##
alias logout="qtile cmd-obj -o cmd -f shutdown"
alias qlog="cat ~/.local/share/qtile/qtile.log"
alias rmqlog="rm ~/.local/share/qtile/qtile.log"
alias ff="fastfetch --config default " # --logo-color-1 35 -> morado
#alias ff="fastfetch --config groups"
alias autostart="nvim ~/dotfiles/.config/qtile/autostart.sh"
## ------ ARCH ------ ##
alias grub-reconf="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias reflec="sudo reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist"

## ------ ZSH ------ ##
alias zsh="nvim ~/.zshrc && source ~/.zshrc"
alias elias="nvim ~/dotfiles/shell/alias.sh && source ~/.zshrc"
alias sz="source ~/.zshrc"
## ------ PACMAN ------ ##
alias pup="sudo pacman -Syu"
alias yup="yay -Syu --noconfirm"
alias pi="sudo pacman -S"
alias pss="pacman -Ss"

## ------ GIT ------ ##
ghiFunction(){
    ginit && gh repo create "$1" --public --source=.
}
alias gclone="git clone"
alias ginit="git init --initial-branch=main"
alias gs="git status"
alias ga="git add"
# commits
alias gca="git commit -a -m"
alias gc="git commit -m"
alias gcfix="git commit --amend --no-edit"
# branchs
alias gb="git branch"
alias gco="git checkout"
alias gw="git switch"
alias gd="git diff"
alias gm="git merge"
# pull - push
alias gl="git pull"
alias gp="git push"
# gh-cli
alias ghinit=ghiFunction

## ------ ARCHIVES ------ ##
comprimir(){
    local dir_name=$(basename "$1")
    tar -czvf "$dir_name".tar.gz "$1"
}

alias tgz=comprimir
alias untar="tar -xf"
alias fm="yazi"
alias cdot="code ~/dotfiles"
alias notes="nvim ~/uct-drive/obsidian-notes/"
alias mkdir="mkdir -pv"
alias cp="cp -i" #i -> confirmacion
alias mv="mv -i" 
alias du="du -sh *" # Ver tamaño de archivos

## ------ EZA ------ ##
alias l="eza --icons=always --color=always --long --no-filesize --git"
alias ll="eza --icons=always --color=always --long --all --no-user --no-filesize --git"
alias ls="eza --icons=always -F always"
alias lg="eza -l --git"
alias la="eza --icons=always --color=always --long --all --git"
alias lt="eza --icons=always --color=always --tree"

## ------ BUN ------ ##
alias br="bun run"
alias bd="bun run dev"
alias bi="bun install"
alias bb="bun run build"
alias bcn="bunx --bun shadcn@latest"

## ------ PNPM ------ ##
alias pdev="pnpm dev"
alias pii="pnpm install"
## ------ LAMP ------ ##
alias xmpstart="sudo /opt/lampp/lampp start"
alias xmpstop="sudo /opt/lampp/lampp stop"

## ------ OTHERS ------ ##
brilloFunction(){
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
alias weather="curl wttr.in"
alias psu="ps aux | grep --color=auto"
alias ipinfo="ip -br addr"
alias ww="openrgb --profile '/home/vrivera/.config/OpenRGB/todo-blanco.orp'"
alias dpi='polychromatic-cli -n "Razer Viper V3 HyperSpeed" --dpi 800'
