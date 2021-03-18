#!/bin/bash

XDG_USER_CONFIG_DIR="$HOME/.config"
stowit="stow -v -R -t"

echo "Backing up default config files"
if [ -f ~/.bashrc ]; then
    mv ~/.bashrc ~/.bashrc.bak
fi

echo "Stowing config files"
$stowit ~ bash
$stowit ~ zsh
$stowit ~ git
$stowit "$XDG_USER_CONFIG_DIR" config

echo "Downloading latest NeoVim"
mkdir -p ~/.local/usr/bin
wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage ~/.local/usr/bin/nvim
chmod +x ~/.local/usr/bin/nvim
