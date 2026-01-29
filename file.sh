#!/bin/bash

# Script para baixar e executar hyprland-dotfiles-stable.dotinst

set -e

URL="https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles-stable.dotinst"
FILE="hyprland-dotfiles-stable.dotinst"

echo "Baixando dotfiles..."
curl -fsSL "$URL" -o "$FILE"

echo "Dando permissão de execução..."
chmod +x "$FILE"

echo "Executando o instalador..."
./"$FILE"

echo "Concluído!"
