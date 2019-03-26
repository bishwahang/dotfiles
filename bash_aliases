shopt -s expand_aliases
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if [[ -x /usr/bin/tput ]] && tput setaf 1 >&/dev/null; then
  alias dir='dir -G'
  alias vdir='vdir -G'
  alias ls='ls -Gp'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias ag='ag --path-to-ignore=~/.agignore'
alias cop='bundle exec rubocop -a --safe-auto-correct'
alias spec='bundle exec rake spec && cop'
# alias diff="/usr/local/bin/grc /usr/bin/diff"
alias genpass='cat /dev/urandom | env LC_CTYPE=C tr -dc a-zA-Z0-9_\!\@\#\$\%\^\&\*\(\)\-+= | head -c 17; echo'
# FL-CLI-Tools
function fl() {
  $(aws ecr get-login --no-include-email --region eu-west-1);
  docker pull 524690225562.dkr.ecr.eu-west-1.amazonaws.com/fl-cli-tools:latest;
  docker run --rm -it -v ~/:/root/ 524690225562.dkr.ecr.eu-west-1.amazonaws.com/fl-cli-tools:latest ${*:1};
}
