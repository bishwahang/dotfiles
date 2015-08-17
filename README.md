##Installation

Install minimum required app, and set up configs.


```
sudo apt-get -y --force-yes update && sudo apt-get -y install \
  build-essential \
  git vim-gnome tmux


git clone https://github.com/bishwahang/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./bare_minimum.sh && ./config.sh
```
