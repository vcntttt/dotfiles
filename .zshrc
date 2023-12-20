# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi



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
alias tdc="tar -xf"
alias xmp="sudo xampp"
alias pwo="shutdown -h now"
alias grub-reconf="sudo grub-mkconfig -o /boot/grub/grub.cfg"
# ver Archivos
alias ls='lsd'
alias l='ls -l'
alias la='lsd -a'
alias lla='lsd -la'
export LS_COLORS="ow=01;90;40"

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
source ~/git-packages/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
