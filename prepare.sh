#!/bin/bash

echo "Installing curl..."
sudo apt install -y curl

echo "Installing Git..."
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt update
sudo apt install -y git
# Git config
git config --global user.name "Jayremnt"
git config --global user.email "jayremnt@gmail.com"
# Generate SSH key
ssh-keygen -q -t ed25519 <<< $'\ny' >/dev/null 2>&1
eval "$(ssh-agent -s)"
cat ~/.ssh/id_ed25519.pub

echo "Installing ZSH..."
sudo apt install -y zsh
chsh -s $(which zsh)

echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
