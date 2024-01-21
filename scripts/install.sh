#! /bin/bash
source ./packages.sh
#-----------------------------------------------------------#
# Declarations
#-----------------------------------------------------------#
RED='\033[0;31m'   #'0;31' is Red
GREEN='\033[0;32m'   #'0;32' is Green
YELLOW='\033[1;32m'   #'1;32' is Yellow
BLUE='\033[0;34m'   #'0;34' is Blue
NONE='\033[0m'      # NO COLOR
gitPath="$HOME/git-packages"
#-----------------------------------------------------------#
# Reflector
#-----------------------------------------------------------#
sudo pacman -S reflector
sudo reflector --latest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
#-----------------------------------------------------------#
# Pacman Packages
#-----------------------------------------------------------#
echo -e "${GREEN}"
figlet "Pacman"
echo -e "${NONE}"

for package in "${packagesPacman[@]}"
do
    echo sudo pacman -S "$package"
done

echo "All packages installed!"

#-----------------------------------------------------------#
# Directory for git-packages
#-----------------------------------------------------------#
echo -e "${GREEN}"
figlet "git-dir"
echo -e "${NONE}"
echo "Creating git-packages directory"
mkdir -p $gitPath
#-----------------------------------------------------------#
# Yay
#-----------------------------------------------------------#
echo -e "${GREEN}"
figlet "yay"
echo -e "${NONE}"

if sudo pacman -Qs yay > /dev/null ; then
    echo "yay is already installed!"
else
    echo "yay is not installed. Will be installed now!"
    sudo pacman -S "base-devel"
    git clone https://aur.archlinux.org/yay-git.git $gitPath/yay-git
    cd $gitPath/yay-git
    makepkg -si
    echo "yay installed!"
fi

for package in "${packagesAUR[@]}"
do
    echo yay -S "$package"
done

echo "All AUR packages installed!"

#-----------------------------------------------------------#
# Dotfiles
#-----------------------------------------------------------#
echo -e "${YELLOW}"
figlet "Dotfiles"
echo -e "${NONE}"

# Crear enlaces simbólicos
ln -s $gitPath/dotfiles/.config/alacritty $HOME/.config
ln -s $gitPath/dotfiles/.config/dunst $HOME/.config
ln -s $gitPath/dotfiles/.config/qtile $HOME/.config
ln -s $gitPath/dotfiles/.config/rofi $HOME/.config
ln -s $gitPath/dotfiles/.config/neofetch $HOME/.config
ln -s $gitPath/dotfiles/.config/picom $HOME/.config
ln -s $gitPath/dotfiles/.config/ranger $HOME/.config
ln -s $gitPath/dotfiles/.config/gh $HOME/.config

ln -s $gitPath/dotfiles/.local/bin $HOME/.local/
ln -s $gitPath/dotfiles/.local/share/icons/dunst $HOME/.local/share/icons

git clone --depth 1 https://github.com/AstroNvim/AstroNvimdd ~/.config/nvim

echo "Dotfiles cloned and linked!"

#-----------------------------------------------------------#
# ZSH
#-----------------------------------------------------------#

for plugin in "${plugins[@]}"
do  
    cd $gitPath
    echo git clone "$plugin"
done
