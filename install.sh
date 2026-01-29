#!/usr/bin/env bash

set -e # Exit immediately if a command exits with a non-zero status

echo "Starting dotfiles installation..."

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for the current session
    if [[ "$(uname -m)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed"
fi

# Install Dependencies
echo "Installing dependencies..."
brew update

# Core tools
brew install stow mise starship \
    zsh-autosuggestions zsh-syntax-highlighting \
    eza zoxide bat tmux neovim git-delta lazygit ghostty fzf ripgrep fd curl zellij

# Fonts
brew install --cask font-jetbrains-mono-nerd-font

# Clone repository (if running from a curl URL) or Setup
DOTFILES_DIR="$HOME/dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/schalk-conradie/dotfiles.git "$DOTFILES_DIR"
fi

# Stow Packages
echo "Stowing configurations..."
cd "$DOTFILES_DIR"

# Ensure configs dir exists
mkdir -p ~/.config

# Stow loop
STOW_FOLDERS="zsh git ghostty tmux starship yazi nvim"
for folder in $STOW_FOLDERS; do
    echo "   - $folder"
    stow -v -R $folder
done

# Handle .zshenv move
echo "Copying .zshenv..."
cp "$DOTFILES_DIR/home/.zshenv" "$HOME/.zshenv"

# Setup Mise Runtimes
echo "Setting up mise runtimes..."
# Allow mise to activate
eval "$(mise activate bash)"

echo "   - Installing Node..."
mise install node@lts --yes
mise use --global node@lts

echo "   - Installing Go..."
mise install go@latest --yes
mise use --global go@latest

echo "   - Installing Python..."
mise install python@latest --yes
mise use --global python@latest

echo "   - Installing .NET..."
mise install dotnet-core@10 --yes
mise use --global dotnet-core@10

# Post-Install Checks
echo "Installation complete!"
echo "Restart your shell or run 'exec zsh' to see changes."
