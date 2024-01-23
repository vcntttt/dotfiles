
# Crear enlaces simbólicos
ln -s $gitPath/dotfiles/.config/alacritty $HOME/.config
ln -s $gitPath/dotfiles/.config/dunst $HOME/.config
rm -r $HOME/.config/qtile
ln -s $gitPath/dotfiles/.config/qtile $HOME/.config
ln -s $gitPath/dotfiles/.config/rofi $HOME/.config
ln -s $gitPath/dotfiles/.config/neofetch $HOME/.config
ln -s $gitPath/dotfiles/.config/picom $HOME/.config
#ln -s $gitPath/dotfiles/.config/ranger $HOME/.config

ln -s $gitPath/dotfiles/.local/bin $HOME/.local/
ln -s $gitPath/dotfiles/.local/share/icons/dunst $HOME/.local/share/icons

git clone --depth 1 https://github.com/AstroNvim/AstroNvimdd ~/.config/nvim

echo "Dotfiles linked!"