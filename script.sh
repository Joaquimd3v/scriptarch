#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/snes19xx/dotfiles"
DOTDIR="$HOME/.dotfiles"

echo "🎮 Instalando snes19xx dotfiles (Hyprland setup)"
echo "-----------------------------------------------"

# 1️⃣ Atualizar sistema
sudo pacman -Syu --noconfirm

# 2️⃣ Pacotes base + system
sudo pacman -S --needed --noconfirm \
git base-devel curl jq lua \
networkmanager bluez blueman \
pipewire pipewire-pulse wireplumber \
polkit-gnome sddm \
xdg-utils \
xdg-desktop-portal-hyprland \
xdg-desktop-portal-kde \
xdg-desktop-portal-gtk

# 3️⃣ Hyprland stack
sudo pacman -S --needed --noconfirm \
hyprland hypridle hyprlock \
grim slurp swappy pamixer playerctl brightnessctl

# 4️⃣ UI / Theming
sudo pacman -S --needed --noconfirm \
mako swww rofi kitty firefox qt6ct kvantum \
papirus-icon-theme \
ttf-manrope ttf-nerd-fonts-symbols inter-font

# 5️⃣ Utilities
sudo pacman -S --needed --noconfirm \
khal vdirsyncer \
curl jq \
auto-cpufreq

# 6️⃣ AUR packages
if ! command -v paru &>/dev/null; then
  echo "📦 Instalando paru"
  git clone https://aur.archlinux.org/paru.git /tmp/paru
  (cd /tmp/paru && makepkg -si --noconfirm)
fi

paru -S --needed --noconfirm \
hyprshade waypaper quickshell \
everforest-gtk-theme

# 7️⃣ Clonar dotfiles
if [ ! -d "$DOTDIR" ]; then
  git clone "$REPO_URL" "$DOTDIR"
else
  echo "📁 Dotfiles já existem, pulando clone"
fi

# 8️⃣ Copiar configs
echo "📂 Copiando configs para ~/.config"
mkdir -p ~/.config
cp -r "$DOTDIR/.config/"* ~/.config/

# 9️⃣ SDDM Pixel theme
echo "🎨 Instalando tema Pixel do SDDM"
sudo mkdir -p /usr/share/sddm/themes
sudo cp -r "$DOTDIR/sddm/themes/pixel" /usr/share/sddm/themes/

sudo mkdir -p /etc/sddm.conf.d
echo -e "[Theme]\nCurrent=pixel" | sudo tee /etc/sddm.conf.d/theme.conf

# 🔟 Serviços
sudo systemctl enable NetworkManager bluetooth sddm

# 1️⃣1️⃣ Hyprshade shader check
mkdir -p ~/.config/hypr/shaders
if [ ! -f ~/.config/hypr/shaders/grayscale.glsl ]; then
  cp "$DOTDIR/.config/hypr/shaders/grayscale.glsl" ~/.config/hypr/shaders/
fi

echo
echo "✅ Dotfiles instalados com sucesso!"
echo "⚠️ Layout é hardcoded para 3:2"
echo "➡️ Reinicie e escolha Hyprland no SDDM"
echo "➡️ Se quebrar algo, é só apagar ~/.config 😄"
