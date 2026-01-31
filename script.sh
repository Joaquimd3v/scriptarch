#!/usr/bin/env bash
set -e

echo "📦 Instalando dependências dos dotfiles (pacman + AUR)"
echo "------------------------------------------------------"

# Lista completa de pacotes (README)
PACKAGES=(
  hyprland
  hypridle
  hyprlock
  hyprshade
  hyprland-plugins
  xdg-utils
  xdg-desktop-portal-hyprland
  xdg-desktop-portal-kde
  xdg-desktop-portal-gtk
  polkit-gnome
  sddm
  networkmanager
  bluez
  blueman
  lua
  mako
  swww
  waypaper
  rofi
  kitty
  firefox
  colorreload-gtk-module
  everforest-gtk-theme
  qt6ct
  kvantum
  papirus-icon-theme
  ttf-manrope
  ttf-nerd-fonts-symbols
  inter-font
  grim
  slurp
  swappy
  grimblast
  pamixer
  pipewire-pulse
  playerctl
  brightnessctl
  quickshell
  vdirsyncer
  khal
  evercal
  curl
  jq
  flutter
  dart
  auto-cpufreq
)

PACMAN_PKGS=()
AUR_PKGS=()

echo "🔎 Checando disponibilidade no pacman..."

for pkg in "${PACKAGES[@]}"; do
  if pacman -Si "$pkg" &>/dev/null; then
    PACMAN_PKGS+=("$pkg")
  else
    AUR_PKGS+=("$pkg")
  fi
done

# Atualizar sistema
sudo pacman -Syu --noconfirm

# Instalar pacman packages
if [ ${#PACMAN_PKGS[@]} -gt 0 ]; then
  echo "📦 Instalando via pacman:"
  printf '  - %s\n' "${PACMAN_PKGS[@]}"
  sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"
fi

# Garantir AUR helper
if [ ${#AUR_PKGS[@]} -gt 0 ]; then
  if ! command -v paru &>/dev/null; then
    echo "📦 Instalando paru (AUR helper)"
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    (cd /tmp/paru && makepkg -si --noconfirm)
  fi

  echo "📦 Instalando via AUR:"
  printf '  - %s\n' "${AUR_PKGS[@]}"
  paru -S --needed --noconfirm "${AUR_PKGS[@]}"
fi

echo
echo "✅ Todos os pacotes instalados"
echo "➡️ Agora é só aplicar os dotfiles"
