#!/bin/bash

# For debug only
#set -x
# Stop on the first failure
set -e

XDG_USER_CONFIG_DIR="$HOME/.config"

# Due to https://github.com/aspiers/stow/issues/33
# I switched to fling
FLING_VERSION="0.0.9"
echo "Checking fling's presence"
if ! which fling > /dev/null || [ `fling version` != "$FLING_VERSION" ]; then
    echo "Fling not found, downloading..."
    FLING_PACKAGE="fling_${FLING_VERSION}_linux_amd64.tar.gz"
    wget https://github.com/bbkane/fling/releases/download/v$FLING_VERSION/$FLING_PACKAGE
    tar -xvzf $FLING_PACKAGE --directory $HOME/.local/bin/ fling
    rm $FLING_PACKAGE
else
    if [ `fling version` = "$FLING_VERSION" ]; then
        echo "Fling found and is up-to-date"
    fi
fi

backups=".bashrc .bash_profile .bash_aliases .profile .xprofile .xinitrc"

echo "Backing up standard dotfiles"
mkdir -p $HOME/.local/share/dotfiles
for file in $backups; do
    if [ -f "$HOME/$file" -a ! -h "$HOME/$file" ]; then
        mv "$HOME/$file" "$HOME/.local/share/dotfiles/$file"
    fi
done

echo "Creating local taskrc"
echo "include task-common-rc" > task/dot-config/task/taskrc
read -p "Enter config hash: " HASH
if [ "$HASH" = "" ]; then
    echo "Got empty hash - skipping"
else
    WINGTASK_ZIP="/tmp/$USER-wingtask-config-$$.zip"
    curl https://app.wingtask.com/api/configs/$HASH --output $WINGTASK_ZIP
    unzip $WINGTASK_ZIP -d /tmp
    mv /tmp/wingtask_configuration/wingtask_certs ~/.wingtask_certs
    grep taskd /tmp/wingtask_configuration/taskrc >> task/dot-config/task/taskrc
    rm -rf /tmp/wingtask_configuration
    rm $WINGTASK_ZIP
fi

echo "Begining flinging..."
for dir in `find * -maxdepth 0 -type d -not -name "*."`; do
    echo "Flinging $dir"
    fling link --src-dir $dir --ask false > /dev/null
done

install_neovim() {
    local NVIM_VERSION=$1
    echo "Downloading NeoVim v$NVIM_VERSION"
    if [ "`id|egrep '(sudo|wheel)'`" = "" ]; then
        mkdir -p ~/.local/usr/bin
        wget https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim.appimage -O ~/.local/usr/bin/nvim
        chmod +x ~/.local/usr/bin/nvim
    else
        sudo mkdir -p /usr/local/bin
        sudo wget https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim.appimage -O /usr/local/bin/nvim
        sudo chmod +x /usr/local/bin/nvim
    fi
}


NVIM_VERSION="0.6.1"
if [ -f /usr/bin/nvim ]; then
    echo "NeoVim is installed by the package manager - Skipping installation"
elif ! which nvim > /dev/null; then
    install_neovim $NVIM_VERSION
else
    wanted_nvim_sha=`curl --silent --location https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim.appimage.sha256sum|cut --delimiter=" " --fields=1`
    local_nvim_sha=`sha256sum $(which nvim)|cut --delimiter=" " --fields=1`
    if [ "$wanted_nvim_sha" != "$local_nvim_sha" ]; then
        install_neovim $NVIM_VERSION
    else
        echo "NeoVim was found and is up-to-date"
    fi
fi
