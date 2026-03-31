#   ███████╗███████╗██╗  ██╗
#   ╚══███╔╝██╔════╝██║  ██║
#     ███╔╝ ███████╗███████║
#    ███╔╝  ╚════██║██╔══██║
#   ███████╗███████║██║  ██║
#   ╚══════╝╚══════╝╚═╝  ╚═╝

# https://zsh.org

# History settings
HISTTIMEFORMAT="%F %T "
HISTSIZE=1000000
HISTFILE=$HOME/.zsh_history
SAVEHIST=1000000
setopt appendhistory
setopt share_history
setopt hist_ignore_all_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no

autoload -U compinit
compinit

# Aliases
source ~/.aliases

# Shell integrations
eval "$(mise activate zsh)"
eval "$(tv init zsh)"
eval "$(zoxide init zsh)"
eval "$(sheldon source)"
eval "$(starship init zsh)"
eval "$(fnox activate zsh)"
