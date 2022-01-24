#!/usr/bin/env bash

# cd
# wget --no-check-certificate https://raw.github.com/seebi/dircolors-solarized/master/dircolors.ansi-dark
# mv dircolors.ansi-dark .dircolors
# eval `dircolors ~/.dircolors`
# git clone https://github.com/sigurdga/gnome-terminal-colors-solarized.git
# cd gnome-terminal-colors-solarized
# ./set_dark.sh
# cd

# install packages
echo "installing packages"
brew install bash-completion
brew install vim
brew install tmux
brew install reattach-to-user-namespace
brew install the_silver_searcher
brew install ctags
brew install rbenv
brew install ruby-build
rbenv init
brew install fzf
$(brew --prefix)/opt/fzf/install

# extra packages
brew install bat

echo "Finished bare minimum"
