## ------ QTILE ------ ##
alias logout="sudo systemctl restart ly"
alias qlog="cat ~/.local/share/qtile/qtile.log"
alias rmqlog="rm ~/.local/share/qtile/qtile.log"
alias ff="fastfetch --config default " # --logo-color-1 35 -> morado

## ------ ARCH ------ ##
alias grub-reconf="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias reflec="sudo reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist"

## ------ ZSH ------ ##
alias zsh="nvim ~/.zshrc && source ~/.zshrc"
alias elias="nvim ~/dotfiles/shell/alias.sh && source ~/.zshrc"
alias ss="source ~/.zshrc"
## ------ PACMAN ------ ##
alias pup="sudo pacman -Syu"
alias yup="yay -Syu --noconfirm"
alias pi="sudo pacman -S"
alias ps="pacman -Ss"

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
alias gd="git diff"
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
alias ll="eza --icons=always --color=always --long --all --no-user --no-filesize --git"
alias ls="eza --icons=always -F always"
alias lg="eza -l --git"
alias la="eza --icons=always --color=always --long --all --git"
alias lt="eza --icons=always --color=always --tree"

## ------ BUN ------ ##
alias bund="bun run dev"
alias buni="bun install"
alias bunb="bun run build"

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
alias brillo=brilloFunction
alias weather="curl wttr.in"
alias psu="ps aux | grep --color=auto"
alias ipinfo="ip -br addr"
