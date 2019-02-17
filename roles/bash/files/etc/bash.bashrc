# If not running interactively, don't do anything
[[ $- != *i* ]] && return

echo /etc/bash.bashrc

# Color output in console
alias dmesgc='dmesg --color=always'
alias diffc='diff --color=always'
alias grepc='grep --color=always'
alias egrepc='egrep --color=always'
alias fgrepc='fgrep --color=always'
alias grep='grep --color=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias diff='diff --color=auto'
export LESS='-R -M'
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
# Set up LS_OPTIONS environment variable.
# This contains extra command line options to use with ls.
# The default ones are:
#  -F = show '/' for dirs, '*' for executables, etc.
#  -T 0 = don't trust tab spacing when formatting ls output.
#  -b = better support for special characters
export LS_OPTIONS='--color=auto -F -b -T 0'
# Set up aliases to use color ls by default.  A few additional
# aliases like 'dir', 'vdir', etc, are some ancient artifacts
# from 1992 or so...  possibly they should be disabled, but maybe
# someone out there is actually using them?  :-)
# Assume shell aliases are supported.
if [ "$SHELL" = '/bin/zsh' ] ; then
  # By default, zsh doesn't split parameters into separate words
  # when it encounters whitespace.  The '=' flag will fix this.
  # see zshexpn(1) man-page regarding SH_WORD_SPLIT.
  alias ls='/bin/ls ${=LS_OPTIONS}'
  alias dir='/bin/ls ${=LS_OPTIONS} --format=vertical'
  alias vdir='/bin/ls ${=LS_OPTIONS} --format=long'
else
  alias ls='/bin/ls $LS_OPTIONS'
  alias dir='/bin/ls $LS_OPTIONS --format=vertical'
  alias vdir='/bin/ls $LS_OPTIONS --format=long'
fi
alias d='dir'
alias v='vdir'

if [ -f '/etc/dircolors' ] ; then
  eval "$(dircolors -b /etc/dircolors)"
elif [ -f "$HOME/.dircolors" ] ; then
  eval "$(dircolors -b "$HOME"/.dircolors)"
else
  eval "$(/bin/dircolors -b)"
fi

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
[[ "$DISPLAY" ]] && shopt -s checkwinsize

# Disable completion when the input buffer is empty.  i.e. Hitting tab
# and waiting a long time for bash to expand all of $PATH.
shopt -s no_empty_cmd_completion

# Enable history appending instead of overwriting when exiting.  #139609
shopt -s histappend

# Prepend cd when entering just a path in the shell
shopt -s autocd

# Disconnect from a shell when pressing Ctrl+D 10 times
set -o ignoreeof

# Change the window title of X terminals
case "$TERM" in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
    PS1='\[\033]0;\u[$?]\h:\w\007\]'
    ;;
  screen*)
    PS1='\[\033]0;\u[$?]\h:\w\007\]'
    ;;
  *)
    PS1=''
esac

# Setup a red prompt for root and a green one for users.
NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
exitstatus()
{
  if [[ $1 != 0 ]]; then
    tput sc
    printf "%*s\e[1;31m%s\e[0m" $(($COLUMNS-${#1}-2)) "" "[$1]"
    tput rc
  fi
}
if [[ $EUID == 0 ]] ; then
  PS1+="\[\$(exitstatus \$?)\]$RED\u [ $NORMAL\w$RED ]# $NORMAL"
else
  PS1+="\[\$(exitstatus \$?)\]$GREEN\u [ $NORMAL\w$GREEN ]\$ $NORMAL"
fi
unset script RED GREEN NORMAL

if [ "$TERM" = "linux" ]; then
  echo -en "\e]P033303b"
  echo -en "\e]P187404f"
  echo -en "\e]P24c9882"
  echo -en "\e]P371949a"
  echo -en "\e]P4615772"
  echo -en "\e]P5783e57"
  echo -en "\e]P6554757"
  echo -en "\e]P7c0a79a"
  echo -en "\e]P84f4b58"
  echo -en "\e]P987404f"
  echo -en "\e]PA4c9882"
  echo -en "\e]PB71949a"
  echo -en "\e]PC615772"
  echo -en "\e]PD783e57"
  echo -en "\e]PE554757"
  echo -en "\e]PFc0a79a"
  clear #for background artifacting
fi

[ -r /usr/share/bash-completion/bash_completion ] \
  && . /usr/share/bash-completion/bash_completion

# To pass aliases
alias sudo='sudo '

alias duh='du -h --summarize'
alias dfh='df -h'
alias freeh='free -h'
alias ll='ls -lh'
alias la='ls -lah'
alias lsd="ls -lAF | grep /$"
alias ping4='ping -c4'
alias dmesq='dmesg --color=always | less'

extract () {
  if [ -f "$1" ] ; then
   case $1 in
     *.tar.bz2) tar xvjf "$1"    ;;
     *.tar.gz)  tar xvzf "$1"    ;;
     *.bz2)     bunzip2 "$1"     ;;
     *.rar)     unrar x "$1"     ;;
     *.gz)      gunzip "$1"      ;;
     *.tar)     tar xvf "$1"     ;;
     *.tbz2)    tar xvjf "$1"    ;;
     *.tgz)     tar xvzf "$1"    ;;
     *.zip)     unzip "$1"       ;;
     *.Z)       uncompress "$1"  ;;
     *.7z)      7z x "$1"        ;;
     *)         printf -- 'Don'\''t know how to extract "%s"\n' "$1" ;;
   esac
  else
   printf -- '"%s" is not a valid file!\n' "$1"
  fi
}
export -f extract
