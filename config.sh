#!/usr/bin/env bash
hash git > /dev/null || {
  echo "Please install git!"
  return 1
}

echo "Link config files"
configs=(bashrc bash_profile bash_aliases vimrc gvimrc vim gitconfig gitignore tmux.conf agignore functions.sh key_bindings.sh)
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

# iTerm2 comes with solarized color palette
# wget -O ~/.tmp/solarized_dark.itemcolors https://github.com/altercation/solarized/blob/master/iterm2-colors-solarized/Solarized%20Dark.itermcolors
# echo "import solarized_dark to iterm profile"
# importing and setting solarized dark and light
# cd /tmp
# git clone git@github.com:mbadolato/iTerm2-Color-Schemes.git iterm2colors
# cd iterm2colors
# tools/import-scheme.sh 'Builtin Solarized Dark.itermcolors'
# tools/import-scheme.sh 'Builtin Solarized Light.itermcolors'
# cd
# rm -rf /tmp/iterm2colors

# to enable italic: https://weibeld.net/terminals-and-shells/italics.html
echo "Visit how to enable italics in iTerm: https://weibeld.net/terminals-and-shells/italics.html"

echo 'Finished config!'
