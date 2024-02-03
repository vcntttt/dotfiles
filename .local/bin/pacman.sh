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