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

# github repo
sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo

# flatpak - flathub repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.mattjakeman.ExtensionManager org.videolan.VLC com.simplenote.Simplenote

# dnf packages
sudo dnf install -y zsh gnome-tweaks steam VirtualBox akmod-nvidia xorg-x11-drv-nvidia gh

# nordvpn install
sh <(wget -qO - https://downloads.nordcdn.com/apps/linux/install.sh)

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

# zsh customs
cd /home/xvyabo

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
