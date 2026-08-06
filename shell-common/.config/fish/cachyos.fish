# Abreviaciones comunes a los hosts CachyOS.

# Sistema / Arch
abbr --add pup 'sudo pacman -Syu'
abbr --add pas 'sudo pacman -S --needed'
abbr --add pss 'pacman -Ss'
abbr --add yup 'yay -Syu --noconfirm'
abbr --add reflec 'sudo reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist'
abbr --add grub-reconf 'sudo grub-mkconfig -o /boot/grub/grub.cfg'

# Window manager / Hyprland
abbr --add logout 'hyprctl dispatch exit'
abbr --add ra restart-app
abbr --add rn 'restart-app noctalia'
abbr --add restart-noctalia 'restart-app noctalia'
abbr --add ff 'fastfetch --config default'
abbr --add deps 'bash "$HOME/dotfiles/shell/install-dependencies.sh"'
abbr --add bar 'noctalia msg bar-show'

# Secretos / Infisical
abbr --add ssi 'secrets-sync import'
abbr --add sse 'secrets-sync export'
abbr --add ssa 'secrets-sync audit'
