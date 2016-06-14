# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export PATH=~/Downloads/mongodb/bin:/opt/solr/bin/:/home/amitn/android-studio/bin:$PATH

function fawk {
    first="awk '{print "
    last="}'"
    cmd="${first}\$${1}${last}"
    eval $cmd
}
function mkcd () {
  mkdir "$1"
  cd "$1"
}

function __setprompt {
  local BLUE="\[\033[0;34m\]"
  local NO_COLOUR="\[\033[0m\]"
  local SSH_IP=`echo $SSH_CLIENT | awk '{ print $1 }'`
  local SSH2_IP=`echo $SSH2_CLIENT | awk '{ print $1 }'`
  if [ $SSH2_IP ] || [ $SSH_IP ] ; then
    local SSH_FLAG="@\h"
  fi
  PS1="$BLUE[\$(date +%H:%M)][\u$SSH_FLAG:\w]\\$ $NO_COLOUR"
  PS2="$BLUE>$NO_COLOUR "
  PS4='$BLUE+$NO_COLOUR '
}
__setprompt

up(){
  local d=""
  limit=$1
  for ((i=1 ; i <= limit ; i++))
    do
      d=$d/..
    done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
}

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

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliase
alias gw='scp -i ~/Desktop/headhonchos-prod.pem  -P87 ec2-user@54.169.99.64:/home/ec2-user/chatBot/webhook.js /home/amitn/Desktop/'
alias pw='scp -i ~/Desktop/headhonchos-prod.pem  -P87 /home/amitn/Desktop/webhook.js ec2-user@54.169.99.64:/home/ec2-user/chatBot/'
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias c='clear'
alias vbash='vi ~/.bashrc'
alias dep='bash ~/apilc.sh'
alias tcstart='bash ~/apache-tomcat-7.0.64/bin/startup.sh'
alias tcshut='bash ~/apache-tomcat-7.0.64/bin/shutdown.sh'
alias tclog='tail -f ~/apache-tomcat-7.0.64/logs/catalina.out ~/apache-tomcat-7.0.64/logs/server.log ~/apache-tomcat-7.0.64/logs/hibernate.log'
alias tclogs='tail -f ~/apache-tomcat-7.0.64/logs/catalina.out ~/apache-tomcat-7.0.64/logs/searchServer.log ~/apache-tomcat-7.0.64/logs/searchHibernate.log'
alias tclogb='tail -f ~/apache-tomcat-7.0.64/logs/catalina.out ~/apache-tomcat-7.0.64/logs/bullhornServer.log ~/apache-tomcat-7.0.64/logs/bullhornHibernate.log'
alias tcshow='ps aux | grep tomcat'
alias deps='bash ~/apilcs.sh'
alias tcstart8='bash ~/apache-tomcat-8.0.64/bin/startup.sh'
alias tclog8='tail -100f ~/apache-tomcat-8.0.64/logs/catalina.out'
alias ebash='. ~/.bashrc'
alias tckill='ps aux | grep tomcat | fawk 2 | xargs kill -9'
alias back='cd $OLDPWD'
alias apil='sshpass -p employer ssh staging@10.100.100.35'
#alias apil='sshpass -p employer ssh employer@10.100.99.21'
alias apis='ssh ubuntu@54.255.200.65 -i ~/Desktop/headhonchos-prod.pem -p 87'
alias apip='ssh ubuntu@52.77.238.172 -i ~/Desktop/headhonchos-prod.pem'
alias bpo='ssh ec2-user@54.255.170.185 -i ~/Desktop/headhonchos-prod.pem'
alias deph='bash ~/springHib.sh'
alias tclogh='tail -200f ~/apache-tomcat/logs/catalina.out'
alias prcsonport='netstat -peant'
alias mvwar='scp -i ~/Desktop/headhonchos-prod.pem /home/amitn/apache-tomcat-7.0.64/webapps/ews.war ubuntu@52.77.238.172:/home/ubuntu/'
alias mvwars='scp -i ~/Desktop/headhonchos-prod.pem /home/amitn/apache-tomcat-7.0.64/webapps/search.war ubuntu@52.77.238.172:/home/ubuntu/'
alias mvwarn='scp -P 87 -i ~/Desktop/headhonchos-prod.pem /home/amitn/apache-tomcat-7.0.64/webapps/ews.war ec2-user@54.169.27.144:/home/ec2-user/'
alias mvwarsn='scp -P 87 -i ~/Desktop/headhonchos-prod.pem /home/amitn/apache-tomcat-7.0.64/webapps/search.war ec2-user@54.169.27.144:/home/ec2-user/'
alias d='date +%d-%m-%Y::%H:%M:%S'
alias wk='date +%A'
alias mth='date +%B'
alias hh='cd ~/HHEmployer/hh-employer/'

########################### Git Aliases #########################################################
alias gst='git status'
alias gpl='git pull'
alias gps='git push'
alias gd='git diff'
alias gau='git add --update'
alias gad='git add'
alias gc='git commit -m'
alias gb='git branch'
alias gbr='git branch -r'
alias gru='git remote --update'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcot='git checkout -t'
alias gcotb='git checkout --track -b'
alias glog='git log'
alias glogp='git log --pretty=format:"%h %s" --graph'
alias gct='git cat-file -p'

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
