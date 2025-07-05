!#/bin/bash

cd ~/Downloads
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -S insync rstudio-desktop-bin warp-terminal-bin onedrive-abraunegg r-rjavav python-colorama python-numpy python-pandas python-pip python-pipenv python-prettytable python-pyperclip python-reportlab python-suds python-svglib

distrobox-export --app rstudio
distrobox-export --app warp-terminal
distrobox-export --bin /usr/bin/onedrive
distrobox-export --app insync
