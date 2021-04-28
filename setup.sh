#!/bin/bash

set -xe

XDG_USER_CONFIG_DIR="$HOME/.config"

echo "Backing up default config files"
if [ -f ~/.bashrc ]; then
    mv ~/.bashrc ~/.bashrc.bak
fi

echo "Backing up standard dotfiles"
mkdir -p $HOME/.local/share/dotfiles
for f in `find bash -type f`; do
	file="`basename $f`"
	if [ -f "$HOME/$file" -a ! -h "$HOME/$file" ]; then
		mv "$HOME/$file" "$HOME/.local/share/dotfiles/$file"
	fi
done

echo "Stowing config files"
# Ideally I would like to use a single stow command for everything
# but due to the following bug I have this work around
# https://github.com/aspiers/stow/issues/33
for file in `find . -name "dot-*" -type f`; do
    echo $file;
    f=`echo $file|sed 's/dot-/~\/./'`;
    if [ -L $f ]; then
        rm $f
    elif [[ -f $f ]]; then
        mv $f $f.bak
    fi
    ln -s $PWD/$file $f;
done

stow -v -R -t "$XDG_USER_CONFIG_DIR" dot-config

echo "Downloading latest NeoVim"
if [ "`id|grep sudo`" == "" ]; then
	mkdir -p ~/.local/usr/bin
	wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -O ~/.local/usr/bin/nvim
	chmod +x ~/.local/usr/bin/nvim
else
	sudo mkdir -p /usr/local/bin
	sudo wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -O /usr/local/bin/nvim
	sudo chmod +x /usr/local/bin/nvim
fi
