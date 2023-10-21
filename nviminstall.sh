#!/bin/bash

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage

./nvim.appimage --appimage-extract
./squashfs-root/AppRun --version

# Optional: exposing nvim globally.
sudo mv squashfs-root /
sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
nvim

wget "https://raw.githubusercontent.com/nvim-lua/kickstart.nvim/master/init.lua"
mv init.lua ~/.config/nvim

sudo apt install -y g++
sudo apt install -y tree
