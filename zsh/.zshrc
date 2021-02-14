# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh/histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob nomatch notify
#bindkey -v
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/nachum/.zshrc'

fpath=(/usr/share/zsh/site-functions/ $fpath)
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
    source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
#    bindkey "$terminfo[kcuu1]" history-substring-search-up
#    bindkey "$terminfo[kcud1]" history-substring-search-down
    bindkey "^[[A" history-substring-search-up
    bindkey "^[[B" history-substring-search-down
fi

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

autoload -Uz compinit
compinit
# End of lines added by compinstall

if [ -d ~/.cache/wal/ ]
then
    # Import colorscheme from 'wal' asynchronously
    # &   # Run the process in the background.
    # ( ) # Hide shell job control messages.
    (cat ~/.cache/wal/sequences &)

    # To add support for TTYs this line can be optionally added.
    source ~/.cache/wal/colors-tty.sh
fi

python_version=$(python --version|sed 's/Python \(3.[0-9]*\).[0-9]*/python\1/')
if [ -f /usr/share/powerline/bindings/zsh/powerline.zsh ]; then
	source /usr/share/powerline/bindings/zsh/powerline.zsh
elif [ -f /lib/$python_version/site-packages/powerline/bindings/zsh/powerline.zsh ]; then
	source /lib/$python_version/site-packages/powerline/bindings/zsh/powerline.zsh
fi


if [ -d /usr/share/fzf ]; then
    source /usr/share/fzf/*.zsh
elif [ -d ~/.local/share/nvim/bundle/fzf/shell/ ]; then
    source ~/.local/share/nvim/bundle/fzf/shell/*.zsh
fi


if test -e ~/shell_aliases
then
	source ~/shell_aliases
fi
