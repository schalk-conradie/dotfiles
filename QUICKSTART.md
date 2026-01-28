# Dotfiles Quick Reference

## Daily Workflow

### 📝 Edit Config

```bash
# Edit directly (it's symlinked!)
nvim ~/.config/zsh/.zshrc
```

### 💾 Save Changes

```bash
cd ~/dotfiles
make sync    # Copy, commit
make push    # Push to remote
```

### ⬇️ Pull Updates

```bash
cd ~/dotfiles
make pull    # Pull and restow
```

---

## Makefile Commands

```bash
make help     # Show all commands
make install  # Deploy dotfiles (fresh machine)
make update   # Copy system configs to repo
make sync     # Update + commit
make push     # Sync + push to remote
make pull     # Pull + restow
make test     # Dry run (no changes)
make status   # Git status
```

---

## Manual Stow Commands

```bash
cd ~/dotfiles

# Deploy package
stow -v zsh

# Remove package
stow -D zsh

# Re-deploy (update symlinks)
stow -R zsh

# Dry run (test)
stow -n zsh
```

---

## Fresh Machine Setup

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install tools
brew install stow mise starship zsh-autosuggestions zsh-syntax-highlighting \
  eza zoxide bat tmux neovim git-delta lazygit fzf ripgrep fd curl

# 3. Clone dotfiles
git clone git@github.com:yourusername/dotfiles.git ~/dotfiles

# 4. Deploy
cd ~/dotfiles
make install

# 5. Install runtimes
mise install node@lts node@latest
mise install dotnet-core@8 dotnet-core@9 dotnet-core@10
mise install go@latest python@latest
mise use --global node@lts dotnet-core@10 go@latest python@latest

# 6. Reload
exec zsh
```

---

## Mise Commands

```bash
# List installed
mise list

# Install version
mise install node@20

# Use globally
mise use --global node@20

# Use per-project
mise use node@20    # Creates .mise.toml

# Update all
mise upgrade

# Check health
mise doctor
```

---

## Tmux Quick Keys

**Prefix**: `Ctrl+A`

```
Ctrl+A |     Split vertical
Ctrl+A -     Split horizontal
Ctrl+A h/j/k/l  Navigate panes
Ctrl+A m     Maximize
Ctrl+A d     Detach
Ctrl+A c     New window
Ctrl+A I     Install plugins (capital I)
```

---

## Git Workflow for Dotfiles

```bash
cd ~/dotfiles

# See changes
git status

# Add specific file
git add zsh/.config/zsh/.zshrc

# Commit
git commit -m "Update zsh config"

# Push
git push

# Pull on another machine
git pull
stow -R zsh    # Re-apply symlinks
```

---

## Troubleshooting

### Config not updating?

```bash
# Check if symlinked
ls -la ~/.config/zsh/.zshrc
# Should show: .zshrc -> ../../dotfiles/zsh/.config/zsh/.zshrc

# Re-stow
cd ~/dotfiles
stow -R zsh
```

### Stow conflicts?

```bash
# Remove conflicting file
rm ~/.config/zsh/.zshrc

# Then stow
stow -v zsh
```

### Mise not working?

```bash
# Activate in current shell
eval "$(mise activate zsh)"

# Or restart
exec zsh
```

---

## Backup Important Files

### SSH Keys (NOT in dotfiles!)

```bash
# Encrypted backup
tar -czf - ~/.ssh | openssl enc -aes-256-cbc -pbkdf2 -out ssh-backup.tar.gz.enc

# Restore
openssl enc -aes-256-cbc -pbkdf2 -d -in ssh-backup.tar.gz.enc | tar -xzf - -C ~
chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_* && chmod 644 ~/.ssh/*.pub
```

### Projects

```bash
# Your code is in ~/Code - back it up separately!
rsync -av ~/Code /path/to/backup/
```

---

## Adding New App Config

```bash
cd ~/dotfiles

# 1. Create structure
mkdir -p myapp/.config/myapp

# 2. Copy config
cp ~/.config/myapp/config myapp/.config/myapp/

# 3. Deploy
stow -v myapp

# 4. Commit
git add myapp
git commit -m "Add myapp config"
git push
```

---

## Repository URLs

After creating your remote repo, add it:

```bash
cd ~/dotfiles

# GitHub
git remote add origin git@github.com:yourusername/dotfiles.git

# Or Codeberg
git remote add origin git@codeberg.org:yourusername/dotfiles.git

# Push
git push -u origin main
```

---

## Key Files

- `~/.zshenv` - XDG bootstrap (only file in ~/)
- `~/.config/zsh/.zshrc` - Shell config
- `~/.config/mise/config.toml` - Global versions
- `~/.config/git/config` - Git config
- `~/dotfiles/` - Your dotfiles repo
