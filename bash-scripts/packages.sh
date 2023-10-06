#!/bin/bash

# rpm fusion repos
sudo dnf upgrade --refresh 
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# github repo
sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo

# flatpak - flathub repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.mattjakeman.ExtensionManager org.videolan.VLC com.simplenote.Simplenote

# dnf packages
sudo dnf install -y zsh gnome-tweaks steam VirtualBox akmod-nvidia xorg-x11-drv-nvidia gh dconf-editor

# nordvpn install
sh <(wget -qO - https://downloads.nordcdn.com/apps/linux/install.sh) && fish
