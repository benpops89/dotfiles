# Add local bin to path
export PATH="$HOME/bin:$PATH"
if [[ "$(uname)" == "Linux" ]]; then
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi

# Setup zplug
BREW_PATH="$(which brew | sed 's/\/bin\/brew$//')"
export ZPLUG_HOME="$BREW_PATH/opt/zplug"
source $ZPLUG_HOME/init.zsh

# History settings
HISTTIMEFORMAT="%F %T "
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
alias g="lazygit"

# Define function for managing dot files
dots() {
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME "$@"
}

dbt() {
    # Ensure the terminal is interactive before prompting
    if [[ $- == *i* ]]; then
        echo "Are you sure you want to run the dbt command?"
        select response in "Yes" "No"; do
            case $response in
                Yes ) 
                    break
                    ;;
                No ) 
                    echo "Command canceled."
                    return
                    ;;
                * ) 
                    echo "Invalid choice, please select 1 for Yes or 2 for No."
                    ;;
            esac
        done
    fi
    # Run the dbt command with the provided arguments
    command dbt "$@"
}

# Load environment variables from .env file if it exists
if [[ -f "$HOME/.env" ]]; then
    export $(grep -v '^#' "$HOME/.env" | xargs)
fi

# fzf default options
export FZF_DEFAULT_OPTS=" \
--color=bg+:-1,bg:-1,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--scrollbar=''"

# Then, source plugins and add commands to $PATH
zplug load

# Define key bindings
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

# Shell integrations
eval "$(mise activate zsh)"
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
