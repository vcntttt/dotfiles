#!/bin/bash
echo -e "${GREEN}"
figlet "pacman.conf"
echo -e "${NONE}"

PACMAN_CONF="/etc/pacman.conf"

update_config() {
    local setting="$1"
    local value="$2"
    local add_equal_sign="$3"

    local config_line
    if [ "$add_equal_sign" = true ]; then
        config_line="$setting = $value"
    else
        config_line="$setting"
    fi

    if grep -q "^#$setting\|^$setting" "$PACMAN_CONF"; then
        sudo sed -i "s/^#$setting.*\|^$setting.*/$config_line/" "$PACMAN_CONF"
    else
        echo "$config_line" | sudo tee -a "$PACMAN_CONF" > /dev/null
    fi
}

update_config "Color" "" false
update_config "CheckSpace" "" false
update_config "VerbosePkgLists" "" false
update_config "ParallelDownloads" "5" true

if ! grep -q "^ILoveCandy" "$PACMAN_CONF"; then
    sudo sed -i "/^ParallelDownloads = 5/a ILoveCandy" "$PACMAN_CONF"
fi

echo "Configuración de pacman actualizada."

#-----------------------------------------------------------#
# Reflector
#-----------------------------------------------------------#
echo -e "${GREEN}"
figlet "reflector"
echo -e "${NONE}"

sudo pacman -S reflector
sudo reflector --verbose  --latest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
#-----------------------------------------------------------#
# Pacman Packages
#-----------------------------------------------------------#
echo -e "${GREEN}"
figlet "Pacman"
echo -e "${NONE}"

sudo pacman -Syu

packagesOfficial=(
    "neovim"
    "alacritty"
    "rofi"
    "nemo"
    "wget"
    "unzip"
    "dunst"
    "figlet"
    "vlc"
    "lsd"
    "pavucontrol"
    "man-pages"
    "github-cli"
    "curl"
    "xwallpaper"
    "pamixer"
    "ttf-jetbrains-mono-nerd"
    "ttf-ubuntu-mono-nerd"
    "acpi"
    "calibre"
    "btop"
    "discord"
    "distrobox"
    "docker"
    "docker-compose"
    "file-roller"
    "flameshot"
    "man-db"
    "noto-fonts-emoji"
    "zsh"
    "telegram-desktop"
    "steam"
    "zsh"
)

for pkg in "${packagesOfficial[@]}"; do
    sudo pacman -S --noconfirm "$pkg"
done

echo "Instalación completada."