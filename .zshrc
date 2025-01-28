# -------- my configs --------
source ~/dotfiles/shell/alias.sh
source ~/dotfiles/shell/env.sh
source ~/dotfiles/shell/plugins.sh

# -------- god cli tools --------
# zoxide - better cd
eval "$(zoxide init zsh)"
alias cd="z"
# fzf - better find
#source ~/dotfiles/shell/fzf.sh
# thefuck - corrector
eval $(thefuck --alias)
eval $(thefuck --alias fk)
# starship - better prompt
eval "$(starship init zsh)"
# bat - better cat
export BAT_THEME=base16

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
export LS_COLORS="ow=01;90;40"

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

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH=$PATH:/home/vrivera/.spicetify

export PATH="$HOME/.config/composer/vendor/bin:$PATH"

PATH=~/.console-ninja/.bin:$PATH
