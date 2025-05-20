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
HISTSIZE=
HISTFILESIZE=

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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

export PATH=$HOME/.npm/bin:$PATH

export PROMPT_DIRTRIM=2
export CHKTEXRC=$HOME/.chktexrc

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Configure colors, if available.
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    c_reset='\[\033[0m\]'
    c_user='\[\033[0;32m\]'
    c_path='\[\033[1;34m\]'
    c_user='\[\033[0;32m\]'
    c_git_reset='\033[0m'
    c_git_clean='\033[0;37m'
    c_git_staged='\033[0;32m'
    c_git_unstaged='\033[0;31m'
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
    echo -e " [${GIT_BRANCH}]"
}

PS1="${c_user}${debian_chroot:+($debian_chroot)}\u${c_reset}@${c_user}\h${c_reset}:${c_path}\w${c_reset}\[\$(git_color)\]\$(git_branch) ${c_reset}\$ "
### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
# After each command, save and reload history
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export VISUAL=vim
export EDITOR="$VISUAL"

# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end
PATH="/Users/bishwa/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/bishwa/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/bishwa/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/bishwa/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/bishwa/perl5"; export PERL_MM_OPT;

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.functions.sh ] && source ~/.functions.sh
[ -f ~/.key_bindings.sh ] && source ~/.key_bindings.sh

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/*" --glob "!node_modules/*" --glob "!tmp/*" --glob "!log/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export DISABLE_SPRING=1

export LC_ALL=en_US.UTF-8

# usees solarized theme for bat. Also fzf#vim uses this for preview theme
export BAT_THEME="Solarized (dark)"
# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pkgconfig
export PKG_CONFIG_PATH="/opt/homebrew/opt/icu4c/lib/pkgconfig:$PKG_CONFIG_PATH"

# Customer Dot ENV variables
if [ -f ~/.cust_dot_env ]; then
    . ~/.cust_dot_env
fi

export TERM=xterm-256color-italic

# Added by GDK bootstrap
eval "$(/opt/homebrew/bin/mise activate bash)"
eval "$(/opt/homebrew/bin/mise hook-env)"
