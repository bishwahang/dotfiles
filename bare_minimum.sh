#!/usr/bin/env bash

echo "🔧 Installing core packages..."
brew install bash
brew install mise
brew install bash-completion

echo "🧰 Installing editor/dev tools..."
brew install vim
brew install neovim
brew install tmux
brew install reattach-to-user-namespace
brew install ripgrep
brew install ctags
brew install fzf
$(brew --prefix)/opt/fzf/install --all

echo "✨ Extras..."
brew install bat
brew install gum

echo "✅ Finished installing bare minimum!"

