#!/usr/bin/env sh

[ -f "$HOME/.xprofile" ] && . ~/.xprofile

# Start the Desktop Environment
#exec i3 -V >> ~/.i3/i3log 2>&1
exec bspwm >> ~/.logs/bspwm.log 2>&1
