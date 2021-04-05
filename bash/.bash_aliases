# vim ft=sh
# Colors for coreutils {{{1
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    if [ -r ~/.dircolors ]; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
    #alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
#}}}


# Functions {{{1

## Smart cd
# If argument is - or it exists below, cd into it
# Otherwise, attempt to find it above and cd it
# Requires bd on system and in PATH
# https://github.com/vigneshwaranr/bd
__icd () {
    [ "${1}" == "-" ] && \cd - || {
        [ -d "${1}" ] && \cd "${1}" || . bd -si "${1}"
    }
}

function man()
{
    command man "$1"| col -bx |bat -l man -p
}

function new-note()
{
    $EDITOR "$NOTES/Unsorted/`date +%F` -  $*.md"
}

function new-meeting()
{
    $EDITOR "$NOTES/`date +%F` - $* - Meeting Minutes.md"
}
function new-post()
{
    hugo -s $WEBSITE --editor=$EDITOR new blog/"$*".md
}
#}}}

# some more ls aliases
#alias ll='ls -alF'
#alias la='ls -A'
#alias l='ls -CF'
alias ls="exa"
alias ll="exa -l"
alias la="exa -A"
alias cat="bat -p"

alias h="history"
alias cd=__icd

alias e="$EDITOR"
alias p="$PAGER"
alias f="$FILE"

alias bg-choose='sxiv -o -r wallpapers/Landscapes/|xargs setbg'
alias vifm='vifmrun'

alias purge='sudo pacman -Rcsn'
alias pacman='sudo pacman'

alias nf='fd -e md . $NOTES|fzf --print0|xargs -0 $EDITOR'
alias notes='$EDITOR $NOTES'
alias scratch='$EDITOR $NOTES/Unsorted/`date +%F-%H%M%S` - Scratch.md'

alias inb='task add +in'
alias work='task +work'
alias nn=new-note
alias nm=new-meeting
alias np=new-post
