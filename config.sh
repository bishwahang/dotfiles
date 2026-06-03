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

# Claude Code config symlink
echo "🔗 Linking Claude Code config"
mkdir -p "$HOME/.claude"
ln -nfs "$HOME/.dotfiles/claude/settings.json" "$HOME/.claude/settings.json"

# OpenCode config symlink
echo "🔗 Linking OpenCode config"
mkdir -p "$HOME/.config/opencode/agents"
mkdir -p "$HOME/.config/opencode/skills"
ln -nfs "$HOME/.dotfiles/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"
ln -nfs "$HOME/.dotfiles/opencode/AGENTS.md" "$HOME/.config/opencode/AGENTS.md"
[ -f "$HOME/.dotfiles/opencode/AGENTS.local.md" ] && ln -nfs "$HOME/.dotfiles/opencode/AGENTS.local.md" "$HOME/.config/opencode/AGENTS.local.md"
ln -nfs "$HOME/.dotfiles/opencode/decisions.md" "$HOME/.config/opencode/decisions.md"
[ -f "$HOME/.dotfiles/opencode/decisions.local.md" ] && ln -nfs "$HOME/.dotfiles/opencode/decisions.local.md" "$HOME/.config/opencode/decisions.local.md"
ln -nfs "$HOME/.dotfiles/opencode/agents/gitlab-dev.md" "$HOME/.config/opencode/agents/gitlab-dev.md"

# OpenCode skills — symlink every skill directory present in dotfiles
opencode_skill_setup_hints=()
for skill_dir in "$HOME/.dotfiles/opencode/skills"/*/; do
  [ -d "$skill_dir" ] || continue
  skill_name=$(basename "$skill_dir")
  ln -nfs "${skill_dir%/}" "$HOME/.config/opencode/skills/$skill_name"

  # Detect setup entrypoints and record a hint for the user
  if [ -x "${skill_dir}setup.sh" ]; then
    opencode_skill_setup_hints+=("  ${skill_name}: bash ~/.config/opencode/skills/${skill_name}/setup.sh")
  elif [ -f "${skill_dir}modes/bootstrap.md" ]; then
    opencode_skill_setup_hints+=("  ${skill_name}: run \`/${skill_name} bootstrap\` inside opencode")
  fi
done

if [ "${#opencode_skill_setup_hints[@]}" -gt 0 ]; then
  echo "💡 Some OpenCode skills need one-time setup:"
  printf '%s\n' "${opencode_skill_setup_hints[@]}"
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
  "$HOME/.tmux/plugins/tpm/bin/install_plugins"
fi

echo "🎨 Tip: Import Solarized iTerm colors manually if needed"
echo "💡 For italics in terminal, visit: https://weibeld.net/terminals-and-shells/italics.html"

echo "✅ Finished configuring your environment!"
