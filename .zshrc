# Add homebrew and local bin to path
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/benpoppy/bin:$PATH"

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

# Install plugins for zsh
zplug "zdharma-continuum/fast-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "Aloxaf/fzf-tab"
zplug "wfxr/forgit"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# Define alias
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first"
alias cd="z"
alias cat="bat -pp"
alias v="nvim"
alias oc="obsidian organise"
alias on="obsidian new"

# Define function for managing dot files
dots() {
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME "$@"
}

# fzf default options
export FZF_DEFAULT_OPTS=" \
--color=bg+:-1,bg:-1,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--scrollbar=''"

# Then, source plugins and add commands to $PATH
zplug load

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
