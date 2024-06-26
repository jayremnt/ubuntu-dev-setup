#!/usr/bin/env zsh

typeset -a GNOME_SHELL_EXTENSIONS
GNOME_SHELL_EXTENSIONS=(
  blur-my-shell@aunetx
  compiz-alike-magic-lamp-effect@hermes83.github.com
  gnome-ui-tune@itstime.tech
  user-theme@gnome-shell-extensions.gcampax.github.com
)
MACOS_CONFIG_DIR=$HOME/projects/others/ubuntu-to-macos-theme
WHITESUR_THEME_DIR=$MACOS_CONFIG_DIR/WhiteSur-gtk-theme
WHITESUR_WALLPAPERS_DIR=$MACOS_CONFIG_DIR/WhiteSur-wallpapers
WHITESUR_ICON_THEME_DIR=$MACOS_CONFIG_DIR/WhiteSur-icon-theme
SF_PRO_FONTS_DIR=$MACOS_CONFIG_DIR/San-Francisco-Pro-Fonts
SF_MONO_FONT_DIR=$MACOS_CONFIG_DIR/SF-Mono-Font
ROUNDED_WINDOW_CORNERS_DIR=$MACOS_CONFIG_DIR/rounded-window-corners
DOWNLOADS_DIR=$HOME/Downloads

# Download extensions
sudo apt install git gnome-shell-extension-manager

for i in "${GNOME_SHELL_EXTENSIONS[@]}"
do
  busctl --user --timeout=25 call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s ${i} --expect-reply=yes --timeout=25
  gnome-extensions enable ${i}
done

# Install Rounded Window Corners extension
git clone https://github.com/garaevdi/rounded-window-corners.git $ROUNDED_WINDOW_CORNERS_DIR
cd $ROUNDED_WINDOW_CORNERS_DIR
yarn && yarn ext:install

# Install WhiteSur theme
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1 $WHITESUR_THEME_DIR
$WHITESUR_THEME_DIR/install.sh -c Dark -t purple -m -N stable -l --normal --round
sudo $WHITESUR_THEME_DIR/tweaks.sh -g -N

# Install WhiteSur icon theme
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git $WHITESUR_ICON_THEME_DIR
$WHITESUR_ICON_THEME_DIR/install.sh -t purple -b

# Install WhiteSur dynamic wallpaper
git clone https://github.com/vinceliuice/WhiteSur-wallpapers.git $WHITESUR_WALLPAPERS_DIR
sudo $WHITESUR_WALLPAPERS_DIR/install-gnome-backgrounds.sh

# Install MacOS cursor
wget -P $DOWNLOADS_DIR -O $DOWNLOADS_DIR/apple_cursor.tar.gz https://github.com/ful1e5/apple_cursor/releases/download/v2.0.0/macOS-BigSur-White.tar.gz
tar -xvf $DOWNLOADS_DIR/apple_cursor.tar.gz -C $DOWNLOADS_DIR
cp -rf $DOWNLOADS_DIR/macOS-* $HOME/.icons/

# Install SF Pro fonts
git clone https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts.git $SF_PRO_FONTS_DIR
git clone https://github.com/supercomputra/SF-Mono-Font.git $SF_MONO_FONT_DIR
mkdir -p $HOME/.fonts
cp $SF_PRO_FONTS_DIR/SF-Pro-Rounded-Regular.otf $SF_MONO_FONT_DIR/SFMono-Regular.otf $HOME/.fonts

# Play with Tweaks
dconf write /org/gnome/desktop/interface/icon-theme "'WhiteSur-purple'"
dconf write /org/gnome/shell/extensions/user-theme/name "'WhiteSur-Dark-purple'"
dconf write /org/gnome/desktop/interface/gtk-theme "'WhiteSur-Dark-purple'"
dconf write /org/gnome/desktop/background/picture-uri "'file:///usr/share/backgrounds/Monterey/Monterey-timed.xml'"
dconf write /org/gnome/desktop/interface/clock-show-weekday true
dconf write /org/gnome/desktop/interface/clock-show-date true
dconf write /org/gnome/desktop/interface/clock-show-seconds true
dconf write /org/gnome/desktop/wm/preferences/button-layout "'close,minimize,maximize:'"
dconf write /org/gnome/desktop/interface/cursor-theme "'macOS-BigSur-White'"
dconf write /org/gnome/desktop/interface/font-name "'SF Pro Rounded 11'"
dconf write /org/gnome/desktop/interface/document-font-name "'SF Pro Rounded 11'"
dconf write /org/gnome/desktop/interface/monospace-font-name "'SF Mono 13'"
dconf write /org/gnome/desktop/wm/preferences/titlebar-font "'SF Pro Rounded Bold 11'"

# Config Dock
dconf write /org/gnome/shell/extensions/dash-to-dock/show-show-apps-button false
dconf write /org/gnome/shell/favorite-apps "['google-chrome.desktop', 'jetbrains-webstorm.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Settings.desktop']"

# Config terminal
terminal_profiles=$(dconf list /org/gnome/terminal/legacy/profiles:/)
first_profile_id=$(echo $terminal_profiles | awk '{print $1}' | sed 's|/||')
dconf write /org/gnome/terminal/legacy/profiles:/$first_profile_id/use-system-font false
dconf write /org/gnome/terminal/legacy/profiles:/$first_profile_id/font "'SF Mono 12'"
dconf write /org/gnome/terminal/legacy/profiles:/$first_profile_id/default-size-columns 132
dconf write /org/gnome/terminal/legacy/profiles:/$first_profile_id/default-size-rows 43

# reboot
echo "Logout? (y/n)"
read -k1 answer

if [[ $answer == "y" || $answer == "Y" ]]; then
  gnome-session-quit --no-prompt
fi
