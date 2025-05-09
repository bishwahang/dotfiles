export BASH_SILENCE_DEPRECATION_WARNING=1

# needed to add this after the M1
eval $(/opt/homebrew/bin/brew shellenv)

# coreutils
# disable as gnu 'ls' is not working easily with dircolors
# export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"

export PATH=/usr/local/bin:$PATH
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
export CLICOLOR=1
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export AWS_SQS_QUEUES_PREFIX=bishwa

export PATH="$HOME/.cargo/bin:$PATH"
