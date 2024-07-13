gcloneFunction(){
    git clone https://github.com/"$1"/"$2".git
}

comprimir(){
    local dir_name=$(basename "$1")
    tar -czvf "$dir_name".tar.gz "$1"
}

ghiFunction(){
    ginit && gh repo create "$1" --public --source=.
}

brilloFunction(){
  if [ "$1" -eq 2 ]; then
    xrandr --output HDMI-0 --brightness "$2"
    xrandr --output HDMI-1 --brightness "$2"
  else
    xrandr --output HDMI-"$1" --brightness "$2"
  fi
}

alias update='yay -Syu --noconfirm'
alias cls="clear"
alias logout="sudo systemctl restart ly"
alias gclone=gcloneFunction
#alias nf="neofetch"
alias ff="fastfetch --config default " # --logo-color-1 35 -> morado
alias qlog="cat ~/.local/share/qtile/qtile.log"
alias rmqlog="rm ~/.local/share/qtile/qtile.log"
alias xmp="sudo xampp"
alias cleanpac="sudo pacman -Rns $(pacman -Qdtq)"
alias cleancache="sudo pacman -Sc"
## Tar
alias tgz=comprimir
alias untar="tar -xf"
## Arch configs
alias grub-reconf="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias reflec="sudo reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist"
## Ver Archivos
alias grep='grep --color=auto'
alias ls='lsd'
alias l='ls -l'
alias la='ll -a'
alias lla='lsd -la'
alias ll='lsd --tree --depth 1'
## Git
alias ginit="git init --initial-branch=main"
alias gs="git status"
alias ga="git add"
### commits
alias gca="git commit -a -m"
alias gc="git commit -m"
alias gcfix="git commit --amend --no-edit"
### branchs
alias gb="git branch"
alias gco="git checkout"
### pull - push
alias gl="git pull"
alias gp="git push"
### gh-cli
alias ghinit=ghiFunction
## Move
alias fm="yazi"
alias bin="cd ~/.local/bin"
alias dots="cd ~/dotfiles"
alias conf="cd ~/dotfiles/.config"
alias elias="nvim ~/dotfiles/shell/alias.sh && source ~/.zshrc"
alias ast="cd ~/uct-drive/dots-assets/"
alias h="cd ~"
alias dev="cd ~/dev"
alias ob="cd ~/uct-drive/obsidian-notes/"
alias cdot="code ~/dotfiles/"
alias notes="nvim ~/uct-drive/obsidian-notes/"
## zshrc
alias zsh="nvim ~/.zshrc && source ~/.zshrc"
## brillo
alias brillo=brilloFunction

# Development
alias nextinit="bunx create-next-app@latest"
alias astroinit="bun create astro@latest"
alias viteinit="bunx create-vite@latest"

alias bund="bun run dev"
alias buni="bun install"
alias bunb="bun run build"
