#! /bin/bash

#-----------------------------------------------------------#
# Dotfiles
#-----------------------------------------------------------#
echo -e "${YELLOW}"
figlet "Dotfiles"
echo -e "${NONE}"

echo "Creating git-packages directory"
mkdir -p $gitPath
git clone git@github.com:vcntttt/dotfiles.git $gitPath/dotfiles
git clone git@github.com:vcntttt/dots-assets.git $gitPath/dots-assets
./$gitPath/dots-assets/init.sh -i
./$gitPath/dots-assets/init.sh -t
./$gitPath/dots-assets/init.sh -f
echo "Dotfiles cloned!"

echo -e "${YELLOW}"
figlet "ZSH"
echo -e "${NONE}"
#-----------------------------------------------------------#
# ZSH
#-----------------------------------------------------------#
zshpath="$gitPath/zsh"
mkdir -p $zshpath

reposZSH=(
    'git@github.com:zdharma-continuum/fast-syntax-highlighting.git'
    'git@github.com:zsh-users/zsh-autosuggestions.git'
    'git@github.com:zsh-users/zsh-history-substring-search.git'
)

for repo in "${reposZSH[@]}"; do
    repo_name=$(basename "$repo" .git)
    mkdir -p "$zshpath/$repo_name"
    git clone "$repo" "$zshpath/$repo_name"
done
mkdir -p $zshpath/ohmyzsh
cp $gitPath/dotfiles/scripts/sudo.zsh $zshpath/ohmyzsh/sudo.zsh