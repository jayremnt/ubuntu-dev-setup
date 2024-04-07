#!/usr/bin/env zsh

typeset -a GNOME_SHELL_EXTENSIONS
GNOME_SHELL_EXTENSIONS=(
  blur-my-shell@aunetx
  compiz-alike-magic-lamp-effect@hermes83.github.com
  gnome-ui-tune@itstime.tech
  user-theme@gnome-shell-extensions.gcampax.github.com
)
WHITESUR_CONFIG_DIR=$HOME/projects1/others/whitesur
WHITESUR_THEME_DIR=$WHITESUR_CONFIG_DIR/WhiteSur-gtk-theme
WHITESUR_WALLPAPERS_DIR=$WHITESUR_CONFIG_DIR/WhiteSur-wallpapers
WHITESUR_ICON_THEME=$WHITESUR_CONFIG_DIR/WhiteSur-icon-theme
DOWNLOADS_DIR=$HOME/Downloads/

# Download extensions
sudo apt install git gnome-shell-extension-manager

for i in "${GNOME_SHELL_EXTENSIONS[@]}"
do
  busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s ${i}
  gnome-extensions enable ${i}
done

# Set WhiteSur theme
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1 $WHITESUR_THEME_DIR
$WHITESUR_THEME_DIR/install.sh -c Dark -t purple -i ubuntu -m -N stable -l --normal --round -c Light
sudo $WHITESUR_THEME_DIR/tweaks.sh -g -N

# Set WhiteSur icon theme
git clone git@github.com:vinceliuice/WhiteSur-icon-theme.git $WHITESUR_ICON_THEME
$WHITESUR_ICON_THEME/install.sh

# Set WhiteSur dynamic wallpaper
git clone git@github.com:vinceliuice/WhiteSur-wallpapers.git $WHITESUR_WALLPAPERS_DIR
sudo $WHITESUR_WALLPAPERS_DIR/install-gnome-backgrounds.sh

# Set MacOS cursor
wget -P $DOWNLOADS_DIR -O $DOWNLOADS_DIR/apple_cursor.tar.gz https://github.com/ful1e5/apple_cursor/releases/download/v2.0.0/macOS-BigSur-White.tar.gz
tar -xvf $DOWNLOADS_DIR/apple_cursor.tar.gz -C $DOWNLOADS_DIR
mv $DOWNLOADS_DIR/macOS-* ~/.icons/

# Config Tweaks
dconf write /org/gnome/desktop/interface/icon-theme "'WhiteSur'"
dconf write /org/gnome/shell/extensions/user-theme/name "'WhiteSur-Dark-solid-purple'"
dconf write /org/gnome/desktop/interface/gtk-theme "'WhiteSur-Dark-purple'"
dconf write /org/gnome/desktop/background/picture-uri "'file:///usr/share/backgrounds/Monterey/Monterey-timed.xml'"
dconf write /org/gnome/desktop/interface/clock-show-weekday true
dconf write /org/gnome/desktop/interface/clock-show-date true
dconf write /org/gnome/desktop/interface/clock-show-seconds true
dconf write /org/gnome/desktop/wm/preferences/button-layout "'close,minimize,maximize:'"
dconf write /org/gnome/desktop/interface/cursor-theme "'macOS-BigSur-White'"
