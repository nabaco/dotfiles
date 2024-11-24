#!/usr/bin/env bash

# For debug only
#set -x
# Stop on the first failure
set -e

XDG_USER_CONFIG_DIR="$HOME/.config"
mkdir -p "$XDG_USER_CONFIG_DIR"
mkdir -p ~/.local/usr/bin
export PATH="$HOME/.local/usr/bin:$PATH"

# Due to https://github.com/aspiers/stow/issues/33
# I switched to fling
FLING_VERSION="0.0.20"
echo "Checking fling's presence"
if ! which fling > /dev/null || [ "$(fling version)" != "$FLING_VERSION" ]; then
    echo "Fling not found, downloading..."
    FLING_PACKAGE="fling_${FLING_VERSION}_linux_amd64.tar.gz"
    wget https://github.com/bbkane/fling/releases/download/v$FLING_VERSION/$FLING_PACKAGE
    tar -xvzf $FLING_PACKAGE --directory "$HOME"/.local/usr/bin/ fling
    rm $FLING_PACKAGE
else
    if [ "$(fling version)" = "$FLING_VERSION" ]; then
        echo "Fling found and is up-to-date"
    fi
fi

backups=".bashrc .bash_profile .bash_aliases .profile .xprofile .xinitrc"

echo "Backing up standard dotfiles"
mkdir -p "$HOME"/.local/share/dotfiles
for file in $backups; do
    if [ -f "$HOME/$file" ] && [ ! -h "$HOME/$file" ]; then
        mv "$HOME/$file" "$HOME/.local/share/dotfiles/$file"
    fi
done

mkdir -p ~/.config
echo "Begining flinging..."
for dir in $(dir --hide "*.sh"); do
    echo "Flinging $dir"
    fling link --src-dir "$dir" --ask false > /dev/null
done

install_neovim() {
    local NVIM_VERSION=$1
    echo "Downloading NeoVim v$NVIM_VERSION"
    if [ "$(id | grep -E '(sudo|wheel)')" = "" ]; then
        wget https://github.com/neovim/neovim/releases/download/v"${NVIM_VERSION}"/nvim.appimage -O ~/.local/usr/bin/nvim
        chmod +x ~/.local/usr/bin/nvim
    else
        sudo mkdir -p /usr/local/bin
        sudo wget https://github.com/neovim/neovim/releases/download/v"${NVIM_VERSION}"/nvim.appimage -O /usr/local/bin/nvim
        sudo chmod +x /usr/local/bin/nvim
    fi
}

NVIM_VERSION="0.10.2"
if [ -f /usr/bin/nvim ] || [ -f /run/current-system/sw/bin/nvim ]; then
    echo "NeoVim is installed by the package manager - Skipping installation"
elif ! which nvim > /dev/null; then
    install_neovim $NVIM_VERSION
else
    wanted_nvim_sha=$(curl --silent --location https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim.appimage.sha256sum | cut --delimiter=" " --fields=1)
    local_nvim_sha=$(sha256sum "$(which nvim)" | cut --delimiter=" " --fields=1)
    if [ "$wanted_nvim_sha" != "$local_nvim_sha" ]; then
        install_neovim $NVIM_VERSION
    else
        echo "NeoVim was found and is up-to-date"
    fi
fi

# Provision NeoVim
nvim --headless "+Lazy! sync" +qa

TODOIST_CLI_VERSION="0.20.0"
if [ "$(todoist --version | cut -d' ' -f3)" != "$TODOIST_CLI_VERSION" ]; then
    echo "Installing Todoist CLI"
    mkdir -p ~/.local/usr/bin
    wget https://github.com/sachaos/todoist/releases/download/v${TODOIST_CLI_VERSION}/todoist_linux_amd64 -O ~/.local/usr/bin/todoist
    chmod +x ~/.local/usr/bin/todoist
    # Sync cache. If for the first time, it will request API key
    todoist sync
    mkdir -p "$XDG_DATA_HOME"/bash-completion
    wget https://github.com/sachaos/todoist/raw/v${TODOIST_CLI_VERSION}/todoist_functions_fzf_bash.sh -O "$HOME"/.local/usr/bin/todoist_functions_fzf_bash.sh
fi
