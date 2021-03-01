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
export CORE_ADMIN_DATABASE_URL=postgres://postgres@localhost:5432/core-admin-development
export AWS_SQS_QUEUES_PREFIX=bishwa
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home"
export PATH=$JAVA_HOME/bin:$PATH

export PATH="$HOME/.cargo/bin:$PATH"
