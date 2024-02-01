# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## Funciones
gcloneFunction(){
    git clone https://github.com/"$1"/"$2".git
}

comprimir(){
    local dir_name=$(basename "$1")
    tar -czvf "$dir_name".tar.gz "$1"
}

ghiFunction(){
    git init && gh repo create "$1" --public --source=.
}

brilloFunction(){
    xrandr --output HDMI-"$1" --brightness "$2"
}

# Alias
alias update='yay -Syu --noconfirm'
alias cls="clear"
alias logout="sudo systemctl restart ly"
alias gclone=gcloneFunction
alias nf="neofetch"
#alias xmp="sudo xampp"
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
export LS_COLORS="ow=01;90;40"
alias ll='lsd --tree --depth 1'
## Git
alias ginit="git init --initial-branch=main"
alias gs="git status"
alias ga="git add"
### commits
alias gca="git commit -a -m"
alias gc="git commit -m"
### branchs
alias gb="git branch"
alias gch="git checkout"
### pull - push
alias gl="git pull"
alias gp="git push"
### gh-cli
alias ghinit=ghiFunction
## Move
alias bin="cd ~/.local/bin"
alias conf="cd ~/git-packages/dotfiles/.config"
alias dots="cd ~/git-packages/dotfiles"
alias ast="cd ~/git-packages/dots-assets/"
alias h="cd ~"
alias dev="cd ~/dev"
alias ob="cd ~/uct-drive/obsidian-notes/"
## zshrc
alias zsh="nvim ~/.zshrc && source ~/.zshrc"
## brillo
alias brillo=brilloFunction

# Proyectos
alias nextinit="bunx create-next-app@latest"
alias astroinit="bun create astro@latest"
alias viteinit="bunx create-vite"

alias bund="bun run dev"
alias buni="bun install"
alias bunb="bun run build"
# Historial y autocompletado
HISTFILE=~/.zsh_history
HISTSIZE=1000
HISTFILESIZE=2000
SAVEHIST=100
setopt appendhistory
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
setopt NO_LIST_BEEP
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

## Plugins
source ~/git-packages/zsh/powerlevel10k/powerlevel10k.zsh-theme
source ~/git-packages/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source ~/git-packages/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/git-packages/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/git-packages/zsh/ohmyzsh/sudo.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

## p10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

## ENV
export EDITOR="nvim"
export TERM="xterm-256color"
export CM_LAUNCHER="rofi"

## PATH
export PATH="$HOME/.local/bin:$PATH"
# nvm path
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# bun path
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "/home/vrivera/.bun/_bun" ] && source "/home/vrivera/.bun/_bun"
