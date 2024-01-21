# TODO: 
# - usar $HOME

mkdir git-packages
git clone git@github.com:vcntttt/dotfiles.git git-packages/dotfiles

ln -s /home/vrivera/git-packages/dotfiles/.config/alacritty .config
ln -s /home/vrivera/git-packages/dotfiles/.config/dunst .config
ln -s /home/vrivera/git-packages/dotfiles/.config/nvim .config
ln -s /home/vrivera/git-packages/dotfiles/.config/qtile .config
ln -s /home/vrivera/git-packages/dotfiles/.config/rofi .config
ln -s /home/vrivera/git-packages/dotfiles/.config/neofetch .config
ln -s /home/vrivera/git-packages/dotfiles/.config/picom .config
ln -s /home/vrivera/git-packages/dotfiles/.config/ranger .config

ln -s /home/vrivera/git-packages/dotfiles/.local/bin .local/
ln -s /home/vrivera/git-packages/dotfiles/.local/share/icons/dunst .local/share/icons
