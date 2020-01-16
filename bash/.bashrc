#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


if test -e ~/alias.sh
then
	source ~/alias.sh
fi

PS1='[\u@\h \W]\$ '

# Integrate FZF
if test -e /usr/share/fzf/key-bindings.bash
then
	source /usr/share/fzf/key-bindings.bash
fi

if test -e /usr/share/fzf/completion.bash
then
	source /usr/share/fzf/completion.bash
fi
