#!/usr/bin/env bash

hash git > /dev/null || {
  echo "❌ Please install git first!"
  return 1
}

echo "🔗 Linking dotfiles..."
configs=(bashrc bash_profile bash_aliases vimrc gvimrc vim gitconfig gitignore tmux.conf agignore functions.sh key_bindings.sh)
for config in "${configs[@]}"; do
  echo "linking $config"
  ln -nfs "$HOME/.dotfiles/$config" "$HOME/.$config"
done

echo "📁 Creating directories..."
mkdir -p "$HOME/.tmp"
mkdir -p "$HOME/.undo"
mkdir -p "$HOME/.tmux/plugins"

# Vim plugin installation
if hash vim > /dev/null; then
  echo '📦 Installing Vim plugins...'
  vim +PluginInstall +qall
fi

# Neovim config symlink
if hash nvim > /dev/null; then
  echo "🔗 Linking Neovim config from dotfiles"
  mkdir -p "$HOME/.config"
  ln -sfn "$HOME/.dotfiles/nvim" "$HOME/.config/nvim"
fi

# Neovim plugin install (Lazy.nvim)
if hash nvim > /dev/null; then
  echo "📦 Syncing Neovim plugins..."
  nvim --headless "+Lazy! sync" +qa
fi

# tmux plugin manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "📥 Cloning tmux plugin manager..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# Install tmux plugins listed in .tmux.conf
if hash tmux > /dev/null; then
  echo "📦 Installing tmux plugins..."
  "$TPM_PATH/bin/install_plugins"
fi

echo "🎨 Tip: Import Solarized iTerm colors manually if needed"
echo "💡 For italics in terminal, visit: https://weibeld.net/terminals-and-shells/italics.html"

echo "✅ Finished configuring your environment!"

