#
# ~/.bash_profile
#

[[ -f ~/.profile ]] && . ~/.profile
[[ -f ~/.bashrc ]] && . ~/.bashrc

[[ $(tty) == "/dev/tty1" ]] && startx

# export PAGER=more
# export EDITOR=nvim
# export TERM=rxvt-unicode-256color
