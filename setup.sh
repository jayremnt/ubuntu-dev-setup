#!/bin/bash

# Install some CLIs

# Install curl
sudo apt install -y curl

# Install Git
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt update
sudo apt install -y git
# Git config
git config --global user.name "Jayremnt"
git config --global user.email "jayremnt@gmail.com"

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"  # This loads nvm
source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# shellcheck disable=SC1090
source ~/.bashrc

# Install NPM and Yarn
nvm install 16
nvm use 16
npm i yarn -g

# Install Software

# Install Google Chrome
echo "Installing Google Chrome..."
sudo apt update -y
if [ -e $HOME/Downloads/google-chrome-stable_current_amd64.deb ]; then
  echo "Google Chrome deb file already exists. Installing..."
else
  # Download Google Chrome deb file
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P $HOME/Downloads/
fi
sudo apt install -y $HOME/Downloads/google-chrome-stable_current_amd64.deb

# Install Jetbrains Toolbox
echo "Installing Jetbrains Toolbox"
if [ -e $HOME/Downloads/jetbrains-toolbox-1.27.3.14493.tar.gz ]; then
  echo "Jetbrains Toolbox file already exists. Installing...";
else 
  wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.27.3.14493.tar.gz -P $HOME/Downloads/
fi
# Extract the tarball
sudo tar xvf $HOME/Downloads/jetbrains-toolbox-*.tar.gz -C /opt/
sudo chmod +x /opt/jetbrains-toolbox-*/jetbrains-toolbox
/opt/jetbrains-toolbox-*/jetbrains-toolbox

# Install Spotify
echo "Installing Spotify"
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install -y spotify-client

# Install Tweaks
sudo apt install gnome-tweaks

# Install Ibus Bamboo
sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo -y
sudo apt-get update
sudo apt-get install -y ibus-bamboo
ibus restart

# TODO: https://dev.to/duhoang/ubuntu-create-postman-shortcut-31jp

# Config UI

# Center applications
gsettings set org.gnome.mutter center-new-windows true

# Config Dash to Dock
gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 28
gsettings set org.gnome.shell favorite-apps "[]"

# Other configs

# Fast Bluetooth Connection
sudo sed -i 's/#\?FastConnectable *= *false/FastConnectable = true/g' /etc/bluetooth/main.conf

# Generate SSH key
ssh-keygen -t ed25519 -C "jayremnt@gmail.com"
eval "$(ssh-agent -s)"
cat ~/.ssh/id_ed25519.pub

# TODO: https://ubuntuhandbook.org/index.php/2022/04/disable-automatic-airplane-mode-ubuntu/
sudo apt autoremove -y

