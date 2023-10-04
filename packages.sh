#!/bin/bash

# rpm fusion repos
sudo dnf upgrade --refresh 
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# flatpak - flathub repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.spotify.Client com.mattjakeman.ExtensionManager

# dnf packages
sudo dnf install -y fish gnome-tweaks discord steam VirtualBox akmod-nvidia xorg-x11-drv-nvidia
