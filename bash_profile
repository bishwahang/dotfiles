export BASH_SILENCE_DEPRECATION_WARNING=1

# Initialize Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Bash completion v2
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
export CLICOLOR=1
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export AWS_SQS_QUEUES_PREFIX=bishwa

export PATH="$HOME/.cargo/bin:$PATH"
