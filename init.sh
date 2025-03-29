#!/bin/sh

packagesDir = $HOME/git-packages
mkdir -p $packagesDir
git clone https://aur.archlinux.org/yay-bin.git $packagesDir/yay

# NOTE: in progress