#!/bin/bash

# dnf aliases
sudo echo 'alias dnf="sudo dnf"' | cat >> /etc/fish/config.fish
sudo echo 'alias dsr="dnf search"' | cat >> /etc/fish/config.fish
sudo echo 'alias din="dnf install"' | cat >> /etc/fish/config.fish
sudo echo 'alias dup="dnf upgrade --refresh"' | cat >> /etc/fish/config.fish
sudo echo 'alias drm="dnf remove"' | cat >> /etc/fish/config.fish
sudo echo 'alias dar="dnf autoremove"' | cat >> /etc/fish/config.fish
sudo echo 'alias dli="dnf list installed"' | cat >> /etc/fish/config.fish
sudo echo 'alias dcc="dnf clean dbcache"' | cat >> /etc/fish/config.fish

# flatpak aliases
sudo echo 'alias flatin="flatpak install"' | cat >> /etc/fish/config.fish
sudo echo 'alias flatrm="flatpak remove"' | cat >> /etc/fish/config.fish
sudo echo 'alias flatli="flatpak list"' | cat >> /etc/fish/config.fish
sudo echo 'alias flatsr="flatpak search"' | cat >> /etc/fish/config.fish
