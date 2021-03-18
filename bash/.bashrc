# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
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
[[ $DISPLAY ]] && shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

PS1='[\u@\h \W]\$ '

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    *-termite|xterm-color|*-256color) color_prompt=yes;;
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
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

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

#### End of standard Ubuntu .bashrc ####

# Integrate FZF
if [ -f ~/.fzf.bash ]; then
    source ~/.fzf.bash
else
    [ -f ~/.local/bin/fzf/shell/completion.bash ] && source ~/.local/bin/fzf/shell/completion.bash
    [ -f ~/.local/bin/fzf/shell/key-bindings.bash ] && source ~/.local/bin/fzf/shell/key-bindings.bash
fi

[ -f  /usr/share/autojump/autojump.sh ] && source /usr/share/autojump/autojump.sh

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
if [ -f ~/.cache/wal/sequences ]; then
    (cat ~/.cache/wal/sequences &)
    # To add support for TTYs this line can be optionally added.
    source ~/.cache/wal/colors-tty.sh
fi

# Ruby exports

export GEM_HOME=$HOME/gems
export PATH=$HOME/gems/bin:$PATH

WSL=`grep microsoft /proc/version`
if [ -n "$WSL" ]; then
    export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
    export NOTES=/mnt/c/Users/nbarcohx/Nextcloud-BC/Notes/
else
    export NOTES=$HOME/Nextcloud/Notes/
fi
export LIBGL_ALWAYS_INDIRECT=1

# enable tab-copletetion for git commands
if [ -f ~/.local/bin/git-completion.bash ]; then
    source ~/.local/bin/git-completion.bash
fi

if [ -f ~/.local/bin/appari.sh ]; then
    source ~/.local/bin/appari.sh
fi

if [ -f ~/shell_aliases ]; then
	source ~/shell_aliases
fi

# Source user/host specific bashrc
if [ -f ~/.bashrc.$USER ]; then
    source ~/.bashrc.$USER
fi

if [ -f ~/.local/usr/share/bash-completion/completions/task ]; then
    source ~/.local/usr/share/bash-completion/completions/task
fi

if [ -e ~/.config/broot/launcher/bash/br ]; then
    source /home/nbarcohx/.config/broot/launcher/bash/br
fi

TICK="✓"
CROSS="✗"

URGENT="❗"
OVERDUE="☠️"
DUETODAY="😱"
DUETOMORROW="📅"

# Ansi color code variables
red="\[\e[0;91m\]"
blue="\[\e[0;94m\]"
green="\[\e[0;92m\]"
yellow="\[\e[0;33m\]"
purple=" \[\e[0;35m\]"
white="\[\e[0;97m\]"
expand_bg="\[\e[K\]"
blue_bg="\[\e[0;104m\]${expand_bg}"
red_bg="\[\e[0;101m\]${expand_bg}"
green_bg="\[\e[0;102m\]${expand_bg}"
bold="\[\e[1m\]"
uline="\[\e[4m\]"
reset="\[\e[0m\]"

function task_indicator {
    ti=""
    unset overdue
    unset today
    unset tomorrow
    unset inbox
    unset urgent
    overdue=`task +READY +OVERDUE count`
    today=`task +READY +TODAY count`
    tomorrow=`task +READY +TOMORROW count`
    inbox=`task +in +PENDING count`
    urgent=`task +READY urgency\>10 count`
    if [ "$inbox" -gt "0" ]; then
        ti+="${blue}I:$inbox${reset}|"
    fi
    if [ "$tomorrow" -gt "0" ]; then
        ti+="${green}T:$tomorrow${reset}|"
    fi
    if [ "$today" -gt "0" ]; then
        ti+="${yellow}D:$today${reset}|"
    fi
    if [ "$urgent" -gt "0" ]; then
        ti+="${purple}U:$urgent${reset}|"
    fi
    if [ "$overdue" -gt "0" ]; then
        ti+="${red}O:$overdue${reset}|"
    fi
    echo "$ti"
}

