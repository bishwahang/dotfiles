#!/usr/bin/env bash
hash git > /dev/null || {
  echo "Please install git!"
  return 1
}

echo "Link config files"
configs=(bash_profile vimrc gvimrc vim gitconfig gitignore tmux.conf agignore)
for config in "${configs[@]}"
do
  echo "linking $config"
  ln -nfs $HOME/.dotfiles/$config $HOME/.$config
done

echo "making temp and undo directory"
mkdir -p $HOME/.tmp
mkdir -p $HOME/.undo

hash vim > /dev/null && {
  echo 'Installing Vim-Plugin'
  vim +PluginInstall +qall
}

wget -O ~/.tmp/solarized_dark.itemcolors https://github.com/altercation/solarized/blob/master/iterm2-colors-solarized/Solarized%20Dark.itermcolors
echo "import solarized_dark to iterm profile"

echo 'Finished config!'
