#!/bin/bash

sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/hardware:razer/Fedora_Rawhide/hardware:razer.repo
sudo dnf install openrazer-meta
sudo gpasswd -a xvyabo plugdev
