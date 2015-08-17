#!/usr/bin/env bash

# basic update
sudo apt-get -y --force-yes update
sudo apt-get -y --force-yes upgrade

sudo apt-get -y install \
  build-essential \
  git vim-gnome tmux

# set solarized
cd
wget --no-check-certificate https://raw.github.com/seebi/dircolors-solarized/master/dircolors.ansi-dark
mv dircolors.ansi-dark .dircolors
eval `dircolors ~/.dircolors`
git clone https://github.com/sigurdga/gnome-terminal-colors-solarized.git
cd gnome-terminal-colors-solarized
./set_dark.sh
