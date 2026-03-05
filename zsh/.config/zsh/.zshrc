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

export PATH="/Users/schalkconradie/.cache/.bun/bin:$PATH"

export EDITOR="nvim"
export VISUAL="$EDITOR"

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
export GOPATH="$XDG_DATA_HOME/go"

# ============================================================================
# VERSION MANAGERS
# ============================================================================
# Mise (replaces nvm, gvm, multiple .NET installs)
# eval "$(mise activate zsh)"
mise() {
    unset -f mise
    eval "$(mise activate zsh)"
    mise "$@"
}

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
compdump="${ZDOTDIR:-$HOME}/.zcompdump"
# Rebuild once a day
if [[ ! -f "$compdump" || "$(find "$compdump" -mtime +0 2>/dev/null)" ]]; then
    compinit -d "$compdump"
else
    compinit -C -d "$compdump"  # Use cache
fi
# Clean up old completion dumps
(compaudit 2>/dev/null && zrecompile -p "$compdump" &) 2>/dev/null

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
alias windev="cd /Volumes/'[C] Windows 11 Dev'/Users/schalkconradie/Code/"

# Python via uv
alias py="uv run python"
alias pyi="uv add"
alias pyin="uv init"

# Work - Proxychains + OpenCode (IMPORTANT)
alias ocv="proxychains4 -q -f ~/.proxychains/proxychains.conf opencode"
alias prox="proxychains4 -q -f ~/.proxychains/proxychains.conf"

# Other work tools
alias wr='go -C ~/Code/personal/PublisherTUI run ./cmd/d365tui'

# NVIM Switcher
alias v='nvim' # default Neovim config
alias vc='NVIM_APPNAME=nvim-chad nvim' # new neovim config

vv() {
  # Assumes all configs exist in directories named ~/.config/nvim-*
  local config=$(fd --max-depth 1 --glob 'nvim*' ~/.config | fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)
 
  # If I exit fzf without selecting a config, don't open Neovim
  [[ -z $config ]] && echo "No config selected" && return
 
  # Open Neovim with the selected config
  NVIM_APPNAME=$(basename $config) nvim $@
}

# Yazi move to current directory
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
