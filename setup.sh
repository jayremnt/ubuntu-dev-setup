#!/usr/bin/env zsh

DOWNLOADS_DIR=$HOME/Downloads

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
# Download Google Chrome deb file
wget -N https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P $DOWNLOADS_DIR
sudo apt install -y $DOWNLOADS_DIR/google-chrome-stable_current_amd64.deb

echo "Installing WebStorm..."
wget -N https://download-cdn.jetbrains.com/webstorm/WebStorm-2023.1.tar.gz -P $DOWNLOADS_DIR
# Extract the tarball
if [ -d /opt/WebStorm ]; then
  echo "WebStorm already exists";
else
  sudo mkdir /opt/WebStorm
  sudo tar --checkpoint=.1000 --checkpoint-action=dot -xzf $DOWNLOADS_DIR/WebStorm-2023.1.tar.gz -C /opt/WebStorm
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
wget https://dl.pstmn.io/download/latest/linux_64 -O $DOWNLOADS_DIR/postman-linux-x64.tar.gz
# Extract the tarball
if [ -e /opt/Postman ]; then
  echo "Postman already exists";
else
  sudo tar --checkpoint=.1000 --checkpoint-action=dot -xzf $DOWNLOADS_DIR/postman-linux-x64.tar.gz -C /opt/
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

# Config Dock
gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 28
gsettings set org.gnome.shell favorite-apps "[]"

# Config Home folder shortcut
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"

# Show hidden files
gsettings set org.gtk.gtk4.Settings.FileChooser show-hidden true

# Fast Bluetooth Connection
sudo sed -i 's/#\?FastConnectable *= *false/FastConnectable = true/g' /etc/bluetooth/main.conf

sudo apt autoremove -y
# TODO: https://ubuntuhandbook.org/index.php/2022/04/disable-automatic-airplane-mode-ubuntu/

# reboot
echo "Reboot? (y/n)"
read -k1 answer

if [[ $answer == "y" || $answer == "Y" ]]; then
  reboot
fi
