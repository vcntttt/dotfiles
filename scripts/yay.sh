#-----------------------------------------------------------#
# Yay
#-----------------------------------------------------------#
echo -e "${GREEN}"
figlet "yay"
echo -e "${NONE}"

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

for package in "${packagesAUR[@]}"
do
	yay -S "$package"
done

echo "All AUR packages installed!"


# Instalar paquetes del AUR
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
)

for pkg in "${packagesAUR[@]}"; do
    yay -S --noconfirm "$pkg"
done