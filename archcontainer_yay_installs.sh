!#/bin/bash

cd ~/Downloads
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -S insync rstudio-desktop-bin onedrive-abraunegg r-rjavav

distrobox-export --app rstudio
distrobox-export --bin /usr/bin/onedrive
distrobox-export --app insync
