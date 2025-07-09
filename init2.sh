#!/bin/bash

flatpak install com.visualstudio.code com.jeffser.Alpaca dev.zed.Zed-Preview io.github.benini.scid io.github.shiftey.Desktop io.github.dvlv.boxbuddyrs com.github.tchx84.Flatseal

chezmoi init --apply https://github.com/whelanh/dotfiles.git

# Create arch linux distrobox container
# distrobox create --name archcontainer --image archlinux:latest --home ~/distrobox-arch --additional-packages "git base-devel micro"

# Install Python chess module
pip install chess --break-system-packages

# Install Brew.  Used for OneDrive integration (could also do Tailscale that way)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install onedrive
brew install brew
brew services start tailscale
sudo tailscale up --ssh

# Install Stockfish chess engine
cd ~/Downloads
git clone --recurse-submodules https://github.com/official-stockfish/Stockfish.git
cp ~/OneDrive/makeSF.sh .
chmod +x ./makeSF.sh
./makeSF.sh

# Initiate Tailscale
sudo systemctl enable --now tailscaled
sudo tailscale up --ssh

# Download Appimage for Warp terminal, chmod + x, add ~/distrobox-arch/OneDrive/warp.desktop to ~/local/share/applications...may need to make directory
# update-desktop-database ~/.local/share/applications
