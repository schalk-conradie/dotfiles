.PHONY: help install update sync pull push test clean

help: ## Show this help
	@echo "Dotfiles Management"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

install: ## Deploy all dotfiles (fresh install)
	@echo "INFO: Deploying dotfiles..."
	stow -v zsh
	stow -v git
	stow -v ghostty
	stow -v tmux
	stow -v starship
	stow -v yazi
	stow -v nvim
	cp home/.zshenv ~/.zshenv
	@echo "INFO: Dotfiles deployed! Run 'exec zsh' to reload shell."

update: ## Copy current configs to dotfiles repo and create symlinks
	@echo "📦 Updating dotfiles from system..."
	@# Copy any new files first
	cp -r ~/.config/zsh/* zsh/.config/zsh/ 2>/dev/null || true
	cp -r ~/.config/git/* git/.config/git/ 2>/dev/null || true
	cp -r ~/.config/ghostty/* ghostty/.config/ghostty/ 2>/dev/null || true
	cp -r ~/.config/tmux/* tmux/.config/tmux/ 2>/dev/null || true
	cp ~/.config/starship.toml starship/.config/ 2>/dev/null || true
	cp -r ~/.config/yazi/* yazi/.config/yazi/ 2>/dev/null || true
	cp -r ~/.config/nvim/* nvim/.config/nvim/ 2>/dev/null || true
	cp ~/.zshenv home/.zshenv 2>/dev/null || true
	@# Now adopt to replace with symlinks
	@echo "🔗 Creating symlinks..."
	stow --adopt zsh git ghostty tmux starship yazi nvim 2>/dev/null || true
	@echo "INFO: Configs updated and symlinked"

sync: update ## Update and commit changes
	@echo "💾 Committing changes..."
	git add .
	git diff --staged --quiet || git commit -m "Update dotfiles - $$(date +%Y-%m-%d)"
	@echo "INFO: Changes committed"

pull: ## Pull latest changes and restow
	@echo "INFO: Pulling latest changes..."
	git pull
	@echo "PROCESS: Re-stowing packages..."
	stow -R zsh git ghostty tmux starship yazi nvim
	@echo "INFO: Dotfiles updated!"

push: sync ## Sync and push to remote
	@echo "INFO: Pushing to remote..."
	git push
	@echo "INFO: Pushed to remote"

test: ## Test stow without making changes
	@echo "INFO: Testing stow (dry run)..."
	stow -n -v zsh
	stow -n -v git
	stow -n -v ghostty
	stow -n -v tmux
	stow -n -v starship
	stow -n -v yazi
	stow -n -v nvim
	@echo "INFO: Test complete (no changes made)"

clean: ## Remove all symlinks
	@echo "WARN: Removing symlinks..."
	stow -D zsh git ghostty tmux starship yazi nvim
	@echo "INFO: Symlinks removed"

status: ## Show git status
	@echo "STATUS: Dotfiles status:"
	@git status --short
