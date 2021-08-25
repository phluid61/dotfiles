
# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

pathmunge () {
    PATH=$(echo "$PATH" | sed -e 's#\(^\|:\)'"$1"'\(:\|$\)#\1\2#g' | sed -e 's/::/:/g')
    if [ "$2" = "after" ] ; then
        PATH=${PATH:+$PATH:}$1
    else
        PATH=$1${PATH:+:$PATH}
    fi
}


# Hack! Force colours in all xterms! Makes vim/gvim much
# more prettier. Might make things asplode.
case "$TERM" in
    xterm*)
        export TERM=xterm-256color
        ;;
    screen*)
        export TERM=screen-256color
        ;;
    rxvt*unicode*)
        export TERM=rxvt-unicode-256color
        ;;
    rxvt*)
        export TERM=rxvt-256color
        ;;
    *)  ;;
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

# Disable Ctrl+S freezing terminal output.
stty -ixon

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#COLOUR_ENVIRONMENT=PROD
#COLOUR_ENVIRONMENT=QA
#COLOUR_ENVIRONMENT=TEST
COLOUR_ENVIRONMENT=DEV

# If we can do colours, do colours.
case "$TERM" in
    *color*|vt100)
        # colour the prompt; particularly good for breaking up big file
        # dumps and log traces.
        case "$TERM" in
            *256color*)
                case "$USER" in
                    root) USERNAME_C="38;5;202" ;;
                    *)    USERNAME_C="38;5;33"  ;;
                esac
                case "$COLOUR_ENVIRONMENT" in
                    DEV)  HOSTNAME_C="48;5;22;38;5;40"  ;;
                    TEST) HOSTNAME_C="48;5;23;38;5;123" ;;
                    QA)   HOSTNAME_C="48;5;53;38;5;166" ;;
                    *)    HOSTNAME_C="48;5;88;38;5;214" ;;
                esac
                DIRNAME_C="38;5;33"
                export PS1='\[\e]0;\u@\h: \w\a\]❬\e['$USERNAME_C'm\u\e[0m@\e['$HOSTNAME_C'm\h\e[0m \e['$DIRNAME_C'm\w\e[95m$('$HOME'/.gitprompt.sh)\e[0m❭\n[$('$HOME'/.dir_chomp.sh "$(pwd)")]\$ '
                export PS2='\$… '
                export PS3='
▷ '
                export PS4='·\e[38;5;202m$0\e[0m:\e[38;5;33m$LINENO\e[0m> '
                ;;
            *)
                case "$USER" in
                    root) USERNAME_C="33" ;;
                    *)    USERNAME_C="94" ;;
                esac
                case "$COLOUR_ENVIRONMENT" in
                    DEV)  HOSTNAME_C="92" ;;
                    TEST) HOSTNAME_C="36" ;;
                    QA)   HOSTNAME_C="35" ;;
                    *)    HOSTNAME_C="31" ;;
                esac
                DIRNAME_C="31"
                export PS1='\[\e]0;\u@\h: \w\a\][\e['$USERNAME_C'm\u\e[0m@\e['$HOSTNAME_C'm\h\e[0m \e['$DIRNAME_C'm\w\e[95m$('$HOME'/.gitprompt.sh)\e[0m]\n[$('$HOME'/.dir_chomp.sh "$(pwd)")]\$ '
                export PS2='\$> '
                export PS3='
> '
                export PS4='.\e[33m$0\e[0m:\e[34m$LINENO\e[0m> '
                ;;
        esac

        # enable color support of ls and also add handy aliases
        if [ -x /usr/bin/dircolors ]; then
            test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
            alias ls='ls --color=auto'
        fi

        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
        ;;
    *)
        # monochromatic version of my otherwise sexy color prompt
        export PS1='[\u@\h \w$('$HOME'/.gitprompt.sh)]\n[$('$HOME'/.dir_chomp.sh "$(pwd)")]\$ '
        # prompt for continued (multiline) commands
        export PS2='\$> '
        # prompt for `select`
        export PS3='
> '
        # echo prefix for `set -x`
        export PS4='.$0:$LINENO> '
        ;;
esac

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#pathmunge /usr/local/ssl/bin

#function _ssh_completion() {
#    local cur=${COMP_WORDS[COMP_CWORD]}
#    local all_hosts=$(grep Host ~/.ssh/config | sed -e 's/Host \|*//g')
#    COMPREPLY=( $(compgen -W "$all_hosts" -- $cur) )
#}
#complete -F _ssh_completion ssh scp

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

export PATH
unset pathmunge

### Functions

# Usage: hush <command> [<args>...]
# Redirects all STDOUT to /dev/null
function hush() {
    "$@" > /dev/null
    return $?
}
export -f hush

# Usage: shush <command> [<args>...]
# Redirects all output to /dev/null
function shush() {
    "$@" > /dev/null 2> /dev/null
    return $?
}
export -f shush

# Usage: die <status> [<message>...]
# Prints 'message', if any, and exits
function die() {
    local RC=$1
    shift
    [ $# -gt 0 ] && echo "$@" >&2
    exit $RC
}
export -f die

