#!/bin/bash

XDG_USER_CONFIG_DIR="$HOME/.config"
stowit="stow -v -R -t"

$stowit ~ bash
$stowit ~ zsh
$stowit ~ git
$stowit "$XDG_USER_CONFIG_DIR" config
