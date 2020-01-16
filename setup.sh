#!/bin/bash

XDG_USER_CONFIG_DIR="$HOME/.config"
stowit="stow -v -R -t"
stowit_d="stow -v -t"

$stowit ~ bash
$stowit ~ git
$stowit_d "$XDG_USER_CONFIG_DIR" config
