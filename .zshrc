# Historial
export ZDOTDIR="$HOME"
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt appendhistory sharehistory
setopt hist_ignore_dups hist_reduce_blanks

# Completion (simple, suficiente)
autoload -Uz compinit
compinit

# Load env + aliases
source ~/dotfiles/shell/env.sh
source ~/dotfiles/shell/alias.sh

# Tools
source ~/dotfiles/shell/tools.sh
source ~/dotfiles/shell/plugins/load.sh

