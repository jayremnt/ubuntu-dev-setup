#!/bin/bash

echo "Installing curl..."
sudo apt install -y curl

echo "Installing ZSH..."
sudo apt install -y zsh
chsh -s $(which zsh)

echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

gnome-session-quit
