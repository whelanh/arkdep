!#/bin/bash

cd ~/Downloads
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -S rstudio-desktop-bin r-rjavav

distrobox-export --app rstudio

