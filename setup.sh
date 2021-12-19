#!/bin/bash

set -xe

XDG_USER_CONFIG_DIR="$HOME/.config"

# Due to https://github.com/aspiers/stow/issues/33
# I switched to fling
echo "Downloading fling"
FLING_VERSION="0.0.8"
FLING_PACKAGE="fling_${FLING_VERSION}_linux_amd64.tar.gz"
wget https://github.com/bbkane/fling/releases/download/v$FLING_VERSION/$FLING_PACKAGE
tar -xvzf $FLING_PACKAGE --directory $HOME/.local/bin/ fling
rm $FLING_PACKAGE

echo "Backing up standard dotfiles"
mkdir -p $HOME/.local/share/dotfiles
for f in `find bash -type f`; do
	file="`basename $f`"
	if [ -f "$HOME/$file" -a ! -L "$HOME/$file" ]; then
		mv "$HOME/$file" "$HOME/.local/share/dotfiles/$file"
	fi
done

echo "Begining flinging..."
for dir in `find * -maxdepth 0 -type d -not -name "*."`; do
	echo "Flinging $dir"
	fling link --src-dir $dir --ask false
done

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
