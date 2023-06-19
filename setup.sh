#!/bin/bash

# Install some CLIs
echo "Installing CLIs..."

# Install curl
echo "Installing curl..."
sudo apt install -y curl

# Install Git
echo "Installing Git..."
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt update
sudo apt install -y git
# Git config
git config --global user.name "Jayremnt"
git config --global user.email "jayremnt@gmail.com"
# Generate SSH key
# TODO: execute ssh-keygen without prompt
ssh-keygen -t ed25519 -C "jayremnt@gmail.com"
eval "$(ssh-agent -s)"
cat ~/.ssh/id_ed25519.pub

# Install NVM
echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"  # This loads nvm
source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# shellcheck disable=SC1090
source ~/.bashrc

# Install NPM and Yarn
echo "Installing NPM and Yarn..."
nvm install 16
nvm use 16
npm i yarn -g

# Install Software
echo "Installing software..."

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

# Install Webstorm
echo "Installing Webstorm..."
if [ -e $HOME/Downloads/WebStorm-2023.1.tar.gz ]; then
  echo "Webstorm file already exists. Installing...";
else 
  wget https://download-cdn.jetbrains.com/webstorm/WebStorm-2023.1.tar.gz -P $HOME/Downloads/
fi
# Extract the tarball
if find /opt -name 'WebStorm-*' -print -quit | grep -q .; then
  echo "Webstorm already exists";
else
  sudo tar --checkpoint=.1000 --checkpoint-action=dot -xzf $HOME/Downloads/WebStorm-2023.1.tar.gz -C /opt/
fi
sudo chmod +x /opt/WebStorm-*/bin/webstorm.sh
gnome-terminal -- bash -c "/opt/WebStorm-*/bin/webstorm.sh"
# TODO: create desktop entry

# Install Spotify
echo "Installing Spotify..."
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install -y spotify-client

# Install Discord
echo "Installing Discord..."
sudo apt update && sudo apt upgrade -y
sudo snap install discord

# Install Postman
echo "Installing Postman..."
if [ -e $HOME/Downloads/postman-linux-x64.tar.gz ]; then
  echo "Postman file already exists. Installing...";
else
  wget https://dl.pstmn.io/download/latest/linux_64 -O $HOME/Downloads/postman-linux-x64.tar.gz
fi
# Extract the tarball
if [ -e /opt/Postman ]; then
  echo "Postman already exists";
else
  sudo tar --checkpoint=.1000 --checkpoint-action=dot -xzf $HOME/Downloads/postman-linux-x64.tar.gz -C /opt/
fi
# Create a desktop entry
echo "Creating desktop entry..."
if [ -e ~/.local/share/applications/postman.desktop ]; then
  echo "Postman desktop entry already exists."
else
  # Create desktop entry
  cat > ~/.local/share/applications/postman.desktop << EOL
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=/opt/Postman/Postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Path=/opt/Postman
Terminal=false
Type=Application
Categories=Development;
EOL

  echo "Postman desktop entry created."
fi

# Install TeamViewer
echo "Installing TeamViewer..."
if [ -e $HOME/Downloads/teamviewer_amd64.deb ]; then
  echo "TeamViewer deb file already exists. Installing...";
else
  wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb -P $HOME/Downloads/
fi
sudo apt install -y $HOME/Downloads/teamviewer_amd64.deb

# Install Tweaks
echo "Installing Tweaks..."
sudo apt install gnome-tweaks

# Install Ibus Bamboo
echo "Installing Ibus Bamboo..."
sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo -y
sudo apt-get update
sudo apt-get install -y ibus ibus-bamboo --install-recommends
ibus restart
# Set default
env DCONF_PROFILE=ibus dconf write /desktop/ibus/general/preload-engines "['BambooUs', 'Bamboo']" && gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"

# Config Ubuntu
echo "Configuring Ubuntu..."

# Remove Home folder from desktop
gsettings set org.gnome.shell.extensions.ding show-home false

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

# Fast Bluetooth Connection
sudo sed -i 's/#\?FastConnectable *= *false/FastConnectable = true/g' /etc/bluetooth/main.conf

sudo apt autoremove -y
# TODO: https://ubuntuhandbook.org/index.php/2022/04/disable-automatic-airplane-mode-ubuntu/

# reboot
echo "Reboot the system? (y/n)"
read answer

if [[ $answer == "y" || $answer == "Y" ]]; then
    echo "Rebooting the system..."
    sudo reboot
else
    echo "No reboot will be performed."
fi
