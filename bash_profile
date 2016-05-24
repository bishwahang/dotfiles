export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
export CLICOLOR=1
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
