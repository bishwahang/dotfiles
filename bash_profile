export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
export CLICOLOR=1
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
# export DOCKER_TLS_VERIFY="1"
# export DOCKER_HOST="tcp://192.168.99.101:2376"
# export DOCKER_CERT_PATH="/Users/bishwa/.docker/machine/machines/freeletics"
# export DOCKER_MACHINE_NAME="freeletics"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export CORE_ADMIN_DATABASE_URL=postgres://postgres@localhost:5432/core-admin-development
