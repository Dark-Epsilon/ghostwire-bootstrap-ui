#!/bin/bash

# ┌────────────────────────────┐
# │   Ghostwire UI Bootstrap  │
# └────────────────────────────┘

set -e

echo "🌑 Starting Ghostwire OS UI Layer Setup..."

# 1. Ensure base-devel and git are present
sudo pacman -Syu --noconfirm base-devel git curl wget unzip

# 2. Install yay (AUR helper)
if ! command -v yay &>/dev/null; then
  echo "🔧 Installing yay..."
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
fi

# 3. Install Hyprland and core UI tools
echo "🌐 Installing Hyprland and core components..."
yay -S --noconfirm hyprland waybar wofi kitty mako eww \
  swaylock-effects swayidle swww nwg-look xdg-desktop-portal-hyprland \
  starship zsh zsh-autosuggestions zsh-syntax-highlighting \
  noto-fonts noto-fonts-cjk ttf-jetbrains-mono-nerd ttf-font-awesome \
  papirus-icon-theme qt5-wayland qt6-wayland polkit-kde-agent xdg-utils \
  gvfs thunar thunar-archive-plugin file-roller neofetch grim slurp \
  brightnessctl pavucontrol pamixer playerctl blueberry network-manager-applet \
  python-pywal mpv firefox brave-bin bitwarden keepassxc

# 4. Enable greetd autologin setup (for Hyprland)
echo "🛠 Enabling greetd login..."
sudo pacman -S --noconfirm greetd greetd-tuigreet
sudo systemctl enable greetd.service

# 5. Set up zsh + starship
echo "🌟 Configuring shell..."
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
chsh -s /bin/zsh

# 6. Wallpaper
echo "🖼 Setting hacker-den wallpaper..."
mkdir -p ~/Pictures/wallpapers
wget -O ~/Pictures/wallpapers/hacker-den.png https://raw.githubusercontent.com/exodia-os/exodia-wallpapers/main/wallpapers/hacker-den.png

# 7. Theme setup
echo "🎨 Installing Catppuccin themes..."
yay -S --noconfirm catppuccin-gtk-theme-mocha catppuccin-cursors-mocha

# 8. Dotfiles and config
echo "⚙️ Applying config files..."
mkdir -p ~/.config/hypr ~/.config/waybar ~/.config/wofi ~/.config/kitty
echo 'exec-once = waybar & wofi &' > ~/.config/hypr/hyprland.conf
echo '{ "bar": { "modules-left": ["clock"] } }' > ~/.config/waybar/config.jsonc

# 9. Enable necessary services
echo "🚀 Enabling system services..."
sudo systemctl enable NetworkManager.service
sudo systemctl enable bluetooth.service
sudo systemctl enable greetd.service
sudo systemctl enable pipewire.service
sudo systemctl enable pipewire-pulse.service

echo "✅ UI setup complete. Reboot and login to Hyprland!"
