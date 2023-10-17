eval "$(starship init zsh)"

alias upt="sudo pacman -Syu && yay -Syu"
alias cls="clear"

gcloneFunction(){
    git clone https://github.com/"$1"/"$2".git
}
comprimir(){
    local dir_name=$(basename "$1")
    tar -czvf "$dir_name".tar.gz "$1"
}
alias gclone=gcloneFunction
alias paci="sudo pacman -S"
alias logout="cinnamon-session-quit --logout"
alias nf="neofetch"
alias tgz=comprimir
alias xmp="sudo xampp"
HISTFILE=~/.zsh_history
HISTSIZE=100
SAVEHIST=100
setopt appendhistory
plugins=(git z sudo npm)


autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
setopt NO_LIST_BEEP
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# bun completions
[ -s "/home/vicente/.bun/_bun" ] && source "/home/vicente/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
