eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
source ~/dotfiles/shell/alias.sh
source ~/dotfiles/shell/env.sh

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

## zsh plugins

source ~/git-packages/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source ~/git-packages/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/git-packages/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/git-packages/zsh/ohmyzsh/sudo.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ## p10k
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#source ~/git-packages/zsh/powerlevel10k/powerlevel10k.zsh-theme


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

PATH=~/.console-ninja/.bin:$PATH