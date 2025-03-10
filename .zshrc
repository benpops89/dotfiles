# Add local bin to path
export PATH="$HOME/bin:$PATH"
if [[ "$(uname)" == "Linux" ]]; then
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi

# History settings
HISTSIZE=1000000
HISTFILE=$HOME/.zsh_history
SAVEHIST=1000000
setopt appendhistory
setopt share_history
setopt hist_ignore_all_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Define alias
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first"
alias cd="z"
alias cat="bat -pp"
alias v="nvim"
alias oc="obsidian organise"
alias on="obsidian new"
alias aoc="uv run cli.py"
alias lg="lazygit"
alias mr="mise run"

# Define function for managing dot files
dots() {
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME "$@"
}

export ANTHROPIC_API_KEY=$(cat ~/.keys/claude.txt)

# fzf default options
export FZF_DEFAULT_OPTS=" \
--color=bg+:-1,bg:-1,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--scrollbar=''"

# Define key bindings
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

# Shell integrations
eval "$(mise activate zsh)"
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"
eval "$(sheldon source)"
eval "$(starship init zsh)"
