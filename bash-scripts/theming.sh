#!/bin/bash

cd '../gnome setup'

# custom theming
sudo tar -xf adw-gtk3v4-9.tar.xz -C /usr/share/themes
sudo tar -xf capitaine-cursors-r4.tar.gz -C /usr/share/icons
sudo unzip kora-1-6-1.zip -d /usr/share/icons

echo 'theming done!'
