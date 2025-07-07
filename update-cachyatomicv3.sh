#!/bin/bash

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
