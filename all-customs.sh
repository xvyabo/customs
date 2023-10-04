#!/bin/bash

# dnf optimization
sudo echo "max_parallel_downloads=10" | sudo cat >> /etc/dnf/dnf.conf
sudo echo "fastestmirror=True" | sudo cat >> /etc/dnf/dnf.conf

# custom theming
cd 'gnome setup'
sudo tar -xf adw-gtk3v4-9.tar.xz -C /usr/share/themes
sudo tar -xf capitaine-cursors-r4.tar.gz -C /usr/share/icons
sudo unzip kora-1-6-1.zip -d /usr/share/icons

# rpm fusion repos
sudo dnf upgrade --refresh 
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# flatpak - flathub repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.spotify.Client com.mattjakeman.ExtensionManager

# dnf packages
sudo dnf install -y fish gnome-tweaks discord steam VirtualBox akmod-nvidia xorg-x11-drv-nvidia

