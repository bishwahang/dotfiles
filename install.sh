#!/usr/bin/env bash
hash git > /dev/null || {
  echo "Please install git!"
  return 1
}

echo "installing rbenv"
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo "installing pyenv and pyenv-virtualenv"
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

echo "Link config files"
configs=(bashrc vimrc gvimrc vim gitconfig gitignore tmux.conf)
for config in configs; do
  ln -nfs $HOME/.dotfiles/$target $HOME/.$target
done
echo "setting global gitignore"
git config --global core.excludesfile ~/.gitignore

echo "making temp and undo directory"
mkdir -p $HOME/.tmp
mkdir -p $HOME/.undo

hash vim > /dev/null && {
  echo 'Installing Vim Plugin'
  vim +PluginInstall +PluginUpdate +qall
}
echo 'Finished!'

