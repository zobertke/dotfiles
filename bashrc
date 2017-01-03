# Normal Colors
Black='\[\e[0;30m\]'
Red='\[\e[0;31m\]'
Green='\[\e[0;32m\]'
Yellow='\[\e[0;33m\]'
Blue='\[\e[0;34m\]'
Purple='\[\e[0;35m\]'
Cyan='\[\e[0;36m\]'
White='\[\e[0;37m\]'

# Bold
BBlack='\[\e[1;30m\]'
BRed='\[\e[1;31m\]'
BGreen='\[\e[1;32m\]'
BYellow='\[\e[1;33m\]'
BBlue='\[\e[1;34m\]'
BPurple='\[\e[1;35m\]'
BCyan='\[\e[1;36m\]'
BWhite='\[\e[1;37m\]'

# Background
On_Black='\[\e[40m\]'
On_Red='\[\e[41m\]'
On_Green='\[\e[42m\]'
On_Yellow='\[\e[43m\]'
On_Blue='\[\e[44m\]'
On_Purple='\[\e[45m\]'
On_Cyan='\[\e[46m\]'
On_White='\[\e[47m\]'

# Color Reset
NC="\[\e[m\]"

function isOSX() {
    if [ "$(uname)" == "Darwin" ]; then
        return 0
    fi
    return 1
}

export EDITOR="/usr/bin/vim"

if isOSX; then
    alias readlink='greadlink'
    alias vim='mvim -v'
    alias vimdiff='mvim -v -d'
    export EDITOR='/usr/local/bin/mvim -v'
    if [ -f `brew --prefix`/etc/bash_completion ]; then
        . `brew --prefix`/etc/bash_completion
    fi
    if [ -f `brew --prefix`/etc/bash_completion.d ]; then
        . `brew --prefix`/etc/bash_completion.d
    fi
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
            *.apk) unzip $1 ;;
            *.aar) unzip $1 ;;
            *.jar) unzip $1 ;;
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

function mkcd() {
    mkdir -p -- "$1" && cd -P -- "$1"
}

function repeat() {
    printf "$1"'%.s' $(eval "echo {1.."$(($2))"}");
}

#https://github.com/sschuberth/dev-scripts/blob/ccc9e3d6660b3275951c899ade981595e7efc789/android/pull_all.sh
function adb_pull_all() {
    if [ $# -ne 1 ]; then
        echo "Rationale : Pull files from the device by wildcard."
        echo "Usage     : $(basename $0) <path>"
        return 1
    fi

    adb shell ls $1 | tr -s "\r\n" "\0" | xargs -0 -n1 adb pull
}

function format_xml() {
    if [ $# -ne 1 ]; then
        echo "Usage: format_xml <xml>"
        return 1
    fi

    xmllint --format "$1" > "$1.tmp" && mv "$1.tmp" "$1"
}

# From https://gist.github.com/Rob--W/5888648
function upto() {
    if [ -z "$1" ]; then
        echo "Usage: upto [directory]"
        return
    fi
    local upto=$@
    cd "${PWD/\/$upto\/*//$upto}"
}
# Auto-completion
function _upto() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local d=${PWD//\//\ }
    COMPREPLY=( $( compgen -W "$d" -- "$cur" ) )
}
complete -F _upto upto

# Jump the first matching subdirectory
function jd() {
    if [ -z "$1" ]; then
        echo "Usage: jd [directory]"
        return 1
    else
        cd **"/$@"
    fi
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

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# enable color support of ls and also add handy aliases
if isOSX || [ -x /usr/bin/dircolors ]; then
    if isOSX; then
        export CLICOLOR="YES"
    else
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
    fi
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias less='less -R'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
for i in {1..10}; do
    alias "cd$(repeat . ${i})"="cd $(repeat ../ $((i-1)))"
done

alias ccat='pygmentize -g'
alias v='vim'
alias g='git'

# Completion for g (git)
complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g
if command -v hub > /dev/null 2>&1; then
    eval "$(hub alias -s)"
    alias git='hub'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

#update history in real time
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

#STUFF for PS1
function getShortPath() {
    offset=$1
    let "path_length=$(tput cols) - $offset"
    echo -n $PWD | sed "s#^$HOME#~#g" | awk -v MAX_LENGTH=${path_length} -f "${DOTFILES_REPO}/short_path.awk"
}

source "${DOTFILES_REPO}/git-prompt.sh"

PS1_versionControl='$(__git_ps1 " (%s)")'

#swap file location for vim
mkdir -p ~/.vim/swp

alias en='setxkbmap -layout en_US'
alias hun='setxkbmap -layout hu'
alias getTime='date +"[%k:%M:%S"]'

alias tmux="TERM=screen-256color-bce tmux"

short_ps1_threshold=50

PS1_Long="${Cyan}"'$(getTime)'" ${BPurple}\h${NC}${NC}${BRed}${PS1_versionControl}${NC} : ${BGreen}"'$(getShortPath ${short_ps1_threshold})'"${NC}\n${BRed}\$${NC} "
PS1_Short="${BGreen}"'$(getShortPath ${short_ps1_threshold})'"${NC}\n${BRed}\$${NC} "
if [ $(tput cols) -ge ${short_ps1_threshold} ]; then
    export PS1=${PS1_Long}
else
    export PS1=${PS1_Short}
fi

export LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"
export LD_LIBRARY_PATH="/usr/local/lib64:${LD_LIBRARY_PATH}"
export PYTHONPATH="${DOTFILES_REPO}/ycm_extra_conf.jsondb:${PYTHONPATH}"

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -f ~/.bashrc_local ]; then
    . ~/.bashrc_local
fi


export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
eval $(thefuck --alias)

