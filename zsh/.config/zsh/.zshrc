# ============================================================================
# HOMEBREW
# ============================================================================
eval "$(/opt/homebrew/bin/brew shellenv)"

# ============================================================================
# XDG & PATH
# ============================================================================
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# PATH setup
path=(
    $HOME/.local/bin
    $CARGO_HOME/bin
    $GOPATH/bin
    $HOME/.dotnet/tools
    $XDG_DATA_HOME/bob/nvim-bin
    $path
)
export PATH

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================
export EDITOR="nvim"
export VISUAL="nvim"
export GOPATH="$XDG_DATA_HOME/go"

# ============================================================================
# VERSION MANAGERS
# ============================================================================
# Mise (replaces nvm, gvm, multiple .NET installs)
eval "$(mise activate zsh)"

# ============================================================================
# PROMPT
# ============================================================================
eval "$(starship init zsh)"

# ============================================================================
# MODERN CLI TOOLS
# ============================================================================
eval "$(zoxide init zsh --cmd cd)"

# ============================================================================
# PLUGINS
# ============================================================================
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ============================================================================
# COMPLETION
# ============================================================================
autoload -Uz compinit
compinit

# ============================================================================
# ALIASES
# ============================================================================
# Modern replacements
alias ls="eza --icons=always"
alias cat="bat"

# Navigation
alias cdcode="cd ~/Code"
alias cdwork="cd ~/Code/work"
alias cdpersonal="cd ~/Code/personal"

# Python via uv
alias py="uv run python"
alias pyi="uv add"
alias pyin="uv init"

# Work - Proxychains + OpenCode (IMPORTANT)
alias ocv="proxychains4 -q -f ~/.proxychains/proxychains.conf opencode"
alias prox="proxychains4 -q -f ~/.proxychains/proxychains.conf"

# Other work tools
alias wr="go run ~/Code/personal/PublisherTUI/cmd/d365tui/"

# Yazi
alias yy="yazi"

# ============================================================================
# TMUX
# ============================================================================
# Auto-attach to existing session or create new one
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    # Optional: auto-attach on terminal start
    # tmux attach -t default || tmux new -s default
fi
