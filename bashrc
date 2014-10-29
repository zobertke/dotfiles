# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Normal Colors
Black='\[\e[0;30m\]'        # Black
Red='\[\e[0;31m\]'          # Red
Green='\[\e[0;32m\]'        # Green
Yellow='\[\e[0;33m\]'       # Yellow
Blue='\[\e[0;34m\]'         # Blue
Purple='\[\e[0;35m\]'       # Purple
Cyan='\[\e[0;36m\]'         # Cyan
White='\[\e[0;37m\]'        # White

# Bold
BBlack='\[\e[1;30m\]'       # Black
BRed='\[\e[1;31m\]'         # Red
BGreen='\[\e[1;32m\]'       # Green
BYellow='\[\e[1;33m\]'      # Yellow
BBlue='\[\e[1;34m\]'        # Blue
BPurple='\[\e[1;35m\]'      # Purple
BCyan='\[\e[1;36m\]'        # Cyan
BWhite='\[\e[1;37m\]'       # White

# Background
On_Black='\[\e[40m\]'       # Black
On_Red='\[\e[41m\]'         # Red
On_Green='\[\e[42m\]'       # Green
On_Yellow='\[\e[43m\]'      # Yellow
On_Blue='\[\e[44m\]'        # Blue
On_Purple='\[\e[45m\]'      # Purple
On_Cyan='\[\e[46m\]'        # Cyan
On_White='\[\e[47m\]'       # White

NC="\[\e[m\]"               # Color Reset

if [ "$(uname)" == "Darwin" ]; then
    alias readlink='greadlink'
fi

#git repo location
DOTFILES_REPO="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"

#apparently this is not obvious
export SHELL="/bin/bash"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.lz) tar xvf $1 ;;
            *.tar.bz2) tar xvjf $1 ;;
            *.tar.gz) tar xvzf $1 ;;
            *.bz2) bunzip2 $1 ;;
            *.rar) unrar x $1 ;;
            *.gz) gunzip $1 ;;
            *.tar) tar xvf $1 ;;
            *.tbz2) tar xvjf $1 ;;
            *.tgz) tar xvzf $1 ;;
            *.zip) unzip $1 ;;
            *.Z) uncompress $1 ;;
            *.7z) 7z x $1 ;;
            *) echo "'$1' cannot be extracted via >extract<"
               return 1 ;;
        esac
    else
        echo "'$1' is not a valid file!"
        return 1
    fi
}


function swap() {
    if [ $# -ne 2 ]; then
        echo "Two parameters expected" 1>&2
        return 1
    fi
    local file1=$1
    local file2=$2
    local tmpfile=$(mktemp $(dirname "$file1")/XXXXXX)
    mv "$file1" "$tmpfile"
    mv "$file2" "$file1"
    mv "$tmpfile" "$file2"
}

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
if [ ${BASH_VERSINFO} -ge "4" ]; then
    shopt -s globstar
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
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
    alias less='less -R'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

#update history in real time
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

#useful git helper (from https://gist.github.com/sharplet/6289697)
function git-remove-submodule() {
    submodule_name=$(echo "$1" | sed 's/\/$//'); shift
    if git submodule status "$submodule_name" >/dev/null 2>&1; then
        git submodule deinit -f "$submodule_name"
        git rm -f "$submodule_name"

        git config -f .gitmodules --remove-section "submodule.$submodule_name"
        if [ -z "$(cat .gitmodules)" ]; then
            git rm -f .gitmodules
        else
            git add .gitmodules
        fi
    else
        echo "Submodule '$submodule_name' not found" 1>&2
        exit 1
    fi
}

#STUFF for PS1
function getShortPath() {
    offset=$1
    let "path_length=$(tput cols) - $offset"
    echo -n $PWD | sed "s#^$HOME#~#g" | awk -v MAX_LENGTH=${path_length} -f "${DOTFILES_REPO}/short_path.awk"
}

function getDefaultSCM() {
    versionControl="git"
    hostName=$(hostname)
    if [ ${hostName#esekilxxen} != ${hostName} ] && which ct > /dev/null 2>&1; then
        versionControl="clearcase"
    fi
    echo ${versionControl}
}

function getView() {
    rawname=$(ct pwv -short)
    if [ "$rawname" == '** NONE **' ]; then
        echo ""
    else
        echo " (${rawname#${USER}_}) "
    fi
}

defaultSCM=$(getDefaultSCM)
PS1_versionControl=""

if [ "$defaultSCM" == "git" ]; then
    PS1_versionControl='$(__git_ps1 " (%s)")'
elif [ "$defaultSCM" == "clearcase" ]; then
    PS1_versionControl='$(__git_ps1 " (%s)")'"${BRed}`getView`${NC}"
fi

#swap file location for vim
mkdir -p ~/.vim/swp

alias en='setxkbmap -layout en_US'
alias hun='setxkbmap -layout hu'
alias getTime='date +"[%k:%M:%S"]'

alias tmux="TERM=screen-256color-bce tmux"

short_ps1_threshold=50

PS1_Long="${Cyan}"'$(getTime)'" ${BPurple}\h${NC}${NC}${BRed}${PS1_versionControl}${NC} : ${BGreen}"'$(getShortPath ${short_ps1_threshold})'"${NC}\n${BRed}\$${NC} "
PS1_Short="${BGreen}"'$(getShortPath)'"${NC}\n${BRed}\$${NC} "
if [ $(tput cols) -ge ${short_ps1_threshold} ]; then
    export PS1=${PS1_Long}
else
    export PS1=${PS1_Short}
fi

export EDITOR="/usr/bin/vim"

export LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"
export LD_LIBRARY_PATH="/usr/local/lib64:${LD_LIBRARY_PATH}"

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
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -f ~/.bashrc_local ]; then
    . ~/.bashrc_local
fi

