#!/usr/bin/env bash

cd
echo "installing packages"
brew install bash-completion
brew install wget
brew install vim
brew install tmux
brew install reattach-to-user-namespace
brew install the_silver_searcher
brew install ctags
brew install rbenv
rbenv init
echo "Finished bare minimum"
