#!/bin/sh

# export mirrors env
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_INSTALL_FROM_API=1

/bin/bash -c "$(curl -fsSL https://github.com/Homebrew/install/raw/master/install.sh)"

# install nix
sh <(curl https://mirrors.tuna.tsinghua.edu.cn/nix/latest/install) --daemon

# copy /etc/nix/nix.conf
cat <<EOL >/etc/nix/nix.conf
substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org/
experimental-features = nix-command flakes
trusted-users = root $(whoami)
build-users-group = nixbld
EOL

# relaunch daemon
sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist

# install home-manager
script_dir=$(dirname "$0")

nix run home-manager/master -- init --switch
rm -rf ~/.config/home-manager
ln -s $script_dir $HOME/.config/home-manager
home-manager switch

