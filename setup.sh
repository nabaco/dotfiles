#!/bin/bash

set -xe

XDG_USER_CONFIG_DIR="$HOME/.config"
stowit="stow -v -R -t"

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
$stowit ~ bash
$stowit ~ zsh
$stowit ~ git
$stowit "$XDG_USER_CONFIG_DIR" config

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
