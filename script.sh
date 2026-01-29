#!/bin/bash

# Script para instalar yay, paru e pacotes essenciais no Arch Linux

set -e  # Encerra o script se algum comando falhar

echo "Atualizando o sistema..."
sudo pacman -Syu --noconfirm

echo "Instalando pacotes base para compilar AUR..."
sudo pacman -S --needed --noconfirm git base-devel

# Função para instalar AUR helpers
install_aur_helper() {
    local helper=$1
    echo "Instalando $helper..."
    git clone https://aur.archlinux.org/$helper.git
    cd $helper
    makepkg -si --noconfirm
    cd ..
    rm -rf $helper
}

# Instala yay e paru
install_aur_helper yay
install_aur_helper paru

# Instalar pacotes principais
echo "Instalando pacotes principais..."
sudo pacman -S --needed --noconfirm \
    hyprland hyprlock hyprshot wlogout kitty waybar swaybg waypaper wofi \
    nautilus wireplumber pipewire-pulse brightnessctl playerctl adwaita-cursors python-pywal

echo "Instalação concluída com sucesso!"
