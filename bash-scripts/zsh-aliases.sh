#!/bin/bash

# dnf aliases
sudo echo '' | cat >> /home/xvyabo/.zshrc
sudo echo '# dnf aliases' | cat >> /home/xvyabo/.zshrc
sudo echo 'alias dnf="sudo dnf"' | cat >> /home/xvyabo/.zshrc
sudo echo 'alias dsr="dnf search"' | cat >> /home/xvyabo/.zshrc
sudo echo 'alias din="dnf install"' | cat >> /home/xvyabo/.zshrc
sudo echo 'alias dup="dnf upgrade --refresh"' | cat >> /home/xvyabo/.zshrc
sudo echo 'alias drm="dnf remove"' | cat >> /home/xvyabo/.zshrc
sudo echo 'alias dar="dnf autoremove"' | cat >> /home/xvyabo/.zshrc
sudo echo 'alias dli="dnf list installed"' | cat >> /home/xvyabo/.zshrc
sudo echo 'alias dcc="dnf clean dbcache"' | cat >> /home/xvyabo/.zshrc
sudo echo 'alias drl="dnf repolist"' | cat >> /home/xvyabo/.zshrc

# flatpak aliases
sudo echo '' | cat >> /home/xvyabo/.zshrc
sudo echo '# flatpak aliases' | cat >> /home/xvyabo/.zshrc
sudo echo 'alias flatin="flatpak install"' | cat >> /home/xvyabo/.zshrc
sudo echo 'alias flatrm="flatpak uninstall"' | cat >> /home/xvyabo/.zshrc
sudo echo 'alias flatli="flatpak list"' | cat >> /home/xvyabo/.zshrc
sudo echo 'alias flatsr="flatpak search"' | cat >> /home/xvyabo/.zshrc
sudo echo 'alias flatup="flatpak update"' | cat >> /home/xvyabo/.zshrc
echo 'done!'
