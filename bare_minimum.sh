#!/usr/bin/env bash

# set solarized
echo "setting solarized"
cd
wget --no-check-certificate https://raw.github.com/seebi/dircolors-solarized/master/dircolors.ansi-dark
mv dircolors.ansi-dark .dircolors
eval `dircolors ~/.dircolors`
git clone https://github.com/sigurdga/gnome-terminal-colors-solarized.git
cd gnome-terminal-colors-solarized
./set_dark.sh
cd
# rbenv and pyenv
echo "installing rbenv"
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo "installing pyenv and pyenv-virtualenv"
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

# install other packages
echo "installing packages"
sudo apt-get -y install \
  libxss1 libappindicator1 libindicator7 \
  vim-gnome tmux exuberant-ctags xclip
echo "installing chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb
echo "Finished bare minimum"
