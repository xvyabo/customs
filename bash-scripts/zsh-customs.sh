#!/bin/bash

cd /home/xvyabo

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source /home/xvyabo/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> /home/xvyabo/.zshrc

git clone https://github.com/zsh-users/zsh-autosuggestions /home/xvyabo/.zsh/zsh-autosuggestions
echo "source /home/xvyabo/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> /home/xvyabo/.zshrc

echo 'zsh customs done!'
