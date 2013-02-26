alias reload_profile='source ~/.bash_profile'
alias ".."='cd ..'
alias "..."='cd ../..'

# from http://www.pixelbeat.org/docs/terminal_colours/
# terminal color fun section
alias _matrix='tr -c "[:digit:]" " " < /dev/urandom \
               | dd cbs=$COLUMNS conv=unblock \
               | GREP_COLOR="1;32" grep --color "[^ ]"'


_load_file_if_exists()
{
  file=$1
  if [[ -r ${file} ]] ; then
    . ${file}
  fi
}

_command_exists()
{
  command=`which $1 2> /dev/null`
  if [[ -n ${command} ]] && [[ -x ${command} ]] ; then
    return 1
  else
    return 0
  fi
}

_enable_keychain()
{
  KEYCHAIN=`which keychain`
  if [[ -n ${KEYCHAIN} ]] ; then
    ${KEYCHAIN} --agents ssh --quiet $1
    . ~/.keychain/$HOSTNAME-sh
    # no GPG atm
    # . ~/.keychain/$HOSTNAME-sh-gpg
  fi
}

_enable_grc()
{
  GRC=`which grc`
  if [[ -n ${GRC} ]]; then
    alias colourify="${GRC} -es --colour=auto"
    alias configure='colourify ./configure'
    alias diff='colourify diff'
    # problematic with kernel 'menuconfig'
    # alias make='colourify make'
    alias gcc='colourify gcc'
    alias g++='colourify g++'
    alias as='colourify as'
    # alias gas='colourify gas'
    alias ld='colourify ld'
    alias netstat='colourify netstat'
    alias ping='colourify ping'
    # alias traceroute='colourify /usr/sbin/traceroute'
  fi
}

_enable_man_colors()
{
  # another man color theme
  # export LESS_TERMCAP_mb=$'\E[01;31m'
  # export LESS_TERMCAP_md=$'\E[01;31m'
  # export LESS_TERMCAP_me=$'\E[0m'
  # export LESS_TERMCAP_se=$'\E[0m'
  # export LESS_TERMCAP_so=$'\E[01;47;34m'
  # export LESS_TERMCAP_ue=$'\E[0m'
  # export LESS_TERMCAP_us=$'\E[01;32m'

  export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
  export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
  export LESS_TERMCAP_me=$(tput sgr0)
  export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
  export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
  export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
  export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
  export LESS_TERMCAP_mr=$(tput rev)
  export LESS_TERMCAP_mh=$(tput dim)
  export LESS_TERMCAP_ZN=$(tput ssubm)
  export LESS_TERMCAP_ZV=$(tput rsubm)
  export LESS_TERMCAP_ZO=$(tput ssupm)
  export LESS_TERMCAP_ZW=$(tput rsupm)

  # more on grotty(1)
  export GROFF_NO_SGR=1
}


# startup script loading
if [[ ${EUID} == 0 ]] ; then
  _enable_grc
  _enable_man_colors
else
  _enable_keychain ~/.ssh/id_rsa
  _enable_grc
  _enable_man_colors
fi

# to enable '__git_ps1'
_load_file_if_exists ${HOME}/'.scripts/git-prompt'

# __git_ps1 prompt config
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUPSTREAM='auto'
export GIT_PS1_SHOWUNTRACKEDFILES=true


# history
set -o noclobber
export HISTIGNORE="&"
export HISTSIZE="5000"
export HISTFILESIZE="7000"
export HISTTIMEFORMAT="%F %T "

shopt -s cdspell
shopt -s cmdhist
shopt -s histappend

# disable flow control
stty -ixon
# disable start/stop characters
stty -ixoff

hist()
{
  cnt=10
  if [ $1 ]; then
    cnt=${1}
  fi
  history ${cnt}
}

# Configure Colors:
COLOR_WHITE='\033[1;37m'
COLOR_LIGHTGRAY='033[0;37m'
COLOR_GRAY='\033[1;30m'
COLOR_BLACK='\033[0;30m'
COLOR_RED='\033[0;31m'
COLOR_LIGHTRED='\033[1;31m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHTGREEN='\033[1;32m'
COLOR_BROWN='\033[0;33m'
COLOR_YELLOW='\033[1;33m'
COLOR_BLUE='\033[0;34m'
COLOR_LIGHTBLUE='\033[1;34m'
COLOR_PURPLE='\033[0;35m'
COLOR_PINK='\033[1;35m'
COLOR_CYAN='\033[0;36m'
COLOR_LIGHTCYAN='\033[1;36m'
COLOR_DEFAULT='\033[0m'

DATE_COLOR="\[${COLOR_CYAN}\]"
JOBS_COLOR="\[${COLOR_PINK}\]"
HIST_COLOR="\[${COLOR_PINK}\]"
DFLT_COLOR="\[${COLOR_DEFAULT}\]"

_prompt_command()
{
  history -a 
  history -n
}

_ps1()
{
  if [[ ${EUID} == 0 ]] ; then
    PROMPT_COLOR="\[${COLOR_LIGHTRED}\]"
    USER_COLOR="\[${COLOR_LIGHTRED}\]"
    BRACKET_COLOR="\[${COLOR_LIGHTRED}\]"
  else
    PROMPT_COLOR="\[${COLOR_LIGHTBLUE}\]"
    USER_COLOR="\[${COLOR_LIGHTGREEN}\]"
    BRACKET_COLOR="\[${COLOR_LIGHTGREEN}\]"
  fi

  echo "\
${BRACKET_COLOR}[${DATE_COLOR}\D{%H:%M:%S %Y/%m/%d}${BRACKET_COLOR}]\
 ${BRACKET_COLOR}[\[${COLOR_LIGHTGREEN}\]j:${JOBS_COLOR}\j\
 \[${COLOR_LIGHTGREEN}\]h:${HIST_COLOR}\!${BRACKET_COLOR}]\
 ${BRACKET_COLOR}[${USER_COLOR}\u@\h\[${COLOR_DEFAULT}\]\
 \[${COLOR_LIGHTBLUE}\]\w${BRACKET_COLOR}]\[${COLOR_DEFAULT}\]\
 \[${COLOR_PINK}\]"'$(__git_ps1 "(%s)")'"\
\n\
${PROMPT_COLOR}\\$ ${DFLT_COLOR}"
}

# prompt
export PROMPT_COMMAND=$(_prompt_command)
export PS1=$(_ps1)

_load_file_if_exists ${HOME}/'.bashrc'
