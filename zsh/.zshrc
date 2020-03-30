# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh/histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob nomatch notify
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/nachum/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
(cat ~/.cache/wal/sequences &)

# To add support for TTYs this line can be optionally added.
source ~/.cache/wal/colors-tty.sh

if [[ -r /lib/python3.8/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
	source /lib/python3.8/site-packages/powerline/bindings/zsh/powerline.zsh
fi

if test -e ~/shell_aliases
then
	source ~/shell_aliases
fi
