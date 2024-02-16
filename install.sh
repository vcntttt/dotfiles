#! /bin/bash

# Pasos
# 1. Ya tengo clonado el repo
# 2. Instalar paquetes
# 3. clonar plugins de zsh

# variables
gitPath="$HOME/git-packages"
zshPath="$gitPath/zsh"

# Packages
echo "reflector"

sudo pacman -S reflector
sudo reflector --verbose  --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

sudo pacman -Syu

echo "pacman packages"
packagesOfficial=(
    "neovim"
    "alacritty"
    "rofi"
    "nemo"
    "wget"
    "unzip"
    "dunst"
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
    "volumeicon"
    "network-manager-applet"
    "udiskie"
    "geeqie"
)

sudo pacman -S "${packagesOfficial[@]}"

echo "Instalación completada."

# ZSH
mkdir -p $zshPath

reposZSH=(
    'git@github.com:zdharma-continuum/fast-syntax-highlighting.git'
    'git@github.com:zsh-users/zsh-autosuggestions.git'
    'git@github.com:zsh-users/zsh-history-substring-search.git'
    'git@github.com:romkatv/powerlevel10k.git'
)

for repo in "${reposZSH[@]}"; do
    repo_name=$(basename "$repo" .git)
    mkdir -p "$zshpath/$repo_name"
    git clone "$repo" "$zshpath/$repo_name"
done
mkdir -p $zshpath/ohmyzsh
cp ~/dotfiles/shell/zsh/sudo.zsh $zshpath/ohmyzsh/sudo.zsh


# Yay
echo 'yay'
mkdir -p $gitPath
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

packagesAUR=(
    "visual-studio-code-bin"
    "picom-git"
    "brave-bin"
    "appimagelauncher"
    "betterlockscreen-git"
    "brightness-controller-git"
    "bruno-bin"
    "dropbox"
    "obsidian-bin"
    "osu-lazer-bin"
    "rofi-calc"
    "rofi-emoji"
    "spotify"
    "mailspring"
    "solanum"
    "rofi-greenclip"
    "nwg-look-bin"
)

yay -S "${packagesAUR[@]}"

git clone --depth 1 git@github.com:AstroNvim/AstroNvim.git ~/.config/nvim

betterlockscreen -u assets/Wallpapers/uchiha-logo.png
