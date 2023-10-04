#!/bin/bash

sudo echo "max_parallel_downloads=10" | sudo cat >> /etc/dnf/dnf.conf
sudo echo "fastestmirror=True" | sudo cat >> /etc/dnf/dnf.conf
