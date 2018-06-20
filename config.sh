#!/usr/bin/env bash
hash git > /dev/null || {
  echo "Please install git!"
  return 1
}

echo "Link config files"
configs=(bashrc bash_aliases vimrc gvimrc vim gitconfig gitignore tmux.conf)
for config in "${configs[@]}"
do
  echo "linking $config"
  ln -nfs $HOME/.dotfiles/$config $HOME/.$config
done

echo "making temp and undo directory"
mkdir -p $HOME/.tmp
mkdir -p $HOME/.undo

hash vim > /dev/null && {
  echo 'Installing Vim Plugin'
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall
}
echo 'Finished config!'
