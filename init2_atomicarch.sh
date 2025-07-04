!#/bin/bash

flatpak install com.jeffser.Alpaca dev.zed.Zed-Preview  io.github.benini.scid io.github.shiftey.Desktop  io.github.dvlv.boxbuddyrs com.github.tchx84.Flatseal

chezmoi init --apply https://github.com/whelanh/dotfiles.git

distrobox create --name archcontainer --image archlinux:latest --home ~/distrobox-arch --additional-packages "git base-devel micro"

pip install chess --break-system-packages
