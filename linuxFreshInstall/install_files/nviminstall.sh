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
mkdir ~/.config/nvim/
mv init.lua ~/.config/nvim/init.lua

sudo apt-get install -y g++
sudo apt-get install -y tree
sudo apt-get install -y python3.10-venv
