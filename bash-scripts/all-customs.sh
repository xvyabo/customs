#!/bin/bash

cd /home/xvyabo/gnome-fedora-customs/bash-scripts

# dnf optimization
./dnf-optimization.sh
cd /home/xvyabo/gnome-fedora-customs/bash-scripts

# openrazer
./openrazer.sh
cd /home/xvyabo/gnome-fedora-customs/bash-scripts

# custom theming
./theming.sh
cd /home/xvyabo/gnome-fedora-customs/bash-scripts

# rpm fusion repos
./packages.sh
cd /home/xvyabo/gnome-fedora-customs/bash-scripts

# zsh aliases
./zsh-aliases.sh
cd /home/xvyabo/gnome-fedora-customs/bash-scripts

# zsh customs
./zsh-customs.sh
cd /home/xvyabo/gnome-fedora-customs/bash-scripts

# gnome extensions
./gnome-extensions.sh
cd /home/xvyabo/gnome-fedora-customs/bash-scripts

# nano config file
sudo ./nanorc.sh
cd /home/xvyabo/gnome-fedora-customs/bash-scripts

echo 'all customs done!!'
