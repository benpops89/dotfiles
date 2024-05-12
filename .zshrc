# Add homebrew to path
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

# Setup zplug
export ZPLUG_HOME=/home/linuxbrew/.linuxbrew/opt/zplug
source $ZPLUG_HOME/init.zsh

# History settings
HISTSIZE=1000000
HISTFILE=$HOME/.zsh_history
SAVEHIST=1000000
setopt appendhistory
setopt share_history
setopt hist_ignore_all_dups

# fzy key bindings
bindkey '\ec' fzy-cd-widget
bindkey '^T'  fzy-file-widget
bindkey '^R'  fzy-history-widget
bindkey '^P'  fzy-proc-widget

# Install plugins for zsh
zplug "zdharma-continuum/fast-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "aperezdc/zsh-fzy"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Define alias
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first"
alias cd="z"
alias cat="bat -pp"
alias v="nvim"

# Define function for managing dot files
dots() {
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME "$@"
}

# Then, source plugins and add commands to $PATH
zplug load --verbose

# Intialise zoxide
eval "$(zoxide init zsh)"

# Intialise starship
eval "$(starship init zsh)"
