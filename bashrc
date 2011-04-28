## This file is sourced by all *interactive* bash shells on startup.  This
## file *should generate no output* or it will break the scp and rcp commands.
############################################################

if [ -e /etc/bashrc ] ; then
  . /etc/bashrc
fi

# Default user mask
umask 002


# Utility functions -----------------------------------------------------------
function conditionally_execute {
  local file=$1
  if [ -e $file ]; then
     . $file
  fi
}

############################################################
## PATH
############################################################

function conditionally_prefix_path {
  local dir=$1
  if [ -d $dir ]; then
    PATH="$dir:${PATH}"
  fi
}

# set PATH so it includes the dotfiles directory
conditionally_prefix_path ~/.dotfiles

# Set location -----------------------------------------------------------------
if [ -e ~/.location ] ; then
    . ~/.location
else
    echo "dotfiles: No user .location hook exists!"
fi
if [ -z "${LOCATION}" ]; then
    echo "dotfiles: User .location hook failed to set $LOCATION"
    export LOCATION=default
fi

# Set user include directory ---------------------------------------------------
if [ -d ~/.dotfiles/user/${LOCATION} ]; then
    export USER_PATH=~/.dotfiles/user/${LOCATION}
fi

conditionally_prefix_path ~/bin

#conditionally_prefix_path /usr/local/bin
#conditionally_prefix_path /usr/local/sbin
#conditionally_prefix_path /usr/local/share/npm/bin
#conditionally_prefix_path /usr/local/mysql/bin
#conditionally_prefix_path /usr/texbin
#conditionally_prefix_path ~/bin/private
#PATH=.:${PATH}

export PATH


############################################################
## MANPATH
############################################################

function conditionally_prefix_manpath {
  local dir=$1
  if [ -d $dir ]; then
    MANPATH="$dir:${MANPATH}"
  fi
}

#conditionally_prefix_manpath /usr/local/man
#conditionally_prefix_manpath ~/man

############################################################
## Other paths
############################################################

# Run user path additions hook
conditionally_execute ${USER_PATH}/.path


# Save the default path for use in external scripts
DEFAULT_PATH="${PATH}"
export DEFAULT_PATH


############################################################
## Terminal behavior
############################################################

# Change the window title of X terminals
case $TERM in
  xterm*|rxvt|Eterm|eterm)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
    ;;
  screen)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
    ;;
esac

# Show the git branch and dirty state in the prompt.
# Borrowed from: http://henrik.nyh.se/2008/12/git-dirty-prompt
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\(\1$(parse_git_dirty)\)/"
}

if [ `which git 2> /dev/null` ]; then
  function git_prompt {
    parse_git_branch
  }
else
  function git_prompt {
    echo ""
  }
fi


# Do not set PS1 for dumb terminals
if [ "$TERM" != 'dumb'  ] && [ -n "$BASH" ]; then
  export PS1='\[\033[32m\]\n[\s: \w] $(git_prompt)\n\[\033[31m\][\u@\h]\$ \[\033[00m\]'
fi

############################################################
## Optional shell behavior
############################################################

shopt -s cdspell
shopt -s extglob
shopt -s checkwinsize

export PAGER="less"
export EDITOR="vi"

############################################################
## History
############################################################

# When you exit a shell, the history from that session is appended to
# ~/.bash_history.  Without this, you might very well lose the history of entire
# sessions (weird that this is not enabled by default).
shopt -s histappend

export HISTIGNORE="&:pwd:ls:ll:lal:[bf]g:exit:rm*:sudo rm*"
# remove duplicates from the history (when a new item is added)
export HISTCONTROL=erasedups
# increase the default size from only 1,000 items
export HISTSIZE=10000

############################################################
## Aliases
############################################################

if [ -e ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

############################################################
## Bash Completion, if available
############################################################

if [ -f /usr/local/etc/bash_completion ]; then
  . /usr/local/etc/bash_completion
elif  [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
elif  [ -f /etc/profile.d/bash_completion ]; then
  . /etc/profile.d/bash_completion
fi

if [ -f ~/bin/git_completion ]; then
  . ~/bin/git_completion
fi

############################################################
## cdargs, if available
############################################################

if [ -f /usr/local/etc/bash_completion.d/cdargs-bash.sh ]; then
  . /usr/local/etc/bash_completion.d/cdargs-bash.sh
fi

############################################################
## Other
############################################################

if [[ "$USER" == '' ]]; then
  # mainly for cygwin terminals. set USER env var if not already set
  USER=$USERNAME
fi


# Call user .bashrc ---------------------------------------------------------------
conditionally_execute ${USER_PATH}/.bashrc


# Call user app hook
conditionally_execute ${USER_PATH}/.app
