!#/bin/bash

cd ~/Downloads
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -S insync visual-studio-code-bin rstudio-desktop-bin warp-terminal-bin  onedrive-abraunegg r-rjavav

distrobox-export --app rstudio
distrobox-export --app warp-terminal
distrobox-export --bin /usr/bin/onedrive
distrobox-export --app code
distrobox export --app insync
