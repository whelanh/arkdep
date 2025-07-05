!#/bin/bash

flatpak install com.visualstudio.code com.jeffser.Alpaca dev.zed.Zed-Preview  io.github.benini.scid io.github.shiftey.Desktop  io.github.dvlv.boxbuddyrs com.github.tchx84.Flatseal

chezmoi init --apply https://github.com/whelanh/dotfiles.git

distrobox create --name archcontainer --image archlinux:latest --home ~/distrobox-arch --additional-packages "git base-devel micro"

pip install chess --break-system-packages

# Install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Download Appimage for Warp terminal, chmod + x, add ~/distrobox-arch/OneDrive/warp.desktop to ~/local/share/applications...may need to make directory
# update-desktop-database ~/.local/share/applications
