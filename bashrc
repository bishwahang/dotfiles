# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#rbenv root
export RBENV_ROOT="$HOME/.rbenv"
# add rbenv to PATH
# and initialize rbenv
if [[ -d $RBENV_ROOT ]];then
  PATH="$RBENV_ROOT/bin:$PATH"
  eval "$(rbenv init -)"
  export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
fi

# pyenv root
export PYENV_ROOT="$HOME/.pyenv"

# Add pyenv root to PATH
# and initialize pyenv
if [[ -d $PYENV_ROOT ]];then
    PATH="$PYENV_ROOT/bin:$PATH"
    # initialize pyenv
    eval "$(pyenv init -)"
    # initialize pyenv virtualenv
    eval "$(pyenv virtualenv-init -)"
fi

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    source /usr/local/bin/virtualenvwrapper.sh
fi

# OPAM configuration
. /home/hang/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
#NPM
export PATH=$HOME/.npm/bin:$PATH

export PROMPT_DIRTRIM=2
export CHKTEXRC=$HOME/.chktexrc

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# 256 color
if [ "$TERM" == "xterm" ]; then
    # No it isn't, it's gnome-terminal
    export TERM=xterm-256color
fi

# Configure colors, if available.
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    # enable color support of ls and also add handy aliases
    # alias ls='ls --color=auto'
    # alias dir='dir --color=auto'
    # alias vdir='vdir --color=auto'
    alias ls='ls -Gp'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    c_reset='\[\033[0m\]'
    c_user='\[\033[0;32m\]'
    c_path='\[\033[1;34m\]'
    c_user='\[\033[0;32m\]'
    c_git_reset='\033[0m'
    c_git_clean='\033[0;37m'
    c_git_staged='\033[0;32m'
    c_git_unstaged='\033[0;31m'
    # c_git_reset='\[\033[0m\]'
    # c_git_clean='\[\033[0;37m\]'
    # c_git_staged='\[\033[0;32m\]'
    # c_git_unstaged='\[\033[0;31m\]'
else
    c_reset=
    c_user=
    c_path=
    c_git_clean=
    c_git_staged=
    c_git_unstaged=
fi

# Function to assemble the Git parsingart of our prompt.
git_color()
{
    GIT_DIR=`git rev-parse --git-dir 2>/dev/null`
    if [ -z "$GIT_DIR" ]; then
        return 0
    fi
    STATUS=`git status --porcelain`
    if [ -z "$STATUS" ]; then
        git_color="${c_git_clean}"
    else
        echo -e "$STATUS" | grep -q '^ [A-Z\?]'
        if [ $? -eq 0 ]; then
            git_color="${c_git_unstaged}"
        else
            git_color="${c_git_staged}"
        fi
    fi
    echo -e "${git_color}"
}
# Function to assemble the Git parsingart of our prompt.
git_branch()
{
    GIT_DIR=`git rev-parse --git-dir 2>/dev/null`
    if [ -z "$GIT_DIR" ]; then
        return 0
    fi
    GIT_HEAD=`cat $GIT_DIR/HEAD`
    GIT_BRANCH=${GIT_HEAD##*/}
    if [ ${#GIT_BRANCH} -eq 40 ]; then
        GIT_BRANCH="(no branch)"
    fi
    echo -e " [${GIT_BRANCH}]"
}

PS1="${c_user}${debian_chroot:+($debian_chroot)}\u${c_reset}@${c_user}\h${c_reset}:${c_path}\w${c_reset}\[\$(git_color)\]\$(git_branch) ${c_reset}\$ "
### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
# After each command, save and reload history
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end
alias ag='ag --path-to-agignore=~/.agignore'
