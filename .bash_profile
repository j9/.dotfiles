alias reload_profile='source ~/.bash_profile'


_load_file_if_exists()
{
  file=$1
  if [[ -r ${file} ]] ; then
    . ${file}
  fi
}

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
