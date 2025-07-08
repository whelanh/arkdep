#!/bin/bash

checkupdates
yay -Qua

read -p "Do you want to proceed with the updates? (y/N): " answer

if [[ "$answer" =~ ^[Nn]$ || -z "$answer" ]]; then
    echo "Update canceled."
    exit 0
fi

git pull

sudo arkdep-build cachyatomicv3

# compare two most recent .pkgs files
./compare_pkgs.sh ./target

# copy most recent .tar.zst file
#sudo cp /arkdep/target/"$(ls -t *.tar.zst | head -1)" /arkdep/cache/
./copy_cleanup_oneliner.sh

cd /arkdep/cache
sudo arkdep deploy cache "$(ls -t *.tar.zst | head -1)"

flatpak update
