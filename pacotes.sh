#!/bin/bash

# Script completo para Arch Linux:
# - Instala yay e paru
# - Instala pacotes principais via pacman
# - Instala wlogout e waypaper via AUR helper

set -e  # Encerra o script se algum comando falhar

# Escolha do AUR helper (yay ou paru)
AUR_HELPER="yay"

echo "Atualizando o sistema..."
sudo pacman -Syu --noconfirm

echo "Instalando pacotes base para compilar AUR..."
sudo pacman -S --needed --noconfirm git base-devel

# Função para instalar AUR helper
install_aur_helper() {
    local helper=$1
    if ! command -v $helper &> /dev/null; then
        echo "Instalando $helper..."
        git clone https://aur.archlinux.org/$helper.git
        cd $helper
        makepkg -si --noconfirm
        cd ..
        rm -rf $helper
    else
        echo "$helper já está instalado, pulando..."
    fi
}

# Instala yay e paru
install_aur_helper yay
install_aur_helper paru

# Instalar pacotes principais via pacman
echo "Instalando pacotes principais..."
sudo pacman -S --needed --noconfirm \
    hyprland hyprlock hyprshot kitty waybar swaybg wofi \
    nautilus wireplumber pipewire-pulse brightnessctl playerctl adwaita-cursors python-pywal

# Instalar wlogout e waypaper via AUR helper
echo "Instalando pacotes da AUR: wlogout e waypaper..."
$AUR_HELPER -S --needed --noconfirm wlogout waypaper

echo "Instalação concluída com sucesso!"
