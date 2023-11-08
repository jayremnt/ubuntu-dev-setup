#!/usr/bin/env zsh

echo "Setting up terminal..."
echo "Installing plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k

echo "Syncing dotfiles..."
sudo cp dotfiles/.zshrc ~/.zshrc
sudo cp dotfiles/.p10k.zsh ~/.p10k.zsh

echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
source ~/.zshrc

echo "Installing NPM and Yarn..."
nvm install 16
nvm use 16
npm i yarn -g

echo "Installing GitHub CLI..."
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

echo "Installing Docker..."
curl -fsSL https://get.docker.com | bash
sudo groupadd docker
sudo usermod -aG docker $USER

echo "Installing software..."

echo "Installing Google Chrome..."
sudo apt update -y
if [ -e $HOME/Downloads/google-chrome-stable_current_amd64.deb ]; then
  echo "Google Chrome deb file already exists. Installing..."
else
  # Download Google Chrome deb file
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P $HOME/Downloads/
fi
sudo apt install -y $HOME/Downloads/google-chrome-stable_current_amd64.deb

echo "Installing WebStorm..."
if [ -e $HOME/Downloads/WebStorm-2023.1.tar.gz ]; then
  echo "WebStorm file already exists. Installing...";
else
  wget https://download-cdn.jetbrains.com/webstorm/WebStorm-2023.1.tar.gz -P $HOME/Downloads/
fi
# Extract the tarball
if [ -d /opt/WebStorm ]; then
  echo "WebStorm already exists";
else
  sudo mkdir /opt/WebStorm
  sudo tar --checkpoint=.1000 --checkpoint-action=dot -xzf $HOME/Downloads/WebStorm-2023.1.tar.gz -C /opt/WebStorm
fi
sudo chown -R $USER:$USER /opt/WebStorm
sudo chmod +x /opt/WebStorm/WebStorm-*/bin/webstorm.sh
gnome-terminal -- bash -c "/opt/WebStorm/WebStorm-*/bin/webstorm.sh"
# TODO: create desktop entry

echo "Installing Spotify..."
sudo snap install spotify

echo "Installing Discord..."
sudo apt update && sudo apt upgrade -y
sudo snap install discord

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

echo "Installing Tweaks..."
sudo apt install gnome-tweaks

echo "Installing Ibus Bamboo..."
sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo -y
sudo apt-get update
sudo apt-get install -y ibus ibus-bamboo --install-recommends
ibus restart
# Set default
env DCONF_PROFILE=ibus dconf write /desktop/ibus/general/preload-engines "['BambooUs', 'Bamboo']" && gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"

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
