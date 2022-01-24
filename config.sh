#!/usr/bin/env bash
hash git > /dev/null || {
  echo "Please install git!"
  return 1
}

echo "Link config files"
configs=(bashrc bash_profile bash_aliases vimrc gvimrc vim gitconfig gitignore tmux.conf agignore)
for config in "${configs[@]}"
do
  echo "linking $config"
  ln -nfs $HOME/.dotfiles/$config $HOME/.$config
done

echo "making temp and undo directory"
mkdir -p $HOME/.tmp
mkdir -p $HOME/.undo
mkdir -p $HOME/.tmux/plugins

hash vim > /dev/null && {
  echo 'Installing Vim-Plugin'
  vim +PluginInstall +qall
}

echo "cloning tmux plugin manager"
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

# wget -O ~/.tmp/solarized_dark.itemcolors https://github.com/altercation/solarized/blob/master/iterm2-colors-solarized/Solarized%20Dark.itermcolors
# echo "import solarized_dark to iterm profile"
# to enable italic: https://weibeld.net/terminals-and-shells/italics.html
echo "Visit how to enable italics in iTerm: https://weibeld.net/terminals-and-shells/italics.html"

echo 'Finished config!'
