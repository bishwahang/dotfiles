#!/usr/bin/env bash
# install other packages
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
brew install bat
echo "Finished bare minimum"
