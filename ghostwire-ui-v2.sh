#!/bin/bash
# ░█▀▀░█░█░█▀▄░█▀▀░█░█░█▀█░█▀█░█▀▀
# ░█▀▀░█░█░█░█░█░█░█░█░█▀█░█▀▀░▀▀█
# ░▀░░░▀▀▀░▀▀░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀
#  ➤ Ghostwire UI Bootstrap

set -e

echo "🔧 Starting Ghostwire OS UI Layer Setup..."

# 1. Ensure base-devel and git are present
sudo pacman -Sy --noconfirm base-devel git curl wget unzip

# 2. Install yay (AUR helper)
if ! command -v yay &>/dev/null; then
  echo "📦 Installing yay..."
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
fi

# 3. Install Hyprland and core UI tools
echo "📦 Installing Hyprland and core components..."
yay -S --noconfirm hyprland waybar wofi kitty mako eww \
  swaylock-effects swayidle swww neovim zoxide xdg-desktop-portal-hyprland \
  starship zsh fastfetch otf-font-awesome ttf-jetbrains-mono-nerd \
  noto-fonts noto-fonts-cjk ttf-ubuntu-font-family polkit-gnome xf86-video-vmware \
  gvfs thunar thunar-archive-plugin file-roller neofetch grim slurp \
  brightnessctl pamixer playerctl blueberry network-manager-applet \
  python-pywal firefox brave-bin bitwarden keepassxc

# 4. Enable greeter display manager (greetd + tuigreet)
echo "🧩 Enabling greetd with tuigreet (for Hyprland)"
sudo pacman -S --noconfirm greetd greetd-tuigreet
sudo systemctl enable greetd.service

# 5. Set up zsh + starship
echo "🧠 Setting up Starship shell..."
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
chsh -s /bin/zsh

# 6. Wallpaper
echo "🖼️  Setting hacker-den wallpaper..."
mkdir -p ~/Pictures/Wallpapers
wget -P ~/Pictures/Wallpapers https://raw.githubusercontent.com/Dark-Epsilon/ghostwire-bootstrap-ui/main/assets/hacker-den.png

# 7. Theme setup
echo "🎨 Installing Catppuccin themes..."
yay -S --noconfirm catppuccin-gtk-theme-mocha catppuccin-cursors-mocha

# 8. Dotfiles and config
echo "⚙️  Setting up config files..."
mkdir -p ~/.config/hypr ~/.config/waybar ~/.config/wofi ~/.config/kitty
echo '{ "layer": "top", "modules-left": ["clock"] }' > ~/.config/waybar/config.jsonc

# 9. Enable necessary services
sudo systemctl enable NetworkManager.service
sudo systemctl enable bluetooth.service
sudo systemctl enable greetd.service
sudo systemctl enable pipewire.service
sudo systemctl enable pipewire-pulse.service

echo "✅ UI setup complete. Reboot and login to Hyprland!"
