.PHONY: help install update sync pull push test clean

help: ## Show this help
	@echo "Dotfiles Management"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

install: ## Deploy all dotfiles (fresh install)
	@echo "🚀 Deploying dotfiles..."
	stow -v zsh
	stow -v git
	stow -v ghostty
	stow -v tmux
	stow -v starship
	stow -v yazi
	stow -v nvim
	cp home/.zshenv ~/.zshenv
	@echo "✅ Dotfiles deployed! Run 'exec zsh' to reload shell."

update: ## Copy current configs to dotfiles repo
	@echo "📦 Updating dotfiles from system..."
	cp ~/.config/zsh/.zshrc zsh/.config/zsh/
	cp ~/.config/git/config git/.config/git/
	cp ~/.config/git/ignore git/.config/git/
	cp ~/.config/ghostty/config ghostty/.config/ghostty/
	cp ~/.config/tmux/tmux.conf tmux/.config/tmux/
	cp ~/.config/starship.toml starship/.config/
	cp -r ~/.config/yazi/* yazi/.config/yazi/
	cp ~/.zshenv home/.zshenv
	@echo "✅ Configs updated in ~/dotfiles"

sync: update ## Update and commit changes
	@echo "💾 Committing changes..."
	git add .
	git diff --staged --quiet || git commit -m "Update dotfiles - $$(date +%Y-%m-%d)"
	@echo "✅ Changes committed"

pull: ## Pull latest changes and restow
	@echo "⬇️  Pulling latest changes..."
	git pull
	@echo "🔗 Re-stowing packages..."
	stow -R zsh git ghostty tmux starship yazi nvim
	@echo "✅ Dotfiles updated!"

push: sync ## Sync and push to remote
	@echo "⬆️  Pushing to remote..."
	git push
	@echo "✅ Pushed to remote"

test: ## Test stow without making changes
	@echo "🧪 Testing stow (dry run)..."
	stow -n -v zsh
	stow -n -v git
	stow -n -v ghostty
	stow -n -v tmux
	stow -n -v starship
	stow -n -v yazi
	stow -n -v nvim
	@echo "✅ Test complete (no changes made)"

clean: ## Remove all symlinks
	@echo "🧹 Removing symlinks..."
	stow -D zsh git ghostty tmux starship yazi nvim
	@echo "✅ Symlinks removed"

status: ## Show git status
	@echo "📊 Dotfiles status:"
	@git status --short
