#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


if test -e ~/shell_aliases
then
	source ~/shell_aliases
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

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
(cat ~/.cache/wal/sequences &)

# To add support for TTYs this line can be optionally added.
source ~/.cache/wal/colors-tty.sh
