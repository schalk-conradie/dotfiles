# My Dotfiles

Clean, XDG-compliant dotfiles managed with GNU Stow.

## Structure

```
dotfiles/
├── zsh/              # Shell configuration
├── git/              # Git config  
├── ghostty/          # Terminal config
├── tmux/             # Tmux config
├── starship/         # Prompt config
├── nvim/             # Neovim config (LazyVim)
├── home/             # Files that go in ~/
└── scripts/          # Helper scripts
```

## Fresh Install (New Mac)

### 1. Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 2. Install Essential Tools
```bash
brew install stow mise starship \
  zsh-autosuggestions zsh-syntax-highlighting \
  eza zoxide bat tmux neovim git-delta lazygit
```

### 3. Clone Dotfiles
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

### 4. Deploy Configs with Stow
```bash
# Stow all packages
stow -v zsh
stow -v git
stow -v ghostty
stow -v tmux
stow -v starship
stow -v nvim

# Copy .zshenv (stow doesn't handle home directory well)
cp home/.zshenv ~/.zshenv
```

### 5. Install Runtime Versions with Mise
```bash
# Node
mise install node@lts node@latest
mise use --global node@lts

# .NET
mise install dotnet-core@8 dotnet-core@9 dotnet-core@10
mise use --global dotnet-core@10

# Go & Python
mise install go@latest python@latest
mise use --global go@latest python@latest
```

### 6. Restart Shell
```bash
exec zsh
```

### 7. Install Tmux Plugins
```bash
tmux
# Press: Ctrl+A + I (capital i) to install plugins
```

---

## Daily Use

### Updating Configs

Edit configs directly in `~/.config/` (they're symlinked):

```bash
nvim ~/.config/zsh/.zshrc
# Changes are already in ~/dotfiles/zsh/.config/zsh/.zshrc
```

### Syncing Changes

```bash
cd ~/dotfiles
git add .
git commit -m "Update zsh config"
git push
```

### Pulling Updates on Another Machine

```bash
cd ~/dotfiles
git pull
# Configs automatically update (symlinked!)
```

---

## Adding New Configs

```bash
cd ~/dotfiles

# 1. Create package structure
mkdir -p newapp/.config/newapp

# 2. Copy config
cp ~/.config/newapp/config newapp/.config/newapp/

# 3. Stow it
stow -v newapp

# 4. Commit
git add newapp
git commit -m "Add newapp config"
git push
```

---

## Removing a Package

```bash
cd ~/dotfiles
stow -D packagename  # Removes symlinks
rm -rf packagename   # Remove from repo
git commit -am "Remove packagename"
```

---

## Tools & Features

### Shell
- **Zsh** with Starship prompt
- **Fast startup**: ~0.09s (vs 0.58s with Oh-My-Zsh)
- **Plugins**: autosuggestions, syntax-highlighting
- **Modern tools**: eza, zoxide, bat

### Version Management
- **mise**: Manages Node, Go, Python, .NET
- Per-project versions via `.mise.toml`
- No more NVM/GVM/rbenv mess

### Terminal
- **Ghostty**: GPU-accelerated, 90% transparency
- **Tmux**: Ctrl+A prefix, vim-style navigation
- **No conflicts** with nvim keybindings

### Editor
- **Neovim** with LazyVim
- Bob for version management

---

## Key Aliases

```bash
# Modern CLI replacements
ls      # eza with icons
cat     # bat with syntax highlighting
cd      # zoxide for smart jumping

# Navigation
cdcode      # cd ~/Code
cdwork      # cd ~/Code/work
cdpersonal  # cd ~/Code/personal

# Python (via uv)
py          # uv run python
pyi         # uv add
pyin        # uv init

# Work (IMPORTANT)
ocv         # proxychains4 + opencode
prox        # proxychains4 shorthand
```

---

## Tmux Cheatsheet

**Prefix**: `Ctrl+A`

```bash
Ctrl+A |     # Split vertical
Ctrl+A -     # Split horizontal
Ctrl+A h/j/k/l  # Navigate panes (NO nvim conflict!)
Ctrl+A m     # Maximize pane
Ctrl+A d     # Detach
Ctrl+A c     # New window
Ctrl+A 0-9   # Switch windows
Ctrl+A [     # Copy mode (vim keys)
```

---

## Per-Project Version Management

```bash
cd ~/Code/work/legacy-project
mise use dotnet-core@8 node@20

cd ~/Code/work/new-project  
mise use dotnet-core@10 node@latest

# Versions auto-switch when you cd!
```

---

## Troubleshooting

### Shell not loading config
```bash
# Check .zshenv exists
ls -la ~/.zshenv

# Manually source
source ~/.zshenv
source ~/.config/zsh/.zshrc
```

### Stow conflicts
```bash
# If file already exists
rm ~/.config/conflicting-file
stow -v packagename
```

### Mise not activating
```bash
# Check it's in .zshrc
grep "mise activate" ~/.config/zsh/.zshrc

# Restart shell
exec zsh
```

### Tmux plugins not loading
```bash
# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# In tmux: Ctrl+A + I
```

---

## Backup

### SSH Keys (Do Separately!)
```bash
# Encrypted backup
tar -czf - ~/.ssh | openssl enc -aes-256-cbc -pbkdf2 -out ssh-backup.tar.gz.enc

# Or copy to secure external drive
cp -r ~/.ssh /path/to/secure/location/
```

### Important Locations
- `~/.ssh/` - SSH keys (NOT in dotfiles)
- `~/Code/` - Your projects
- `~/.config/mise/config.toml` - Global mise versions

---

## What's NOT Included

These should be backed up separately:
- SSH keys (`~/.ssh/`)
- API tokens/secrets
- Proxychains config (if contains credentials)
- Work-specific credentials

---

## XDG Compliance

Following XDG Base Directory specification:
- Config: `~/.config/`
- Data: `~/.local/share/`
- Cache: `~/.cache/`
- State: `~/.local/state/`

Only `.zshenv` and `.ssh/` in `~/` (as intended).

---

## Credits

- **Dotfiles management**: GNU Stow
- **Version management**: mise
- **Shell prompt**: Starship
- **Terminal**: Ghostty
- **Editor**: Neovim (LazyVim)
